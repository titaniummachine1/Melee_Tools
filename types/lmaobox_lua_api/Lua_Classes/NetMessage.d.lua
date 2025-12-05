---@meta

-- Lmaobox Lua API: NetMessage - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/NetMessage/
-- Path: Lua_Classes/NetMessage
-- Last updated: 2025-12-05T11:44:38.441Z

---@class NetMessage
-- Returns the message group.
---@return any
---@field GetGroup fun(self: NetMessage): any
-- Returns the NetChannel object that the message belongs to.
---@return any
---@field GetNetChannel fun(self: NetMessage): any
-- Returns true if the message is reliable.
---@return boolean
---@field IsReliable fun(self: NetMessage): boolean
-- Sets the message to be reliable or unreliable.
---@param reliable boolean
---@field SetReliable fun(self: NetMessage, reliable: boolean)
-- Returns the message type.
---@return any
---@field GetType fun(self: NetMessage): any
-- Returns the message name.
---@return string
---@field GetName fun(self: NetMessage): string
-- Returns the message as a human readable string with the contents of the message.
---@return string
---@field ToString fun(self: NetMessage): string
-- Writes the message content to a BitBuffer , useful for reading its variables via the bit buffer. Make sure that current bit position is correct and that you do not overflow the buffer.
---@param bitBuffer any
---@return any
---@field WriteToBitBuffer fun(self: NetMessage, bitBuffer: any): any
-- Reads the message content from a BitBuffer and applies it to the message. If done in SendNetMsg callback, the sent message will be changed. Make sure that current bit position is correct.
---@param bitBuffer any
---@return any
---@field ReadFromBitBuffer fun(self: NetMessage, bitBuffer: any): any
local NetMessage = {}

