-- Imports
local SimConstants = require("Simulation.constants")
local MeleeConstants = require("Melee.melee_constants")
local DirectionUtils = require("Melee.direction_utils")
local Physics = require("Simulation.physics")

-- Module declaration
local PathSimulation = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2
local HULL = MeleeConstants.HULL
local CLASS_MAX_SPEEDS = MeleeConstants.CLASS_MAX_SPEEDS
local SMOOTH_WARP = MeleeConstants.SMOOTH_WARP

-- Public API ----
function PathSimulation.simulateDash(params)
	assert(params, "simulateDash: params are required")
	assert(params.startPos and params.startVel and params.wishdir, "simulateDash: missing vectors")
	assert(params.ticks and params.ticks > 0, "simulateDash: ticks must be > 0")

	SimConstants.refresh()

	local tickInterval = params.tickInterval or globals.TickInterval() or SimConstants.TICK_INTERVAL_DEFAULT
	local gravity = params.gravity or SimConstants.DEFAULT_GRAVITY
	local maxSpeed = params.maxSpeed

	if not maxSpeed then
		local classId = params.classId or TF2.SPY_CLASS_ID
		maxSpeed = CLASS_MAX_SPEEDS[classId] or TF2.MAX_SPEED
	end

	local traceHull = params.traceHull
	local shouldHit = params.shouldHitEntity
	local canBackstab = params.canBackstab
	local hull = params.hull or SimConstants.DEFAULT_HULL or HULL
	local vUp = params.upVector or SimConstants.DEFAULT_UP
	local wishdir = DirectionUtils.normalizeVector(params.wishdir)
	local onGround = params.onGround ~= false
	local pos = Vector3(params.startPos.x, params.startPos.y, params.startPos.z)
	local vel = Vector3(params.startVel.x, params.startVel.y, params.startVel.z)

	local positions = {}
	local endwarps = {}
	local minBackstabTick = math.huge
	local closestBackstab

	for tick = 1, params.ticks do
		vel = Physics.applyFriction(
			vel,
			onGround,
			tickInterval,
			TF2.STOP_SPEED or SimConstants.DEFAULT_STOP_SPEED,
			TF2.GROUND_FRICTION or SimConstants.DEFAULT_GROUND_FRICTION
		)
		vel = Physics.accelerateGround(
			vel,
			wishdir,
			maxSpeed,
			tickInterval,
			TF2.ACCELERATION or SimConstants.DEFAULT_ACCELERATION,
			onGround
		)

		local step = vel * tickInterval
		local nextPos = pos + step

		if traceHull then
			local wallTrace = traceHull(pos, nextPos, hull.MIN, hull.MAX, params.collisionMask, shouldHit)
			if wallTrace and wallTrace.fraction and wallTrace.fraction < 1 then
				if wallTrace.entity and wallTrace.entity:GetClass() == "CTFPlayer" then
					break
				end
				nextPos.x, nextPos.y = Physics.handleForwardCollision(vel, wallTrace, TF2.FORWARD_COLLISION_ANGLE)
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
					Physics.handleGroundCollision(vel, groundTrace, vUp, TF2.GROUND_ANGLE_LOW, TF2.GROUND_ANGLE_HIGH)
			end
		end

		if not onGround then
			vel.z = vel.z - gravity
		end

		pos = nextPos
		positions[tick] = pos

		if canBackstab then
			local isBackstab = canBackstab(pos)
			endwarps[tick] = { pos = pos, isBackstab = isBackstab, tick = tick }
			if isBackstab and tick < minBackstabTick then
				minBackstabTick = tick
				closestBackstab = pos
			end
		end
	end

	return {
		finalPos = pos,
		finalVel = vel,
		positions = positions,
		endwarps = endwarps,
		firstBackstabTick = minBackstabTick,
		closestBackstabPos = closestBackstab,
	}
end

function PathSimulation.simulateBonusTicks(params)
	assert(params, "simulateBonusTicks: params are required")
	assert(
		params.startPos and params.startVel and params.enemyPos and params.enemyBack,
		"simulateBonusTicks: missing vectors"
	)

	SimConstants.refresh()

	local tickInterval = params.tickInterval or globals.TickInterval() or SimConstants.TICK_INTERVAL_DEFAULT
	local maxBonusTicks = params.maxBonusTicks or SMOOTH_WARP.BONUS_TICKS
	local maxSpeed = params.maxSpeed

	if not maxSpeed then
		local classId = params.classId or TF2.SPY_CLASS_ID
		maxSpeed = CLASS_MAX_SPEEDS[classId] or TF2.MAX_SPEED
	end

	local startPos = params.startPos
	local startVel = params.startVel
	local enemyPos = params.enemyPos
	local enemyBack = params.enemyBack
	local canBackstab = params.canBackstab
	local myRadius = params.myRadius or TF2.HITBOX_RADIUS
	local enemyRadius = params.enemyRadius or TF2.HITBOX_RADIUS
	local baseTick = params.baseTick or 0

	local lastPos = Vector3(startPos.x, startPos.y, startPos.z)
	local lastVel = Vector3(startVel.x, startVel.y, startVel.z)
	local lastGround = params.onGround ~= false

	local bonusPositions = {}
	local bonusEndwarps = {}
	local combinedRadius = myRadius + enemyRadius

	for i = 1, maxBonusTicks do
		local targetPos = enemyPos + enemyBack * combinedRadius
		local toTarget = targetPos - lastPos
		local toTargetLen = toTarget:Length()
		local wishdir = (toTargetLen > 1) and (toTarget / toTargetLen) or Vector3(1, 0, 0)

		local vel = Physics.applyFriction(
			lastVel,
			lastGround,
			tickInterval,
			TF2.STOP_SPEED or SimConstants.DEFAULT_STOP_SPEED,
			TF2.GROUND_FRICTION or SimConstants.DEFAULT_GROUND_FRICTION
		)
		vel = Physics.accelerateGround(
			vel,
			wishdir,
			maxSpeed,
			tickInterval,
			TF2.ACCELERATION or SimConstants.DEFAULT_ACCELERATION,
			lastGround
		)
		vel = Physics.capHorizontalSpeed(vel, maxSpeed)

		local pos = lastPos + vel * tickInterval

		bonusPositions[i] = pos
		if canBackstab then
			local isBackstab = canBackstab(pos)
			bonusEndwarps[i] = { pos = pos, isBackstab = isBackstab, tick = baseTick + i }
		end

		lastPos, lastVel = pos, vel
	end

	return {
		positions = bonusPositions,
		endwarps = bonusEndwarps,
		finalPos = lastPos,
		finalVel = lastVel,
	}
end

-- Self-init (optional) ---

-- Callbacks -----

return PathSimulation
