---@meta

-- Lmaobox Lua API: engine - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/engine/
-- Path: Lua_Libraries/engine
-- Last updated: 2025-12-05T12:04:26.049Z

---@class engine
engine = {}

-- Whether the game console is visible.
---@return boolean
function engine.Con_IsVisible() end

-- Whether the game UI is visible.
---@return boolean
function engine.IsGameUIVisible() end

-- Whether the game chat is open.
---@return boolean
function engine.IsChatOpen() end

-- Whether the game is taking a screenshot.
---@return boolean
function engine.IsTakingScreenshot() end

-- Traces line from src to dst, returns Trace class. The shouldHitEntity function is optional, and can be used to filter out entities that should not be hit. It should return true if the entity should be hit, and false otherwise.
---@param src Vector3
---@param dst Vector3
---@param mask number
---@return Trace
function engine.TraceLine(src, dst, mask) end

-- Traces hull from src to dst, returns Trace class. The shouldHitEntity function is optional, and can be used to filter out entities that should not be hit. It should return true if the entity should be hit, and false otherwise.
---@param src Vector3
---@param dst Vector3
---@param mins Vector3
---@param maxs Vector3
---@param mask number
---@return Trace
function engine.TraceHull(src, dst, mins, maxs, mask) end

-- Returns 2 values: mask as integer and entity as Entity class. The mask is the contents of the point in 3D space, and the entity is the entity present at the point, can be nil.
---@param pos Vector3
---@return number, Entity|nil
function engine.GetPointContents(pos) end

-- Returns map name
---@return string
function engine.GetMapName() end

-- Returns server ip
---@return string
function engine.GetServerIP() end

-- Returns player view angles
---@return Vector3
function engine.GetViewAngles() end

-- Sets player view angles
---@param angles EulerAngles
function engine.SetViewAngles(angles) end

-- Plays a sound at the given path, relative to the game's root folder
---@param soundPath string
function engine.PlaySound(soundPath) end

-- Returns game install directory
---@return string
function engine.GetGameDir() end

-- Sends key values to server, returns true if successful, this can be used to send very specific commands to the server. For example, buy MvM upgrades, trigger noise makers...
---@param keyValues string
---@return boolean
function engine.SendKeyValues(keyValues) end

-- Creates a notification in the TF2 client. If longText is not specified, the notification will be a simple popup with title text. If longText is specified, the notification will be a popup with title text, which will open a large window with longText as text.
---@param title string
---@param longText string
---@return any
function engine.Notification(title, longText) end

-- Sets the seed for the game's uniform random number generator.
---@param seed number
function engine.RandomSeed(seed) end

-- Returns a random number between min and max (inclusive), using the game's uniform random number generator.
---@param min number
---@return number
function engine.RandomFloat(min) end

-- Returns a random integer between min and max (inclusive), using the game's uniform random number generator.
---@param min number
---@return number
function engine.RandomInt(min) end

-- Returns a random number between min and max using the exponent, using the game's uniform random number generator.
---@param min number
---@param max number
---@return number
function engine.RandomFloatExp(min, max) end
