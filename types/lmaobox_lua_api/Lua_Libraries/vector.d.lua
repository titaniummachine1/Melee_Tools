---@meta

-- Lmaobox Lua API: vector - Lmaobox Lua
-- Auto-generated from: https://lmaobox.net/lua/Lua_Libraries/vector/
-- Path: Lua_Libraries/vector
-- Last updated: 2025-12-05T12:04:26.128Z

---@class vector
vector = {}

-- Add two vectors
---@param a Vector3
---@param b Vector3
---@return any
function vector.Add(a, b) end

-- Subtract two vectors
---@param a Vector3
---@param b Vector3
---@return any
function vector.Subtract(a, b) end

-- Multiply vector by scalar
---@param vec Vector3
---@param scalar number
---@return any
function vector.Multiply(vec, scalar) end

-- Divide vector by scalar
---@param vec Vector3
---@param scalar number
---@return any
function vector.Divide(vec, scalar) end

-- Get vector length
---@param vec Vector3
---@return number
function vector.Length(vec) end

-- Get vector squared length
---@param vec Vector3
---@return number
function vector.LengthSqr(vec) end

-- Get distance between two vectors
---@param a Vector3
---@param b Vector3
---@return any
function vector.Distance(a, b) end

-- Normalize vector
---@param vec Vector3
---@return any
function vector.Normalize(vec) end

-- Get vector angles
---@param angles EulerAngles
---@return Vector3
function vector.Angles(angles) end

-- Get forward vector angle
---@param angles EulerAngles
---@return any
function vector.AngleForward(angles) end

-- Get right vector angle
---@param angles EulerAngles
---@return any
function vector.AngleRight(angles) end

-- Get up vector angle
---@param angles EulerAngles
---@return any
function vector.AngleUp(angles) end

-- Get forward, right, and up vector angles as 3 return values
---@param angles EulerAngles
---@return Vector3, Vector3, Vector3
function vector.AngleVectors(angles) end

-- Normalize vector angles
---@param angles EulerAngles
---@return any
function vector.AngleNormalize(angles) end

