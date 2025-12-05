---@meta

-- Lmaobox Lua API: steam - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/steam/
-- Path: Lua_Libraries/steam
-- Last updated: 2025-12-05T11:44:39.019Z

---@class steam
steam = {}

-- Returns SteamID of the user as string.
---@return string
function steam.GetSteamID() end

-- Returns the player name of the player having the given SteamID.
---@param steamid string
---@return string
function steam.GetPlayerName(steamid) end

-- Returns true if the player is a friend of the user.
---@param steamid string
---@return boolean
function steam.IsFriend(steamid) end

-- Returns a table of all friends of the user.
---@return any
function steam.GetFriends() end

-- Returns the 64bit SteamID of the player as a long integer.
---@param steamid string
---@return number
function steam.ToSteamID64(steamid) end

