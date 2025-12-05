---@meta

-- Lmaobox Lua API: playerlist - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/playerlist/
-- Path: Lua_Libraries/playerlist
-- Last updated: 2025-12-05T11:09:57.458Z

---@class playerlist
playerlist = {}

---@param player Entity|nil
---@return any
function playerlist.GetPriority(player) end

---@param userID number
---@return any
function playerlist.GetPriority(userID) end

---@param steamID string
---@return any
function playerlist.GetPriority(steamID) end

---@param player Entity|nil
---@param priority number
function playerlist.SetPriority(player, priority) end

---@param userID number
---@param priority number
function playerlist.SetPriority(userID, priority) end

---@param steamID string
---@param priority number
function playerlist.SetPriority(steamID, priority) end

---@param player Entity|nil
---@return any
function playerlist.GetColor(player) end

---@param userID number
---@return any
function playerlist.GetColor(userID) end

---@param steamID string
---@return any
function playerlist.GetColor(steamID) end

---@param player Entity|nil
---@param color number
function playerlist.SetColor(player, color) end

---@param userID number
---@param color number
function playerlist.SetColor(userID, color) end

---@param steamID string
---@param color number
function playerlist.SetColor(steamID, color) end

