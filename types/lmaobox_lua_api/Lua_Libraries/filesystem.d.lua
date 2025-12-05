---@meta

-- Lmaobox Lua API: filesystem - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/filesystem/
-- Path: Lua_Libraries/filesystem
-- Last updated: 2025-12-05T10:33:20.592Z

---@class filesystem
filesystem = {}

-- Creates a directory at the specified relative or absolute path. Returns true if the directory was created, false if unsuccessful. Returns the full path as second return value.
---@param string any
---@return string
function filesystem.CreateDirectory(string) end

-- Enumerates the files and directories in the specified directory. The callback function receives the filename and attributes of each file or directory. The path is relative to the game directory or absolute. You are not allowed to enumerate outside of the game directory.
---@param string any
---@param filename string
---@param attributes number
---@return string
function filesystem.EnumerateDirectory(string, filename, attributes) end

-- Returns 3 return values: the creation time, the last access time, and the last write time of the file at the specified path.
---@param string any
---@return number
function filesystem.GetFileTime(string) end

-- Returns the attributes of the file at the specified path.
---@param string any
---@return any
function filesystem.GetFileAttributes(string) end

-- Sets the attributes of the file at the specified path.
---@param string any
---@param integer any
---@return any
function filesystem.SetFileAttributes(string, integer) end

