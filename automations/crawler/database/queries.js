import { getDatabase } from './schema.js';

export const db = {
	// Pages
	insertPage(page) {
		const db = getDatabase();
		const stmt = db.prepare(`
			INSERT OR REPLACE INTO pages 
			(url, path, title, content_hash, last_fetched, fetch_count, page_type, parent_url, depth, sitemap_order, parsed_data)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		`);
		return stmt.run(
			page.url,
			page.path || null,
			page.title || null,
			page.content_hash || null,
			page.last_fetched || Date.now(),
			page.fetch_count || 0,
			page.page_type || null,
			page.parent_url || null,
			page.depth || 0,
			page.sitemap_order || null,
			page.parsed_data ? JSON.stringify(page.parsed_data) : null
		);
	},

	getPage(url) {
		const db = getDatabase();
		return db.prepare('SELECT * FROM pages WHERE url = ?').get(url);
	},

	getAllPages() {
		const db = getDatabase();
		return db.prepare('SELECT * FROM pages ORDER BY sitemap_order').all();
	},

	getAllPagesWithPaths() {
		const db = getDatabase();
		return db.prepare('SELECT * FROM pages WHERE path IS NOT NULL ORDER BY path').all();
	},

	updatePagePath(url, pathInfo) {
		const db = getDatabase();
		const stmt = db.prepare(`
			UPDATE pages 
			SET path = ?, parent_url = ?, depth = ?
			WHERE url = ?
		`);
		return stmt.run(pathInfo.path, pathInfo.parent || null, pathInfo.depth, url);
	},

	updatePageHash(url, hash) {
		const db = getDatabase();
		const stmt = db.prepare('UPDATE pages SET content_hash = ?, last_fetched = ?, fetch_count = fetch_count + 1 WHERE url = ?');
		return stmt.run(hash, Date.now(), url);
	},

	updatePageParsedData(url, parsedData) {
		const db = getDatabase();
		const stmt = db.prepare('UPDATE pages SET parsed_data = ? WHERE url = ?');
		return stmt.run(JSON.stringify(parsedData), url);
	},

	getAllGlobals() {
		const db = getDatabase();
		const pages = db.prepare('SELECT parsed_data FROM pages WHERE parsed_data IS NOT NULL').all();
		const globals = new Set();

		for (const page of pages) {
			try {
				const parsed = JSON.parse(page.parsed_data);
				// Functions that are not part of a class or library are globals
				if (parsed.functions && parsed.functions.length > 0) {
					// Check if page has libraries or classes - if not, functions are globals
					const hasLibraries = parsed.libraries && parsed.libraries.length > 0;
					const hasClasses = parsed.classes && parsed.classes.length > 0;

					if (!hasLibraries && !hasClasses) {
						// These are global functions
						for (const func of parsed.functions) {
							globals.add(func.name);
						}
					}
				}
				// Constants are also globals
				if (parsed.constants && parsed.constants.length > 0) {
					for (const constant of parsed.constants) {
						globals.add(constant.name);
					}
				}
			} catch (e) {
				// Skip invalid JSON
			}
		}

		return Array.from(globals).sort();
	},

	// Links
	insertLink(link) {
		const db = getDatabase();
		const stmt = db.prepare(`
			INSERT OR REPLACE INTO links (from_url, to_url, link_text, link_type)
			VALUES (?, ?, ?, ?)
		`);
		return stmt.run(link.from_url, link.to_url, link.link_text || null, link.link_type || 'internal');
	},

	getLinksFrom(url) {
		const db = getDatabase();
		return db.prepare('SELECT * FROM links WHERE from_url = ?').all(url);
	},

	getLinksTo(url) {
		const db = getDatabase();
		return db.prepare('SELECT * FROM links WHERE to_url = ?').all(url);
	},

	clearLinksForPage(url) {
		const db = getDatabase();
		return db.prepare('DELETE FROM links WHERE from_url = ?').run(url);
	},

	// Sitemap
	saveSitemapSnapshot(urls) {
		const db = getDatabase();
		const stmt = db.prepare(`
			INSERT INTO sitemap_snapshots (timestamp, url_count, urls_json)
			VALUES (?, ?, ?)
		`);
		return stmt.run(Date.now(), urls.length, JSON.stringify(urls));
	},

	getLatestSitemapSnapshot() {
		const db = getDatabase();
		return db.prepare('SELECT * FROM sitemap_snapshots ORDER BY timestamp DESC LIMIT 1').get();
	},

	// Type definitions
	saveTypeDefinition(url, path, content) {
		const db = getDatabase();
		const stmt = db.prepare(`
			INSERT OR REPLACE INTO type_definitions (url, path, generated_at, type_content)
			VALUES (?, ?, ?, ?)
		`);
		return stmt.run(url, path, Date.now(), content);
	},

	getTypeDefinition(url) {
		const db = getDatabase();
		return db.prepare('SELECT * FROM type_definitions WHERE url = ?').get(url);
	},

	// Update log
	logUpdate(updateType, pagesUpdated, durationMs) {
		const db = getDatabase();
		const stmt = db.prepare(`
			INSERT INTO update_log (timestamp, update_type, pages_updated, duration_ms)
			VALUES (?, ?, ?, ?)
		`);
		return stmt.run(Date.now(), updateType, pagesUpdated, durationMs);
	}
};
