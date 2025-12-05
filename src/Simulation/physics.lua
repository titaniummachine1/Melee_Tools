-- Imports
local MeleeConstants = require("Melee.melee_constants")

-- Module declaration
local Physics = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2

local function clampHorizontalSpeed(vel, maxSpeed)
	if not maxSpeed then
		return vel
	end

	local horizSpeed = math.sqrt(vel.x * vel.x + vel.y * vel.y)
	if horizSpeed > maxSpeed then
		local scale = maxSpeed / horizSpeed
		return Vector3(vel.x * scale, vel.y * scale, vel.z)
	end

	return vel
end

-- Public API ----
function Physics.applyFriction(velocity, onGround, tickInterval, stopSpeed, groundFriction)
	assert(velocity, "applyFriction: velocity is nil")
	if not onGround then
		return velocity
	end

	local stop = stopSpeed or TF2.STOP_SPEED
	local friction = groundFriction or TF2.GROUND_FRICTION

	local speed = velocity:Length()
	if speed < stop then
		return Vector3(0, 0, 0)
	end

	local control = (speed < stop) and stop or speed
	local drop = control * friction * tickInterval

	local newSpeed = speed - drop
	if newSpeed < 0 then
		newSpeed = 0
	end

	if newSpeed < speed then
		local scale = newSpeed / speed
		return velocity * scale
	end

	return velocity
end

function Physics.accelerateGround(velocity, wishdir, maxSpeed, tickInterval, accel, onGround)
	if not onGround then
		return velocity
	end

	local acceleration = accel or TF2.ACCELERATION
	local currentSpeed = velocity:Dot(wishdir)
	local addSpeed = maxSpeed - currentSpeed
	if addSpeed <= 0 then
		return velocity
	end

	local accelSpeed = math.min(acceleration * maxSpeed * tickInterval, addSpeed)
	return velocity + wishdir * accelSpeed
end

function Physics.handleForwardCollision(vel, wallTrace, forwardCollisionAngle)
	assert(wallTrace and wallTrace.plane and wallTrace.endpos, "handleForwardCollision: invalid trace")

	local normal = wallTrace.plane
	local angle = math.deg(math.acos(normal:Dot(Vector3(0, 0, 1))))
	local limit = forwardCollisionAngle or TF2.FORWARD_COLLISION_ANGLE

	if angle > limit then
		local dot = vel:Dot(normal)
		vel = vel - normal * dot
	end

	return wallTrace.endpos.x, wallTrace.endpos.y
end

function Physics.handleGroundCollision(vel, groundTrace, upVector, groundAngleLow, groundAngleHigh)
	assert(groundTrace and groundTrace.plane and groundTrace.endpos, "handleGroundCollision: invalid trace")

	local normal = groundTrace.plane
	local vUp = upVector or Vector3(0, 0, 1)
	local angle = math.deg(math.acos(normal:Dot(vUp)))

	local low = groundAngleLow or TF2.GROUND_ANGLE_LOW
	local high = groundAngleHigh or TF2.GROUND_ANGLE_HIGH
	local onGround = false

	if angle < low then
		onGround = true
	elseif angle < high then
		vel.x, vel.y, vel.z = 0, 0, 0
	else
		local dot = vel:Dot(normal)
		vel = vel - normal * dot
		onGround = true
	end

	if onGround then
		vel.z = 0
	end

	return groundTrace.endpos, onGround
end

function Physics.capHorizontalSpeed(vel, maxSpeed)
	return clampHorizontalSpeed(vel, maxSpeed)
end

-- Self-init (optional) ---

-- Callbacks -----

return Physics
