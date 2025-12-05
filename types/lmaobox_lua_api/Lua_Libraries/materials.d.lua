---@meta

-- Lmaobox Lua API: materials - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/materials/
-- Path: Lua_Libraries/materials
-- Last updated: 2025-12-05T11:00:38.501Z

---@class materials
materials = {}

-- Find a material by name
---@return any
function materials.Functions() end

---@return any
function materials.Examples() end

-- Find a material by name
---@param name string
---@return any
function materials.Find(name) end

-- Enumerate all loaded materials and call the callback function for each one. The only argument in the callback is the Material object.
---@return any
function materials.Enumerate() end

-- Create custom material following the Valve Material Type syntax. VMT should be a string containing the full material definition. Name should be an unique name of the material.
---@param name string
---@param vmt string
---@return any
function materials.Create(name, vmt) end

-- Create a texture render target. Name should be an unique name of the material. Width and height are the dimensions of the texture. Returns a Texture object.
---@param name string
---@param width number
---@param height number
---@return string
function materials.CreateTextureRenderTarget(name, width, height) end

-- Fetches a texture by name. If the texture is not found, it will be created. If complain is true, it will print an error message if the texture is not found. Returns a Texture object.
---@param name string
---@param groupName string
---@param complain boolean
---@return string
function materials.FindTexture(name, groupName, complain) end

