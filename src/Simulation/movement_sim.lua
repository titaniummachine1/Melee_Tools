-- Imports
local SimConstants = require("Simulation.constants")
local MeleeConstants = require("Melee.melee_constants")
local DirectionUtils = require("Melee.direction_utils")
local Physics = require("Simulation.physics")

-- Module declaration
local MovementSim = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2
local HULL = MeleeConstants.HULL
local CLASS_MAX_SPEEDS = MeleeConstants.CLASS_MAX_SPEEDS

local function getTickInterval(override)
	return override or globals.TickInterval() or SimConstants.TICK_INTERVAL_DEFAULT
end

local function resolveMaxSpeed(params)
	if params.maxSpeed then
		return params.maxSpeed
	end

	if params.classMaxSpeeds and params.classId then
		return params.classMaxSpeeds[params.classId]
	end

	if params.classId then
		return CLASS_MAX_SPEEDS[params.classId]
	end

	return TF2.MAX_SPEED
end

local function resolveWishdir(params, tick, pos, vel)
	if params.getWishdir then
		return params.getWishdir(tick, pos, vel)
	end
	return params.wishdir
end

-- Public API ----
-- Generic movement simulation (no backstab scoring) for reuse across dash/swing prediction.
function MovementSim.simulate(params)
	assert(params, "simulate: params are required")
	assert(params.startPos and params.startVel, "simulate: missing start positions")
	assert(params.ticks and params.ticks > 0, "simulate: ticks must be > 0")

	local tickInterval = getTickInterval(params.tickInterval)
	local gravity = params.gravity or (client.GetConVar and client.GetConVar("sv_gravity")) or 800
	local maxSpeed = resolveMaxSpeed(params)

	local traceHull = params.traceHull
	local shouldHit = params.shouldHitEntity
	local hull = params.hull or HULL
	local vUp = params.upVector or Vector3(0, 0, 1)
	local onGround = params.onGround ~= false

	local pos = Vector3(params.startPos.x, params.startPos.y, params.startPos.z)
	local vel = Vector3(params.startVel.x, params.startVel.y, params.startVel.z)

	local positions = {}

	for tick = 1, params.ticks do
		local wishdir = resolveWishdir(params, tick, pos, vel)
		if wishdir then
			wishdir = DirectionUtils.normalizeVector(wishdir)
		end

		vel = Physics.applyFriction(vel, onGround, tickInterval, params.stopSpeed, params.groundFriction)
		if wishdir then
			vel = Physics.accelerateGround(vel, wishdir, maxSpeed, tickInterval, params.acceleration, onGround)
		end

		local step = vel * tickInterval
		local nextPos = pos + step

		if traceHull then
			local wallTrace = traceHull(pos, nextPos, hull.MIN, hull.MAX, params.collisionMask, shouldHit)
			if wallTrace and wallTrace.fraction and wallTrace.fraction < 1 then
				nextPos.x, nextPos.y = Physics.handleForwardCollision(vel, wallTrace, params.forwardCollisionAngle)
			end

			local groundTrace = traceHull(
				nextPos,
				nextPos - (onGround and step or Vector3(0, 0, 0)),
				hull.MIN,
				hull.MAX,
				params.collisionMask,
				shouldHit
			)
			if groundTrace and groundTrace.fraction and groundTrace.fraction < 1 then
				nextPos, onGround =
					Physics.handleGroundCollision(vel, groundTrace, vUp, params.groundAngleLow, params.groundAngleHigh)
			end
		end

		if not onGround then
			vel.z = vel.z - gravity
		end

		pos = nextPos
		vel = Physics.capHorizontalSpeed(vel, maxSpeed)
		positions[tick] = pos

		if params.onTick then
			params.onTick({
				tick = tick,
				pos = pos,
				vel = vel,
				onGround = onGround,
			})
		end
	end

	return {
		finalPos = pos,
		finalVel = vel,
		positions = positions,
	}
end

-- Self-init (optional) ---

-- Callbacks -----

return MovementSim
