-- Imports
local MenuConfig = require("Simulation.menu_config")

-- Module declaration
local PrototypeHooks = {}

-- Public API ----
function PrototypeHooks.getActiveProfileConfig()
	local profile, cfg = MenuConfig.getActiveConfig()
	return profile, cfg
end

function PrototypeHooks.getSpySettings()
	return MenuConfig.getProfileConfig("spy")
end

function PrototypeHooks.getDemoknightSettings()
	return MenuConfig.getProfileConfig("demoknight")
end

function PrototypeHooks.shouldEnableTrickstab()
	local profile, cfg = PrototypeHooks.getActiveProfileConfig()
	return profile == "spy" and cfg and cfg.TrickstabAssist
end

function PrototypeHooks.shouldEnableDemoknight()
	local profile, cfg = PrototypeHooks.getActiveProfileConfig()
	return profile == "demoknight" and cfg
end

function PrototypeHooks.shouldShowVisuals()
	return MenuConfig.shouldUseVisuals()
end

-- Self-init (optional) ---

-- Callbacks -----

return PrototypeHooks
