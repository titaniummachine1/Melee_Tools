---@meta

-- Lmaobox Lua API: itemschema - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/itemschema/
-- Path: Lua_Libraries/itemschema
-- Last updated: 2025-12-05T11:20:21.009Z

---@class itemschema
itemschema = {}

-- Returns the item definition for the item with the given ID.
---@return any
function itemschema.Functions() end

---@return any
function itemschema.Examples() end

-- Returns the item definition for the item with the given ID.
---@param id number
---@return any
function itemschema.GetItemDefinitionByID(id) end

-- Returns the item definition for the item with the given name.
---@param name string
---@return string
function itemschema.GetItemDefinitionByName(name) end

-- Enumerates all item definitions, calling the callback for each one.
---@param callback function
---@return any
function itemschema.Enumerate(callback) end

-- Returns the attribute definition for the item with the given name.
---@param name string
---@return string
function itemschema.GetAttributeDefinitionByName(name) end

-- Enumerates all attribute definitions, calling the callback for each one.
---@param callback function
---@return any
function itemschema.EnumerateAttributes(callback) end

