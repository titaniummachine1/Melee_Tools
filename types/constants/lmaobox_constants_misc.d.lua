---@meta

-- Lmaobox Lua API - Miscellaneous Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

-- ============================================================================
-- E_PlayerFlag - Player movement flags
-- ============================================================================

---@type number
FL_ONGROUND = 1 << 0

---@type number
FL_DUCKING = 1 << 1

---@type number
FL_WATERJUMP = 1 << 2

---@type number
FL_ONTRAIN = 1 << 3

---@type number
FL_INRAIN = 1 << 4

---@type number
FL_FROZEN = 1 << 5

---@type number
FL_ATCONTROLS = 1 << 6

---@type number
FL_CLIENT = 1 << 7

---@type number
FL_FAKECLIENT = 1 << 8

---@type number
FL_INWATER = 1 << 9

-- ============================================================================
-- E_RoundState - Round states
-- ============================================================================

---@type number
ROUND_INIT = 0

---@type number
ROUND_PREGAME = 1

---@type number
ROUND_STARTGAME = 2

---@type number
ROUND_PREROUND = 3

---@type number
ROUND_RUNNING = 4

---@type number
ROUND_TEAMWIN = 5

---@type number
ROUND_RESTART = 6

---@type number
ROUND_STALEMATE = 7

---@type number
ROUND_GAMEOVER = 8

---@type number
ROUND_BONUS = 9

---@type number
ROUND_BETWEEN_ROUNDS = 10

-- ============================================================================
-- E_SignonState - Signon states
-- ============================================================================

---@type number
SIGNONSTATE_NONE = 0

---@type number
SIGNONSTATE_CHALLENGE = 1

---@type number
SIGNONSTATE_CONNECTED = 2

---@type number
SIGNONSTATE_NEW = 3

---@type number
SIGNONSTATE_PRESPAWN = 4

---@type number
SIGNONSTATE_SPAWN = 5

---@type number
SIGNONSTATE_FULL = 6

---@type number
SIGNONSTATE_CHANGELEVEL = 7

-- ============================================================================
-- E_MoveType - Movement types
-- ============================================================================

---@type number
MOVETYPE_NONE = 0

---@type number
MOVETYPE_ISOMETRIC = 1

---@type number
MOVETYPE_WALK = 2

---@type number
MOVETYPE_STEP = 3

---@type number
MOVETYPE_FLY = 4

---@type number
MOVETYPE_FLYGRAVITY = 5

---@type number
MOVETYPE_VPHYSICS = 6

---@type number
MOVETYPE_PUSH = 7

---@type number
MOVETYPE_NOCLIP = 8

---@type number
MOVETYPE_LADDER = 9

---@type number
MOVETYPE_OBSERVER = 10

---@type number
MOVETYPE_CUSTOM = 11

-- ============================================================================
-- E_Hitbox - Hitbox indices
-- ============================================================================

---@type number
HITBOX_HEAD = 0

---@type number
HITBOX_PELVIS = 1

---@type number
HITBOX_SPINE_0 = 2

---@type number
HITBOX_SPINE_1 = 3

---@type number
HITBOX_SPINE_2 = 4

---@type number
HITBOX_SPINE_3 = 5

---@type number
HITBOX_UPPERARM_L = 6

---@type number
HITBOX_LOWERARM_L = 7

---@type number
HITBOX_HAND_L = 8

---@type number
HITBOX_UPPERARM_R = 9

---@type number
HITBOX_LOWERARM_R = 10

---@type number
HITBOX_HAND_R = 11

---@type number
HITBOX_HIP_L = 12

---@type number
HITBOX_KNEE_L = 13

---@type number
HITBOX_FOOT_L = 14

---@type number
HITBOX_HIP_R = 15

---@type number
HITBOX_KNEE_R = 16

---@type number
HITBOX_FOOT_R = 17

-- ============================================================================
-- E_ProjectileType - Projectile types
-- ============================================================================

---@type number
TF_PROJECTILE_NONE = 0

---@type number
TF_PROJECTILE_BULLET = 1

---@type number
TF_PROJECTILE_ROCKET = 2

---@type number
TF_PROJECTILE_PIPEBOMB = 3

---@type number
TF_PROJECTILE_PIPEBOMB_REMOTE = 4

---@type number
TF_PROJECTILE_SYRINGE = 5

---@type number
TF_PROJECTILE_FLARE = 6

---@type number
TF_PROJECTILE_JAR = 7

---@type number
TF_PROJECTILE_ARROW = 8

---@type number
TF_PROJECTILE_FLAME_ROCKET = 9

---@type number
TF_PROJECTILE_JAR_MILK = 10

---@type number
TF_PROJECTILE_HEALING_BOLT = 11

---@type number
TF_PROJECTILE_ENERGY_BALL = 12

---@type number
TF_PROJECTILE_ENERGY_RING = 13

---@type number
TF_PROJECTILE_PIPEBOMB_PRACTICE = 14

---@type number
TF_PROJECTILE_CLEAVER = 15

---@type number
TF_PROJECTILE_STICKY_BALL = 16

---@type number
TF_PROJECTILE_CANNONBALL = 17

---@type number
TF_PROJECTILE_BUILDING_REPAIR_BOLT = 18

---@type number
TF_PROJECTILE_FESTIVE_ARROW = 19

---@type number
TF_PROJECTILE_THROWABLE = 20

---@type number
TF_PROJECTILE_SPELL = 21

---@type number
TF_PROJECTILE_FESTIVE_JAR = 22

---@type number
TF_PROJECTILE_FESTIVE_HEALING_BOLT = 23

---@type number
TF_PROJECTILE_BREADMONSTER_JARATE = 24

---@type number
TF_PROJECTILE_BREADMONSTER_MADMILK = 25

---@type number
TF_PROJECTILE_GRAPPLINGHOOK = 26

---@type number
TF_PROJECTILE_SENTRY_ROCKET = 27

---@type number
TF_PROJECTILE_BREAD_MONSTER = 28

-- ============================================================================
-- E_RuneType - Rune types
-- ============================================================================

---@type number
RUNETYPE_TEMP_NONE = 0

---@type number
RUNETYPE_TEMP_CRIT = 1

---@type number
RUNETYPE_TEMP_UBER = 2

-- ============================================================================
-- E_Flows - Network flow directions
-- ============================================================================

---@type number
FLOW_OUTGOING = 0

---@type number
FLOW_INCOMING = 1

---@type number
MAX_FLOWS = 2

-- ============================================================================
-- E_ClientFrameStage - Client frame stages
-- ============================================================================

---@type number
FRAME_UNDEFINED = -1

---@type number
FRAME_START = 0

---@type number
FRAME_NET_UPDATE_START = 1

---@type number
FRAME_NET_UPDATE_POSTDATAUPDATE_START = 2

---@type number
FRAME_NET_UPDATE_POSTDATAUPDATE_END = 3

---@type number
FRAME_NET_UPDATE_END = 4

---@type number
FRAME_RENDER_START = 5

---@type number
FRAME_RENDER_END = 6

-- ============================================================================
-- E_DataUpdateType - Data update types
-- ============================================================================

---@type number
DATA_UPDATE_CREATED = 0

---@type number
DATA_UPDATE_DATATABLE_CHANGED = 1
