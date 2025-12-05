---@meta

-- Lmaobox Lua API: playerlist - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/playerlist/
-- Path: Lua_Libraries/playerlist
-- Last updated: 2025-12-05T12:04:26.115Z

---@class playerlist
playerlist = {}

-- Returns the priority of the player.
---@param player any
---@return any
function playerlist.GetPriority(player) end

-- Returns the priority of the player by user ID.
---@param userID number
---@return any
function playerlist.GetPriority(userID) end

-- Returns the priority of the player by Steam ID.
---@param steamID string
---@return any
function playerlist.GetPriority(steamID) end

-- Sets the priority of the player.
---@param player any
---@param priority number
function playerlist.SetPriority(player, priority) end

-- Sets the priority of the player by user ID.
---@param userID number
---@param priority number
function playerlist.SetPriority(userID, priority) end

-- Sets the priority of the player by Steam ID.
---@param steamID string
---@param priority number
function playerlist.SetPriority(steamID, priority) end

-- Returns the color of the player.
---@param player any
---@return any
function playerlist.GetColor(player) end

-- Returns the color of the player by user ID.
---@param userID number
---@return any
function playerlist.GetColor(userID) end

-- Returns the color of the player by Steam ID.
---@param steamID string
---@return any
function playerlist.GetColor(steamID) end

-- Sets the color of the player.
---@param player any
---@param color number
function playerlist.SetColor(player, color) end

-- Sets the color of the player by user ID.
---@param userID number
---@param color number
function playerlist.SetColor(userID, color) end

-- Sets the color of the player by Steam ID.
---@param steamID string
---@param color number
function playerlist.SetColor(steamID, color) end

