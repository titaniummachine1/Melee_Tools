---@meta

-- Lmaobox Lua API: Material - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/Material/
-- Path: Lua_Classes/Material
-- Last updated: 2025-12-05T11:44:38.404Z

---@class Material
-- Returns the material name
---@return string
---@field GetName fun(self: Material): string
-- Returns group the material is part of
---@return string
---@field GetTextureGroupName fun(self: Material): string
-- Modulate transparency of material by given alpha value
---@param alpha number
---@return any
---@field AlphaModulate fun(self: Material, alpha: number): any
-- Modulate color of material by given RGB values
---@param red number
---@param green number
---@param blue number
---@return any
---@field ColorModulate fun(self: Material, red: number, green: number, blue: number): any
-- Change a material variable flag, see MaterialVarFlags for a list of flags. The flag is the integer value of the flag enum, not the string name.
---@param flag number
---@param set boolean
---@field SetMaterialVarFlag fun(self: Material, flag: number, set: boolean)
-- Set a shader parameter, see ShaderParameters for a list of parameters. Supported values are integer, number, Vector3, string.
---@param param string
---@param value any
---@field SetShaderParam fun(self: Material, param: string, value: any)
local Material = {}

