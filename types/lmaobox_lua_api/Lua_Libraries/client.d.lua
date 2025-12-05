---@meta

-- Lmaobox Lua API: client - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/client/
-- Path: Lua_Libraries/client
-- Last updated: 2025-12-05T11:44:38.699Z

---@class client
client = {}

-- Returns the number of extra inventory slots the user has.
---@return number
function client.GetExtraInventorySlots() end

-- Returns whether the user is a free trial account.
---@return boolean
function client.IsFreeTrialAccount() end

-- Returns whether the user has competitive access.
---@return boolean
function client.HasCompetitiveAccess() end

-- Returns whether the user is in the coaches list.
---@return boolean
function client.IsInCoachesList() end

-- Translate world position into screen position (x,y). view is optional, and of type ViewSetup
---@param worldPos Vector3
---@param view ViewSetup
---@return any
function client.WorldToScreen(worldPos, view) end

-- Run command in game console
---@param command string
---@param unrestrict boolean
---@return any
function client.Command(command, unrestrict) end

-- Say text on chat
---@param msg string
---@return any
function client.ChatSay(msg) end

-- Say text on team chat
---@param msg string
---@return any
function client.ChatTeamSay(msg) end

-- DOES NOTHING. All events are allowed by default. This function is deprecated and it's only there to not cause errors in existing scripts.
---@param eventName string
---@return any
function client.AllowListener(eventName) end

-- Return player name by index
---@param index number
---@return number
function client.GetPlayerNameByIndex(index) end

-- Return player name by user id
---@param userID number
---@return string
function client.GetPlayerNameByUserID(userID) end

-- Returns the following table:
---@param index number
---@return Entity|nil
function client.GetPlayerInfo(index) end

-- Returns the players view setup. See ViewSetup for more information.
---@return Entity|nil
function client.GetPlayerView() end

-- Return local player index
---@return number
function client.GetLocalPlayerIndex() end

-- Get game convar value. Returns integer, number and string if found. Returns nil if not found.
---@param name string
---@return string
function client.GetConVar(name) end

-- Set game convar value. Value can be integer, number, string.
---@param name string
---@param value any
function client.SetConVar(name, value) end

-- Remove convar protection. This is needed for convars that are not allowed to be changed by the server.
---@param name string
---@return any
function client.RemoveConVarProtection(name) end

-- Print text on chat, this text can be colored. Color codes are:
---@param msg string
---@return any
function client.ChatPrintf(msg) end

-- Returns a localized string. The localizable strings usually start with a # character, but there are exceptions. Will return nil on failure.
---@param key string
---@return string
function client.Localize(key) end

