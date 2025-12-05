---@meta

-- Lmaobox Lua API - TF2 Specific Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml

-- ============================================================================
-- E_TFCOND - TF2 Condition flags
-- ============================================================================

---@type number
TFCond_Slowed = 0

---@type number
TFCond_Zoomed = 1

---@type number
TFCond_Disguising = 2

---@type number
TFCond_Disguised = 3

---@type number
TFCond_Cloaked = 4

---@type number
TFCond_Ubercharged = 5

---@type number
TFCond_TeleportedGlow = 6

---@type number
TFCond_Taunting = 7

---@type number
TFCond_UberchargeFading = 8

---@type number
TFCond_Unknown1 = 9

---@type number
TFCond_CloakFlicker = 9

---@type number
TFCond_Teleporting = 10

---@type number
TFCond_Kritzkrieged = 11

---@type number
TFCond_Unknown2 = 12

---@type number
TFCond_TmpDamageBonus = 12

---@type number
TFCond_DeadRingered = 13

---@type number
TFCond_Bonked = 14

---@type number
TFCond_Dazed = 15

---@type number
TFCond_Buffed = 16

---@type number
TFCond_Charging = 17

---@type number
TFCond_DemoBuff = 18

---@type number
TFCond_CritCola = 19

---@type number
TFCond_InHealRadius = 20

---@type number
TFCond_Healing = 21

---@type number
TFCond_OnFire = 22

---@type number
TFCond_Overhealed = 23

---@type number
TFCond_Jarated = 24

---@type number
TFCond_Bleeding = 25

---@type number
TFCond_DefenseBuffed = 26

---@type number
TFCond_Milked = 27

---@type number
TFCond_MegaHeal = 28

---@type number
TFCond_RegenBuffed = 29

---@type number
TFCond_MarkedForDeath = 30

---@type number
TFCond_NoHealingDamageBuff = 31

---@type number
TFCond_SpeedBuffAlly = 32

---@type number
TFCond_HalloweenCritCandy = 33

---@type number
TFCond_CritCanteen = 34

---@type number
TFCond_CritDemoCharge = 35

---@type number
TFCond_CritHype = 36

---@type number
TFCond_CritOnFirstBlood = 37

---@type number
TFCond_CritOnWin = 38

---@type number
TFCond_CritOnFlagCapture = 39

---@type number
TFCond_CritOnKill = 40

---@type number
TFCond_RestrictToMelee = 41

---@type number
TFCond_DefenseBuffNoCritBlock = 42

---@type number
TFCond_Reprogrammed = 43

---@type number
TFCond_CritMmmph = 44

---@type number
TFCond_DefenseBuffMmmph = 45

---@type number
TFCond_FocusBuff = 46

---@type number
TFCond_DisguiseRemoved = 47

---@type number
TFCond_MarkedForDeathSilent = 48

---@type number
TFCond_DisguisedAsDispenser = 49

---@type number
TFCond_Sapped = 50

---@type number
TFCond_UberchargedHidden = 51

---@type number
TFCond_UberchargedCanteen = 52

---@type number
TFCond_HalloweenBombHead = 53

---@type number
TFCond_HalloweenThriller = 54

---@type number
TFCond_RadiusHealOnDamage = 55

---@type number
TFCond_CritOnDamage = 56

---@type number
TFCond_UberchargedOnTakeDamage = 57

---@type number
TFCond_UberBulletResist = 58

---@type number
TFCond_UberBlastResist = 59

---@type number
TFCond_UberFireResist = 60

---@type number
TFCond_SmallBulletResist = 61

---@type number
TFCond_SmallBlastResist = 62

---@type number
TFCond_SmallFireResist = 63

---@type number
TFCond_Stealthed = 64

---@type number
TFCond_MedigunDebuff = 65

---@type number
TFCond_StealthedUserBuffFade = 66

---@type number
TFCond_BulletImmune = 67

---@type number
TFCond_BlastImmune = 68

---@type number
TFCond_FireImmune = 69

---@type number
TFCond_PreventDeath = 70

---@type number
TFCond_MVMBotRadiowave = 71

---@type number
TFCond_HalloweenSpeedBoost = 72

---@type number
TFCond_HalloweenQuickHeal = 73

---@type number
TFCond_HalloweenGiant = 74

---@type number
TFCond_HalloweenTiny = 75

---@type number
TFCond_HalloweenInHell = 76

---@type number
TFCond_HalloweenGhostMode = 77

---@type number
TFCond_MiniCritOnKill = 78

---@type number
TFCond_DodgeChance = 79

---@type number
TFCond_ObscuredSmoke = 79

---@type number
TFCond_Parachute = 80

---@type number
TFCond_BlastJumping = 81

---@type number
TFCond_HalloweenKart = 82

---@type number
TFCond_HalloweenKartDash = 83

---@type number
TFCond_BalloonHead = 84

---@type number
TFCond_MeleeOnly = 85

---@type number
TFCond_SwimmingCurse = 86

---@type number
TFCond_HalloweenKartNoTurn = 87

---@type number
TFCond_FreezeInput = 87

---@type number
TFCond_HalloweenKartCage = 88

---@type number
TFCond_HasRune = 89

---@type number
TFCond_RuneStrength = 90

---@type number
TFCond_RuneHaste = 91

---@type number
TFCond_RuneRegen = 92

---@type number
TFCond_RuneResist = 93

---@type number
TFCond_RuneVampire = 94

---@type number
TFCond_RuneWarlock = 95

---@type number
TFCond_RunePrecision = 96

---@type number
TFCond_RuneAgility = 97

---@type number
TFCond_GrapplingHook = 98

---@type number
TFCond_GrapplingHookSafeFall = 99

---@type number
TFCond_GrapplingHookLatched = 100

---@type number
TFCond_GrapplingHookBleeding = 101

---@type number
TFCond_AfterburnImmune = 102

---@type number
TFCond_RuneKnockout = 103

---@type number
TFCond_RuneImbalance = 104

---@type number
TFCond_CritRuneTemp = 105

---@type number
TFCond_PasstimeInterception = 106

---@type number
TFCond_SwimmingNoEffects = 107

---@type number
TFCond_EyeaductUnderworld = 108

---@type number
TFCond_KingRune = 109

---@type number
TFCond_PlagueRune = 110

---@type number
TFCond_SupernovaRune = 111

---@type number
TFCond_Plague = 112

---@type number
TFCond_KingAura = 113

---@type number
TFCond_SpawnOutline = 114

---@type number
TFCond_KnockedIntoAir = 115

---@type number
TFCond_CompetitiveWinner = 116

---@type number
TFCond_CompetitiveLoser = 117

---@type number
TFCond_NoTaunting_DEPRECATED = 118

---@type number
TFCond_HealingDebuff = 118

---@type number
TFCond_PasstimePenaltyDebuff = 119

---@type number
TFCond_GrappledToPlayer = 120

---@type number
TFCond_GrappledByPlayer = 121

---@type number
TFCond_ParachuteDeployed = 122

---@type number
TFCond_Gas = 123

---@type number
TFCond_BurningPyro = 124

---@type number
TFCond_RocketPack = 125

---@type number
TFCond_LostFooting = 126

---@type number
TFCond_AirCurrent = 127
