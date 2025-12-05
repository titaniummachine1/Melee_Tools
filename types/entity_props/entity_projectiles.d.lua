---@meta

-- Projectile Entity Properties
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

---@class CTFBaseRocket : Entity
---@field m_vInitialVelocity Vector3
---@field m_vecOrigin Vector3
---@field m_angRotation Vector3
---@field m_iDeflected number
---@field m_hLauncher number

---@class CTFProjectile_Rocket : CTFBaseRocket
---@field m_bCritical number

---@class CTFWeaponBaseGrenadeProj : Entity
---@field m_vInitialVelocity Vector3
---@field m_bCritical number
---@field m_iDeflected number
---@field m_vecOrigin Vector3
---@field m_angRotation Vector3
---@field m_hDeflectOwner number

---@class CTFProjectile_Pipebomb : Entity
---@field m_bTouched number
---@field m_iType number
---@field m_hLauncher number
---@field m_bDefensiveBomb number

---@class CTFProjectile_Flare : Entity
---@field m_bCritical number

---@class CTFProjectile_Arrow : Entity
---@field m_bArrowAlight number
---@field m_bCritical number
---@field m_iProjectileType number

---@class CTFProjectile_EnergyBall : Entity
---@field m_bChargedShot number
---@field m_vColor1 Vector3
---@field m_vColor2 Vector3

---@class CTFProjectile_BallOfFire : Entity
---@field m_vecInitialVelocity Vector3
---@field m_vecSpawnOrigin Vector3

---@class CTFBaseProjectile : Entity
---@field m_vInitialVelocity Vector3
---@field m_hLauncher number

---@class CGrapplingHook : Entity
---@field m_hProjectile number
