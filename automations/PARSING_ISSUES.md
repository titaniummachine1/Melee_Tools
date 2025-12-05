# Parsing Issues Summary

## Current Status After Refresh

### Constants (`types/hierarchy/constants/`)

- **Generated**: 24 files
- **Expected**: 28 files
- **Missing**: 4 categories
  - ❌ E_UserMessage
  - ❌ E_TFCOND
  - ❌ E_Character
  - ❌ E_GCResults

### Libraries (`types/hierarchy/Lua_Libraries/`)

- **Generated**: 22 files ✅
- **Includes**: inventory, itemschema, input, http (all present)

### Classes (`types/hierarchy/Lua_Classes/`)

- **Generated**: 27 files
- **Expected**: 37 files (based on sitemap)
- **Missing**: 10 classes
  - GameEvent
  - GameServerLobby
  - Item
  - ItemDefinition
  - LobbyPlayer
  - MatchGroup
  - Trace
  - UserCmd
  - UserMessage
  - (and possibly more)

## Root Cause Analysis

### Constants Parsing Issue

**Problem**: 4 constant categories are not being generated despite existing in HTML.

**HTML Verification**:

- ✅ `<h3 id="e_usermessage">E_UserMessage</h3>` exists at line 2957
- ✅ `<h3 id="e_tfcond">E_TFCOND</h3>` exists at line 3751
- ✅ `<h3 id="e_character">E_Character</h3>` exists at line 4592
- ✅ `<h3 id="e_gcresults">E_GCResults</h3>` exists at line 5848

**Possible Causes**:

1. **H3 regex not matching**: The regex should match these, but maybe there's a subtle difference
2. **Table not found**: Tables exist immediately after h3 tags, but maybe the regex isn't matching
3. **Constants filtered out**: Constants in these sections might not pass the name filter
4. **Section boundaries**: Maybe the section slicing is cutting off the tables

**Constants in E_UserMessage**: "Geiger", "Train", "HudText", "SayText", etc.

- These are PascalCase, not UPPER_CASE
- Current filter: `/^[A-Z]/.test(name)` - should accept these ✅
- But maybe the table isn't being found at all

### Classes Parsing Issue

**Problem**: Many classes from sitemap are not being generated.

**Sitemap shows these classes are fetched**:

- GameEvent, GameServerLobby, Item, ItemDefinition, LobbyPlayer, MatchGroup, Trace, UserCmd, UserMessage

**But they're not in the generated files**. This suggests:

1. The pages are being fetched but not parsed correctly
2. The type generation is skipping them
3. They might be empty or have no content

## Fixes Applied

1. ✅ Improved h3 regex to handle both with/without id
2. ✅ Relaxed constant name filter to accept PascalCase
3. ✅ Improved table matching logic
4. ✅ Added special handling for constants page (folder structure)
5. ✅ Removed false positive constants from class files
6. ✅ Added debug logging

## Next Steps

### Immediate Actions Needed

1. **Debug constants parsing**:

   - Add more detailed logging to see why the 4 sections aren't being processed
   - Check if h3 headings are being found
   - Verify table matching is working
   - Check if constants are being filtered out

2. **Debug classes parsing**:

   - Check why classes from sitemap aren't being generated
   - Verify pages are being parsed correctly
   - Check if empty pages are being skipped

3. **Run test script**:
   ```bash
   node automations/test-constants-parse.js
   ```
   This should show what sections are being found and why some are missing.

### Recommended Fixes

1. **Improve table matching**: Use a more robust method to find tables (maybe by counting nested tags)

2. **Add validation**: Create a script that compares sitemap.xml with generated files to find all discrepancies

3. **Better error reporting**: When sections have 0 constants, log why (no table found, constants filtered, etc.)

## Testing

After fixes, verify:

- [ ] All 28 constant categories generated
- [ ] All classes from sitemap generated
- [ ] All libraries from sitemap generated
- [ ] No false positive constants in class/library files
- [ ] Constants use folder structure (not single file)
