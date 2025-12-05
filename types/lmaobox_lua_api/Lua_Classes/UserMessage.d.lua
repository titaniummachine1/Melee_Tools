---@meta

-- Lmaobox Lua API: UserMessage - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/UserMessage/
-- Path: Lua_Classes/UserMessage
-- Last updated: 2025-12-05T11:20:20.849Z

---@class UserMessage
-- Reading starts at the beginning of the message (curBit = 0). Each call to Read*() advances the read cursor by the number of bits read. Reading past the end of the message will cause an error.
---@return any
---@field Reading fun(self: UserMessage): any
-- Writing to the BitBuffer changes the actual message contents, so you can modify what you're receiving.
---@return any
---@field Writing fun(self: UserMessage): any
---@return any
---@field Example fun(self: UserMessage): any
-- Returns the ID of the message. You can get the list here: TF2 User Messages .
---@return any
---@field GetID fun(self: UserMessage): any
-- Returns the BitBuffer object that contains the message data.
---@return any
---@field GetBitBuffer fun(self: UserMessage): any
local UserMessage = {}

