# Hierarchy & Parsing Review

## Overview

This document reviews the type definition hierarchy structure and identifies discrepancies between the sitemap.xml and generated type files.

## Current Structure

### ✅ Generated Files

#### Constants (`types/hierarchy/constants/`)

- E_BoneMask.d.lua
- E_ButtonCode.d.lua
- E_ClearFlags.d.lua
- E_ClientFrameStage.d.lua
- E_DataUpdateType.d.lua
- E_FileAttribute.d.lua
- E_Flows.d.lua
- E_FontFlag.d.lua
- E_Hitbox.d.lua
- E_KillEffect.d.lua
- E_LifeState.d.lua
- E_LoadoutSlot.d.lua
- E_MatchAbandonStatus.d.lua
- E_MaterialFlag.d.lua
- E_MoveType.d.lua
- E_PlayerFlag.d.lua
- E_ProjectileType.d.lua
- E_RoundState.d.lua
- E_RuneType.d.lua
- E_SignonState.d.lua
- E_TeamNumber.d.lua
- E_TraceLine.d.lua
- E_UserCmd.d.lua
- E_WeaponBaseID.d.lua

#### ❌ Missing Constants (Found in HTML but not generated)

- **E_UserMessage** - Exists in HTML at line 2957
- **E_TFCOND** - Exists in HTML at line 3751
- **E_Character** - Exists in HTML at line 4592
- **E_GCResults** - Exists in HTML at line 5848

**Issue**: Parsing logic may be missing these due to:

1. Case sensitivity in h3 ID matching
2. Section boundary calculation cutting off tables
3. Name extraction failing for some h3 tags

#### Libraries (`types/hierarchy/Lua_Libraries/`)

- aimbot.d.lua
- callbacks.d.lua
- client.d.lua
- clientstate.d.lua
- draw.d.lua
- engine.d.lua
- entities.d.lua
- filesystem.d.lua
- gamecoordinator.d.lua
- gamerules.d.lua
- globals.d.lua
- gui.d.lua
- materials.d.lua
- models.d.lua
- party.d.lua
- physics.d.lua
- playerlist.d.lua
- render.d.lua
- steam.d.lua
- vector.d.lua
- warp.d.lua

**Potential Missing** (need to verify against sitemap):

- inventory (if exists in sitemap)
- itemschema (if exists in sitemap)

#### Classes (`types/hierarchy/Lua_Classes/`)

- AttributeDefinition.d.lua
- BitBuffer.d.lua
- DrawModelContext.d.lua
- Entity.d.lua
- EulerAngles.d.lua
- EventInfo.d.lua
- MatchMapDefinition.d.lua
- Material.d.lua
- Model.d.lua
- NetChannel.d.lua
- NetMessage.d.lua
- PartyMemberActivity.d.lua
- PhysicsCollisionModel.d.lua
- PhysicsEnvironment.d.lua
- PhysicsObject.d.lua
- PhysicsObjectParameters.d.lua
- PhysicsSolid.d.lua
- StaticPropRenderInfo.d.lua
- StringCmd.d.lua
- StudioBBox.d.lua
- StudioHitboxSet.d.lua
- StudioModelHeader.d.lua
- TempEntity.d.lua
- Vector3.d.lua
- ViewSetup.d.lua
- WeaponData.d.lua

**Missing Classes** (need to verify):

- GameEvent (if exists)
- GameServerLobby (if exists)
- Item (if exists)
- ItemDefinition (if exists)
- LobbyPlayer (if exists)
- MatchGroup (if exists)
- Texture (if exists)
- Trace (if exists)
- UserCmd (if exists)
- UserMessage (if exists)

#### Entity Props (`types/hierarchy/entity_props/`)

- 175 files generated ✅
- Properly categorized by entity type ✅

#### Root Files

- API_changelog.d.lua ✅
- index.d.lua ✅
- Lua_Callbacks.d.lua ✅
- Lua_Globals.d.lua ✅
- ~~Lua_Constants.d.lua~~ ❌ (Should be deleted - using folder structure now)

## Parsing Issues Found

### 1. Constants Parsing

**Problem**: Missing 4 constant categories (E_UserMessage, E_TFCOND, E_Character, E_GCResults)

**Root Cause**:

- h3 regex may not be matching all cases
- Section boundaries may be cutting off tables
- Name extraction may fail for some formats

**Fix Applied**:

- Improved h3 regex to handle both with/without id in single pass
- Better name cleaning and normalization
- More robust section boundary detection

### 2. False Positive Constants

**Problem**: Constants like `API_ = nil` appearing in class files

**Root Cause**: Aggressive uppercase token extraction from HTML

**Fix Applied**:

- Removed aggressive fallback extraction
- Added filtering in generation logic
- Only extract from code examples on non-constants pages

### 3. Page Type Inference

**Current Logic**:

```javascript
function inferPageType(url) {
  const path = url.replace(API_BASE_URL, "");
  if (path.startsWith("classes/")) return "class";
  if (path.includes("callback")) return "callback";
  if (path.match(/^[a-z]+$/)) return "library";
  return "page";
}
```

**Issues**:

- Library detection only matches single-word lowercase paths
- May miss libraries with underscores or in subdirectories
- Constants page not specifically handled

**Recommendation**: Improve page type inference to handle:

- `Lua_Libraries/` prefix
- `Lua_Classes/` prefix
- `Lua_Constants` specifically
- `TF2_props` specifically

## Recommendations

### Immediate Fixes

1. ✅ Fix constants parsing to capture all categories
2. ✅ Remove false positive constants
3. ✅ Ensure constants use folder structure (not single file)
4. ⚠️ Verify all libraries from sitemap are generated
5. ⚠️ Verify all classes from sitemap are generated

### Long-term Improvements

1. Add validation script to compare sitemap.xml with generated files
2. Add unit tests for parsing logic
3. Improve error reporting when sections fail to parse
4. Add logging for missing expected categories

## Validation Checklist

- [ ] All constants categories from HTML are generated
- [ ] All libraries from sitemap are generated
- [ ] All classes from sitemap are generated
- [ ] No false positive constants in class/library files
- [ ] Entity props properly categorized
- [ ] Constants properly categorized in folder structure
- [ ] Old main constants file is deleted
- [ ] All page types correctly inferred

## Next Steps

1. Run refresh script to regenerate with fixes
2. Compare generated files against sitemap.xml
3. Verify all missing constants are now generated
4. Check for any other missing pages
