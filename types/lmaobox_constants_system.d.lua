---@meta

-- Lmaobox Lua API - System and File Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

-- ============================================================================
-- E_FileAttribute - File attribute flags
-- ============================================================================

---@type number
FILE_ATTRIBUTE_READONLY = 0x1

---@type number
FILE_ATTRIBUTE_HIDDEN = 0x2

---@type number
FILE_ATTRIBUTE_SYSTEM = 0x4

---@type number
FILE_ATTRIBUTE_DIRECTORY = 0x10

---@type number
FILE_ATTRIBUTE_ARCHIVE = 0x20

---@type number
FILE_ATTRIBUTE_DEVICE = 0x40

---@type number
FILE_ATTRIBUTE_NORMAL = 0x80

---@type number
FILE_ATTRIBUTE_TEMPORARY = 0x100

---@type number
FILE_ATTRIBUTE_SPARSE_FILE = 0x200

---@type number
FILE_ATTRIBUTE_REPARSE_POINT = 0x400

---@type number
FILE_ATTRIBUTE_COMPRESSED = 0x800

---@type number
FILE_ATTRIBUTE_OFFLINE = 0x1000

---@type number
FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 0x2000

---@type number
FILE_ATTRIBUTE_ENCRYPTED = 0x4000

---@type number
FILE_ATTRIBUTE_INTEGRITY_STREAM = 0x8000

---@type number
FILE_ATTRIBUTE_VIRTUAL = 0x10000

---@type number
FILE_ATTRIBUTE_NO_SCRUB_DATA = 0x20000

---@type number
FILE_ATTRIBUTE_RECALL_ON_OPEN = 0x40000

---@type number
FILE_ATTRIBUTE_PINNED = 0x80000

---@type number
FILE_ATTRIBUTE_UNPINNED = 0x100000

---@type number
FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS = 0x400000

---@type number
INVALID_FILE_ATTRIBUTES = 0xFFFFFFFF

-- ============================================================================
-- E_GCResults - GC result codes
-- ============================================================================

---@type number
k_EGCResultOK = 0

---@type number
k_EGCResultNoMessage = 1

---@type number
k_EGCResultBufferTooSmall = 2

---@type number
k_EGCResultNotLoggedOn = 3

---@type number
k_EGCResultInvalidMessage = 4

-- ============================================================================
-- E_MatchAbandonStatus - Match abandon status
-- ============================================================================

---@type number
MATCHABANDON_SAFE = 0

---@type number
MATCHABANDON_NOPENALTY = 1

---@type number
MATCHABANDON_PENTALTY = 2
