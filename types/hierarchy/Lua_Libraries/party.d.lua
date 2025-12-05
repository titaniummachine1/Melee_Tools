---@meta

-- Lmaobox Lua API: party - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/party/
-- Path: Lua_Libraries/party
-- Last updated: 2025-12-05T03:55:13.907Z

---@class party
party = {}

---@return any
function party.Functions() end

---@return any
function party.Examples() end

---@return any
function party.GetLeader() end

---@return any
function party.GetMembers() end

---@return any
function party.GetPendingMembers() end

---@return any
function party.GetGroupID() end

---@return any
function party.GetQueuedMatchGroups() end

---@return any
function party.GetAllMatchGroups() end

---@return any
function party.Leave() end

---@param matchGroup any
---@return boolean
function party.CanQueueForMatchGroup(matchGroup) end

---@param matchGroup any
---@return any
function party.QueueUp(matchGroup) end

---@param matchGroup any
---@return boolean
function party.CancelQueue(matchGroup) end

---@return boolean
function party.IsInStandbyQueue() end

---@return boolean
function party.CanQueueForStandby() end

---@return any
function party.QueueUpStandby() end

---@return boolean
function party.CancelQueueStandby() end

---@param index number
---@return any
function party.GetMemberActivity(index) end

---@param steamid string
---@return any
function party.PromoteMemberToLeader(steamid) end

---@param steamid string
---@return any
function party.KickMember(steamid) end

---@param map any
---@return boolean
function party.IsCasualMapSelected(map) end

---@param map any
---@param selected boolean
---@return any
function party.SetCasualMapSelected(map, selected) end

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

