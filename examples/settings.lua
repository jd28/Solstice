-- The following file is a set of example settings

----------------------------------------------------------------------
-- Module Settings

-- If set to false all CEP specific variables, baseitems, etc
-- will be ignored.  If set to a CEP version number without dots (e,g 2.3 -> 23)
-- CEP resources will be available.
NS_OPT_USING_CEP = 23

-- Number of damage types
NS_OPT_NUM_DAMAGES = 13

------------------------------------------------------------------------------------------
-- Effect settings

-- Maximum number of effects to consider when calculating bonuses/penalties
NS_OPT_MAX_EFFECT_MODS = 20

-- Use Versus info
NS_OPT_USE_VERSUS_INFO = true

------------------------------------------------------------------------------------------
-- Combat Settings

-- This is the max number of damage bonuses or penalties in any one
-- combat round.
NS_OPT_MAX_DMG_ROLL_MODS = 100

-- If set to true only one damage visual effect will be applied to a
-- target, rather than all applicable.
NS_OPT_ONE_COMBAT_VFX = true

-- If set to true 0 damage will not float above the target.
NS_OPT_NO_FLOAT_ZERO_DAMAGE = false

-- If set to true, damage results will not float above the target.
-- If true it will override NS_OPT_NO_FLOAT_ZERO_DAMAGE.
-- When the data is broadcast you could also allow individual players
-- to choose their own preference.
NS_OPT_NO_FLOAT_DAMAGE = false

-- If true no feedback from damage reduction, resistance, and immunity
-- will be printed in the combat log.
NS_OPT_NO_DAMAGE_REDUCTION_FEEDBACK = true

-- Number of situational atatcks.
NS_OPT_NUM_SITUATIONS = 3

-- PCs are dead when their hitpoints are below this level.
NS_OPT_HP_LIMIT = -10

-- Maximum level that a creature can be Coup de Grace'd
NS_OPT_COUPDEGRACE_MAX_LEVEL = 5

-- If true Death Attack will not respect immunity to critical hits.
NS_OPT_DEATHATT_IGNORE_CRIT_IMM = false

-- If true Sneak Attack will not respect immunity to critical hits.
NS_OPT_SNEAKATT_IGNORE_CRIT_IMM = false

-- If true Devistating Critical insta-kill is disabled for all
-- creatures
NS_OPT_DEVCRIT_DISABLE_ALL = true

-- If true Devistating Critical insta-kill is disabled for PCs
-- only.  If the NS_OPT_DEVCRIT_DISABLE_ALL is true this setting
-- will be overriden.
NS_OPT_DEVCRIT_DISABLE_PC = false
