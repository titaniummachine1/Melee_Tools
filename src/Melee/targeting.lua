-- Imports
local MeleeConstants = require("Melee.melee_constants")
local DirectionUtils = require("Melee.direction_utils")

-- Module declaration
local Targeting = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2

local function computeFov(viewAngles, targetAngles)
	assert(viewAngles and targetAngles, "computeFov: missing angles")
	local yawDelta = math.abs(DirectionUtils.normalizeYaw(targetAngles.yaw - viewAngles.yaw))
	local pitchDelta = math.abs(targetAngles.pitch - viewAngles.pitch)
	return math.sqrt((yawDelta * yawDelta) + (pitchDelta * pitchDelta))
end

local function getEyePosition(entity, eyeHeight)
	local origin = entity:GetAbsOrigin()
	return origin + Vector3(0, 0, eyeHeight)
end

local function healthWeight(player)
	local hp = player:GetHealth() or 0
	local maxHp = hp

	if player.GetPropInt then
		local value = player:GetPropInt("m_iMaxHealth")
		if value and value > 0 then
			maxHp = value
		end
	end

	local missing = (maxHp > 0) and ((maxHp - hp) / maxHp) or 0
	return 1 + missing
end

local function isEnemy(me, other)
	return other:GetTeamNumber() ~= me:GetTeamNumber()
end

local function isValidTarget(me, target)
	return target and target:IsValid() and target:IsAlive() and not target:IsDormant() and isEnemy(me, target)
end

local function buildCandidate(me, target, opts)
	local viewAngles = opts.viewAngles
	local localOrigin = opts.localOrigin
	local eyeHeight = opts.eyeHeight
	local fovLimit = opts.fovLimit
	local meleeRange = opts.meleeRange
	local rangedLimit = opts.rangedLimit
	local visibilityFn = opts.visibilityFn
	local mathLib = opts.mathLib

	local targetOrigin = target:GetAbsOrigin()
	local targetEye = targetOrigin + Vector3(0, 0, eyeHeight)

	local anglesToTarget = DirectionUtils.positionAngles(localOrigin, targetEye)
	local fov = computeFov(viewAngles, anglesToTarget)
	if fov > fovLimit then
		return nil
	end

	local distance = (targetOrigin - localOrigin):Length()
	if distance > rangedLimit then
		return nil
	end

	local visibilityFactor = 1
	if visibilityFn then
		visibilityFactor = visibilityFn(target, localOrigin, targetEye) and 1 or 0.1
	end

	local inMelee = distance <= meleeRange
	local distanceFactor = 1 - (distance / rangedLimit)
	local fovFactor = 1 - (fov / math.max(fovLimit, 0.1))

	if mathLib and mathLib.RemapValClamped then
		distanceFactor = mathLib.RemapValClamped(distance, 0, rangedLimit, 1, 0.9)
		fovFactor = mathLib.RemapValClamped(fov, 0, fovLimit, 1, 0.1)
	end

	local base = distanceFactor * fovFactor * visibilityFactor
	if inMelee then
		base = base * 1.1
	end

	return {
		player = target,
		factor = base,
		distance = distance,
		inMelee = inMelee,
	}
end

local function chooseBest(candidates)
	if #candidates == 0 then
		return nil
	end

	if #candidates > 1 then
		for _, c in ipairs(candidates) do
			c.factor = c.factor * healthWeight(c.player)
		end
	end

	local best = candidates[1]
	for i = 2, #candidates do
		if candidates[i].factor > best.factor then
			best = candidates[i]
		end
	end

	return best.player, best
end

-- Public API ----
function Targeting.findBestTarget(args)
	assert(args, "findBestTarget: args required")
	assert(args.me, "findBestTarget: local player missing")
	assert(args.players, "findBestTarget: players list missing")

	local me = args.me
	local players = args.players
	local viewAngles = args.viewAngles or engine.GetViewAngles()
	local eyeHeight = args.eyeHeight or TF2.VIEW_OFFSET_Z
	local meleeRange = args.meleeRange or (TF2.MELEE_HIT_RANGE + 50)
	local rangedLimit = args.rangedLimit or 770
	local fovLimit = args.fov or 360
	local visibilityFn = args.visibilityFn
	local extraFilter = args.filter
	local mathLib = args.mathLib

	local localOrigin = me:GetAbsOrigin()
	local eyePos = getEyePosition(me, eyeHeight)

	local meleeCandidates = {}
	local rangedCandidates = {}

	for _, player in pairs(players) do
		if not isValidTarget(me, player) then
			goto continue
		end

		if extraFilter and not extraFilter(player) then
			goto continue
		end

		local candidate = buildCandidate(me, player, {
			viewAngles = viewAngles,
			localOrigin = localOrigin,
			eyeHeight = eyeHeight,
			fovLimit = fovLimit,
			meleeRange = meleeRange,
			rangedLimit = rangedLimit,
			visibilityFn = visibilityFn,
			eyePos = eyePos,
			mathLib = mathLib,
		})

		if candidate then
			if candidate.inMelee then
				table.insert(meleeCandidates, candidate)
			else
				table.insert(rangedCandidates, candidate)
			end
		end

		::continue::
	end

	if #meleeCandidates > 0 then
		return chooseBest(meleeCandidates)
	end

	return chooseBest(rangedCandidates)
end

-- Self-init (optional) ---

-- Callbacks -----

return Targeting
