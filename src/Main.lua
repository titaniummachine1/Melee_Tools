-- Main entry point for Melee_Tools
-- Imports

-- Module declaration
local Main = {}

-- Local constants / utilities -----

-- Public API ----
function Main.Initialize()
	-- Load adaptive menu - it registers its own Draw callback for TimMenu
	local okMenu, AdaptiveMenu = pcall(require, "Simulation.adaptive_menu")
	if not okMenu or not AdaptiveMenu then
		client.ChatPrintf("\x07FF0000Failed to load adaptive menu!")
		return
	end
end

-- Self-init (optional) ---
Main.Initialize()

-- Callbacks -----

return Main
