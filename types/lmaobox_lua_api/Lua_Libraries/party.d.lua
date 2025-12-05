---@meta

-- Lmaobox Lua API: party - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/party/
-- Path: Lua_Libraries/party
-- Last updated: 2025-12-05T11:44:38.947Z

---@class party
party = {}

-- Returns the player's party leader's SteamID as string.
---@return string
function party.GetLeader() end

-- Returns a table containing the player's party members' SteamIDs as strings.
---@return string
function party.GetMembers() end

-- Returns a table containing the player's pending party members' SteamIDs as strings. These members are invited to party, but have not joined yet.
---@return string
function party.GetPendingMembers() end

-- Returns the player's party's group ID.
---@return any
function party.GetGroupID() end

-- Returns a table where values are the player's queued match groups as MatchGroup objects.
---@return any
function party.GetQueuedMatchGroups() end

-- Returns a table where values are all possible match groups as MatchGroup objects.
---@return any
function party.GetAllMatchGroups() end

-- Leaves the current party.
---@return any
function party.Leave() end

-- Returns true if the player can queue for the given match group. If the player can not queue for the match groups, returns a table of reasons why the player can not queue.
---@param matchGroup any
---@return boolean
function party.CanQueueForMatchGroup(matchGroup) end

-- Requests to queue up for a match group.
---@param matchGroup any
---@return any
function party.QueueUp(matchGroup) end

-- Cancles the request to queue up for a match group.
---@param matchGroup any
---@return boolean
function party.CancelQueue(matchGroup) end

-- Whether the player is in the standby queue. That refers to queueing up for an ongoing match in your party.
---@return boolean
function party.IsInStandbyQueue() end

-- Returns whether the player can queue up for a standby match. That refers to an ongoing match in your party.
---@return boolean
function party.CanQueueForStandby() end

-- Requests to queue up for a standby match in your party. That refers to an ongoing match in your party.
---@return any
function party.QueueUpStandby() end

-- Cancles the request to queue up for a standby match in your party. That refers to an ongoing match in your party.
---@return boolean
function party.CancelQueueStandby() end

-- Returns a PartyMemberActivity object for the party member at the given index. See GetMembers() for the index.
---@param index number
---@return any
function party.GetMemberActivity(index) end

-- Promotes the given player to the party leader. Works only if you are the party leader.
---@param steamid string
---@return any
function party.PromoteMemberToLeader(steamid) end

-- Kicks the given player from the party. Works only if you are the party leader.
---@param steamid string
---@return any
function party.KickMember(steamid) end

-- Returns true if the given map is selected for casual play.
---@param map any
---@return boolean
function party.IsCasualMapSelected(map) end

-- Sets the given map as selected for casual play.
---@param map any
---@param selected boolean
function party.SetCasualMapSelected(map, selected) end

