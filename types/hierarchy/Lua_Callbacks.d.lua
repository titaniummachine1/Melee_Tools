---@meta

-- Lmaobox Lua API: Lua Callbacks - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Callbacks/
-- Path: Lua_Callbacks
-- Last updated: 2025-12-05T03:32:42.161Z

---@return any
function Draw() end

---@param DrawModelContext any
---@return any
function DrawModel(DrawModelContext) end

---@param StaticPropRenderInfo any
---@return any
function DrawStaticProps(StaticPropRenderInfo) end

---@param UserCmd any
---@return any
function CreateMove(UserCmd) end

---@param GameEvent any
---@return any
function FireGameEvent(GameEvent) end

---@param UserMessage any
---@return any
function DispatchUserMessage(UserMessage) end

---@param StringCmd any
---@return string
function SendStringCmd(StringCmd) end

---@param stage number
---@return any
function FrameStageNotify(stage) end

---@param ViewSetup any
---@return any
function RenderView(ViewSetup) end

---@param ViewSetup any
---@return any
function PostRenderView(ViewSetup) end

---@param ViewSetup any
---@return any
function RenderViewModel(ViewSetup) end

---@param StringCmd any
---@return any
function ServerCmdKeyValues(StringCmd) end

---@param Item any
---@param Table any
---@return any
function OnFakeUncrate(Item, Table) end

---@param GameServerLobby any
---@return any
function OnLobbyUpdated(GameServerLobby) end

---@param String any
---@param String any
---@return any
function SetRichPresence(String, String) end

---@param typeID number
---@param data string
---@return any
function GCSendMessage(typeID, data) end

---@param typeID number
---@param data string
---@return any
function GCRetrieveMessage(typeID, data) end

---@param NetMessage any
---@param reliable boolean
---@param voice boolean
---@return any
function SendNetMsg(NetMessage, reliable, voice) end

---@return any
function DoPostScreenSpaceEffects() end

---@return any
function ProcessTempEntities() end

---@return any
function Unload() end

