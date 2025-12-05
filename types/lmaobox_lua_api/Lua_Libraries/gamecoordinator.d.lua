---@meta

-- Lmaobox Lua API: gamecoordinator - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/gamecoordinator/
-- Path: Lua_Libraries/gamecoordinator
-- Last updated: 2025-12-05T10:33:20.596Z

---@class gamecoordinator
gamecoordinator = {}

-- Returns true if the player is connected to the game coordinator.
---@return any
function gamecoordinator.ConnectedToGC() end

-- Returns true if the player is in the end of match phase.
---@return any
function gamecoordinator.InEndOfMatch() end

-- Returns true if the player is assigned to a live match.
---@return boolean
function gamecoordinator.HasLiveMatch() end

-- Returns true if the player is connected to the assigned match server.
---@return boolean
function gamecoordinator.IsConnectedToMatchServer() end

-- Abandons the current match and forcefully disconnects the player from the match server.
---@return any
function gamecoordinator.AbandonMatch() end

-- Returns the status of the match relative to the player connection.
---@return any
function gamecoordinator.GetMatchAbandonStatus() end

-- Returns the ping data for all available data centers in a table. Table example:
---@return any
function gamecoordinator.GetDataCenterPingData() end

-- Returns the number of match invites the player has.
---@return any
function gamecoordinator.GetNumMatchInvites() end

-- Accepts all match invites the player has. Usually it's just one, and they are automatically accepted after some time anyway so you can selectively accept them. Accepting an invite does not immediately join you into the match.
---@return any
function gamecoordinator.AcceptMatchInvites() end

-- Joins the match the player is currently assigned to from the previously acccepted match invite. This is usually called after accepting a match invite if the player wants to join the match. If not, call AbandonMatch() to leave the match.
---@return any
function gamecoordinator.JoinMatchmakingMatch() end

-- Enumerates the maps in the queue and calls the callback function for each map. The callback function receives the MatchMapDefinition and the health of the map represented as a number from 0 to 1. You must receive the GameCoordinator's map health update at least once to use this function (i.e. by ...
---@return any
function gamecoordinator.EnumerateQueueMapsHealth() end

-- Returns the GameServerLobby object for the current match or nil if the player is not in a match.
---@return any
function gamecoordinator.GetGameServerLobby() end

-- Sends a message to the game coordinator. You can use this to send custom messages to the game coordinator. The typeID is the message type, and data is the message data. The data must be a string of protobuf encoded bytes.
---@param typeID number
---@param data any
---@return any
function gamecoordinator.GCSendMessage(typeID, data) end

