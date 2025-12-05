---@meta

-- Lmaobox Lua API: entities - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/entities/
-- Path: Lua_Libraries/entities
-- Last updated: 2025-12-05T11:09:57.403Z

---@class entities
entities = {}

---@param className string
---@return any
function entities.FindByClass(className) end

---@return Entity|nil
function entities.GetLocalPlayer() end

---@param index number
---@return number
function entities.GetByIndex(index) end

---@return number
function entities.GetHighestEntityIndex() end

---@param userID number
---@return any
function entities.GetByUserID(userID) end

---@return Entity|nil
function entities.GetPlayerResources() end

---@param className string
---@return string
function entities.CreateEntityByName(className) end

---@param className string
---@return string
function entities.CreateTempEntityByName(className) end

