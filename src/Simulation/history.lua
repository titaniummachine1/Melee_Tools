-- Imports
local SimConstants = require("Simulation.constants")
local DirectionUtils = require("Melee.direction_utils")

-- Module declaration
local History = {}
History.__index = History

-- Local constants / utilities -----
local function velocityYaw(vec)
	if not vec or not vec.Length then
		return nil
	end

	if vec:Length() < SimConstants.MIN_SPEED_FOR_STRAFE then
		return nil
	end

	return math.deg(math.atan(vec.y, vec.x))
end

local function clampAge(samples, maxAge, now)
	while #samples > 0 and (now - samples[1].time) > maxAge do
		table.remove(samples, 1)
	end
end

-- Private helpers -----
local function createRecord(entity)
	return {
		index = entity:GetIndex(),
		samples = {},
	}
end

local function addSample(record, sample)
	record.samples[#record.samples + 1] = sample
end

local function pruneSamples(record, maxSamples, maxAge, now)
	while #record.samples > maxSamples do
		table.remove(record.samples, 1)
	end

	clampAge(record.samples, maxAge, now)
end

-- Public API ----
function History.new(maxSamples, maxAgeSeconds)
	local tracker = setmetatable({}, History)

	tracker.maxSamples = maxSamples or SimConstants.MAX_HISTORY_SAMPLES
	tracker.maxAgeSeconds = maxAgeSeconds or SimConstants.MAX_HISTORY_SECONDS
	tracker.records = {}

	return tracker
end

function History:record(entity)
	assert(entity and entity.GetIndex, "History:record - entity is invalid")

	local idx = entity:GetIndex()
	local now = globals.CurTime()
	local record = self.records[idx]

	if not record then
		record = createRecord(entity)
		self.records[idx] = record
	end

	local origin = assert(entity:GetAbsOrigin(), "History:record - origin is nil")
	local velocity = entity:EstimateAbsVelocity() or Vector3(0, 0, 0)
	local yaw = velocityYaw(velocity)

	addSample(record, {
		time = now,
		pos = origin,
		vel = velocity,
		yaw = yaw,
	})

	pruneSamples(record, self.maxSamples, self.maxAgeSeconds, now)

	return record.samples[#record.samples]
end

function History:getLastSample(entity)
	assert(entity and entity.GetIndex, "History:getLastSample - entity is invalid")

	local record = self.records[entity:GetIndex()]
	if not record or #record.samples == 0 then
		return nil
	end

	return record.samples[#record.samples]
end

function History:getStrafeDelta(entity)
	assert(entity and entity.GetIndex, "History:getStrafeDelta - entity is invalid")

	local record = self.records[entity:GetIndex()]
	if not record or #record.samples < 2 then
		return nil
	end

	local latest = record.samples[#record.samples]
	local previous = record.samples[#record.samples - 1]

	local deltaTime = math.max(latest.time - previous.time, SimConstants.MIN_DELTA_TIME)
	local latestYaw = latest.yaw or 0
	local previousYaw = previous.yaw or latestYaw
	local yawDelta = DirectionUtils.normalizeYaw(latestYaw - previousYaw)
	local turnRate = yawDelta / deltaTime

	return {
		yawDelta = yawDelta,
		turnRate = turnRate,
		deltaTime = deltaTime,
		latest = latest,
		previous = previous,
	}
end

-- Self-init (optional) ---

-- Callbacks -----

return History
