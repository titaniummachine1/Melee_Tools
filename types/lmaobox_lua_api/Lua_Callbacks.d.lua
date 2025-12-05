---@meta

-- Lmaobox Lua API: Lua Callbacks - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Callbacks/
-- Path: Lua_Callbacks
-- Last updated: 2025-12-05T11:20:20.581Z

---@return any
function Draw() end

---@param ctx DrawModelContext
---@return any
function DrawModel(ctx) end

---@param info StaticPropRenderInfo
---@return any
function DrawStaticProps(info) end

---@param cmd UserCmd
---@return any
function CreateMove(cmd) end

---@param event GameEvent
---@return any
function FireGameEvent(event) end

---@param msg UserMessage
---@return any
function DispatchUserMessage(msg) end

---@param cmd StringCmd
---@return string
function SendStringCmd(cmd) end

---@param stage integer
---@return any
function FrameStageNotify(stage) end

---@param view ViewSetup
---@return any
function RenderView(view) end

---@param view ViewSetup
---@return any
function PostRenderView(view) end

---@param view ViewSetup
---@return any
function RenderViewModel(view) end

---@param keyvalues StringCmd
---@return any
function ServerCmdKeyValues(keyvalues) end

---@param crate Item
---@param crateLootList Table
---@return any
function OnFakeUncrate(crate, crateLootList) end

---@param lobby GameServerLobby
---@return any
function OnLobbyUpdated(lobby) end

---@param key String
---@param value String
function SetRichPresence(key, value) end

---@param typeID integer
---@param data StringCmd
---@return any
function GCSendMessage(typeID, data) end

---@param typeID integer
---@param data StringCmd
---@return any
function GCRetrieveMessage(typeID, data) end

---@param msg NetMessage
---@param reliable boolean
---@param voice boolean
---@return any
function SendNetMsg(msg, reliable, voice) end

---@return any
function DoPostScreenSpaceEffects() end

---@param TempEntity table<
---@param entEvtTable EventInfo>
---@return any
function ProcessTempEntities(TempEntity, entEvtTable) end

---@return any
function Unload() end

