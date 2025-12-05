---@meta

-- Lmaobox Lua API - Rendering and Material Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

-- ============================================================================
-- E_FontFlag - Font rendering flags
-- ============================================================================

---@type number
FONTFLAG_NONE = 0

---@type number
FONTFLAG_ITALIC = 0x001

---@type number
FONTFLAG_UNDERLINE = 0x002

---@type number
FONTFLAG_STRIKEOUT = 0x004

---@type number
FONTFLAG_SYMBOL = 0x008

---@type number
FONTFLAG_ANTIALIAS = 0x010

---@type number
FONTFLAG_GAUSSIANBLUR = 0x020

---@type number
FONTFLAG_ROTARY = 0x040

---@type number
FONTFLAG_DROPSHADOW = 0x080

---@type number
FONTFLAG_ADDITIVE = 0x100

---@type number
FONTFLAG_OUTLINE = 0x200

---@type number
FONTFLAG_CUSTOM = 0x400

---@type number
FONTFLAG_BITMAP = 0x800

-- ============================================================================
-- E_MaterialFlag - Material variable flags
-- ============================================================================

---@type number
MATERIAL_VAR_DEBUG = 1 << 0

---@type number
MATERIAL_VAR_NO_DEBUG_OVERRIDE = 1 << 1

---@type number
MATERIAL_VAR_NO_DRAW = 1 << 2

---@type number
MATERIAL_VAR_USE_IN_FILLRATE_MODE = 1 << 3

---@type number
MATERIAL_VAR_VERTEXCOLOR = 1 << 4

---@type number
MATERIAL_VAR_VERTEXALPHA = 1 << 5

---@type number
MATERIAL_VAR_SELFILLUM = 1 << 6

---@type number
MATERIAL_VAR_ADDITIVE = 1 << 7

---@type number
MATERIAL_VAR_ALPHATEST = 1 << 8

---@type number
MATERIAL_VAR_ZNEARER = 1 << 10

---@type number
MATERIAL_VAR_MODEL = 1 << 11

---@type number
MATERIAL_VAR_FLAT = 1 << 12

---@type number
MATERIAL_VAR_NOCULL = 1 << 13

---@type number
MATERIAL_VAR_NOFOG = 1 << 14

---@type number
MATERIAL_VAR_IGNOREZ = 1 << 15

---@type number
MATERIAL_VAR_DECAL = 1 << 16

---@type number
MATERIAL_VAR_ENVMAPSPHERE = 1 << 17

---@type number
MATERIAL_VAR_ENVMAPCAMERASPACE = 1 << 19

---@type number
MATERIAL_VAR_BASEALPHAENVMAPMASK = 1 << 20

---@type number
MATERIAL_VAR_TRANSLUCENT = 1 << 21

---@type number
MATERIAL_VAR_NORMALMAPALPHAENVMAPMASK = 1 << 22

---@type number
MATERIAL_VAR_NEEDS_SOFTWARE_SKINNING = 1 << 23

---@type number
MATERIAL_VAR_OPAQUETEXTURE = 1 << 24

---@type number
MATERIAL_VAR_ENVMAPMODE = 1 << 25

---@type number
MATERIAL_VAR_SUPPRESS_DECALS = 1 << 26

---@type number
MATERIAL_VAR_HALFLAMBERT = 1 << 27

---@type number
MATERIAL_VAR_WIREFRAME = 1 << 28

---@type number
MATERIAL_VAR_ALLOWALPHATOCOVERAGE = 1 << 29

---@type number
MATERIAL_VAR_ALPHA_MODIFIED_BY_PROXY = 1 << 30

---@type number
MATERIAL_VAR_VERTEXFOG = 1 << 31

-- ============================================================================
-- E_ClearFlags - View clear flags
-- ============================================================================

---@type number
VIEW_CLEAR_COLOR = 0x1

---@type number
VIEW_CLEAR_DEPTH = 0x2

---@type number
VIEW_CLEAR_FULL_TARGET = 0x4

---@type number
VIEW_NO_DRAW = 0x8

---@type number
VIEW_CLEAR_OBEY_STENCIL = 0x10

---@type number
VIEW_CLEAR_STENCIL = 0x20

-- ============================================================================
-- E_BoneMask - Bone mask flags
-- ============================================================================

---@type number
BONE_USED_BY_ANYTHING = 0x0007FF00

---@type number
BONE_USED_BY_HITBOX = 0x00000100

---@type number
BONE_USED_BY_ATTACHMENT = 0x00000200

---@type number
BONE_USED_BY_VERTEX_MASK = 0x0003FC00

---@type number
BONE_USED_BY_VERTEX_LOD0 = 0x00000400

---@type number
BONE_USED_BY_VERTEX_LOD1 = 0x00000800

---@type number
BONE_USED_BY_VERTEX_LOD2 = 0x00001000

---@type number
BONE_USED_BY_VERTEX_LOD3 = 0x00002000

---@type number
BONE_USED_BY_VERTEX_LOD4 = 0x00004000

---@type number
BONE_USED_BY_VERTEX_LOD5 = 0x00008000

---@type number
BONE_USED_BY_VERTEX_LOD6 = 0x00010000

---@type number
BONE_USED_BY_VERTEX_LOD7 = 0x00020000

---@type number
BONE_USED_BY_BONE_MERGE = 0x00040000
