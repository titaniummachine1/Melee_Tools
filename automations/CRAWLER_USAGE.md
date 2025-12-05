# Crawler Usage Guide

## Quick Start

### Manual Refresh (Recommended)

**Via VS Code Task:**

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type: `Tasks: Run Task`
3. Select: **🔄 Refresh Documentation Types**
4. Watch the terminal for progress!

**Via Command Line:**

```bash
node automations/refresh-docs.js
```

## What It Does

The crawler will:

1. ✅ Fetch sitemap from `https://lmaobox.net/lua/sitemap.xml`
2. ✅ Crawl all documentation pages
3. ✅ Parse HTML to extract functions, classes, libraries, constants
4. ✅ Generate type definitions in `types/hierarchy/`
5. ✅ Update `.luarc.json` with discovered globals
6. ✅ Create docs index for AI

## Progress Indicators

You'll see output like:

```
[Crawler] Starting smart crawler...
[GraphBuilder] Fetching sitemap...
[GraphBuilder] Found 150 URLs in sitemap
[Crawler] Fetching pages (with 1s rate limit and session cache)...
[1/150] Processing: index
[11/150] Processing: client
[21/150] Processing: draw
...
[Crawler] Fetched: 45, Changed: 12
[Crawler] Calculating shortest paths...
[Crawler] Generating folder hierarchy...
[Crawler] Generating type definitions...
[TypeGenerator] Generated 150 type definition files
[Crawler] Updating .luarc.json with discovered globals...
[LuarcUpdater] Found 25 discovered globals, 40 total
[Crawler] ✅ Complete! Generated 150 type files in 45000ms
```

## Output Locations

- **Type Definitions**: `types/hierarchy/**/*.d.lua`
- **Database**: `.cache/docs-graph.db`
- **HTML Cache**: `.cache/docs/**/*.html`
- **Config**: `.vscode/.luarc.json` (globals updated)

## Rate Limiting

- **Automatic runs**: Limited to once per 24 hours
- **Manual refresh**: Bypasses rate limit (forces full crawl)
- **Page fetches**: 1 second delay between requests

## Troubleshooting

**No output?**

- Check the terminal panel in VS Code
- Make sure Node.js is installed: `node --version`

**Types not updating?**

- Reload VS Code window: `Ctrl+Shift+P` → "Developer: Reload Window"
- Check `types/hierarchy/` folder exists and has `.d.lua` files

**Crawler errors?**

- Check internet connection
- Verify `https://lmaobox.net/lua/sitemap.xml` is accessible
- Check `.cache/` folder permissions
