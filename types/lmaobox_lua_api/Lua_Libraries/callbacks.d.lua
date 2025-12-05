---@meta

-- Lmaobox Lua API: callbacks - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/callbacks/
-- Path: Lua_Libraries/callbacks
-- Last updated: 2025-12-05T12:04:26.013Z

---@class callbacks
callbacks = {}

-- Registers a callback function to be called when the event with the given id occurs.
---@param id any
---@param callback any
---@return any
function callbacks.Register(id, callback) end

-- Registers a callback function to be called when the event with the given id occurs. If the callback function is already registered, it will not be registered again.
---@param id any
---@param unique any
---@param callback any
---@return any
function callbacks.Register(id, unique, callback) end

-- Unregisters a callback function from the event with the given id.
---@param id any
---@param unique any
---@return any
function callbacks.Unregister(id, unique) end

