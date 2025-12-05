---@meta

-- Lmaobox Lua API: input - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/input/
-- Path: Lua_Libraries/input
-- Last updated: 2025-12-05T10:33:20.643Z

---@class input
input = {}

-- Returns the current mouse position as a table where index 1 is x and index 2 is y.
---@return any
function input.Functions() end

---@return any
function input.Examples() end

-- Returns the current mouse position as a table where index 1 is x and index 2 is y.
---@return any
function input.GetMousePos() end

-- Returns true if the specified mouse button is down. Otherwise, it returns false.
---@return boolean
function input.IsButtonDown() end

-- Returns true if the specified mouse button was pressed. Otherwise, it returns false. Second return value is the tick when button was pressed.
---@return boolean
function input.IsButtonPressed() end

-- Returns true if the specified mouse button was released. Otherwise, it returns false. Second return value is the tick when button was released.
---@return boolean
function input.IsButtonReleased() end

-- Returns whether the mouse input is currently enabled.
---@return boolean
function input.IsMouseInputEnabled() end

-- Sets whether the mouse is visible on screen and has priority on the topmost panel.
---@return any
function input.SetMouseInputEnabled() end

-- Returns the tick when buttons have last been polled.
---@return any
function input.GetPollTick() end

