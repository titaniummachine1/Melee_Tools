-- Imports
local MeleeConstants = require("Melee.melee_constants")

-- Module declaration
local DirectionUtils = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2
local MATH = MeleeConstants.MATH

local function normalizeVector(vec)
	assert(vec and vec.Length, "DirectionUtils.normalizeVector: vec is invalid")
	return vec / vec:Length()
end

local function normalizeYaw(yaw)
	assert(yaw ~= nil, "DirectionUtils.normalizeYaw: yaw is nil")

	yaw = yaw % MATH.FULL_CIRCLE
	if yaw > MATH.HALF_CIRCLE then
		yaw = yaw - MATH.FULL_CIRCLE
	elseif yaw < -MATH.HALF_CIRCLE then
		yaw = yaw + MATH.FULL_CIRCLE
	end

	return yaw
end

local function positionYaw(source, dest)
	assert(source and dest, "DirectionUtils.positionYaw: positions are invalid")
	local delta = normalizeVector(source - dest)
	return math.deg(math.atan(delta.y, delta.x))
end

local function positionAngles(source, dest)
	assert(source and dest, "DirectionUtils.positionAngles: positions are invalid")
	local delta = dest - source
	local dist = math.sqrt(delta.x * delta.x + delta.y * delta.y)

	return {
		pitch = math.deg(math.atan(-delta.z, dist)),
		yaw = math.deg(math.atan(delta.y, delta.x)),
	}
end

-- Private helpers -----
local function determineRelativeDirection(myPos, enemyPos, hitboxSize, verticalRange)
	assert(myPos and enemyPos, "determineRelativeDirection: positions are invalid")
	assert(hitboxSize and hitboxSize > 0, "determineRelativeDirection: hitboxSize is invalid")
	assert(verticalRange and verticalRange > 0, "determineRelativeDirection: verticalRange is invalid")

	local dx = enemyPos.x - myPos.x
	local dy = enemyPos.y - myPos.y
	local dz = enemyPos.z - myPos.z
	local buffer = 1

	local outOfVerticalRange = (math.abs(dz) > verticalRange) and 1 or 0
	local dirX = ((dx > hitboxSize - buffer) and 1 or 0) - ((dx < -hitboxSize + buffer) and 1 or 0)
	local dirY = ((dy > hitboxSize - buffer) and 1 or 0) - ((dy < -hitboxSize + buffer) and 1 or 0)

	return { dirX * (1 - outOfVerticalRange), dirY * (1 - outOfVerticalRange) }
end

local function getDynamicCorners(cornerDistance)
	if not cornerDistance or cornerDistance <= 0 then
		cornerDistance = TF2.HITBOX_RADIUS * 2
	end

	return {
		Vector3(-cornerDistance, cornerDistance, 0.0), -- top left
		Vector3(cornerDistance, cornerDistance, 0.0), -- top right
		Vector3(-cornerDistance, -cornerDistance, 0.0), -- bottom left
		Vector3(cornerDistance, -cornerDistance, 0.0), -- bottom right
	}
end

local center = Vector3(0, 0, 0)

local function mapDirectionToCorners(corners)
	return {
		[-1] = {
			[-1] = { center, corners[4], corners[1] },
			[0] = { center, corners[4], corners[2] },
			[1] = { center, corners[3], corners[2] },
		},
		[0] = {
			[-1] = { center, corners[2], corners[1] },
			[0] = { center },
			[1] = { center, corners[3], corners[4] },
		},
		[1] = {
			[-1] = { center, corners[2], corners[3] },
			[0] = { center, corners[1], corners[3] },
			[1] = { center, corners[1], corners[4] },
		},
	}
end

local function getBestCornersOrCenter(myPos, enemyPos, hitboxSize, verticalRange)
	local direction = determineRelativeDirection(myPos, enemyPos, hitboxSize, verticalRange)
	local corners = getDynamicCorners(hitboxSize)
	local directionMap = mapDirectionToCorners(corners)
	local best = directionMap[direction[1]] and directionMap[direction[1]][direction[2]]

	if not best then
		return { center }
	end

	return best
end

local function scaleCorner(corner, distance)
	return Vector3(
		corner.x ~= 0 and (corner.x > 0 and distance or -distance) or 0,
		corner.y ~= 0 and (corner.y > 0 and distance or -distance) or 0,
		0
	)
end

local function calculateOptimalWishdir(startPos, startVel, offsetFromEnemy, enemyPos, ticks, maxSpeed, hitboxSize, verticalRange)
	assert(startPos and startVel and offsetFromEnemy and enemyPos, "calculateOptimalWishdir: positions are invalid")
	assert(ticks and ticks > 0, "calculateOptimalWishdir: ticks is invalid")
	assert(maxSpeed and maxSpeed > 0, "calculateOptimalWishdir: maxSpeed is invalid")

	local tickInterval = globals.TickInterval()

	-- Direction from start to extended target
	local baseTarget = enemyPos + offsetFromEnemy
	local dirFromStart = baseTarget - startPos
	local dirFromStartNorm = normalizeVector(dirFromStart)
	local extendedTarget = baseTarget + dirFromStartNorm * TF2.TARGET_EXTENSION

	-- Coast without input
	local pos = Vector3(startPos.x, startPos.y, startPos.z)
	local vel = Vector3(startVel.x, startVel.y, startVel.z)

	for _ = 1, ticks do
		pos = pos + vel * tickInterval

		local speed = vel:Length()
		if speed > 0 then
			local drop = speed * TF2.GROUND_FRICTION * tickInterval
			local newspeed = math.max(speed - drop, 0)
			if speed > 0 then
				vel = vel * (newspeed / speed)
			end
		end
	end

	local directionToTarget = extendedTarget - pos
	return normalizeVector(directionToTarget)
end

local function getOptimalBackstabCorners(myPos, enemyPos, enemyBack, hitboxSize, verticalRange)
	assert(myPos and enemyPos and enemyBack, "getOptimalBackstabCorners: required vectors are missing")

	if not hitboxSize or hitboxSize <= 0 then
		hitboxSize = TF2.HITBOX_RADIUS
	end

	if not verticalRange or verticalRange <= 0 then
		verticalRange = TF2.HITBOX_HEIGHT
	end

	local allPositions = getBestCornersOrCenter(myPos, enemyPos, hitboxSize, verticalRange)
	local optimal
	local secondary
	local centerCorner
	local bestYawDelta = math.huge
	local enemyBackYaw = positionYaw(enemyPos, enemyPos + enemyBack)
	local sorted = {}

	for _, pos in ipairs(allPositions) do
		if pos == center then
			centerCorner = pos
		else
			local testYaw = positionYaw(enemyPos, enemyPos + pos)
			local yawDiff = math.abs(normalizeYaw(testYaw - enemyBackYaw))

			if yawDiff < bestYawDelta then
				if optimal then
					secondary = optimal
				end
				bestYawDelta = yawDiff
				optimal = pos
			else
				secondary = pos
			end
		end
	end

	if optimal then
		table.insert(sorted, optimal)
	end
	if secondary then
		table.insert(sorted, secondary)
	end
	if centerCorner then
		table.insert(sorted, centerCorner)
	end

	return sorted, optimal, secondary, centerCorner
end

-- Public API ----
DirectionUtils.normalizeVector = normalizeVector
DirectionUtils.normalizeYaw = normalizeYaw
DirectionUtils.positionYaw = positionYaw
DirectionUtils.positionAngles = positionAngles
DirectionUtils.determineRelativeDirection = determineRelativeDirection
DirectionUtils.getDynamicCorners = getDynamicCorners
DirectionUtils.getOptimalBackstabCorners = getOptimalBackstabCorners
DirectionUtils.scaleCorner = scaleCorner
DirectionUtils.calculateOptimalWishdir = calculateOptimalWishdir

-- Self-init (optional) ---

-- Callbacks -----

return DirectionUtils
