---@meta

-- Lmaobox Lua API - Trace and Contents Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

-- ============================================================================
-- E_TraceLine - Contents flags
-- ============================================================================

---@type number
CONTENTS_EMPTY = 0

---@type number
CONTENTS_SOLID = 0x1

---@type number
CONTENTS_WINDOW = 0x2

---@type number
CONTENTS_AUX = 0x4

---@type number
CONTENTS_GRATE = 0x8

---@type number
CONTENTS_SLIME = 0x10

---@type number
CONTENTS_WATER = 0x20

---@type number
CONTENTS_BLOCKLOS = 0x40

---@type number
CONTENTS_OPAQUE = 0x80

---@type number
CONTENTS_TESTFOGVOLUME = 0x100

---@type number
CONTENTS_UNUSED = 0x200

---@type number
CONTENTS_BLOCKLIGHT = 0x400

---@type number
CONTENTS_TEAM1 = 0x800

---@type number
CONTENTS_TEAM2 = 0x1000

---@type number
CONTENTS_IGNORE_NODRAW_OPAQUE = 0x2000

---@type number
CONTENTS_MOVEABLE = 0x4000

---@type number
CONTENTS_AREAPORTAL = 0x8000

---@type number
CONTENTS_PLAYERCLIP = 0x10000

---@type number
CONTENTS_MONSTERCLIP = 0x20000

---@type number
CONTENTS_CURRENT_0 = 0x40000

---@type number
CONTENTS_CURRENT_90 = 0x80000

---@type number
CONTENTS_CURRENT_180 = 0x100000

---@type number
CONTENTS_CURRENT_270 = 0x200000

---@type number
CONTENTS_CURRENT_UP = 0x400000

---@type number
CONTENTS_CURRENT_DOWN = 0x800000

---@type number
CONTENTS_ORIGIN = 0x1000000

---@type number
CONTENTS_MONSTER = 0x2000000

---@type number
CONTENTS_DEBRIS = 0x4000000

---@type number
CONTENTS_DETAIL = 0x8000000

---@type number
CONTENTS_TRANSLUCENT = 0x10000000

---@type number
CONTENTS_LADDER = 0x20000000

---@type number
CONTENTS_HITBOX = 0x40000000

-- Surface flags
---@type number
SURF_LIGHT = 0x0001

---@type number
SURF_SKY2D = 0x0002

---@type number
SURF_SKY = 0x0004

---@type number
SURF_WARP = 0x0008

---@type number
SURF_TRANS = 0x0010

---@type number
SURF_NOPORTAL = 0x0020

---@type number
SURF_TRIGGER = 0x0040

---@type number
SURF_NODRAW = 0x0080

---@type number
SURF_HINT = 0x0100

---@type number
SURF_SKIP = 0x0200

---@type number
SURF_NOLIGHT = 0x0400

---@type number
SURF_BUMPLIGHT = 0x0800

---@type number
SURF_NOSHADOWS = 0x1000

---@type number
SURF_NODECALS = 0x2000

---@type number
SURF_NOCHOP = 0x4000

---@type number
SURF_HITBOX = 0x8000

-- Trace masks (computed values - using hex for clarity)
---@type number
MASK_ALL = 0xFFFFFFFF

---@type number
MASK_SOLID = 0x200400B

---@type number
MASK_PLAYERSOLID = 0x200400B

---@type number
MASK_NPCSOLID = 0x200400B

---@type number
MASK_NPCFLUID = 0x200400B

---@type number
MASK_WATER = 0x20

---@type number
MASK_OPAQUE = 0x200400B

---@type number
MASK_OPAQUE_AND_NPCS = 0x200400B

---@type number
MASK_BLOCKLOS = 0x200400B

---@type number
MASK_BLOCKLOS_AND_NPCS = 0x200400B

---@type number
MASK_VISIBLE = 0x200400B

---@type number
MASK_VISIBLE_AND_NPCS = 0x200400B

---@type number
MASK_SHOT = 0x200400B

---@type number
MASK_SHOT_BRUSHONLY = 0x200400B

---@type number
MASK_SHOT_HULL = 0x200400B

---@type number
MASK_SHOT_PORTAL = 0x200400B

---@type number
MASK_SOLID_BRUSHONLY = 0x200400B

---@type number
MASK_PLAYERSOLID_BRUSHONLY = 0x200400B

---@type number
MASK_NPCSOLID_BRUSHONLY = 0x200400B

---@type number
MASK_NPCWORLDSTATIC = 0x200400B

---@type number
MASK_NPCWORLDSTATIC_FLUID = 0x200400B

---@type number
MASK_SPLITAREAPORTAL = 0x20

---@type number
MASK_CURRENT = 0x40000

---@type number
MASK_DEADSOLID = 0x200400B

---@type number
MAX_COORD_INTEGER = 16384

---@type number
COORD_EXTENT = 2 * MAX_COORD_INTEGER

---@type number
MAX_TRACE_LENGTH = 1.732050807569 * COORD_EXTENT
