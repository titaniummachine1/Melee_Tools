---@meta

-- Weapon Entity Properties
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

---@class CTFWeaponBase : Entity
---@field m_bLowered number
---@field m_iReloadMode number
---@field m_bResetParity number
---@field m_bReloadedThroughAnimEvent number
---@field m_bDisguiseWeapon number
---@field LocalActiveTFWeaponData LocalActiveTFWeaponData
---@field NonLocalTFWeaponData table
---@field m_flEnergy number
---@field m_hExtraWearable number
---@field m_hExtraWearableViewModel number
---@field m_bBeingRepurposedForTaunt number
---@field m_nKillComboClass number
---@field m_nKillComboCount number
---@field m_flInspectAnimEndTime number
---@field m_nInspectStage number
---@field m_iConsecutiveShots number

---@class LocalActiveTFWeaponData
---@field m_flLastCritCheckTime number
---@field m_flReloadPriorNextFire number
---@field m_flLastFireTime number
---@field m_flEffectBarRegenTime number
---@field m_flObservedCritChance number

---@class CTFSniperRifle : CTFWeaponBase
---@field SniperRifleLocalData SniperRifleLocalData

---@class SniperRifleLocalData
---@field m_flChargedDamage number

---@class CTFSniperRifleClassic : CTFWeaponBase
---@field m_bCharging number

---@class CSniperDot : Entity
---@field m_flChargeStartTime number

---@class CWeaponMedigun : CTFWeaponBase
---@field m_hHealingTarget number
---@field m_bHealing number
---@field m_bAttacking number
---@field m_bChargeRelease number
---@field m_bHolstered number
---@field m_nChargeResistType number
---@field m_hLastHealingTarget number
---@field LocalTFWeaponMedigunData LocalTFWeaponMedigunData
---@field NonLocalTFWeaponMedigunData NonLocalTFWeaponMedigunData

---@class LocalTFWeaponMedigunData
---@field m_flChargeLevel number

---@class NonLocalTFWeaponMedigunData
---@field m_flChargeLevel number

---@class CTFWeaponKnife : CTFWeaponBase
---@field m_bReadyToBackstab number
---@field m_bKnifeExists number
---@field m_flKnifeRegenerateDuration number
---@field m_flKnifeMeltTimestamp number

---@class CWeaponMinigun : CTFWeaponBase
---@field m_iWeaponState number
---@field m_bCritShot number

---@class CWeaponFlameThrower : CTFWeaponBase
---@field m_iWeaponState number
---@field m_bCritFire number
---@field m_bHitTarget number
---@field m_flChargeBeginTime number
---@field LocalFlameThrowerData LocalFlameThrowerData

---@class LocalFlameThrowerData
---@field m_iActiveFlames number
---@field m_iDamagingFlames number
---@field m_hFlameManager number
---@field m_bHasHalloweenSpell number

---@class CWeaponGrenadeLauncher : CTFWeaponBase
---@field m_flDetonateTime number
---@field m_iCurrentTube number
---@field m_iGoalTube number

---@class CWeaponPipebombLauncher : CTFWeaponBase
---@field PipebombLauncherLocalData PipebombLauncherLocalData

---@class PipebombLauncherLocalData
---@field m_iPipebombCount number
---@field m_flChargeBeginTime number

---@class CWeaponChargedSMG : CTFWeaponBase
---@field m_flMinicritCharge number

---@class CTFWeaponSlap : CTFWeaponBase
---@field m_bFirstHit number
---@field m_nNumKills number

---@class CTFWeaponRocketPack : CTFWeaponBase
---@field m_flInitLaunchTime number
---@field m_flLaunchTime number
---@field m_flToggleEndTime number
---@field m_bEnabled number

---@class CCrossbow : CTFWeaponBase
---@field m_flRegenerateDuration number
---@field m_flLastUsedTimestamp number

---@class CWeaponRaygun : CTFWeaponBase
---@field m_bUseNewProjectileCode number

---@class CParticleCannon : CTFWeaponBase
---@field m_flChargeBeginTime number
---@field m_iChargeEffect number

---@class CTFWeaponThrowable : CTFWeaponBase
---@field m_flChargeBeginTime number

---@class CTFWeaponKatana : CTFWeaponBase
---@field m_bIsBloody number

---@class CTFWeaponStickBomb : CTFWeaponBase
---@field m_iDetonated number

---@class CTFWeaponBreakableMelee : CTFWeaponBase
---@field m_bBroken number

---@class CTFWeaponSapper : CTFWeaponBase
---@field m_flChargeBeginTime number

---@class CTFWeaponBuilder : CTFWeaponBase
---@field m_iBuildState number
---@field BuilderLocalData BuilderLocalData
---@field m_iObjectMode number
---@field m_flWheatleyTalkingUntil number

---@class BuilderLocalData
---@field m_iObjectType number
---@field m_hObjectBeingBuilt number
---@field m_aBuildableObjectTypes table

---@class CWeaponLunchBox : CTFWeaponBase
---@field m_bBroken number

---@class CTFWeaponSpellBook : CTFWeaponBase
---@field m_iSelectedSpellIndex number
---@field m_iSpellCharges number
---@field m_flTimeNextSpell number
---@field m_bFiredAttack number

---@class CTFWeaponRobotArm : CTFWeaponBase
---@field m_hRobotArm number

---@class CTFWeaponCompoundBow : CTFWeaponBase
---@field m_bArrowAlight number
---@field m_bNoFire number

---@class CWeaponFlareGun : CTFWeaponBase
---@field m_flChargeBeginTime number

---@class CWeaponFlareGun_Revenge : CTFWeaponBase
---@field m_fLastExtinguishTime number

---@class CWeaponFlameBall : CTFWeaponBase
---@field m_flRechargeScale number

---@class CTFDroppedWeapon : Entity
---@field m_Item Item
---@field m_flChargeLevel number

---@class CTFWearableLevelableItem : Entity
---@field m_unLevel number

---@class CTFWearableCampaignItem : Entity
---@field m_nState number
