---@meta

-- Lmaobox Lua API: NetMessage - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/NetMessage/
-- Path: Lua_Classes/NetMessage
-- Last updated: 2025-12-05T09:48:47.863Z

---@class NetMessage
---@return any
---@field Methods fun(self: NetMessage): any
---@return any
---@field Examples fun(self: NetMessage): any
---@return any
---@field GetGroup fun(self: NetMessage): any
---@return any
---@field GetNetChannel fun(self: NetMessage): any
---@return boolean
---@field IsReliable fun(self: NetMessage): boolean
---@param reliable boolean
---@return any
---@field SetReliable fun(self: NetMessage, reliable: boolean): any
---@return any
---@field GetType fun(self: NetMessage): any
---@return string
---@field GetName fun(self: NetMessage): string
---@return string
---@field ToString fun(self: NetMessage): string
---@param bitBuffer any
---@return any
---@field WriteToBitBuffer fun(self: NetMessage, bitBuffer: any): any
---@param bitBuffer any
---@return any
---@field ReadFromBitBuffer fun(self: NetMessage, bitBuffer: any): any
local NetMessage = {}

