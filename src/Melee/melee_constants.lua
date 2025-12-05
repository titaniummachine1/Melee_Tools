-- Imports

-- Module declaration
local MeleeConstants = {}

-- Local constants / utilities -----
local TF2 = {
	BACKSTAB_RANGE = 66,
	MELEE_HIT_RANGE = 225,
	BACKSTAB_ANGLE = 90,
	SWING_HULL_SIZE = 38,
	HITBOX_RADIUS = 24,
	HITBOX_HEIGHT = 82,
	VIEW_OFFSET_Z = 75,
	MAX_SPEED = 320,
	ACCELERATION = 10,
	GROUND_FRICTION = 4.0,
	STOP_SPEED = 100,
	WARP_READY_TICKS = 23,
	AUTO_RECHARGE_THRESHOLD = 24,
	TARGET_EXTENSION = 450,
	MIN_BACKSTAB_POINTS = 3,
	STAIRSTAB_HEIGHT = 82,
	ATTACK_RANGE = 225,
	MAX_SCORE_DISTANCE = 120,
	YAW_WEIGHT = 0.7,
	DISTANCE_WEIGHT = 0.3,
	MIN_PING_COOLDOWN = 7,
	PING_BUFFER_TICKS = 5,
	MANUAL_THRESHOLD = 1,
	SPY_CLASS_ID = 8,
	STUCK_SPEED_THRESHOLD = 10,
	MAX_CMD_SPEED = 450,
}

local MATH = {
	TWO_PI = 2 * math.pi,
	DEG_TO_RAD = math.pi / 180,
	RAD_TO_DEG = 180 / math.pi,
	HALF_PI = math.pi / 2,
	THREE_QUARTER_PI = 3 * math.pi / 4,
	HALF_CIRCLE = 180,
	FULL_CIRCLE = 360,
}

local HULL = {
	MIN = Vector3(-23.99, -23.99, 0),
	MAX = Vector3(23.99, 23.99, 82),
	SWING_MIN = Vector3(-19, -19, -19),
	SWING_MAX = Vector3(19, 19, 19),
}

local CLASS_MAX_SPEEDS = {
	[1] = 400, -- Scout
	[2] = 300, -- Sniper
	[3] = 240, -- Soldier
	[4] = 280, -- Demoman
	[5] = 320, -- Medic
	[6] = 280, -- Heavy
	[7] = 300, -- Pyro
	[8] = 320, -- Spy
	[9] = 320, -- Engineer
}

local SMOOTH_WARP = {
	BONUS_TICKS = 3,
	RESERVE_TICKS = 3,
	ASSIST_ANGLE_THRESHOLD = 10,
	NEW_COMMANDS_SIZE = 4,
	BACKUP_COMMANDS_SIZE = 3,
	CLC_MOVE_TYPE = 9,
}

-- Public API ----
MeleeConstants.TF2 = TF2
MeleeConstants.MATH = MATH
MeleeConstants.HULL = HULL
MeleeConstants.CLASS_MAX_SPEEDS = CLASS_MAX_SPEEDS
MeleeConstants.SMOOTH_WARP = SMOOTH_WARP

return MeleeConstants
