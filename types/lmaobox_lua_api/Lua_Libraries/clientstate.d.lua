---@meta

-- Lmaobox Lua API: clientstate - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/clientstate/
-- Path: Lua_Libraries/clientstate
-- Last updated: 2025-12-05T11:44:38.713Z

---@class clientstate
clientstate = {}

-- Requests a full update from the server. This can lag the game a bit and should be used sparingly. It can even cause the game to crash if used incorrectly.
---@return any
function clientstate.ForceFullUpdate() end

-- Returns the current client signon state. This is useful for determining if the client is fully connected to the server.
---@return any
function clientstate.GetClientSignonState() end

-- Returns the tick number of the last received tick.
---@return number
function clientstate.GetDeltaTick() end

-- Returns the last outgoing command number.
---@return number
function clientstate.GetLastOutgoingCommand() end

-- Returns the number of commands the client is currently choking.
---@return number
function clientstate.GetChokedCommands() end

-- Returns the last command acknowledged by the server.
---@return any
function clientstate.GetLastCommandAck() end

-- Returns the NetChannel object. This can be nil if the client is not connected to a server. NetChannel first spawns when a "client_connected" event is fired.
---@return any
function clientstate.GetNetChannel() end

