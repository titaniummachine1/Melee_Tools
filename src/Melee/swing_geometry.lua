-- Imports
local MeleeConstants = require("Melee.melee_constants")
local DirectionUtils = require("Melee.direction_utils")

-- Module declaration
local SwingGeometry = {}

-- Local constants / utilities -----
local HULL = MeleeConstants.HULL
local TF2 = MeleeConstants.TF2

local DEFAULT_HITBOX = {
	mins = Vector3(-TF2.HITBOX_RADIUS, -TF2.HITBOX_RADIUS, 0),
	maxs = Vector3(TF2.HITBOX_RADIUS, TF2.HITBOX_RADIUS, TF2.HITBOX_HEIGHT),
}

-- Private helpers -----
local function clampPointToHitbox(point, hitboxMin, hitboxMax)
	return Vector3(
		math.max(hitboxMin.x, math.min(point.x, hitboxMax.x)),
		math.max(hitboxMin.y, math.min(point.y, hitboxMax.y)),
		math.max(hitboxMin.z, math.min(point.z, hitboxMax.z))
	)
end

-- Public API ----
function SwingGeometry.checkSwingRange(targetPos, spherePos, sphereRadius, opts)
	assert(targetPos and spherePos, "checkSwingRange: positions are required")
	assert(sphereRadius and sphereRadius > 0, "checkSwingRange: radius invalid")

	opts = opts or {}

	local hitboxMin = (opts.hitbox and opts.hitbox[1]) or (opts.hitboxMin) or DEFAULT_HITBOX.mins
	local hitboxMax = (opts.hitbox and opts.hitbox[2]) or (opts.hitboxMax) or DEFAULT_HITBOX.maxs
	local traceLine = opts.traceLine
	local traceHull = opts.traceHull
	local advancedHitreg = opts.advancedHitreg
	local targetEntity = opts.targetEntity

	local closestPoint = clampPointToHitbox(spherePos, targetPos + hitboxMin, targetPos + hitboxMax)
	local distance = (spherePos - closestPoint):Length()

	if sphereRadius <= distance then
		return false, nil
	end

	if not advancedHitreg then
		return true, closestPoint
	end

	if traceLine and targetEntity then
		local swingEnd = spherePos + DirectionUtils.normalizeVector(closestPoint - spherePos) * sphereRadius
		local trace = traceLine(spherePos, swingEnd)
		if trace and trace.fraction and trace.entity == targetEntity then
			return true, closestPoint
		end

		if traceHull then
			local swingHullMin = HULL.SWING_MIN
			local swingHullMax = HULL.SWING_MAX
			trace = traceHull(spherePos, swingEnd, swingHullMin, swingHullMax)
			if trace and trace.fraction and trace.entity == targetEntity then
				return true, closestPoint
			end
		end
	end

	return false, nil
end

-- Self-init (optional) ---

-- Callbacks -----

return SwingGeometry
