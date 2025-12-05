# Lmaobox Lua API Type Definitions

This folder contains type definitions for the Lmaobox Lua API to enable proper linting, autocompletion, and type checking in VS Code.

## Auto-Update

The Lua runtime version is set to **Lua 5.4** in `.luarc.json`, which will automatically use the latest 5.4.x version as the language server updates.

## Type Definitions

- `lmaobox.d.lua` - Core Lmaobox API type definitions

## Updating Types

When the Lmaobox API is updated, you can:

1. Check the official documentation: http://lmaobox.net/lua/sitemap.xml
2. Update `lmaobox.d.lua` with new API methods/types
3. The Lua Language Server will automatically pick up changes

## Configuration

Type definitions are automatically loaded via:

- `.vscode/.luarc.json` - Lua Language Server configuration
- `.vscode/settings.json` - VS Code workspace settings

Both reference `${workspace}/types` in the workspace library.
