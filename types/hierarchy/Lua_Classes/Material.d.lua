---@meta

-- Lmaobox Lua API: Material - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/Material/
-- Path: Lua_Classes/Material
-- Last updated: 2025-12-05T03:32:42.198Z

---@class Material
---@return string
---@field GetName fun(self: Material): string
---@param alpha number
---@return any
---@field AlphaModulate fun(self: Material, alpha: number): any
---@param red number
---@param green number
---@param blue number
---@return any
---@field ColorModulate fun(self: Material, red: number, green: number, blue: number): any
---@param flag number
---@param set boolean
---@return any
---@field SetMaterialVarFlag fun(self: Material, flag: number, set: boolean): any
---@param param string
---@param value any
---@return any
---@field SetShaderParam fun(self: Material, param: string, value: any): any
local Material = {}

