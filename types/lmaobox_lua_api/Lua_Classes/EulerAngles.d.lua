---@meta

-- Lmaobox Lua API: EulerAngles - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/EulerAngles/
-- Path: Lua_Classes/EulerAngles
-- Last updated: 2025-12-05T10:33:20.004Z

---@class EulerAngles
-- Creates a new instace of EulerAngles.
---@return Vector3
---@field EulerAngles fun(self: EulerAngles): Vector3
-- Returns the X, Y, and Z coordinates as a separate variables.
---@return any
---@field Unpack fun(self: EulerAngles): any
-- Clears the angles to 0, 0, 0
---@return any
---@field Clear fun(self: EulerAngles): any
-- Clamps the angles to standard ranges.
---@return any
---@field Normalize fun(self: EulerAngles): any
-- Returns the forward vector of the angles.
---@return any
---@field Forward fun(self: EulerAngles): any
-- Returns the right vector of the angles.
---@return any
---@field Right fun(self: EulerAngles): any
-- Returns the up vector of the angles.
---@return any
---@field Up fun(self: EulerAngles): any
-- Returns the forward, right, and up vectors as 3 return values.
---@return Vector3
---@field Vectors fun(self: EulerAngles): Vector3
local EulerAngles = {}

