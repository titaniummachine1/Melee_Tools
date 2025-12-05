# Simulation / Adaptive Menu

- Menu module: `Simulation/adaptive_menu.lua` (TimMenu). Registers a Draw callback and reads `G.Menu.Melee`.
- Class detection: `Simulation/class_state.lua` (auto spy/demoknight via local player + shield).
- Shared accessors: `Simulation/menu_config.lua`, `Simulation/prototype_hooks.lua`.
- Defaults live in `src/Utils/DefaultConfig.lua` under the `Melee` table. Loading/saving uses existing `Utils/Config.lua`.
- Intended consumers: trickstab (Spy) and demoknight prediction; add options in `DefaultConfig.Melee.*` and surface them in `adaptive_menu.lua`.
