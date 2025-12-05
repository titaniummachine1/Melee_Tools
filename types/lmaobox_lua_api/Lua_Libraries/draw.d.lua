---@meta

-- Lmaobox Lua API: draw - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/draw/
-- Path: Lua_Libraries/draw
-- Last updated: 2025-12-05T12:04:26.044Z

---@class draw
draw = {}

-- Set color for drawing shapes and texts
---@param r any
---@param g any
---@param b any
---@param a any
---@return any
function draw.Color(r, g, b, a) end

-- Draw line from x1, y1 to x2, y2
---@param x1 any
---@param y1 any
---@param x2 any
---@param y2 any
---@return any
function draw.Line(x1, y1, x2, y2) end

-- Draw filled rectangle with top left point at x1, y1 and bottom right point at x2, y2
---@param x1 any
---@param y1 any
---@param x2 any
---@param y2 any
---@return any
function draw.FilledRect(x1, y1, x2, y2) end

-- Draw outlined rectangle with top left point at x1, y1 and bottom right point at x2, y2
---@param x1 any
---@param y1 any
---@param x2 any
---@param y2 any
---@return any
function draw.OutlinedRect(x1, y1, x2, y2) end

-- Draw a rectangle with a fade. The fade is horizontal by default, but can be vertical by setting horizontal to false. The alpha values are between 0 and 255.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param alpha1 number
---@param alpha2 number
---@param horizontal boolean
---@return any
function draw.FilledRectFade(x1, y1, x2, y2, alpha1, alpha2, horizontal) end

-- Draws a fade between the fadeStartPt and fadeEndPT points. The fade is horizontal by default, but can be vertical by setting horizontal to false. The alpha values are between 0 and 255.
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

-- Draw a colored circle with center at centerx, centery and radius radius. The color is specified by r, g, b, a.
---@param centerx number
---@param centery number
---@param radius number
---@param r number
---@param g number
---@param b number
---@param a number
---@return any
function draw.ColoredCircle(centerx, centery, radius, r, g, b, a) end

-- Draw an outlined circle with center at centerx, centery and radius radius. The circle is made up of segments number of lines.
---@param x number
---@param y number
---@param radius number
---@param segments number
---@return any
function draw.OutlinedCircle(x, y, radius, segments) end

-- returns: width, height Get text size with current font
---@param string any
---@return number
function draw.GetTextSize(string) end

-- Draw text at x, y
---@param x number
---@param y number
---@param text string
---@return string
function draw.Text(x, y, text) end

-- Draw text with shadow at x, y
---@param x number
---@param y number
---@param text string
---@return string
function draw.TextShadow(x, y, text) end

-- returns: width, height Get game resolution settings
---@return number
function draw.GetScreenSize() end

-- Create font by name. Font flags are optional and can be combined with bitwise OR. Default font flags are FONTFLAG_CUSTOM | FONTFLAG_ANTIALIAS
---@param name string
---@param height number
---@param weight number
---@param fontFlags number
---@return any
function draw.CreateFont(name, height, weight, fontFlags) end

-- Add font resource by path to ttf file, relative to Team Fortress 2 folder
---@param pathTTF string
---@return any
function draw.AddFontResource(pathTTF) end

-- Set current font for drawing. To be used with DrawText
---@param font number
function draw.SetFont(font) end

---@return string
function draw.Textures() end

-- Create texture from image on the given path. Path is relative to %localappdata%/lua/ .. But you can also specify an absolute path if you wish. Returns texture id for the newly created texture. Supported image extensions: PNG, JPG, BMP, TGA, VTF
---@param imagePath string
---@return string
function draw.CreateTexture(imagePath) end

-- Create texture from raw rgba data in the format RGBA8888 (one byte per color). In this format you must specify the valid width and height of the texture. Returns texture id for the newly created texture.
---@param rgbaBinaryData string
---@param width number
---@param height number
---@return string
function draw.CreateTextureRGBA(rgbaBinaryData, width, height) end

-- Returns: width, height of the texture as integers
---@param textureId number
---@return number
function draw.GetTextureSize(textureId) end

-- Draw the texture by textureId as a rectangle with top left point at x1, y1 and bottom right point at x2, y2.
---@param textureId number
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return string
function draw.TexturedRect(textureId, x1, y1, x2, y2) end

-- Draw the texture by textureId as a polygon. The vertices table should be a list of tables, each containing 4 values: x,y of the vertex, and u,v of the tex coordinate. Example vertex = { 0,0,0.1,0.5 }. clipVertices decides whether the resulting polygon should be clipped to the screen or not. If unsure how to add vertices, refer to an example below
---@param textureId number
---@param vertices table
---@param clipVertices boolean
---@return boolean
function draw.TexturedPolygon(textureId, vertices, clipVertices) end

-- Delete texture by textureId from memory. You should do this when unloading your script.
---@param textureId number
---@return string
function draw.DeleteTexture(textureId) end

