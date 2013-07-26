local M = {}

-- NWN Damage related constants

M.BLUDGEONING  = 0x1
M.BLUDG_PIERCE = 0x3
M.PIERCING     = 0x2
M.SLASHING     = 0x4
M.PIERCE_SLASH = 0x6
M.MAGICAL      = 0x8
M.ACID         = 0x10
M.COLD         = 0x20
M.DIVINE       = 0x40
M.ELECTRICAL   = 0x80
M.FIRE         = 0x100
M.NEGATIVE     = 0x200
M.POSITIVE     = 0x400
M.SONIC        = 0x800
-- The base weapon damage is the base damage delivered by the weapon before
-- any additional types of damage (e.g. fire) have been added.
M.BASE_WEAPON  = 0x1000

-- The following are for testing damage flags, not doing damage.
M.PHYSICAL     = 0x1007
M.ELEMENT      = 0x9B0
M.ENERGY       = 0x648

-- Special versus flag just for AC effects
M.ALL    = 4103

M.BONUS_1           = 1
M.BONUS_2           = 2
M.BONUS_3           = 3
M.BONUS_4           = 4
M.BONUS_5           = 5
M.BONUS_1d4         = 6
M.BONUS_1d6         = 7
M.BONUS_1d8         = 8
M.BONUS_1d10        = 9
M.BONUS_2d6         = 10
M.BONUS_2d8         = 11
M.BONUS_2d4         = 12
M.BONUS_2d10        = 13
M.BONUS_1d12        = 14
M.BONUS_2d12        = 15
M.BONUS_6           = 16
M.BONUS_7           = 17
M.BONUS_8           = 18
M.BONUS_9           = 19
M.BONUS_10          = 20
M.BONUS_11          = 21
M.BONUS_12          = 22
M.BONUS_13          = 23
M.BONUS_14          = 24
M.BONUS_15          = 25
M.BONUS_16          = 26
M.BONUS_17          = 27
M.BONUS_18          = 28
M.BONUS_19          = 29
M.BONUS_20          = 30

M.POWER_NORMAL         = 0
M.POWER_PLUS_ONE       = 1
M.POWER_PLUS_TWO       = 2
M.POWER_PLUS_THREE     = 3
M.POWER_PLUS_FOUR      = 4
M.POWER_PLUS_FIVE      = 5
M.POWER_ENERGY         = 6
M.POWER_PLUS_SIX       = 7
M.POWER_PLUS_SEVEN     = 8
M.POWER_PLUS_EIGHT     = 9
M.POWER_PLUS_NINE      = 10
M.POWER_PLUS_TEN       = 11
M.POWER_PLUS_ELEVEN    = 12
M.POWER_PLUS_TWELVE    = 13
M.POWER_PLUS_THIRTEEN  = 14
M.POWER_PLUS_FOURTEEN  = 15
M.POWER_PLUS_FIFTEEN   = 16
M.POWER_PLUS_SIXTEEN   = 17
M.POWER_PLUS_SEVENTEEN = 18
M.POWER_PLUS_EIGHTEEN  = 19
M.POWER_PLUS_NINTEEN   = 20
M.POWER_PLUS_TWENTY    = 21

return M