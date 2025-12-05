---@meta

-- Lmaobox Lua API: callbacks - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/callbacks/
-- Path: Lua_Libraries/callbacks
-- Last updated: 2025-12-05T11:44:14.508Z

-- Callbacks are functions that are called when a certain event occurs. Yiu can use them to add custom functionality to your scripts. To see the list of available callbacks, see the callbacks page.

---@class callbacks
callbacks = {}

-- Registers a callback function to be called when the event with the given id occurs.
---@param id any
---@param function any
---@return any
function callbacks.Register(id, function) end

-- Registers a callback function to be called when the event with the given id occurs. If the callback function is already registered, it will not be registered again.
---@param id any
---@param unique any
---@param function any
---@return any
function callbacks.Register(id, unique, function) end

-- Unregisters a callback function from the event with the given id.
---@param id any
---@param unique any
---@return any
function callbacks.Unregister(id, unique) end

