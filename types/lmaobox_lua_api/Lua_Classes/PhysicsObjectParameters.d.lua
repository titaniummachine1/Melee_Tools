---@meta

-- Lmaobox Lua API: PhysicsObjectParameters - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/PhysicsObjectParameters/
-- Path: Lua_Classes/PhysicsObjectParameters
-- Last updated: 2025-12-05T11:43:58.570Z

-- This is a class that contains parameters for a physics object. You can use this to set the mass, drag, and other parameters of a physics object.

---@class PhysicsObjectParameters
---@field mass number
---@field inertia number
---@field damping number
---@field rotdamping number
---@field rotInertiaLimit number
---@field volume number
---@field dragCoefficient number
---@field enableCollisions boolean
-- number The mass of the physics object.
---@return any
---@field mass fun(self: PhysicsObjectParameters): any
-- number The inertia of the physics object.
---@return any
---@field inertia fun(self: PhysicsObjectParameters): any
-- number The damping of the physics object.
---@return any
---@field damping fun(self: PhysicsObjectParameters): any
-- number The rotational damping of the physics object.
---@return any
---@field rotdamping fun(self: PhysicsObjectParameters): any
-- number The rotational inertia limit of the physics object.
---@return any
---@field rotInertiaLimit fun(self: PhysicsObjectParameters): any
-- number The volume of the physics object.
---@return any
---@field volume fun(self: PhysicsObjectParameters): any
-- number The drag coefficient of the physics object.
---@return any
---@field dragCoefficient fun(self: PhysicsObjectParameters): any
-- boolean Whether or not the physics object should collide with other physics objects.
---@return boolean
---@field enableCollisions fun(self: PhysicsObjectParameters): boolean
local PhysicsObjectParameters = {}

