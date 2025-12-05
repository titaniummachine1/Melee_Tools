---@meta

-- Lmaobox Lua API: physics - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/physics/
-- Path: Lua_Libraries/physics
-- Last updated: 2025-12-05T11:20:21.041Z

---@class physics
physics = {}

---@return any
function physics.CreateEnvironment() end

---@param environment any
---@return any
function physics.DestroyEnvironment(environment) end

---@return any
function physics.DefaultEnvironment() end

---@param mins Vector3
---@param maxs Vector3
---@return any
function physics.BBoxToCollisionModel(mins, maxs) end

---@param modelName string
---@return string
function physics.ParseModelByName(modelName) end

---@return any
function physics.DefaultObjectParameters() end

