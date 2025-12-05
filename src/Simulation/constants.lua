-- Imports

-- Module declaration
local SimConstants = {}

-- Local constants / utilities -----
local TICK_INTERVAL_DEFAULT = 1 / 66 -- fallback when globals.TickInterval() unavailable

-- Public API ----
SimConstants.TICK_INTERVAL_DEFAULT = TICK_INTERVAL_DEFAULT
SimConstants.MAX_HISTORY_SAMPLES = 16
SimConstants.MAX_HISTORY_SECONDS = 0.75
SimConstants.MIN_SPEED_FOR_STRAFE = 5
SimConstants.MIN_DELTA_TIME = 0.01
SimConstants.DEFAULT_LOOKAHEAD_SECONDS = 0.2

-- Self-init (optional) ---

-- Callbacks -----

return SimConstants
