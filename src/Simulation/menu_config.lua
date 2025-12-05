-- Imports
local G = require("Cheater_Detection.Utils.Globals")
local ClassState = require("Simulation.class_state")

-- Module declaration
local MenuConfig = {}

-- Local constants / utilities -----
local PROFILE_AUTO = 0
local PROFILE_SPY = 1
local PROFILE_DEMOKNIGHT = 2

local function getMelee()
	assert(G.Menu, "MenuConfig: G.Menu is nil")
	assert(G.Menu.Melee, "MenuConfig: G.Menu.Melee missing (load Config first)")
	return G.Menu.Melee
end

local function detectedProfile()
	local ok, profile = pcall(function()
		return ClassState.refresh()
	end)
	if ok then
		return profile
	end
	return "other"
end

local function resolveProfile(m)
	local manual = m.Adaptive.ManualProfile or PROFILE_AUTO
	if manual == PROFILE_SPY then
		return "spy"
	elseif manual == PROFILE_DEMOKNIGHT then
		return "demoknight"
	end
	return detectedProfile()
end

-- Public API ----
function MenuConfig.getActiveProfile()
	local melee = getMelee()
	return resolveProfile(melee)
end

function MenuConfig.getProfileConfig(profile)
	local melee = getMelee()
	if profile == "spy" then
		return melee.Spy
	elseif profile == "demoknight" then
		return melee.Demoknight
	end
	return nil
end

function MenuConfig.getActiveConfig()
	local melee = getMelee()
	local profile = resolveProfile(melee)
	return profile, MenuConfig.getProfileConfig(profile)
end

function MenuConfig.shouldUseVisuals()
	local melee = getMelee()
	return melee.Adaptive.ShowVisuals
end

-- Self-init (optional) ---

-- Callbacks -----

return MenuConfig
