---@meta

-- Lmaobox Lua API: render - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/render/
-- Path: Lua_Libraries/render
-- Last updated: 2025-12-05T04:07:53.893Z

---@class render
render = {}

---@return any
function render.Functions() end

---@return any
function render.Examples() end

---@param view ViewSetup
---@param clearFlags number
---@param texture any
---@return any
function render.Push3DView(view, clearFlags, texture) end

---@return any
function render.PopView() end

---@param draw3Dskybox boolean
---@param drawSkybox boolean
---@param view ViewSetup
---@return any
function render.ViewDrawScene(draw3Dskybox, drawSkybox, view) end

---@param material Material|nil
---@param destX number
---@param destY number
---@param width number
---@param height number
---@param srcTextureX0 number
---@param srcTextureY0 number
---@param srcTextureX1 number
---@param srcTextureY1 number
---@param srcTextureWidth number
---@param srcTextureHeight number
---@return any
function render.DrawScreenSpaceRectangle(material, destX, destY, width, height, srcTextureX0, srcTextureY0, srcTextureX1, srcTextureY1, srcTextureWidth, srcTextureHeight) end

---@param material Material|nil
---@return any
function render.DrawScreenSpaceQuad(material) end

---@return any
function render.GetViewport() end

---@param x number
---@param y number
---@param w number
---@param h number
---@return any
function render.Viewport(x, y, w, h) end

---@param zNear number
---@param zFar number
---@return any
function render.DepthRange(zNear, zFar) end

---@return any
function render.GetDepthRange() end

---@return any
function render.SetRenderTarget() end

---@return any
function render.GetRenderTarget() end

---@param clearColor boolean
---@param clearDepth boolean
---@param clearStencil boolean
---@return any
function render.ClearBuffers(clearColor, clearDepth, clearStencil) end

---@param r number
---@param g number
---@param b number
---@return any
function render.ClearColor3ub(r, g, b) end

---@param r number
---@param g number
---@param b number
---@param a number
---@return any
function render.ClearColor4ub(r, g, b, a) end

---@param enable boolean
---@param depthEnable boolean
---@return any
function render.OverrideDepthEnable(enable, depthEnable) end

---@param enable boolean
---@param alphaWriteEnable boolean
---@return any
function render.OverrideAlphaWriteEnable(enable, alphaWriteEnable) end

---@return any
function render.PushRenderTargetAndViewport() end

---@return any
function render.PopRenderTargetAndViewport() end

---@param enable boolean
---@return any
function render.SetStencilEnable(enable) end

---@param failOp number
---@return any
function render.SetStencilFailOperation(failOp) end

---@param zFailOp number
---@return any
function render.SetStencilZFailOperation(zFailOp) end

---@param passOp number
---@return any
function render.SetStencilPassOperation(passOp) end

---@param compareFunc number
---@return any
function render.SetStencilCompareFunction(compareFunc) end

---@param comparationValue number
---@return any
function render.SetStencilReferenceValue(comparationValue) end

---@param mask number
---@return any
function render.SetStencilTestMask(mask) end

---@param mask number
---@return any
function render.SetStencilWriteMask(mask) end

---@param xmin number
---@param ymin number
---@param xmax number
---@param ymax number
---@param value number
---@return any
function render.ClearStencilBufferRectangle(xmin, ymin, xmax, ymax, value) end

---@param material Material|nil
---@return any
function render.ForcedMaterialOverride(material) end

---@param blend number
---@return any
function render.SetBlend(blend) end

---@return any
function render.GetBlend() end

---@param r number
---@param g number
---@param b number
---@return any
function render.SetColorModulation(r, g, b) end

---@return any
function render.GetColorModulation() end

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

