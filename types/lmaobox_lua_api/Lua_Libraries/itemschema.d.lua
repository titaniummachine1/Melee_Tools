---@meta

-- Lmaobox Lua API: itemschema - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/itemschema/
-- Path: Lua_Libraries/itemschema
-- Last updated: 2025-12-05T11:44:38.848Z

---@class itemschema
itemschema = {}

-- Returns the item definition for the item with the given ID.
---@param id number
---@return any
function itemschema.GetItemDefinitionByID(id) end

-- Returns the item definition for the item with the given name.
---@param name string
---@return string
function itemschema.GetItemDefinitionByName(name) end

-- Enumerates all item definitions, calling the callback for each one.
---@return any
function itemschema.Enumerate() end

-- Returns the attribute definition for the item with the given name.
---@param name string
---@return string
function itemschema.GetAttributeDefinitionByName(name) end

-- Enumerates all attribute definitions, calling the callback for each one.
---@return any
function itemschema.EnumerateAttributes() end

