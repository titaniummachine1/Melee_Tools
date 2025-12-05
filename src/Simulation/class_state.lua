-- Imports
local MeleeConstants = require("Melee.melee_constants")

-- Module declaration
local ClassState = {}

-- Local constants / utilities -----
local TF2 = MeleeConstants.TF2
local CLASS_SPY = TF2.SPY_CLASS_ID or 8
local CLASS_DEMOMAN = 4

local listeners = {}
local cachedProfile = "other"
local cachedClass = nil
local cachedHasShield = false

local function isDemoknight(localPlayer)
	assert(localPlayer, "ClassState.isDemoknight: localPlayer is nil")

	if localPlayer:GetPropInt("m_iClass") ~= CLASS_DEMOMAN then
		return false
	end

	for _, wearable in ipairs(entities.FindByClass("CTFWearableDemoShield")) do
		if wearable and wearable:IsValid() then
			local owner = wearable:GetPropEntity("m_hOwnerEntity")
			if owner == localPlayer then
				return true
			end
		end
	end

	return false
end

local function detectProfile()
	local lp = entities.GetLocalPlayer()
	if not lp then
		return "other", nil, false
	end

	local classId = lp:GetPropInt("m_iClass")
	if not classId then
		return "other", nil, false
	end

	if classId == CLASS_SPY then
		return "spy", classId, false
	end

	if isDemoknight(lp) then
		return "demoknight", classId, true
	end

	return "other", classId, false
end

local function notify(profile, classId, hasShield)
	for _, cb in ipairs(listeners) do
		local ok, err = pcall(cb, profile, classId, hasShield)
		if not ok then
			printc(255, 100, 100, 255, "[ClassState] listener error: " .. tostring(err))
		end
	end
end

-- Public API ----
function ClassState.refresh()
	local profile, classId, hasShield = detectProfile()

	if profile ~= cachedProfile or classId ~= cachedClass or hasShield ~= cachedHasShield then
		cachedProfile = profile
		cachedClass = classId
		cachedHasShield = hasShield
		notify(profile, classId, hasShield)
	end

	return cachedProfile, cachedClass, cachedHasShield
end

function ClassState.getProfile()
	if not cachedClass then
		return ClassState.refresh()
	end
	return cachedProfile, cachedClass, cachedHasShield
end

function ClassState.subscribe(callback)
	assert(type(callback) == "function", "ClassState.subscribe: callback must be function")
	table.insert(listeners, callback)
end

-- Self-init (optional) ---

-- Callbacks -----

return ClassState
