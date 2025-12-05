local MeleeConstants = require("Melee.melee_constants")

-- Module declaration
local SimConstants = {}

-- Local constants / utilities -----
local TICK_INTERVAL_DEFAULT = globals.TickInterval() or (1 / 66) -- fallback when globals.TickInterval() unavailable
local TF2 = MeleeConstants.TF2
local HULL = MeleeConstants.HULL
local CLASS_MAX_SPEEDS = MeleeConstants.CLASS_MAX_SPEEDS
local DEFAULT_GRAVITY = (client.GetConVar and select(2, client.GetConVar("sv_gravity"))) or 800
local DEFAULT_STEP_SIZE = 18

local function readConVar(name)
	if client and client.GetConVar then
		local a, b = client.GetConVar(name)
		return b or a
	end
	return nil
end

local function readStepSize()
	if entities and entities.GetLocalPlayer then
		local lp = entities.GetLocalPlayer()
		if lp and lp:IsValid() then
			local step = lp:GetPropFloat("localdata", "m_flStepSize")
			if step and step > 0 then
				return step
			end
		end
	end
	return nil
end

-- Public API ----
SimConstants.TICK_INTERVAL_DEFAULT = TICK_INTERVAL_DEFAULT
SimConstants.MAX_HISTORY_SAMPLES = 16
SimConstants.MAX_HISTORY_SECONDS = 0.75
SimConstants.MIN_SPEED_FOR_STRAFE = 5
SimConstants.MIN_DELTA_TIME = 0.01
SimConstants.DEFAULT_LOOKAHEAD_SECONDS = 0.2
SimConstants.DEFAULT_GRAVITY = DEFAULT_GRAVITY
SimConstants.DEFAULT_UP = Vector3(0, 0, 1)
SimConstants.DEFAULT_STEP_SIZE = DEFAULT_STEP_SIZE
SimConstants.DEFAULT_STOP_SPEED = TF2.STOP_SPEED
SimConstants.DEFAULT_GROUND_FRICTION = TF2.GROUND_FRICTION
SimConstants.DEFAULT_ACCELERATION = TF2.ACCELERATION
SimConstants.DEFAULT_FORWARD_COLLISION_ANGLE = TF2.FORWARD_COLLISION_ANGLE
SimConstants.DEFAULT_GROUND_ANGLE_LOW = TF2.GROUND_ANGLE_LOW
SimConstants.DEFAULT_GROUND_ANGLE_HIGH = TF2.GROUND_ANGLE_HIGH
SimConstants.DEFAULT_HULL = HULL
SimConstants.DEFAULT_SWING_HULL_MIN = HULL.SWING_MIN
SimConstants.DEFAULT_SWING_HULL_MAX = HULL.SWING_MAX
SimConstants.DEFAULT_CLASS_MAX_SPEEDS = CLASS_MAX_SPEEDS

function SimConstants.refresh()
	local tick = globals and globals.TickInterval and globals.TickInterval()
	if tick and tick > 0 then
		SimConstants.TICK_INTERVAL_DEFAULT = tick
	end

	local grav = readConVar("sv_gravity")
	if grav and grav > 0 then
		SimConstants.DEFAULT_GRAVITY = grav
	end

	local step = readStepSize()
	if step and step > 0 then
		SimConstants.DEFAULT_STEP_SIZE = step
	end
end

-- Self-init (optional) ---

-- Callbacks -----

return SimConstants
