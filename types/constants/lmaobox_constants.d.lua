---@meta

-- Lmaobox Lua API Constants
-- Auto-updating to latest Lua 5.4.x syntax
-- API Documentation: http://lmaobox.net/lua/sitemap.xml
-- Organized by category for easy maintenance

-- ============================================================================
-- E_UserCmd - Input bit fields
-- ============================================================================

---@type number
IN_ATTACK = 1 << 0

---@type number
IN_JUMP = 1 << 1

---@type number
IN_DUCK = 1 << 2

---@type number
IN_FORWARD = 1 << 3

---@type number
IN_BACK = 1 << 4

---@type number
IN_USE = 1 << 5

---@type number
IN_CANCEL = 1 << 6

---@type number
IN_LEFT = 1 << 7

---@type number
IN_RIGHT = 1 << 8

---@type number
IN_MOVELEFT = 1 << 9

---@type number
IN_MOVERIGHT = 1 << 10

---@type number
IN_ATTACK2 = 1 << 11

---@type number
IN_RUN = 1 << 12

---@type number
IN_RELOAD = 1 << 13

---@type number
IN_ALT1 = 1 << 14

---@type number
IN_ALT2 = 1 << 15

---@type number
IN_SCORE = 1 << 16

---@type number
IN_SPEED = 1 << 17

---@type number
IN_WALK = 1 << 18

---@type number
IN_ZOOM = 1 << 19

---@type number
IN_WEAPON1 = 1 << 20

---@type number
IN_WEAPON2 = 1 << 21

---@type number
IN_BULLRUSH = 1 << 22

---@type number
IN_GRENADE2 = 1 << 24

---@type number
IN_ATTACK3 = 1 << 25

-- ============================================================================
-- E_ButtonCode - Key and mouse button codes
-- ============================================================================

---@type number
BUTTON_CODE_INVALID = -1

---@type number
BUTTON_CODE_NONE = 0

---@type number
KEY_FIRST = 0

---@type number
KEY_NONE = KEY_FIRST

---@type number
KEY_0 = 1

---@type number
KEY_1 = 2

---@type number
KEY_2 = 3

---@type number
KEY_3 = 4

---@type number
KEY_4 = 5

---@type number
KEY_5 = 6

---@type number
KEY_6 = 7

---@type number
KEY_7 = 8

---@type number
KEY_8 = 9

---@type number
KEY_9 = 10

---@type number
KEY_A = 11

---@type number
KEY_B = 12

---@type number
KEY_C = 13

---@type number
KEY_D = 14

---@type number
KEY_E = 15

---@type number
KEY_F = 16

---@type number
KEY_G = 17

---@type number
KEY_H = 18

---@type number
KEY_I = 19

---@type number
KEY_J = 20

---@type number
KEY_K = 21

---@type number
KEY_L = 22

---@type number
KEY_M = 23

---@type number
KEY_N = 24

---@type number
KEY_O = 25

---@type number
KEY_P = 26

---@type number
KEY_Q = 27

---@type number
KEY_R = 28

---@type number
KEY_S = 29

---@type number
KEY_T = 30

---@type number
KEY_U = 31

---@type number
KEY_V = 32

---@type number
KEY_W = 33

---@type number
KEY_X = 34

---@type number
KEY_Y = 35

---@type number
KEY_Z = 36

---@type number
KEY_PAD_0 = 37

---@type number
KEY_PAD_1 = 38

---@type number
KEY_PAD_2 = 39

---@type number
KEY_PAD_3 = 40

---@type number
KEY_PAD_4 = 41

---@type number
KEY_PAD_5 = 42

---@type number
KEY_PAD_6 = 43

---@type number
KEY_PAD_7 = 44

---@type number
KEY_PAD_8 = 45

---@type number
KEY_PAD_9 = 46

---@type number
KEY_PAD_DIVIDE = 47

---@type number
KEY_PAD_MULTIPLY = 48

---@type number
KEY_PAD_MINUS = 49

---@type number
KEY_PAD_PLUS = 50

---@type number
KEY_PAD_ENTER = 51

---@type number
KEY_PAD_DECIMAL = 52

---@type number
KEY_LBRACKET = 53

---@type number
KEY_RBRACKET = 54

---@type number
KEY_SEMICOLON = 55

---@type number
KEY_APOSTROPHE = 56

---@type number
KEY_BACKQUOTE = 57

---@type number
KEY_COMMA = 58

---@type number
KEY_PERIOD = 59

---@type number
KEY_SLASH = 60

---@type number
KEY_BACKSLASH = 61

---@type number
KEY_MINUS = 62

---@type number
KEY_EQUAL = 63

---@type number
KEY_ENTER = 64

---@type number
KEY_SPACE = 65

---@type number
KEY_BACKSPACE = 66

---@type number
KEY_TAB = 67

---@type number
KEY_CAPSLOCK = 68

---@type number
KEY_NUMLOCK = 69

---@type number
KEY_ESCAPE = 70

---@type number
KEY_SCROLLLOCK = 71

---@type number
KEY_INSERT = 72

---@type number
KEY_DELETE = 73

---@type number
KEY_HOME = 74

---@type number
KEY_END = 75

---@type number
KEY_PAGEUP = 76

---@type number
KEY_PAGEDOWN = 77

---@type number
KEY_BREAK = 78

---@type number
KEY_LSHIFT = 79

---@type number
KEY_RSHIFT = 80

---@type number
KEY_LALT = 81

---@type number
KEY_RALT = 82

---@type number
KEY_LCONTROL = 83

---@type number
KEY_RCONTROL = 84

---@type number
KEY_LWIN = 85

---@type number
KEY_RWIN = 86

---@type number
KEY_APP = 87

---@type number
KEY_UP = 88

---@type number
KEY_LEFT = 89

---@type number
KEY_DOWN = 90

---@type number
KEY_RIGHT = 91

---@type number
KEY_F1 = 92

---@type number
KEY_F2 = 93

---@type number
KEY_F3 = 94

---@type number
KEY_F4 = 95

---@type number
KEY_F5 = 96

---@type number
KEY_F6 = 97

---@type number
KEY_F7 = 98

---@type number
KEY_F8 = 99

---@type number
KEY_F9 = 100

---@type number
KEY_F10 = 101

---@type number
KEY_F11 = 102

---@type number
KEY_F12 = 103

---@type number
KEY_CAPSLOCKTOGGLE = 104

---@type number
KEY_NUMLOCKTOGGLE = 105

---@type number
KEY_SCROLLLOCKTOGGLE = 106

---@type number
KEY_LAST = KEY_SCROLLLOCKTOGGLE

---@type number
KEY_COUNT = KEY_LAST - KEY_FIRST + 1

---@type number
MOUSE_FIRST = KEY_LAST + 1

---@type number
MOUSE_LEFT = MOUSE_FIRST

---@type number
MOUSE_RIGHT = MOUSE_FIRST + 1

---@type number
MOUSE_MIDDLE = MOUSE_FIRST + 2

---@type number
MOUSE_4 = MOUSE_FIRST + 3

---@type number
MOUSE_5 = MOUSE_FIRST + 4

---@type number
MOUSE_WHEEL_UP = MOUSE_FIRST + 5

---@type number
MOUSE_WHEEL_DOWN = MOUSE_FIRST + 6

-- ============================================================================
-- E_LifeState - Player life states
-- ============================================================================

---@type number
LIFE_ALIVE = 0

---@type number
LIFE_DYING = 1

---@type number
LIFE_DEAD = 2

---@type number
LIFE_RESPAWNABLE = 3

---@type number
LIFE_DISCARDAIM_BODY = 4

-- ============================================================================
-- E_TeamNumber - Team numbers
-- ============================================================================

---@type number
TEAM_UNASSIGNED = 0

---@type number
TEAM_SPECTATOR = 1

---@type number
TEAM_BLU = 2

---@type number
TEAM_RED = 3

-- ============================================================================
-- E_Character - TF2 Character classes
-- ============================================================================

---@type number
TF2_Scout = 1

---@type number
TF2_Soldier = 3

---@type number
TF2_Pyro = 7

---@type number
TF2_Demoman = 4

---@type number
TF2_Heavy = 6

---@type number
TF2_Engineer = 9

---@type number
TF2_Medic = 5

---@type number
TF2_Sniper = 2

---@type number
TF2_Spy = 8
