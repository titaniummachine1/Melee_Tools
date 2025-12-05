-- Main entry point for Melee_Tools
-- Imports (static requires for luabundle)
local AdaptiveMenu = require("Simulation.adaptive_menu")
-- Register Cheater Detection menu draw callback on load
require("Visuals.Menu")

-- Module declaration
local Main = {}

-- Public API ----
function Main.Initialize()
	-- AdaptiveMenu registers its Draw callback on require
	-- Nothing else needed here
end

-- Self-init (optional) ---
Main.Initialize()

-- Callbacks -----

return Main
