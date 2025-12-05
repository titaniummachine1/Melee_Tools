---@meta

-- Lmaobox Lua API: Lua Globals - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Globals/
-- Path: Lua_Globals
-- Last updated: 2025-12-05T11:44:38.664Z

-- Prints message to console. Each argument is printed on a new line.
---@param msg any
---@return any
function print(msg) end

-- Prints a colored message to console. Each argument is printed on a new line.
---@param r number
---@param g number
---@param b number
---@param a number
---@param msg any
---@return any
function printc(r, g, b, a, msg) end

-- Loads a Lua script from given file.
---@param scriptFile string
---@return any
function LoadScript(scriptFile) end

-- Unloads a Lua script from given file.
---@param scriptFile string
---@return any
function UnloadScript(scriptFile) end

-- Returns current script's file name.
---@return string
function GetScriptName() end

