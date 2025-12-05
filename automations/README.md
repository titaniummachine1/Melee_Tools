# Automation Scripts

This folder contains all automation scripts for building, deploying, and maintaining the Lua development environment.

## Scripts

### `crawl-docs.js` ⭐ **NEW - Comprehensive Crawler**

- **Purpose**: Crawl entire documentation site starting from sitemap.xml, build graph of all docs, parse everything
- **When it runs**:
  - ✅ Automatically when `update-types.js` runs (on workspace load)
  - ✅ Manually via: `node automations/crawl-docs.js`
- **What it does**:
  - Fetches `https://lmaobox.net/lua/sitemap.xml`
  - Discovers all documentation pages (only follows links with `https://lmaobox.net/lua/` prefix)
  - Builds a graph/hierarchy of all documentation pages
  - Fetches and parses each page (with rate limiting and caching)
  - Extracts:
    - All libraries, classes, functions, methods
    - All callbacks, globals, constants
    - All code examples
  - Organizes type definitions by URL hierarchy in `types/hierarchy/`
  - Caches HTML pages in `.cache/docs/` for faster subsequent runs
- **Rate limiting**: Fetches limited to once per hour (uses cached data otherwise)
- **Self-healing**: Automatically adapts to new pages, new categories, structure changes

### `auto-generate-types.js`

- **Purpose**: Automatically parse the Lmaobox API documentation and generate comprehensive type definitions with examples
- **When it runs**:
  - ✅ Automatically when `update-types.js` runs (on workspace load)
  - ✅ Manually via: `node automations/auto-generate-types.js`
- **What it does**:
  - **Auto-discovers everything** - No hardcoded lists! Automatically finds:
    - All libraries (any `## LibraryName` section with functions)
    - All classes (any `# ClassName` section with methods/fields)
    - All callbacks (from "Lua Callbacks" section)
    - All globals (from "Lua Globals" section)
    - All constants (from "Predefined constants" section)
    - All Entity methods (from Entity class section)
  - Generates type definition files (`.d.lua`) with:
    - Complete function signatures with parameter types
    - Return type inference from function names
    - Code examples embedded as comments
    - All discovered libraries, classes, callbacks, globals
  - Updates/creates type files:
    - `types/lmaobox.d.lua` - All library definitions
    - `types/entity_props/entity_base.d.lua` - Entity methods
    - `types/classes_*.d.lua` - Individual class definitions
    - `types/callbacks.d.lua` - Callback type definitions
    - `types/globals.d.lua` - Global function definitions
- **Self-healing**: Automatically adapts to new libraries, classes, callbacks, constants, and globals as they appear in the documentation
- **Rate limiting**: Sitemap fetch is limited to once per hour (same as `update-types.js`)

### `update-types.js`

- **Purpose**: Check if type definitions need updating
- **When it runs**:
  - ✅ Manually via VS Code task "Check Type Definitions"
  - ✅ On workspace load (if configured)
  - ❌ **NEVER** on file save (to prevent DDoS)
- **Rate limiting**: Sitemap fetch is limited to once per hour (stored in `types/.session`)

### `generate-all-types.js`

- **Purpose**: Generate comprehensive type definitions from documentation
- **When it runs**: Manually only
- **Rate limiting**: Sitemap fetch is limited to once per hour

### `auto-commit.js`

- **Purpose**: Auto-commit when >10 lines changed
- **When it runs**: After successful bundle/deploy (via BundleAndDeploy.bat)
- **Note**: Only commits, never pushes

### `bundle.js`

- **Purpose**: Bundle Lua files
- **When it runs**: On file save (via BundleAndDeploy.bat)

### `BundleAndDeploy.bat`

- **Purpose**: Bundle and deploy Lua files
- **When it runs**: On `.lua` file save (via Run On Save extension)
- **What it does**:
  1. Bundles Lua files using `bundle.js`
  2. Deploys to `%localappdata%\lua\`
  3. Runs `auto-commit.js` for Git commits

## Rate Limiting

All scripts that fetch from lmaobox.net:

1. Check `types/.session` file for last fetch time
2. Only fetch if more than 1 hour has passed
3. Update `.session` file after successful fetch

This prevents DDoSing the lmaobox.net server.

## Auto-Generation

The `auto-generate-types.js` script automatically:

- Parses all library sections (client, draw, engine, etc.)
- Extracts all function signatures with parameter types
- Infers return types from function names and descriptions
- Extracts code examples and embeds them as comments
- Generates complete type definitions for the Lua Language Server
- Updates existing type files or creates new ones

This ensures the linter always has the latest API information with examples, making development easier and catching errors early.
