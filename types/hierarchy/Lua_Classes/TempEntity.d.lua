---@meta

-- Lmaobox Lua API: TempEntity - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/TempEntity/
-- Path: Lua_Classes/TempEntity
-- Last updated: 2025-12-05T03:42:28.921Z

---@class TempEntity
---@return string
---@field GetNetworkName fun(self: TempEntity): string
---@return any
---@field Release fun(self: TempEntity): any
---@param dataUpdateType number
---@return any
---@field PostDataUpdate fun(self: TempEntity, dataUpdateType: number): any
---@return any
---@field GetPropFloat fun(self: TempEntity): any
---@return number
---@field GetPropInt fun(self: TempEntity): number
---@return any
---@field GetPropBool fun(self: TempEntity): any
---@return string
---@field GetPropString fun(self: TempEntity): string
---@return Vector3
---@field GetPropVector fun(self: TempEntity): Vector3
---@return Entity|nil
---@field GetPropEntity fun(self: TempEntity): Entity|nil
---@param value number
---@return any
---@field SetPropFloat fun(self: TempEntity, value: number): any
---@param value number
---@return number
---@field SetPropInt fun(self: TempEntity, value: number): number
---@param value boolean
---@return any
---@field SetPropBool fun(self: TempEntity, value: boolean): any
---@param value Entity|nil
---@return Entity|nil
---@field SetPropEntity fun(self: TempEntity, value: Entity|nil): Entity|nil
---@param value Vector3
---@return Vector3
---@field SetPropVector fun(self: TempEntity, value: Vector3): Vector3
---@return any
---@field GetPropDataTableFloat fun(self: TempEntity): any
---@return any
---@field GetPropDataTableBool fun(self: TempEntity): any
---@return number
---@field GetPropDataTableInt fun(self: TempEntity): number
---@return Entity|nil
---@field GetPropDataTableEntity fun(self: TempEntity): Entity|nil
---@param value number
---@param index number
---@return any
---@field SetPropDataTableFloat fun(self: TempEntity, value: number, index: number): any
---@param value number
---@param index number
---@return any
---@field SetPropDataTableBool fun(self: TempEntity, value: number, index: number): any
---@param value number
---@param index number
---@return number
---@field SetPropDataTableInt fun(self: TempEntity, value: number, index: number): number
---@param value Entity|nil
---@param index number
---@return Entity|nil
---@field SetPropDataTableEntity fun(self: TempEntity, value: Entity|nil, index: number): Entity|nil
local TempEntity = {}

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

