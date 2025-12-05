-- Imports
local SimConstants = require("Simulation.constants")
local History = require("Simulation.history")
local DirectionUtils = require("Melee.direction_utils")

-- Module declaration
local StrafePrediction = {}

-- Local constants / utilities -----
local function yawToForward(yawDegrees)
	local yawRad = math.rad(yawDegrees)
	return Vector3(math.cos(yawRad), math.sin(yawRad), 0)
end

local function copyVector(vec)
	if not vec then
		return nil
	end

	return Vector3(vec.x, vec.y, vec.z)
end

-- Private helpers -----
local function validateHistory(tracker)
	assert(getmetatable(tracker) == History, "StrafePrediction: tracker must be created by History.new")
end

local function getLatestSample(tracker, entity)
	local sample = tracker:getLastSample(entity)
	assert(sample, "StrafePrediction: missing history samples for entity")
	return sample
end

-- Public API ----
function StrafePrediction.predictYaw(tracker, entity, lookAheadSeconds)
	validateHistory(tracker)
	assert(entity, "StrafePrediction.predictYaw: entity is required")

	local strafe = tracker:getStrafeDelta(entity)
	if not strafe then
		return nil
	end

	local horizon = lookAheadSeconds or SimConstants.DEFAULT_LOOKAHEAD_SECONDS
	local projectedYaw = strafe.latest.yaw or 0

	projectedYaw = projectedYaw + (strafe.turnRate * horizon)
	projectedYaw = DirectionUtils.normalizeYaw(projectedYaw)

	return {
		projectedYaw = projectedYaw,
		turnRate = strafe.turnRate,
		horizon = horizon,
	}
end

function StrafePrediction.predictPosition(tracker, entity, lookAheadSeconds)
	validateHistory(tracker)
	assert(entity, "StrafePrediction.predictPosition: entity is required")

	local yawResult = StrafePrediction.predictYaw(tracker, entity, lookAheadSeconds)
	if not yawResult then
		return nil
	end

	local sample = getLatestSample(tracker, entity)
	local speed = sample.vel:Length()
	local forward = yawToForward(yawResult.projectedYaw)
	local horizon = yawResult.horizon

	local offset = forward * speed * horizon
	local projectedPos = copyVector(sample.pos) + offset

	return {
		position = projectedPos,
		yaw = yawResult.projectedYaw,
		speed = speed,
		horizon = horizon,
	}
end

-- Self-init (optional) ---

-- Callbacks -----

return StrafePrediction
