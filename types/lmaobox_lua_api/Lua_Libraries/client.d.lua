---@meta

-- Lmaobox Lua API: client - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/client/
-- Path: Lua_Libraries/client
-- Last updated: 2025-12-05T10:33:20.557Z

---@class client
client = {}

---@return any
function client.Functions() end

---@return any
function client.Examples() end

---@return any
function client.GetExtraInventorySlots() end

---@return boolean
function client.IsFreeTrialAccount() end

---@return boolean
function client.HasCompetitiveAccess() end

---@return boolean
function client.IsInCoachesList() end

---@param worldPos Vector3
---@param view ViewSetup
---@return any
function client.WorldToScreen(worldPos, view) end

---@param command string
---@param unrestrict boolean
---@return any
function client.Command(command, unrestrict) end

---@param msg string
---@return any
function client.ChatSay(msg) end

---@param msg string
---@return any
function client.ChatTeamSay(msg) end

---@param eventName string
---@return any
function client.AllowListener(eventName) end

---@param index number
---@return number
function client.GetPlayerNameByIndex(index) end

---@param userID number
---@return string
function client.GetPlayerNameByUserID(userID) end

---@param index number
---@return Entity|nil
function client.GetPlayerInfo(index) end

---@return Entity|nil
function client.GetPlayerView() end

---@return number
function client.GetLocalPlayerIndex() end

---@param name string
---@return any
function client.GetConVar(name) end

---@param name string
---@param value any
---@return any
function client.SetConVar(name, value) end

---@param name string
---@return any
function client.RemoveConVarProtection(name) end

---@param msg string
---@return any
function client.ChatPrintf(msg) end

---@param key string
---@return any
function client.Localize(key) end

