---@meta

-- Lmaobox Lua API: StudioBBox - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/StudioBBox/
-- Path: Lua_Classes/StudioBBox
-- Last updated: 2025-12-05T10:33:20.302Z

---@class StudioBBox
-- Returns the name of the bounding box.
---@return string
---@field GetName fun(self: StudioBBox): string
-- Returns the bone index of the bounding box. This is useful to index the bone matrix to properly transform the bounding box.
---@return any
---@field GetBone fun(self: StudioBBox): any
-- Returns the group index of the bounding box.
---@return any
---@field GetGroup fun(self: StudioBBox): any
-- Returns the minimum point of the bounding box as a Vector3 .
---@return any
---@field GetBBMin fun(self: StudioBBox): any
-- Returns the maximum point of the bounding box as a Vector3 .
---@return any
---@field GetBBMax fun(self: StudioBBox): any
local StudioBBox = {}

