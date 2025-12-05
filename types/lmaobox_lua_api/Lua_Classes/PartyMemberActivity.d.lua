---@meta

-- Lmaobox Lua API: PartyMemberActivity - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/PartyMemberActivity/
-- Path: Lua_Classes/PartyMemberActivity
-- Last updated: 2025-12-05T12:04:25.903Z

---@class PartyMemberActivity
-- Returns the lobby ID of the party member. This can be used to find out whether the party member is currently in a matchmade game.
---@return boolean
---@field GetLobbyID fun(self: PartyMemberActivity): boolean
-- Returns whether the party member is currently online.
---@return boolean
---@field IsOnline fun(self: PartyMemberActivity): boolean
-- Returns whether the party member is currently blocked from joining a matchmade game.
---@return boolean
---@field IsMultiqueueBlocked fun(self: PartyMemberActivity): boolean
-- Returns the client version of the party member.
---@return any
---@field GetClientVersion fun(self: PartyMemberActivity): any
local PartyMemberActivity = {}

