---@meta

-- Lmaobox Lua API: StudioModelHeader - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/StudioModelHeader/
-- Path: Lua_Classes/StudioModelHeader
-- Last updated: 2025-12-05T10:33:20.308Z

---@class StudioModelHeader
-- Returns the name of the model.
---@return string
---@field GetName fun(self: StudioModelHeader): string
-- Returns a StudioHitboxSet object by the entities hitbox set index. This can be retrieved from m_nHitBoxSet netvar.
---@param index number
---@return any
---@field GetHitboxSet fun(self: StudioModelHeader, index: number): any
-- Returns a table of all StudioHitboxSet objects for the model.
---@return any
---@field GetAllHitboxSets fun(self: StudioModelHeader): any
local StudioModelHeader = {}

