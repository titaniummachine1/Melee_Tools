-- Imports (static requires for luabundle)
local G = require("Utils.Globals")
local ClassState = require("Simulation.class_state")

-- External libs (pcall - user must install separately)
local menuLoaded, TimMenu = pcall(require, "TimMenu")
if not menuLoaded then
	client.ChatPrintf("\x07FF0000TimMenu failed to load!")
	engine.PlaySound("common/bugreporter_failed.wav")
	return
end
assert(menuLoaded, "TimMenu not found, please install it!")

-- Module declaration
local AdaptiveMenu = {}

-- Local constants / utilities -----
local PROFILE_AUTO = 0
local PROFILE_SPY = 1
local PROFILE_DEMOKNIGHT = 2

local profileOptions = { "Auto", "Spy", "Demoknight" }

local function resolveProfile(menuMelee)
	local manual = menuMelee.Adaptive.ManualProfile or PROFILE_AUTO
	if manual == PROFILE_SPY then
		return "spy"
	elseif manual == PROFILE_DEMOKNIGHT then
		return "demoknight"
	end

	local profile = ClassState.refresh()
	return profile or "other"
end

local function drawShared(menuMelee, activeProfile)
	TimMenu.BeginSector("Adaptive Control")

	menuMelee.Adaptive.Enabled = TimMenu.Checkbox("Enable Adaptive Logic", menuMelee.Adaptive.Enabled)
	TimMenu.NextLine()

	menuMelee.Adaptive.ShowVisuals = TimMenu.Checkbox("Show Visuals", menuMelee.Adaptive.ShowVisuals)
	TimMenu.NextLine()

	menuMelee.Adaptive.Keybind = TimMenu.Keybind("Activation Key", menuMelee.Adaptive.Keybind)
	TimMenu.NextLine()

	TimMenu.Text("Active Profile: " .. tostring(activeProfile))
	TimMenu.NextLine()

	menuMelee.Adaptive.ManualProfile =
		TimMenu.Dropdown("Profile Override", menuMelee.Adaptive.ManualProfile, profileOptions)
	TimMenu.NextLine()

	TimMenu.EndSector()
end

local function drawSpy(menuMelee)
	TimMenu.BeginSector("Spy / Trickstab")
	menuMelee.Spy.TrickstabAssist = TimMenu.Checkbox("Trickstab Assist", menuMelee.Spy.TrickstabAssist)
	TimMenu.NextLine()

	menuMelee.Spy.MoveAssist = TimMenu.Checkbox("Move Assist", menuMelee.Spy.MoveAssist)
	TimMenu.NextLine()

	menuMelee.Spy.SmoothWarp = TimMenu.Checkbox("Smooth Warp", menuMelee.Spy.SmoothWarp)
	TimMenu.NextLine()

	menuMelee.Spy.VisualizePoints = TimMenu.Checkbox("Visualize Stab Points", menuMelee.Spy.VisualizePoints)
	TimMenu.NextLine()
	TimMenu.EndSector()
end

local function drawDemoknight(menuMelee)
	TimMenu.BeginSector("Demoknight")
	menuMelee.Demoknight.ChargePrediction = TimMenu.Checkbox("Charge Prediction", menuMelee.Demoknight.ChargePrediction)
	TimMenu.NextLine()

	menuMelee.Demoknight.SwingPrediction = TimMenu.Checkbox("Swing Prediction", menuMelee.Demoknight.SwingPrediction)
	TimMenu.NextLine()

	menuMelee.Demoknight.LateCharge = TimMenu.Checkbox("Late Charge", menuMelee.Demoknight.LateCharge)
	TimMenu.NextLine()

	menuMelee.Demoknight.WarpOnAttack = TimMenu.Checkbox("Warp On Attack", menuMelee.Demoknight.WarpOnAttack)
	TimMenu.NextLine()

	menuMelee.Demoknight.VisualizePath = TimMenu.Checkbox("Visualize Path", menuMelee.Demoknight.VisualizePath)
	TimMenu.NextLine()

	TimMenu.EndSector()
end

local function drawBody(menuMelee)
	local activeProfile = resolveProfile(menuMelee)

	drawShared(menuMelee, activeProfile)

	if activeProfile == "spy" then
		drawSpy(menuMelee)
	elseif activeProfile == "demoknight" then
		drawDemoknight(menuMelee)
	else
		TimMenu.BeginSector("No Active Profile")
		TimMenu.Text("Waiting for class detection or override.")
		TimMenu.EndSector()
	end
end

-- Public API ----
function AdaptiveMenu.OnDraw()
	if not G.Menu or not G.Menu.Melee then
		return
	end

	local menuMelee = G.Menu.Melee
	if not menuMelee.Adaptive.Enabled then
		return
	end

	if TimMenu.Begin("Adaptive Melee", true) then
		drawBody(menuMelee)
	end
end

-- Register Draw callback - TimMenu needs to be called every tick
callbacks.Register("Draw", "AdaptiveMelee_Menu_Draw", AdaptiveMenu.OnDraw)

-- Self-init (optional) ---

-- Callbacks -----

return AdaptiveMenu
