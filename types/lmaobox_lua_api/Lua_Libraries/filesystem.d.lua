---@meta

-- Lmaobox Lua API: filesystem - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/filesystem/
-- Path: Lua_Libraries/filesystem
-- Last updated: 2025-12-05T11:20:20.948Z

---@class filesystem
filesystem = {}

---@param string any
---@return string
function filesystem.CreateDirectory(string) end

---@param string any
---@param filename string
---@param attributes number
---@return string
function filesystem.EnumerateDirectory(string, filename, attributes) end

---@param string any
---@return number
function filesystem.GetFileTime(string) end

---@param string any
---@return any
function filesystem.GetFileAttributes(string) end

---@param string any
---@param integer any
function filesystem.SetFileAttributes(string, integer) end

