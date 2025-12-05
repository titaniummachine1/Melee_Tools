-- Imports
local MeleeConstants = require("Melee.melee_constants")
local DirectionUtils = require("Melee.direction_utils")

-- Module declaration
local MovementControl = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2
local MATH = MeleeConstants.MATH

local function computeMove(cmd, fromPos, toPos, maxSpeed)
	assert(cmd and fromPos and toPos, "computeMove: missing arguments")

	local diff = toPos - fromPos
	if diff:Length() == 0 then
		return Vector3(0, 0, 0)
	end

	local silent = Vector3(diff.x, diff.y, 0)
	local ang = silent:Angles()
	local currentPitch, currentYaw = cmd:GetViewAngles()
	local yaw = math.rad(ang.y - currentYaw)

	local move = Vector3(math.cos(yaw) * maxSpeed, -math.sin(yaw) * maxSpeed, 0)
	return move
end

-- Private helpers -----
local function setMovement(cmd, move, speedScale)
	local scale = speedScale or 1
	cmd:SetForwardMove(move.x * scale)
	cmd:SetSideMove(move.y * scale)
end

-- Public API ----
function MovementControl.walkTo(cmd, localPlayer, destination, opts)
	assert(cmd and localPlayer and destination, "walkTo: missing arguments")

	opts = opts or {}
	local maxSpeed = opts.maxSpeed or TF2.MAX_CMD_SPEED
	local minSpeed = opts.minSpeed or 10
	local localPos = localPlayer:GetAbsOrigin()
	local distVector = destination - localPos

	if not distVector or distVector:Length() > 1000 then
		return
	end

	local distance = distVector:Length()
	local speed = math.max(minSpeed, math.min(maxSpeed, distance))

	if distance > 1 then
		local move = computeMove(cmd, localPos, destination, maxSpeed)
		if not move then
			return
		end

		local scaleFactor = speed / maxSpeed
		setMovement(cmd, move, scaleFactor)
	else
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
	end
end

function MovementControl.walkInDirection(cmd, direction, opts)
	assert(cmd and direction, "walkInDirection: missing arguments")

	opts = opts or {}
	local useAngleSnap = opts.useAngleSnap
	if useAngleSnap == nil then
		useAngleSnap = true
	end

	local dx, dy = direction.x, direction.y
	if useAngleSnap then
		local forwardMove = cmd:GetForwardMove()
		local sideMove = cmd:GetSideMove()

		local targetYaw = math.atan(dy, dx)
		local inputAngle = 0

		if math.abs(forwardMove) > 0.1 or math.abs(sideMove) > 0.1 then
			inputAngle = math.atan(-sideMove, forwardMove)
		end

		local desiredViewYaw = (targetYaw - inputAngle) * MATH.RAD_TO_DEG
		desiredViewYaw = DirectionUtils.normalizeYaw(desiredViewYaw)

		local viewPitch = select(1, cmd:GetViewAngles())
		engine.SetViewAngles(EulerAngles(viewPitch, desiredViewYaw, 0))
	else
		local targetYaw = (math.atan(dy, dx) + MATH.TWO_PI) % MATH.TWO_PI
		local _, currentYaw = cmd:GetViewAngles()
		currentYaw = currentYaw * MATH.DEG_TO_RAD

		local yawDiff = (targetYaw - currentYaw + math.pi) % MATH.TWO_PI - math.pi
		local forward = math.cos(yawDiff) * TF2.MAX_CMD_SPEED
		local side = math.sin(-yawDiff) * TF2.MAX_CMD_SPEED

		cmd:SetForwardMove(forward)
		cmd:SetSideMove(side)
	end
end

-- Self-init (optional) ---

-- Callbacks -----

return MovementControl
