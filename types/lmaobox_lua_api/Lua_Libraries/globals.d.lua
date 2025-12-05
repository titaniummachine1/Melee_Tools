---@meta

-- Lmaobox Lua API: globals - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/globals/
-- Path: Lua_Libraries/globals
-- Last updated: 2025-12-05T10:33:20.613Z

---@class globals
globals = {}

-- Returns server tick interval
---@return number
function globals.TickInterval() end

-- Returns client tick count
---@return number
function globals.TickCount() end

-- Returns the time since start of the game
---@return number
function globals.RealTime() end

-- Returns the current time
---@return number
function globals.CurTime() end

-- Returns the frame count
---@return number
function globals.FrameCount() end

-- Return delta time between frames
---@return number
function globals.FrameTime() end

-- Return delta time between frames
---@return number
function globals.AbsoluteFrameTime() end

-- Max player count of the current server
---@return any
function globals.MaxClients() end

