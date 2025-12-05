---@meta

-- Lmaobox Lua API: render - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/render/
-- Path: Lua_Libraries/render
-- Last updated: 2025-12-05T11:44:38.977Z

---@class render
render = {}

-- Push a 3D view of type ViewSetup to the render stack. Flags is a bitfield of Clear flags. Texture is a Texture object to render to. If texture is nil, the current render target is used.
---@param view ViewSetup
---@param clearFlags number
---@param texture any
---@return any
function render.Push3DView(view, clearFlags, texture) end

-- Pop the current view from the render stack.
---@return any
function render.PopView() end

-- Draw the scene onto the texture that is currently on top of the stack - by default your whole screen. draw3Dskybox and drawSkybox are booleans that determine if the 3D skybox or 2D skybox should be drawn. View is a ViewSetup object.
---@param draw3Dskybox boolean
---@param drawSkybox boolean
---@param view ViewSetup
---@return any
function render.ViewDrawScene(draw3Dskybox, drawSkybox, view) end

-- Draw a screen space rectangle with a given Material. Material is a Material object. destX and destY are the coordinates of the top left corner of the rectangle. width and height are the dimensions of the rectangle. srcTextureX0, srcTextureY0, srcTextureX1, srcTextureY1 are the coordinates of the top left and bottom right corners of the rectangle on the texture. srcTextureWidth and srcTextureHeight are the dimensions of the texture.
---@param material any
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

-- Draws a screen space quad by material
---@param material any
---@return any
function render.DrawScreenSpaceQuad(material) end

-- Returns x, y, w, h of current viewport
---@return Vector3
function render.GetViewport() end

-- Sets current viewport
---@param x number
---@param y number
---@param w number
---@param h number
function render.Viewport(x, y, w, h) end

-- Sets the depth range of rendering
---@param zNear number
---@param zFar number
function render.DepthRange(zNear, zFar) end

-- Returns the depth range of rendering as zNear, zFar
---@return any
function render.GetDepthRange() end

-- Sets the current render target to texture.
---@param texture any
function render.SetRenderTarget(texture) end

-- Returns the current render target as a Texture object.
---@return any
function render.GetRenderTarget() end

-- Clears the current render target's buffers. clearColor, clearDepth and clearStencil are booleans that determine which buffers should be cleared.
---@param clearColor boolean
---@param clearDepth boolean
---@param clearStencil boolean
function render.ClearBuffers(clearColor, clearDepth, clearStencil) end

-- Clears the current render target's color buffer with the given RGB values. r, g and b are integers between 0 and 255.
---@param r number
---@param g number
---@param b number
function render.ClearColor3ub(r, g, b) end

-- Clears the current render target's color buffer with the given RGBA values. r, g, b and a are integers between 0 and 255.
---@param r number
---@param g number
---@param b number
---@param a number
function render.ClearColor4ub(r, g, b, a) end

-- Sets the depth override state. enable is a boolean that determines if the depth override is enabled. depthEnable is a boolean that determines if depth testing is enabled when the depth override is enabled.
---@param enable boolean
---@param depthEnable boolean
function render.OverrideDepthEnable(enable, depthEnable) end

-- Sets the alpha write override state. enable is a boolean that determines if the alpha write override is enabled. alphaWriteEnable is a boolean that determines if alpha writing is enabled when the alpha write override is enabled.
---@param enable boolean
---@param alphaWriteEnable boolean
function render.OverrideAlphaWriteEnable(enable, alphaWriteEnable) end

-- Push the current render target and viewport to the stack.
---@return any
function render.PushRenderTargetAndViewport() end

-- Pop the current render target and viewport from the stack.
---@return any
function render.PopRenderTargetAndViewport() end

-- Sets the stencil staet. enable is a boolean that determines if the stencil test is enabled.
---@param enable boolean
function render.SetStencilEnable(enable) end

-- Seets the stencil fail operation. failOp is an integer that determines the operation to perform when the stencil test fails. The possible values are of enum E_StencilOperation.
---@param failOp number
function render.SetStencilFailOperation(failOp) end

-- Sets the stencil Z fail operation. zFailOp is an integer that determines the operation to perform when the stencil test passes but the depth test fails. The possible values are of enum E_StencilOperation.
---@param zFailOp number
function render.SetStencilZFailOperation(zFailOp) end

-- Sets the stencil pass operation. passOp is an integer that determines the operation to perform when the stencil test passes. The possible values are of enum E_StencilOperation.
---@param passOp number
function render.SetStencilPassOperation(passOp) end

-- Set the stencil compare function. compareFunc is an integer that determines the comparison function to use. The possible values are of enum E_StencilComparisonFunction.
---@param compareFunc number
function render.SetStencilCompareFunction(compareFunc) end

-- Ssets the stencil reference value. comparationValue is an integer that determines the reference value to use for the stencil test. The value is clamped between 0 and 255.
---@param comparationValue number
function render.SetStencilReferenceValue(comparationValue) end

-- Sets the stencil test mask. mask is an integer that determines the mask to use for the stencil test. The value is clamped between 0 and 0xFFFFFFFF.
---@param mask number
function render.SetStencilTestMask(mask) end

-- Sets the stencil write mask. mask is an integer that determines the mask to use for writing to the stencil buffer. The value is clamped between 0 and 0xFFFFFFFF.
---@param mask number
function render.SetStencilWriteMask(mask) end

-- Clears the stencil buffer rectangle. xmin, ymin, xmax and ymax are integers that determine the rectangle to clear. value is an integer that determines the value to clear the rectangle to.
---@param xmin number
---@param ymin number
---@param xmax number
---@param ymax number
---@param value number
function render.ClearStencilBufferRectangle(xmin, ymin, xmax, ymax, value) end

-- Sets the forced material override. material is a Material object that determines the material to use for all subsequent draw calls. Pass nil to disable the forced material override.
---@param material any
function render.ForcedMaterialOverride(material) end

-- Set the blend factor. blend is a float that determines the blend factor to use for all subsequent draw calls. The value is clamped between 0 and 1. This is used for alpha blending.
---@param blend number
function render.SetBlend(blend) end

-- Reutrns the current blend factor as a float.
---@return any
function render.GetBlend() end

-- Set the color modulation. r, g and b are floats that determine the color modulation to use for all subsequent draw calls. The values are clamped between 0 and 1. This is used for color tinting.
---@param r number
---@param g number
---@param b number
function render.SetColorModulation(r, g, b) end

-- Returns r,g,b - 3 floats that represent the current color modulation.
---@return any
function render.GetColorModulation() end

