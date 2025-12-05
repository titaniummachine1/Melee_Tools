---@meta

-- Lmaobox Lua API Type Definitions
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

---@class Entity
---@field GetIndex fun(self: Entity): number
---@field GetName fun(self: Entity): string
---@field IsAlive fun(self: Entity): boolean
---@field IsDormant fun(self: Entity): boolean
---@field GetAbsOrigin fun(self: Entity): Vector3
---@field GetHealth fun(self: Entity): number
---@field GetTeamNumber fun(self: Entity): number
---@field GetClassID fun(self: Entity): number
local Entity = {}

---@class Vector3
---@field x number
---@field y number
---@field z number
---@field Length fun(self: Vector3): number
---@field Normalize fun(self: Vector3): Vector3
local Vector3 = {}

---@class EulerAngles
---@field pitch number
---@field yaw number
---@field roll number
local EulerAngles = {}

---@class client
client = {}

---@param message string
function client.ChatPrintf(message) end

---@param sound string
function client.PlaySound(sound) end

---@param origin Vector3
---@return number[]|nil screenPos
function client.WorldToScreen(origin) end

---@param name string
---@return number
function client.GetConVar(name) end

---@class draw
draw = {}

---@class Font
local Font = {}

---@param fontName string
---@param size number
---@param weight number
---@return Font
function draw.CreateFont(fontName, size, weight) end

---@param font Font
function draw.SetFont(font) end

---@param r number
---@param g number
---@param b number
---@param a number
function draw.Color(r, g, b, a) end

---@param x number
---@param y number
---@param text string
function draw.Text(x, y, text) end

---@class engine
engine = {}

---@return boolean
function engine.Con_IsVisible() end

---@return boolean
function engine.IsGameUIVisible() end

---@param sound string
function engine.PlaySound(sound) end

---@class entities
entities = {}

---@return Entity|nil
function entities.GetLocalPlayer() end

---@param index number
---@return Entity|nil
function entities.GetByIndex(index) end

---@param userid number
---@return Entity|nil
function entities.GetByUserID(userid) end

---@param className string
---@return Entity[]
function entities.FindByClass(className) end

---@class globals
globals = {}

---@return number
function globals.FrameCount() end

---@return number
function globals.FrameTime() end

---@return number
function globals.TickCount() end

---@return number
function globals.CurTime() end

---@return number
function globals.TickInterval() end

---@class gui
gui = {}

---@return boolean
function gui.IsMenuOpen() end

---@param key string
---@return number
function gui.GetValue(key) end

---@param key string
---@param value number
function gui.SetValue(key, value) end

---@class input
input = {}

---@param key number
---@return boolean
function input.IsButtonDown(key) end

---@class render
render = {}

---@class warp
warp = {}

---@return boolean
function warp.IsWarping() end

---@return number
function warp.GetChargedTicks() end

---@return boolean
function warp.CanWarp() end

---@class filesystem
filesystem = {}

---@param path string
---@return boolean success
---@return string fullPath
function filesystem.CreateDirectory(path) end

---@class callbacks
callbacks = {}

---@param eventName string
---@param name string
---@param callback fun(...)
function callbacks.Register(eventName, name, callback) end

---@class GameEvent
---@field GetName fun(self: GameEvent): string
---@field GetInt fun(self: GameEvent, key: string): number
---@field GetFloat fun(self: GameEvent, key: string): number
---@field GetString fun(self: GameEvent, key: string): string
---@field GetBool fun(self: GameEvent, key: string): boolean
local GameEvent = {}

--- Global variables provided by Lmaobox
---@type string
Lua__fileName = ""

---@param r number
---@param g number
---@param b number
---@param a number
---@param message string
function printc(r, g, b, a, message) end

--- Vector3 constructor
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3(x, y, z) end

-- Key constants
---@type number
KEY_NONE = 0

---@type number
KEY_LSHIFT = 106

---@type number
KEY_RSHIFT = 107
