---@meta

-- Lmaobox Lua API: StaticPropRenderInfo - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Classes/StaticPropRenderInfo/
-- Path: Lua_Classes/StaticPropRenderInfo
-- Last updated: 2025-12-05T10:33:20.294Z

---@class StaticPropRenderInfo
-- Replace material used to draw the models. Material can be found or created via materials. API
---@param mat Material|nil
---@return any
---@field ForcedMaterialOverride fun(self: StaticPropRenderInfo, mat: Material|nil): any
-- Redraws the models. Can be used to achieve various effects with different materials.
---@return any
---@field DrawExtraPass fun(self: StaticPropRenderInfo): any
-- Sets the color modulation of the models via StudioRender.
---@param color Color|nil
---@return any
---@field StudioSetColorModulation fun(self: StaticPropRenderInfo, color: Color|nil): any
-- Sets the alpha modulation of the models via StudioRender.
---@param alpha number
---@return any
---@field StudioSetAlphaModulation fun(self: StaticPropRenderInfo, alpha: number): any
local StaticPropRenderInfo = {}

