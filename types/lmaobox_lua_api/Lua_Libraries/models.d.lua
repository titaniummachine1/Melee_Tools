---@meta

-- Lmaobox Lua API: models - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/models/
-- Path: Lua_Libraries/models
-- Last updated: 2025-12-05T11:44:38.916Z

---@class models
models = {}

-- Returns a Model object by model index.
---@param modelIndex number
---@return any
function models.GetModel(modelIndex) end

-- Returns a model index as an integer by a given model name.
---@param modelName string
---@return number
function models.GetModelIndex(modelName) end

-- Returns a StudioModelHeader object by model.
---@param model any
---@return any
function models.GetStudioModel(model) end

-- Returns a model name by string.
---@param model any
---@return string
function models.GetModelName(model) end

-- Returns a table of Material objects by model.
---@param model any
---@return any
function models.GetModelMaterials(model) end

-- Returns two Vector3 objects, mins and maxs, by model string, representing render bounds.
---@param model any
---@return string
function models.GetModelRenderBounds(model) end

-- Returns two Vector3 objects, mins and maxs, by model string representing model space bounds.
---@param model any
---@return string
function models.GetModelBounds(model) end

