---@meta

-- Lmaobox Lua API: PhysicsEnvironment - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/PhysicsEnvironment/
-- Path: Lua_Classes/PhysicsEnvironment
-- Last updated: 2025-12-05T03:55:13.799Z

---@class PhysicsEnvironment
---@return any
---@field Methods fun(self: PhysicsEnvironment): any
---@param gravity Vector3
---@return any
---@field SetGravity fun(self: PhysicsEnvironment, gravity: Vector3): any
---@return any
---@field GetGravity fun(self: PhysicsEnvironment): any
---@param airDensity number
---@return any
---@field SetAirDensity fun(self: PhysicsEnvironment, airDensity: number): any
---@return any
---@field GetAirDensity fun(self: PhysicsEnvironment): any
---@param deltaTime number
---@return any
---@field Simulate fun(self: PhysicsEnvironment, deltaTime: number): any
---@return boolean
---@field IsInSimulation fun(self: PhysicsEnvironment): boolean
---@return number
---@field GetSimulationTime fun(self: PhysicsEnvironment): number
---@return number
---@field GetSimulationTimestep fun(self: PhysicsEnvironment): number
---@param timestep number
---@return number
---@field SetSimulationTimestep fun(self: PhysicsEnvironment, timestep: number): number
---@return any
---@field GetActiveObjects fun(self: PhysicsEnvironment): any
---@return any
---@field ResetSimulationClock fun(self: PhysicsEnvironment): any
---@param collisionModel any
---@param surfacePropertyName string
---@param objectParams any
---@return any
---@field CreatePolyObject fun(self: PhysicsEnvironment, collisionModel: any, surfacePropertyName: string, objectParams: any): any
---@param object any
---@return any
---@field DestroyObject fun(self: PhysicsEnvironment, object: any): any
local PhysicsEnvironment = {}

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

