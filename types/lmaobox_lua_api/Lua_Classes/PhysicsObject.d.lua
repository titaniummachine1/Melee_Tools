---@meta

-- Lmaobox Lua API: PhysicsObject - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/PhysicsObject/
-- Path: Lua_Classes/PhysicsObject
-- Last updated: 2025-12-05T11:43:57.416Z

-- PhysicsObject is a class that represents a physics object. It has a position, angle, velocity, angular velocity, and is affected by gravity and air resistance. It can be simulated in time. Other parameters include class PhysicsObjectParameters .

---@class PhysicsObject
-- Wakes up the physics object. It will become active in the physics environment and will be simulated in time if the physics environment is simulating.
---@return any
---@field Wake fun(self: PhysicsObject): any
-- Puts the physics object to sleep. It will become inactive in the physics environment and will not be simulated.
---@return any
---@field Sleep fun(self: PhysicsObject): any
-- Returns the position of the physics object as a Vector3 and the angle as a Vector3 second return value.
---@return Vector3
---@field GetPosition fun(self: PhysicsObject): Vector3
-- Sets the position and angle of the physics object. If isTeleport is true, the physics object will be teleported to the new position and angle.
---@param position Vector3
---@param angle Vector3
---@param isTeleport boolean
---@field SetPosition fun(self: PhysicsObject, position: Vector3, angle: Vector3, isTeleport: boolean)
-- Returns the velocity of the physics object as a Vector3 and the angular velocity as a Vector3 second return value.
---@return Vector3
---@field GetVelocity fun(self: PhysicsObject): Vector3
-- Sets the velocity and angular velocity of the physics object.
---@param velocity Vector3
---@param angularVelocity Vector3
---@field SetVelocity fun(self: PhysicsObject, velocity: Vector3, angularVelocity: Vector3)
-- Adds the velocity and angular velocity to the physics object.
---@param velocity Vector3
---@param angularVelocity Vector3
---@return Vector3
---@field AddVelocity fun(self: PhysicsObject, velocity: Vector3, angularVelocity: Vector3): Vector3
-- Outputs debug information about the physics object to the console.
---@return any
---@field OutputDebugInfo fun(self: PhysicsObject): any
local PhysicsObject = {}

