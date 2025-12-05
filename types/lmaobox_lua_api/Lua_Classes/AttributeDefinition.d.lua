---@meta

-- Lmaobox Lua API: AttributeDefinition - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/AttributeDefinition/
-- Path: Lua_Classes/AttributeDefinition
-- Last updated: 2025-12-05T10:33:19.981Z

---@class AttributeDefinition
-- Returns the name of the attribute.
---@return string
---@field GetName fun(self: AttributeDefinition): string
-- Returns the ID of the attribute.
---@return any
---@field GetID fun(self: AttributeDefinition): any
-- Returns true if the attribute is stored as an integer. For numeric attibutes, false means it is stored as a float.
---@return boolean
---@field IsStoredAsInteger fun(self: AttributeDefinition): boolean
local AttributeDefinition = {}

