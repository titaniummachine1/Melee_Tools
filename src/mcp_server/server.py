import json
import logging
import sqlite3
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import urlparse, parse_qs
import difflib
import re

from .config import (
    DB_PATH,
    DEFAULT_ENCODING,
    DEFAULT_HOST,
    DEFAULT_PORT,
    ROOT_DIR,
    SMART_CONTEXT_DIR,
    TYPES_DIR,
)

LOG = logging.getLogger("mcp_server")


def _ensure_db(conn: sqlite3.Connection) -> None:
    """Create metadata table if it does not exist."""
    conn.execute(
        """
		CREATE TABLE IF NOT EXISTS symbol_metadata (
			symbol TEXT PRIMARY KEY,
			signature TEXT,
			required_constants TEXT,
			source TEXT,
			updated_at INTEGER DEFAULT (strftime('%s','now'))
		)
		"""
    )
    conn.commit()


def _load_symbol_from_db(conn: sqlite3.Connection, symbol: str):
    _ensure_db(conn)
    cur = conn.execute(
        "SELECT symbol, signature, required_constants, source FROM symbol_metadata WHERE symbol = ?",
        (symbol,)
    )
    row = cur.fetchone()
    if not row:
        return None
    required = []
    if row[2]:
        try:
            required = json.loads(row[2])
        except Exception:
            required = []
    return {
        "symbol": row[0],
        "signature": row[1],
        "required_constants": required,
        "source": row[3] or "sqlite"
    }


def _extract_signature_line(text: str, symbol: str, short_symbol: str) -> str | None:
    """Extract signature, prioritizing function definitions over comments."""
    lines = text.splitlines()

    # For symbols with dots (like engine.TraceLine), require function keyword
    has_namespace = "." in symbol
    pattern_full = re.compile(rf"\b{re.escape(symbol)}\b")
    pattern_short = re.compile(rf"\b{re.escape(short_symbol)}\b")

    # First pass: look for function definitions (highest priority)
    for raw in lines:
        trimmed = raw.strip()
        if trimmed.startswith("---") or trimmed.startswith("--"):
            continue  # Skip all comments
        if "function" in trimmed:
            # Check if this line contains our symbol
            if (has_namespace and pattern_full.search(trimmed)) or (not has_namespace and pattern_short.search(trimmed)):
                return trimmed

    # Second pass: only for symbols without namespace (globals)
    if not has_namespace:
        for raw in lines:
            trimmed = raw.strip()
            if trimmed.startswith("---") or trimmed.startswith("--"):
                continue
            if pattern_short.search(trimmed):
                return trimmed

    return None


def _fuzzy_constants_for_symbol(symbol: str):
    """Heuristic: if symbol includes 'mask' or is TraceLine/TraceHull, suggest trace masks."""
    name = symbol.lower()
    candidates = []
    if "trace" in name or "mask" in name:
        candidates.append("E_TraceLine")
    if "engine.traceline" in symbol.lower() or "tracehul" in name:
        candidates.append("E_TraceLine")
    return candidates


def _scan_types_for_symbol(symbol: str):
    """Fallback scanner that looks through generated type files for a quick signature hint."""
    short_symbol = symbol.split(".")[-1]
    parts = symbol.split(".")

    # Prioritize more specific files (e.g., engine.d.lua for engine.TraceLine)
    candidate_files = []
    search_roots = [
        TYPES_DIR / "lmaobox_lua_api",
        TYPES_DIR,
    ]

    # First: look in specific library/class files if symbol has dots (highest priority)
    if len(parts) > 1:
        lib_or_class = parts[0]
        for base in search_roots:
            lib_file = base / "Lua_Libraries" / f"{lib_or_class}.d.lua"
            if lib_file.exists() and lib_file not in candidate_files:
                candidate_files.append(lib_file)  # Add to prioritized list
            class_file = base / "Lua_Classes" / f"{lib_or_class}.d.lua"
            if class_file.exists() and class_file not in candidate_files:
                candidate_files.append(class_file)

    # Then: scan all other files (lower priority)
    for base in search_roots:
        if not base.exists():
            continue
        for path in base.rglob("*.lua"):
            if path not in candidate_files:
                candidate_files.append(path)

    # Search candidate files in priority order
    for path in candidate_files:
        try:
            text = path.read_text(encoding=DEFAULT_ENCODING, errors="ignore")
        except Exception:
            continue
        signature = _extract_signature_line(text, symbol, short_symbol)
        if signature:
            # Try to enrich with constants hints
            constants = _fuzzy_constants_for_symbol(symbol)
            return {
                "symbol": symbol,
                "signature": signature,
                "required_constants": constants,
                "source": f"types:{path.relative_to(ROOT_DIR)}"
            }
    return None


def _suggest_symbols(conn: sqlite3.Connection, symbol: str, limit: int = 10):
	"""Return fuzzy symbol suggestions from the symbols table."""
	try:
		short = symbol.split(".")[-1]
		rows = conn.execute(
			"SELECT full_name FROM symbols WHERE full_name LIKE ? LIMIT ?",
			(f"%{short}%", limit * 4)
		).fetchall()
		candidates = [r[0] for r in rows] if rows else []
		# Rank with difflib for better ordering
		ranked = difflib.get_close_matches(symbol, candidates, n=limit, cutoff=0)
		return ranked[:limit]
	except Exception:
		return []


def get_types(symbol: str):
    if not symbol:
        raise ValueError("symbol is required")

    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row

    from_db = _load_symbol_from_db(conn, symbol)
    if from_db:
		# Re-validate to avoid stale/false-positive cache entries
		recheck = _scan_types_for_symbol(symbol)
		if recheck:
			return recheck
		# Cache was stale; drop it
		conn.execute("DELETE FROM symbol_metadata WHERE symbol = ?", (symbol,))
		conn.commit()

    fallback = _scan_types_for_symbol(symbol)
    if fallback:
        _ensure_db(conn)
        conn.execute(
            """
			INSERT OR REPLACE INTO symbol_metadata (symbol, signature, required_constants, source, updated_at)
			VALUES (?, ?, ?, ?, strftime('%s','now'))
			""",
            (symbol, fallback["signature"], json.dumps(
                fallback["required_constants"]), fallback["source"]),
        )
        conn.commit()
        return fallback

    # Not found: include fuzzy suggestions to help correction
    return {
        "symbol": symbol,
        "signature": None,
        "required_constants": [],
        "source": "not_found",
        "suggestions": _suggest_symbols(conn, symbol, limit=10)
    }


def _smart_context_candidates(symbol: str):
    normalized = symbol.strip().replace("::", ".").replace("/", ".")
    segments = normalized.split(".")
    while segments:
        # Map namespaces to folders: engine.TraceLine -> engine/TraceLine.md
        if len(segments) == 1:
            yield SMART_CONTEXT_DIR / (segments[0] + ".md")
        else:
            yield SMART_CONTEXT_DIR / Path(*segments[:-1]) / (segments[-1] + ".md")
        segments.pop()


def get_smart_context(symbol: str):
    if not symbol:
        raise ValueError("symbol is required")

    for candidate in _smart_context_candidates(symbol):
        if candidate.exists():
            return {
                "symbol": symbol,
                "path": str(candidate),
                "content": candidate.read_text(encoding=DEFAULT_ENCODING)
            }

    normalized = symbol.strip().replace("::", ".").replace("/", ".")
    partial_hits = list(SMART_CONTEXT_DIR.glob(f"*{normalized}*.md"))
    if partial_hits:
        target = partial_hits[0]
        return {
            "symbol": symbol,
            "path": str(target),
            "content": target.read_text(encoding=DEFAULT_ENCODING)
        }

    # No direct hit: return suggestions from symbols to guide the caller
    conn = sqlite3.connect(DB_PATH)
    suggestions = _suggest_symbols(conn, symbol, limit=5)
    return {
        "symbol": symbol,
        "path": None,
        "content": None,
        "suggestions": suggestions
    }


class MCPRequestHandler(BaseHTTPRequestHandler):
    def _json(self, status: int, payload: dict) -> None:
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(payload).encode(DEFAULT_ENCODING))

    def do_GET(self):  # noqa: N802 - http handler naming
        parsed = urlparse(self.path)
        query = parse_qs(parsed.query)
        path = parsed.path

        if path == "/health":
            self._json(200, {"status": "ok"})
            return

        if path == "/get_types":
            symbol = (query.get("symbol") or [""])[0]
            if not symbol:
                self._json(
                    400, {"error": "symbol query parameter is required"})
                return
            try:
                payload = get_types(symbol)
                self._json(200, payload)
            except Exception as exc:  # guard against unexpected errors
                LOG.exception("get_types failed")
                self._json(500, {"error": str(exc)})
            return

        if path == "/smart_context":
            symbol = (query.get("symbol") or [""])[0]
            if not symbol:
                self._json(
                    400, {"error": "symbol query parameter is required"})
                return
            try:
                payload = get_smart_context(symbol)
                if payload:
                    self._json(200, payload)
                else:
                    self._json(404, {"error": "context not found"})
            except Exception as exc:
                LOG.exception("get_smart_context failed")
                self._json(500, {"error": str(exc)})
            return

        self._json(404, {"error": "not found"})

    def log_message(self, fmt, *args):  # noqa: D401, N802
        LOG.info("%s - %s", self.address_string(), fmt % args)


def run_server(host: str = DEFAULT_HOST, port: int = DEFAULT_PORT) -> None:
    SMART_CONTEXT_DIR.mkdir(parents=True, exist_ok=True)
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)

    server = HTTPServer((host, port), MCPRequestHandler)
    LOG.info("MCP server listening on http://%s:%s", host, port)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        LOG.info("Shutting down MCP server")
    finally:
        server.server_close()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format="%(asctime)s %(levelname)s %(message)s")
    run_server()
