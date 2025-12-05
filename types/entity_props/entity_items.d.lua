---@meta

-- Item Entity Properties
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

---@class Item
---@field m_iItemDefinitionIndex number
---@field m_iEntityLevel number
---@field m_iItemIDHigh number
---@field m_iItemIDLow number
---@field m_iAccountID number
---@field m_iEntityQuality number
---@field m_bInitialized number
---@field m_bOnlyIterateItemViewAttributes number
---@field m_iTeamNumber number
---@field m_AttributeList AttributeList
---@field m_NetworkedDynamicAttributesForDemos NetworkedDynamicAttributesForDemos

---@class AttributeList
---@field m_Attributes Attribute[]

---@class Attribute
---@field def_index number
---@field value number

---@class NetworkedDynamicAttributesForDemos
---@field m_Attributes Attribute[]

---@class CBaseAttributableItem : Entity
---@field m_AttributeManager AttributeManager

---@class AttributeManager
---@field m_hOuter number
---@field m_ProviderType number
---@field m_iReapplyProvisionParity number
---@field m_Item Item

---@class CEconEntity : Entity
---@field m_AttributeManager AttributeManager
---@field m_bValidatedAttachedEntity number

---@class CTFWearable : Entity
---@field m_bDisguiseWearable number
---@field m_hWeaponAssociatedWith number
