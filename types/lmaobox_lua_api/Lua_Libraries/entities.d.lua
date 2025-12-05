---@meta

-- Lmaobox Lua API: entities - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/entities/
-- Path: Lua_Libraries/entities
-- Last updated: 2025-12-05T12:04:26.052Z

---@class entities
entities = {}

-- Find and put into table all entities with given class name
---@param className string
---@return any
function entities.FindByClass(className) end

-- Return local player entity
---@return Entity|nil
function entities.GetLocalPlayer() end

-- Return entity by index
---@param index number
---@return number
function entities.GetByIndex(index) end

-- Return highest entity index
---@return number
function entities.GetHighestEntityIndex() end

-- Return entity by user id
---@param userID number
---@return any
function entities.GetByUserID(userID) end

-- Return player resources entity
---@return Entity|nil
function entities.GetPlayerResources() end

-- Creates a non-networkable entity by class name, returns entity. Keep in mind that YOU are responsible for its entire lifecycle and for releasing the entity later by calling entity.Release .
---@param className string
---@return string
function entities.CreateEntityByName(className) end

-- Creates a non-networkable temporary entity of type TempEntity . You are responsible for calling tempentity.Release when you are done with the entity. To trigger the entity, call PostDataUpdate.
---@param className string
---@return string
function entities.CreateTempEntityByName(className) end

