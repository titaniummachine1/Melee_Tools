---@meta

-- Lmaobox Lua API: inventory - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/inventory/
-- Path: Lua_Libraries/inventory
-- Last updated: 2025-12-05T11:44:38.838Z

---@class inventory
inventory = {}

-- Callback is called for each item in the inventory. The item is passed as the first argument and is of type Item .
---@return any
function inventory.Enumerate() end

-- Returns the item at the given position in the inventory.
---@param position number
---@return Vector3
function inventory.GetItemByPosition(position) end

-- Returns the maximum number of items that can be in the inventory.
---@return number
function inventory.GetMaxItemCount() end

-- Returns the item with the given 64bit item ID.
---@param itemID number
---@return any
function inventory.GetItemByItemID(itemID) end

-- Returns the item that is in the given slot in the given class' loadout slot.
---@param classid number
---@param slot number
---@return any
function inventory.GetItemInLoadout(classid, slot) end

-- Equips the item that is in the given slot in the given class' loadout slot. The item is of type Item
---@param item any
---@param classid number
---@param slot number
---@return any
function inventory.EquipItemInLoadout(item, classid, slot) end

-- Creates a fake item with the given parameters. The item definition is of type ItemDefinition . The pickupOrPosition parameter is the pickup method, if isNewItem parameter is true, and the inventory position of the item if isNewItem parameter is false. The itemID64 is the unique 64bit item ID of the item, you can use -1 to generate a random ID. For quality and origin you can use constants. The level is the item's level.
---@param itemdef any
---@param pickupOrPosition number
---@param itemID64 number
---@param quality number
---@param origin number
---@param level number
---@param isNewItem boolean
---@return any
function inventory.CreateFakeItem(itemdef, pickupOrPosition, itemID64, quality, origin, level, isNewItem) end

