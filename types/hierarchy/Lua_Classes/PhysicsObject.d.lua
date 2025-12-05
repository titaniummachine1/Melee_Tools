---@meta

-- Lmaobox Lua API: PhysicsObject - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/PhysicsObject/
-- Path: Lua_Classes/PhysicsObject
-- Last updated: 2025-12-05T03:32:42.230Z

---@class PhysicsObject
---@return any
---@field Wake fun(self: PhysicsObject): any
---@return any
---@field Sleep fun(self: PhysicsObject): any
---@return Vector3
---@field GetPosition fun(self: PhysicsObject): Vector3
---@param position Vector3
---@param angle Vector3
---@param isTeleport boolean
---@return Vector3
---@field SetPosition fun(self: PhysicsObject, position: Vector3, angle: Vector3, isTeleport: boolean): Vector3
---@return Vector3
---@field GetVelocity fun(self: PhysicsObject): Vector3
---@param velocity Vector3
---@param angularVelocity Vector3
---@return Vector3
---@field SetVelocity fun(self: PhysicsObject, velocity: Vector3, angularVelocity: Vector3): Vector3
---@param velocity Vector3
---@param angularVelocity Vector3
---@return Vector3
---@field AddVelocity fun(self: PhysicsObject, velocity: Vector3, angularVelocity: Vector3): Vector3
---@return any
---@field OutputDebugInfo fun(self: PhysicsObject): any
local PhysicsObject = {}

