---@meta

-- Lmaobox Lua API: NetMessage - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/NetMessage/
-- Path: Lua_Classes/NetMessage
-- Last updated: 2025-12-05T11:20:20.735Z

---@class NetMessage
---@return any
---@field GetGroup fun(self: NetMessage): any
---@return any
---@field GetNetChannel fun(self: NetMessage): any
---@return boolean
---@field IsReliable fun(self: NetMessage): boolean
---@param reliable boolean
---@field SetReliable fun(self: NetMessage, reliable: boolean)
---@return any
---@field GetType fun(self: NetMessage): any
---@return string
---@field GetName fun(self: NetMessage): string
---@return string
---@field ToString fun(self: NetMessage): string
---@param bitBuffer BitBuffer
---@return any
---@field WriteToBitBuffer fun(self: NetMessage, bitBuffer: BitBuffer): any
---@param bitBuffer BitBuffer
---@return any
---@field ReadFromBitBuffer fun(self: NetMessage, bitBuffer: BitBuffer): any
local NetMessage = {}

