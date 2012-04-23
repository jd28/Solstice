-- NWN Damage related constants

nwn.DAMAGE_TYPE_BLUDGEONING  = 0x1
nwn.DAMAGE_TYPE_PIERCING     = 0x2
nwn.DAMAGE_TYPE_SLASHING     = 0x4
nwn.DAMAGE_TYPE_PIERCE_SLASH = 0x6
nwn.DAMAGE_TYPE_MAGICAL      = 0x8
nwn.DAMAGE_TYPE_ACID         = 0x10
nwn.DAMAGE_TYPE_COLD         = 0x20
nwn.DAMAGE_TYPE_DIVINE       = 0x40
nwn.DAMAGE_TYPE_ELECTRICAL   = 0x80
nwn.DAMAGE_TYPE_FIRE         = 0x100
nwn.DAMAGE_TYPE_NEGATIVE     = 0x200
nwn.DAMAGE_TYPE_POSITIVE     = 0x400
nwn.DAMAGE_TYPE_SONIC        = 0x800
-- The base weapon damage is the base damage delivered by the weapon before
-- any additional types of damage (e.g. fire) have been added.
nwn.DAMAGE_TYPE_BASE_WEAPON  = 0x1000

-- The following are for testing damage flags, not doing damage.
nwn.DAMAGE_TYPE_PHYSICAL     = 0x1007
nwn.DAMAGE_TYPE_ELEMENT      = 0x9B0
nwn.DAMAGE_TYPE_ENERGY       = 0x648

-- Special versus flag just for AC effects
nwn.AC_VS_DAMAGE_TYPE_ALL    = 4103

nwn.DAMAGE_BONUS_1           = 1
nwn.DAMAGE_BONUS_2           = 2
nwn.DAMAGE_BONUS_3           = 3
nwn.DAMAGE_BONUS_4           = 4
nwn.DAMAGE_BONUS_5           = 5
nwn.DAMAGE_BONUS_1d4         = 6
nwn.DAMAGE_BONUS_1d6         = 7
nwn.DAMAGE_BONUS_1d8         = 8
nwn.DAMAGE_BONUS_1d10        = 9
nwn.DAMAGE_BONUS_2d6         = 10
nwn.DAMAGE_BONUS_2d8         = 11
nwn.DAMAGE_BONUS_2d4         = 12
nwn.DAMAGE_BONUS_2d10        = 13
nwn.DAMAGE_BONUS_1d12        = 14
nwn.DAMAGE_BONUS_2d12        = 15
nwn.DAMAGE_BONUS_6           = 16
nwn.DAMAGE_BONUS_7           = 17
nwn.DAMAGE_BONUS_8           = 18
nwn.DAMAGE_BONUS_9           = 19
nwn.DAMAGE_BONUS_10          = 20
nwn.DAMAGE_BONUS_11          = 21
nwn.DAMAGE_BONUS_12          = 22
nwn.DAMAGE_BONUS_13          = 23
nwn.DAMAGE_BONUS_14          = 24
nwn.DAMAGE_BONUS_15          = 25
nwn.DAMAGE_BONUS_16          = 26
nwn.DAMAGE_BONUS_17          = 27
nwn.DAMAGE_BONUS_18          = 28
nwn.DAMAGE_BONUS_19          = 29
nwn.DAMAGE_BONUS_20          = 30

nwn.DAMAGE_POWER_NORMAL         = 0
nwn.DAMAGE_POWER_PLUS_ONE       = 1
nwn.DAMAGE_POWER_PLUS_TWO       = 2
nwn.DAMAGE_POWER_PLUS_THREE     = 3
nwn.DAMAGE_POWER_PLUS_FOUR      = 4
nwn.DAMAGE_POWER_PLUS_FIVE      = 5
nwn.DAMAGE_POWER_ENERGY         = 6
nwn.DAMAGE_POWER_PLUS_SIX       = 7
nwn.DAMAGE_POWER_PLUS_SEVEN     = 8
nwn.DAMAGE_POWER_PLUS_EIGHT     = 9
nwn.DAMAGE_POWER_PLUS_NINE      = 10
nwn.DAMAGE_POWER_PLUS_TEN       = 11
nwn.DAMAGE_POWER_PLUS_ELEVEN    = 12
nwn.DAMAGE_POWER_PLUS_TWELVE    = 13
nwn.DAMAGE_POWER_PLUS_THIRTEEN  = 14
nwn.DAMAGE_POWER_PLUS_FOURTEEN  = 15
nwn.DAMAGE_POWER_PLUS_FIFTEEN   = 16
nwn.DAMAGE_POWER_PLUS_SIXTEEN   = 17
nwn.DAMAGE_POWER_PLUS_SEVENTEEN = 18
nwn.DAMAGE_POWER_PLUS_EIGHTEEN  = 19
nwn.DAMAGE_POWER_PLUS_NINTEEN   = 20
nwn.DAMAGE_POWER_PLUS_TWENTY    = 21