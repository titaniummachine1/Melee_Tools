---@meta

-- Lmaobox Lua API: physics - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/physics/
-- Path: Lua_Libraries/physics
-- Last updated: 2025-12-05T11:44:38.956Z

---@class physics
physics = {}

-- Creates a new physics environment of class PhysicsEnvironment . By default it has no gravity, and no air resistance and no collisions.
---@return any
function physics.CreateEnvironment() end

-- Destroys a physics environment.
---@param environment any
---@return any
function physics.DestroyEnvironment(environment) end

-- Returns the default physics environment. This is the environment that TF2 client uses for clientside physics calculations. Wouldnt recommend using, can cause odd side effects, but im not your mom.
---@return any
function physics.DefaultEnvironment() end

-- Creates a collision model from a bounding box. Returns a PhysicsCollisionModel object.
---@param mins Vector3
---@param maxs Vector3
---@return any
function physics.BBoxToCollisionModel(mins, maxs) end

-- Creates a PhysicsSolid and a PhysicsCollisionModel from a model name. Returns a PhysicsSolid object and a PhysicsCollisionModel object.
---@param modelName string
---@return string
function physics.ParseModelByName(modelName) end

-- Creates a PhysicsObjectParameters object with default values.
---@return any
function physics.DefaultObjectParameters() end

