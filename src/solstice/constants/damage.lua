-- NWN Damage related constants

solstice.DAMAGE_TYPE_BLUDGEONING  = 0x1
solstice.DAMAGE_TYPE_BLUDG_PIERCE = 0x3
solstice.DAMAGE_TYPE_PIERCING     = 0x2
solstice.DAMAGE_TYPE_SLASHING     = 0x4
solstice.DAMAGE_TYPE_PIERCE_SLASH = 0x6
solstice.DAMAGE_TYPE_MAGICAL      = 0x8
solstice.DAMAGE_TYPE_ACID         = 0x10
solstice.DAMAGE_TYPE_COLD         = 0x20
solstice.DAMAGE_TYPE_DIVINE       = 0x40
solstice.DAMAGE_TYPE_ELECTRICAL   = 0x80
solstice.DAMAGE_TYPE_FIRE         = 0x100
solstice.DAMAGE_TYPE_NEGATIVE     = 0x200
solstice.DAMAGE_TYPE_POSITIVE     = 0x400
solstice.DAMAGE_TYPE_SONIC        = 0x800
-- The base weapon damage is the base damage delivered by the weapon before
-- any additional types of damage (e.g. fire) have been added.
solstice.DAMAGE_TYPE_BASE_WEAPON  = 0x1000

-- The following are for testing damage flags, not doing damage.
solstice.DAMAGE_TYPE_PHYSICAL     = 0x1007
solstice.DAMAGE_TYPE_ELEMENT      = 0x9B0
solstice.DAMAGE_TYPE_ENERGY       = 0x648

-- Special versus flag just for AC effects
solstice.AC_VS_DAMAGE_TYPE_ALL    = 4103

solstice.DAMAGE_BONUS_1           = 1
solstice.DAMAGE_BONUS_2           = 2
solstice.DAMAGE_BONUS_3           = 3
solstice.DAMAGE_BONUS_4           = 4
solstice.DAMAGE_BONUS_5           = 5
solstice.DAMAGE_BONUS_1d4         = 6
solstice.DAMAGE_BONUS_1d6         = 7
solstice.DAMAGE_BONUS_1d8         = 8
solstice.DAMAGE_BONUS_1d10        = 9
solstice.DAMAGE_BONUS_2d6         = 10
solstice.DAMAGE_BONUS_2d8         = 11
solstice.DAMAGE_BONUS_2d4         = 12
solstice.DAMAGE_BONUS_2d10        = 13
solstice.DAMAGE_BONUS_1d12        = 14
solstice.DAMAGE_BONUS_2d12        = 15
solstice.DAMAGE_BONUS_6           = 16
solstice.DAMAGE_BONUS_7           = 17
solstice.DAMAGE_BONUS_8           = 18
solstice.DAMAGE_BONUS_9           = 19
solstice.DAMAGE_BONUS_10          = 20
solstice.DAMAGE_BONUS_11          = 21
solstice.DAMAGE_BONUS_12          = 22
solstice.DAMAGE_BONUS_13          = 23
solstice.DAMAGE_BONUS_14          = 24
solstice.DAMAGE_BONUS_15          = 25
solstice.DAMAGE_BONUS_16          = 26
solstice.DAMAGE_BONUS_17          = 27
solstice.DAMAGE_BONUS_18          = 28
solstice.DAMAGE_BONUS_19          = 29
solstice.DAMAGE_BONUS_20          = 30

solstice.DAMAGE_POWER_NORMAL         = 0
solstice.DAMAGE_POWER_PLUS_ONE       = 1
solstice.DAMAGE_POWER_PLUS_TWO       = 2
solstice.DAMAGE_POWER_PLUS_THREE     = 3
solstice.DAMAGE_POWER_PLUS_FOUR      = 4
solstice.DAMAGE_POWER_PLUS_FIVE      = 5
solstice.DAMAGE_POWER_ENERGY         = 6
solstice.DAMAGE_POWER_PLUS_SIX       = 7
solstice.DAMAGE_POWER_PLUS_SEVEN     = 8
solstice.DAMAGE_POWER_PLUS_EIGHT     = 9
solstice.DAMAGE_POWER_PLUS_NINE      = 10
solstice.DAMAGE_POWER_PLUS_TEN       = 11
solstice.DAMAGE_POWER_PLUS_ELEVEN    = 12
solstice.DAMAGE_POWER_PLUS_TWELVE    = 13
solstice.DAMAGE_POWER_PLUS_THIRTEEN  = 14
solstice.DAMAGE_POWER_PLUS_FOURTEEN  = 15
solstice.DAMAGE_POWER_PLUS_FIFTEEN   = 16
solstice.DAMAGE_POWER_PLUS_SIXTEEN   = 17
solstice.DAMAGE_POWER_PLUS_SEVENTEEN = 18
solstice.DAMAGE_POWER_PLUS_EIGHTEEN  = 19
solstice.DAMAGE_POWER_PLUS_NINTEEN   = 20
solstice.DAMAGE_POWER_PLUS_TWENTY    = 21