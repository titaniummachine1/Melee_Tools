---@meta

-- Lmaobox Lua API: engine - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/engine/
-- Path: Lua_Libraries/engine
-- Last updated: 2025-12-05T03:42:28.981Z

---@class engine
engine = {}

---@return any
function engine.Functions() end

---@return any
function engine.Examples() end

---@return any
function engine.Con_IsVisible() end

---@return boolean
function engine.IsGameUIVisible() end

---@return boolean
function engine.IsChatOpen() end

---@return boolean
function engine.IsTakingScreenshot() end

---@param src Vector3
---@param dst Vector3
---@param mask number
---@param ent Entity|nil
---@param contentsMask number
---@return any
function engine.TraceLine(src, dst, mask, ent, contentsMask) end

---@param src Vector3
---@param dst Vector3
---@param mins Vector3
---@param maxs Vector3
---@param mask number
---@param ent Entity|nil
---@param contentsMask number
---@return any
function engine.TraceHull(src, dst, mins, maxs, mask, ent, contentsMask) end

---@param pos Vector3
---@return any
function engine.GetPointContents(pos) end

---@return string
function engine.GetMapName() end

---@return any
function engine.GetServerIP() end

---@return Vector3
function engine.GetViewAngles() end

---@param angles EulerAngles
---@return Vector3
function engine.SetViewAngles(angles) end

---@param soundPath string
---@return any
function engine.PlaySound(soundPath) end

---@return string
function engine.GetGameDir() end

---@param keyValues string
---@return any
function engine.SendKeyValues(keyValues) end

---@param title string
---@param longText string
---@return any
function engine.Notification(title, longText) end

---@param seed number
---@return any
function engine.RandomSeed(seed) end

---@param min number
---@param max number
---@return any
function engine.RandomFloat(min, max) end

---@param min number
---@param max number
---@return number
function engine.RandomInt(min, max) end

---@param min number
---@param max number
---@param exponent number
---@return any
function engine.RandomFloatExp(min, max, exponent) end

-- Constants:
---@type any
API_ = nil

---@type any
API = nil

---@type any
UIV = nil

---@type any
FFF = nil

