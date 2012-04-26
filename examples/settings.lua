-- The following file is a set of example settings

local settings = {
   -- If set to false all CEP specific variables, baseitems, etc
   -- will be ignored.  If set to a CEP version number without dots (e,g 2.3 -> 23)
   -- CEP resources will be available.
   NS_OPT_USING_CEP = 23,

   -- Number of damage types
   NS_OPT_NUM_DAMAGES = 12,

   -- This is the max number of damage bonuses or penalties in any one
   -- combat round.
   NS_OPT_MAX_DMG_ROLL_MODS = 100,

   -- If set to true only one damage visual effect will be applied to a
   -- target, rather than all applicable.
   NS_OPT_ONE_COMBAT_VFX = true,

   -- If set to true, 0 damage will not float above the target.
   NS_OPT_NO_FLOAT_ZERO_DAMAGE = false,

   -- If set to true, damage results will not float above the target.
   -- If true it will override NS_OPT_NO_FLOAT_ZERO_DAMAGE.
   -- When the data is broadcast you could also allow individual players
   -- to choose their own preference.
   NS_OPT_NO_FLOAT_DAMAGE = false,

   -- Number of situational atatcks.
   NS_OPT_NUM_SITUATIONS = 3,

   -- PC's are die when Hitpoints are below this level.
   NS_OPT_HP_LIMIT = -10,

   -- If true Death Attack will not respect immunity to critical hits.
   NS_OPT_DEATHATT_IGNORE_CRIT_IMM = false,

   -- If true Sneak Attack will not respect immunity to critical hits.
   NS_OPT_SNEAKATT_IGNORE_CRIT_IMM = false,

   -- If true Devistating Critical insta-kill is disabled for all
   -- creatures
   NS_OPT_DEVCRIT_DISABLE_ALL = false,

   -- If true Devistating Critical insta-kill is disabled for PCs
   -- only.  If the NS_OPT_DEVCRIT_DISABLE_ALL is true this setting
   -- will be overriden.
   NS_OPT_DEVCRIT_DISABLE_PC = false
}

return settings