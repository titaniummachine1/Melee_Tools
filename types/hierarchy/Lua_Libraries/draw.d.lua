---@meta

-- Lmaobox Lua API: draw - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/draw/
-- Path: Lua_Libraries/draw
-- Last updated: 2025-12-05T04:04:19.346Z

---@class draw
draw = {}

---@return any
function draw.Functions() end

---@return string
function draw.Textures() end

---@return any
function draw.Examples() end

---@return any
function draw.Color() end

---@return any
function draw.Line() end

---@return any
function draw.FilledRect() end

---@return any
function draw.OutlinedRect() end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param alpha1 number
---@param alpha2 number
---@param horizontal boolean
---@return any
function draw.FilledRectFade(x1, y1, x2, y2, alpha1, alpha2, horizontal) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param fadeStartPt number
---@param fadeEndPt number
---@param alpha1 number
---@param alpha2 number
---@param horizontal boolean
---@return any
function draw.FilledRectFastFade(x1, y1, x2, y2, fadeStartPt, fadeEndPt, alpha1, alpha2, horizontal) end

---@param centerx number
---@param centery number
---@param radius number
---@param r number
---@param g number
---@param b number
---@param a number
---@return any
function draw.ColoredCircle(centerx, centery, radius, r, g, b, a) end

---@param x number
---@param y number
---@param radius number
---@param segments number
---@return any
function draw.OutlinedCircle(x, y, radius, segments) end

---@return number
function draw.GetTextSize() end

---@param x number
---@param y number
---@param text string
---@return string
function draw.Text(x, y, text) end

---@param x number
---@param y number
---@param text string
---@return string
function draw.TextShadow(x, y, text) end

---@return number
function draw.GetScreenSize() end

---@param name string
---@param height number
---@param weight number
---@param fontFlags number
---@return any
function draw.CreateFont(name, height, weight, fontFlags) end

---@param pathTTF string
---@return any
function draw.AddFontResource(pathTTF) end

---@param font number
---@return any
function draw.SetFont(font) end

---@param imagePath string
---@return string
function draw.CreateTexture(imagePath) end

---@param rgbaBinaryData string
---@param width number
---@param height number
---@return string
function draw.CreateTextureRGBA(rgbaBinaryData, width, height) end

---@param textureId number
---@return number
function draw.GetTextureSize(textureId) end

---@param textureId number
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return string
function draw.TexturedRect(textureId, x1, y1, x2, y2) end

---@param textureId number
---@param vertices table
---@param clipVertices boolean
---@return string
function draw.TexturedPolygon(textureId, vertices, clipVertices) end

---@param textureId number
---@return string
function draw.DeleteTexture(textureId) end

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

---@type any
TTF = nil

---@type any
RGBA = nil

