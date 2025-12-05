---@meta

-- Lmaobox Lua API: gamerules - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/gamerules/
-- Path: Lua_Libraries/gamerules
-- Last updated: 2025-12-05T10:33:20.602Z

---@class gamerules
gamerules = {}

-- Returns true if the match is a casual match.
---@return boolean
function gamerules.IsMatchTypeCasual() end

-- Returns true if the match is a competitive match.
---@return boolean
function gamerules.IsMatchTypeCompetitive() end

-- Returns true if the matchmaking match has ended.
---@return boolean
function gamerules.IsManagedMatchEnded() end

-- Returns the time left in the match.
---@return number
function gamerules.GetTimeLeftInMatch() end

-- When truce is active, players cannot attack each other.
---@return boolean
function gamerules.IsTruceActive() end

-- Returns true if the current match is a MvM game.
---@return boolean
function gamerules.IsMvM() end

-- Returns the current match group.
---@return any
function gamerules.GetCurrentMatchGroup() end

-- Returns true if current gamemode allows players to use the grappling hook.
---@return boolean
function gamerules.IsUsingGrapplingHook() end

-- Returns true if current gamemode allows players to use spells.
---@return boolean
function gamerules.IsUsingSpells() end

-- Returns the current next map voting state.
---@return any
function gamerules.GetCurrentNextMapVotingState() end

-- Returns the vote state of the player with the given index.
---@param playerIndex number
---@return Entity|nil
function gamerules.GetPlayerVoteState(playerIndex) end

-- Returns the current state of the round as integer.
---@return any
function gamerules.GetRoundState() end

