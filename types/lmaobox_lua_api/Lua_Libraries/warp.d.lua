---@meta

-- Lmaobox Lua API: warp - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/warp/
-- Path: Lua_Libraries/warp
-- Last updated: 2025-12-05T12:04:26.134Z

---@class warp
warp = {}

-- Returns the amount of charged warp ticks.
---@return any
function warp.GetChargedTicks() end

-- Returns true if the user is currently warping. Since the period of warping is super short, this is only really useful in CreateMove callbacks where you can use it to do your logic.
---@return boolean
function warp.IsWarping() end

-- Whether we can warp or not. Does not guarantee a full charge or a double tap.
---@return boolean
function warp.CanWarp() end

-- Extension of CanWarp with additional checks. When this is true, you can guarentee a weapon will double tap.
---@param weapon any
---@return boolean
function warp.CanDoubleTap(weapon) end

-- Triggers a warp.
---@return any
function warp.TriggerWarp() end

-- Triggers a warp with double tap.
---@return any
function warp.TriggerDoubleTap() end

-- Triggers a charge of warp ticks.
---@return any
function warp.TriggerCharge() end

