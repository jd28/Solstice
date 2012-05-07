-- The following file is a set of example settings

----------------------------------------------------------------------
-- Module Settings

-- If set to false all CEP specific variables, baseitems, etc
-- will be ignored.  If set to a CEP version number without dots (e,g 2.3 -> 23)
-- CEP resources will be available.
NS_OPT_USING_CEP = 23

-- Number of damage types
NS_OPT_NUM_DAMAGES = 12

------------------------------------------------------------------------------------------
-- Effect settings
-- If true attack bonus from effects/gear stack.
NS_OPT_EFFECT_AB_STACK       = true

-- If true multiple attack bonus of the same type on the same item will stack.
NS_OPT_EFFECT_AB_STACK_GEAR  = false

-- If true multiple attack bonus of the same type applied from the same spell.
NS_OPT_EFFECT_AB_STACK_SPELL = false


-- If true abilities from effects/gear stack.
NS_OPT_EFFECT_ABILITY_STACK       = true

-- If true multiple abilities of the same type on the same item will stack.
NS_OPT_EFFECT_ABILITY_STACK_GEAR  = false

-- If true multiple abilities of the same type applied from the same spell.
NS_OPT_EFFECT_ABILITY_STACK_SPELL = false

-- If true saves from effects/gear stack.
NS_OPT_EFFECT_SAVE_STACK       = true

-- If true multiple saves of the same type on the same item will stack.
NS_OPT_EFFECT_SAVE_STACK_GEAR  = false

-- If true multiple saves of the same type applied from the same spell.
NS_OPT_EFFECT_SAVE_STACK_SPELL = false

-- If true skills from effects/gear stack.
NS_OPT_EFFECT_SKILL_STACK       = true

-- If true multiple skills of the same type on the same item will stack.
NS_OPT_EFFECT_SKILL_STACK_GEAR  = false

-- If true multiple skills of the same type applied from the same spell.
NS_OPT_EFFECT_SKILL_STACK_SPELL = false

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
NS_OPT_DEVCRIT_DISABLE_ALL = false

-- If true Devistating Critical insta-kill is disabled for PCs
-- only.  If the NS_OPT_DEVCRIT_DISABLE_ALL is true this setting
-- will be overriden.
NS_OPT_DEVCRIT_DISABLE_PC = false
