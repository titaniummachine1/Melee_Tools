---@meta

-- Lmaobox Lua API: MatchGroup - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/MatchGroup/
-- Path: Lua_Classes/MatchGroup
-- Last updated: 2025-12-05T10:33:20.039Z

---@class MatchGroup
-- Returns the ID of the match group.
---@return any
---@field Methods fun(self: MatchGroup): any
-- Returns the ID of the match group.
---@return any
---@field GetID fun(self: MatchGroup): any
-- Returns the name of the match group.
---@return string
---@field GetName fun(self: MatchGroup): string
-- Returns whether the match group is a competitive mode. Can return false if you are using a competitive bypass feature.
---@return boolean
---@field IsCompetitiveMode fun(self: MatchGroup): boolean
local MatchGroup = {}

