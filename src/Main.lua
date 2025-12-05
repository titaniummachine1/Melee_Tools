-- Imports
local okConfig, Config = pcall(require, "Cheater_Detection.Utils.Config")
assert(okConfig and Config, "Main: failed to load Config")

-- Module declaration
local Main = {}

-- Local constants / utilities -----
local okMenu, AdaptiveMenu = pcall(require, "Simulation.adaptive_menu")
assert(okMenu and AdaptiveMenu, "Main: failed to load adaptive menu")

-- Public API ----
function Main.Initialize()
	-- Config require already loads/initializes G.Menu; adaptive menu registers its Draw callback.
end

-- Self-init (optional) ---
Main.Initialize()

-- Callbacks -----

return Main
