----------------------------------------------------------
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module itemprop


local M = require 'solstice.itemprop.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Eff = require 'solstice.effect'

M.const = require 'solstice.itemprop.constant'
setmetatable(M, { __index = M.const })

M.Itemprop = inheritsFrom(Eff.Effect, "solstice.itemprop.Itemprop")

--- Internal ctype
M.itemprop_t = ffi.metatype("Itemprop", { __index = M.Itemprop })

--- Class Itemprop
-- @section sol_itemprop_Itemprop
-- @see sol_effect_Effect

--- Convert itemprop effect to formatted string.
-- Override Effect:ToString
function M.Itemprop:ToString()
   local fmt = "Item Property: Type: %d, SubType: %d, Cost Table: %d, Cost Table Value: %d, Param1: %d, Param1 Value: %d"

   return string.format(fmt,
			self:GetPropertyType(),
			self:GetPropertySubType(),
			self:GetCostTable(),
			self:GetCostTableValue(),
			self:GetParam1(),
			self:GetParam1Value())
end

--- Returns the cost table number of the itemproperty.
-- See the 2DA files for value definitions.
function M.Itemprop:GetCostTable()
   return self:GetInt(2)
end

--- Returns the cost table value of an itemproperty.
-- See the 2DA files for value definitions.
function M.Itemprop:GetCostTableValue()
   return self:GetInt(3)
end

--- Returns the Param1 number of the item property.
function M.Itemprop:GetParam1()
   return self:GetInt(4)
end

--- Returns the Param1 value of the item property.
function M.Itemprop:GetParam1Value()
   return self:GetInt(5)
end

--- Returns the subtype of the itemproperty
function M.Itemprop:GetPropertySubType()
   return self:GetInt(1)
end

--- Returns the subtype of the itemproperty
function M.Itemprop:GetPropertyType()
   return self:GetInt(0)
end

-- Sets the item property effect values directly.
function M.Itemprop:SetValues(type, subtype, cost, cost_val, param1, param1_val, chance)
   subtype = subtype or -1
   cost = cost or -1
   cost_val = cost_val or -1
   param1 = param1 or -1
   param1_val = param1_val or -1
   chance = chance or 100

   self:SetInt(0, type)
   self:SetInt(1, subtype)
   self:SetInt(2, cost)
   self:SetInt(3, cost_val)
   self:SetInt(4, param1)
   self:SetInt(5, param1_val)
   self:SetInt(6, uses_per_day or 1)
   self:SetInt(7, chance) -- Chance
   self:SetInt(8, 1) -- Useable
end

-------------------------------------------------------------------------------

EFFECT_VS_INVALID   = 0
EFFECT_VS_ALIGN     = 1
EFFECT_VS_ALIGN_GRP = 2
EFFECT_VS_RACE      = 3
EFFECT_VS_DMG_TYPE  = 4

--- Item Property creation functions.
-- @section ip_create

function M.CreateItemPropery(command, args)
    NWE.ExecuteCommand(command, args)
    return NWE.StackPopEngineStructure(NWE.STRUCTURE_ITEMPROPERTY)
end

function M.CreateItempropEffect(show_icon)
   show_icon = show_icon or 0
   local eff = itemprop_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetCreator(NWE.GetCommandObject())
   eff:SetNumIntegers(9)
   eff:SetAllInts(-1)
   eff:SetSubType(0)
   eff:SetDurationType(Eff.DURATION_TYPE_PERMANENT)
   eff:SetTrueType(Eff.ITEMPROPERTY)

   return eff
end

---
-- @param ability
-- @param bonus
function M.AbilityScore(ability, bonus)
   local eff = M.CreateItempropEffect()

   if bonus < 0 then
      eff:SetValues(M.DECREASED_ABILITY_SCORE, ability, 21, math.clamp(-bonus, 1, 12))
   else
      eff:SetValues(M.ABILITY_BONUS, ability, 1, math.clamp(bonus, 1, 12))
   end
   
   return eff
end

---
-- @param bonus
-- @param ac_type
function M.AC(bonus, ac_type)
   ac_type = ac_type or solstice.nwn.AC_DODGE_BONUS
   local eff = M.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(M.DECREASED_AC, ac_type, 20, math.clamp(-bonus, 1, 20))
   else
      eff:SetValues(M.AC_BONUS, ac_type, 2, math.clamp(bonus, 1, 20))
   end
   
   return eff
end

function M.ACVsAligmentGroup() end
function M.ACVsDamage() end
function M.ACVsRace() end
function M.ACVsAligment() end

function M.ArcaneSpellFailure(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ARCANE_SPELL_FAILURE, nil, 27, amount)
   return eff
end


--- Item Property Enhancement Bonus
-- @param bonus If greater than 0 enhancment bonus, else penalty
function M.EnhancementModifier(bonus)
   local eff = M.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(M.DECREASED_ENHANCEMENT_MODIFIER, nil, 20, math.clamp(-bonus, 1, 20))
   else
      eff:SetValues(M.ENHANCEMENT_BONUS, nil, 2, math.clamp(bonus, 1, 20))
   end
   
   return eff
end

function M.EnhancementModifierVsAlignmentGroup(bonus) end
function M.EnhancementModifierVsRace(bonus) end
function M.EnhancementModifierVsAlignmentGroup(bonus) end

--- Item Property Weight Increase
-- @param amount solstice.itemprop.const.WEIGHTINCREASE_*
function M.WeightIncrease(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.WEIGHT_INCREASE, nil, 0, nil, 11, amount)
   return eff
end

--- Item Property Weight Reuction
-- @param amount solstice.itemprop.const.REDUCEDWEIGHT_*
function M.WeightReduction(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.BASE_ITEM_WEIGHT_REDUCTION, nil, 10, amount)
   return eff
end

--- Item Property Bonus Feat
-- @param feat solstice.itemprop.const.FEAT_*
function M.BonusFeat(feat)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.BONUS_FEAT, nil, 0, feat)
   return eff
end

--- Creates a "bonus spell of a specified level" itemproperty.
-- @param class solstice.itemprop.const.CLASS_*
-- @param level [0, 9]
function M.BonusLevelSpell(class, level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.BONUS_SPELL_SLOT_OF_LEVEL_N, class, 13, level)
   return eff
end

--- Creates a "cast spell" itemproperty.
-- @param spell solstice.itemprop.const.CASTSPELL_*
-- @param uses solstice.itemprop.const.CASTSPELL_NUMUSES_*
function M.CastSpell(spell, uses)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.CAST_SPELL, spell, 3, uses)
   return eff
end

--- Creates a damage bonus itemproperty.
-- @param damage_type solstice.itemprop.const.DAMAGETYPE_*
-- @param damage solstice.itemprop.const.DAMAGEBONUS_*
function M.DamageBonus(damage_type, damage)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DAMAGE_BONUS, damage_type, 4, damage)
   return eff
end

function M.DamageBonusVsAlignmentGroup(damage_type, damage) end
function M.DamageBonusVsRace(damage_type, damage) end
function M.DamageBonusVsAlignment(damage_type, damage) end

--- Creates a damage immunity itemproperty.
-- @param damage_type solstice.itemprop.const.DAMAGETYPE_*
-- @param amount 
function M.DamageImmunity(damage_type, amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMMUNITY_DAMAGE_TYPE, damage_type, 5, amount)
   return eff
end

--- Creatses a damage penalty itemproperty.
-- @param penalty [1,5]
function M.DamagePenalty(penalty)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DECREASED_DAMAGE, nil, 20, amount)
   return eff
end

--- Creates a damage reduction itemproperty.
-- @param enhancement solstice.itemprop.const.DAMAGEREDUCTION_*
-- @param soak solstice.itemprop.const.DAMAGESOAK_*
function M.DamageReduction(enhancement, soak)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DAMAGE_REDUCTION, enhancement, 6, soak)
   return eff
end

--- Creates damage resistance item property.
-- @param damage_type solstice.itemprop.const.DAMAGETYPE_*
-- @param amount solstice.itemprop.const.DAMAGERESIST_*
function M.DamageResistance(damage_type, amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DAMAGE_RESISTANCE, damage_type, 7, amount)
   return eff
end

--- Creates damage vulnerability item property.
-- @param damage_type solstice.itemprop.const.DAMAGETYPE_*
-- @param amount solstice.itemprop.const.DAMAGEVULNERABILITY_*
function M.DamageVulnerability(damage_type, amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DAMAGE_VULNERABILITY, damage_type, 22, amount)
   return eff
end

--- Creates Darkvision Item Property
function M.Darkvision()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.DARKVISION, nil, 0)
   return eff
end

--- Creates skill modifier item property
-- @param skill solstice.skill type constant.
-- @param amount [1, 50] or [-10, -1]
function M.SkillModifier(skill, amount)
   local eff = M.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(M.DECREASED_SKILL_MODIFIER, skill, 21, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(M.SKILL_BONUS, skill, 25, math.clamp(amount, 1, 50))
   end
   
   return eff
end

--- Create a "reduced weight container" itemproperty.
-- @param amount solstice.itemprop.const.CONTAINERWEIGHTRED_*
function M.ContainerReducedWeight(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ENHANCED_CONTAINER_REDUCED_WEIGHT, nil, 15, amount)
   return eff
end

--- Creates an "extra damage type" item property.
-- @param damage_type solstice.itemprop.const.DAMAGETYPE_*
-- @param[opt=false] is_ranged ExtraRangedDamge if true, melee if false.
function M.ExtraDamageType(damage_type, is_ranged)
   local eff = M.CreateItempropEffect()

   if is_ranged then
      eff:SetValues(M.EXTRA_RANGED_DAMAGE_TYPE, damage_type, 0)
   else
      eff:SetValues(M.EXTRA_MELEE_DAMAGE_TYPE, damage_type, 0)
   end
   return eff
end

--- Creates haste item property.
function M.Haste()
   return NWE.CreateItemPropery( 647, 0) 
end

--- Creates Holy Avenger item propety.
function M.HolyAvenger()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.HOLY_AVENGER, nil, 0)
   return eff
end

--- Creates immunity item property
-- @param immumity_type solstice.itemprop.const.IMMUNITYMISC_*
function M.ImmunityMisc(immumity_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMMUNITY_MISCELLANEOUS, immumity_type, 0)
   return eff
end

--- Creates Improved evasion item property.
function M.ImprovedEvasion()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMPROVED_EVASION, nil, 0)
   return eff
end

--- Creates a spell resistince item property
-- @param amount solstice.itemprop.const.SPELLRESISTANCEBONUS_*
function M.BonusSpellResistance(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.SPELL_RESISTANCE, nil, 11, amount)
   return eff
end

--- Creates saving throw bonus vs item property
-- @param save_type solstice.itemprop.const.SAVEVS_*
-- @param amount [1,20] or [-20, -1]
function M.SavingThrowVsX(save_type, amount)
   local eff = M.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(M.DECREASED_SAVING_THROWS, save_type, 20, math.clamp(-amount, 1, 20))
   else
      eff:SetValues(M.SAVING_THROW_BONUS, save_type, 2, math.clamp(amount, 1, 20))
   end
   return eff
end

--- Creates saving throw bonus item property
-- @param save_type solstice.itemprop.const.SAVEBASETYPE_*
-- @param amount [1,20] or [-20, -1]
function M.BonusSavingThrow(save_type, amount)
   local eff = M.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(M.DECREASED_SAVING_THROWS_SPECIFIC, save_type, 20, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(M.SAVING_THROW_BONUS_SPECIFIC, save_type, 2, math.clamp(amount, 1, 50))
   end
   
   return eff
end

--- Creates keen item property
function M.Keen()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.KEEN, nil, 0)
   return eff
end

--- Creates a light item property.
-- @param brightness solstice.itemprop.const.LIGHTBRIGHTNESS_*
-- @param color solstice.itemprop.const.LIGHTCOLOR_*
function M.Light(brightness, color)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.LIGHT, nil, 18, brightness, 9, color)
   return eff
end

--- Creates a mighty item property.
-- @param modifier [1,20]
function M.Mighty(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.MIGHTY, nil, 2, math.clamp(modifier, 1, 20))
   return eff
end

--- Creates no damage item property
function M.NoDamage()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.NO_DAMAGE, nil, 0)
   return eff
end

--- Creates an OnHit itemproperty.
-- @param prop solstice.itemprop.const.ONHIT_*
-- @param dc solstice.itemprop.const.ONHIT_SAVEDC_*
-- @param special Meaning varies with type. (Default: 0)
function M.OnHitProps(prop, dc, special)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ON_HIT_PROPERTIES, 
		 prop, 
		 24, 
		 dc, 
		 0,
		 special or 0)
   return eff
end

--- Creates a regeneration item property.
-- @param amount [1, 20]
function M.Regeneration(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.REGENERATION, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates an "immunity to specific spell" itemproperty.
-- @param spell solstice.itemprop.const.IMMUNITYSPELL_*
function M.SpellImmunitySpecific(spell)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMMUNITY_SPECIFIC_SPELL, nil, 16, spell)
   return eff
end

--- Creates an "immunity against spell school" itemproperty.
-- @param school solstice.itemprop.const.SPELLSCHOOL_*
function M.SpellImmunitySchool(school)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMMUNITY_SPECIFIC_SPELL, school, 0)
   return eff
end

--- Creates a thieves tool item property
-- @param modifier [1, 12]
function M.ThievesTools(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.THIEVES_TOOLS, nil, 25, math.clamp(modifier, 1, 12))
   return eff
end

--- Creatures attack modifier item property
-- @param bonus [1,20] or [-5, -1]
function M.AttackModifier(bonus)
   local eff = M.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(M.DECREASED_ATTACK_MODIFIER, nil, 25, math.clamp(bonus, 1, 5))
   else
      eff:SetValues(M.ATTACK_BONUS, nil, 20, math.clamp(bonus, 1, 20))
   end
   return eff
end

function M.AttackModifierVsAlignmentGroup(bonus) end
function M.AttackModifierVsRace(bonus) end
function M.AttackModifierVsAlignment(bonus) end

--- Creates an unlimited ammo itemproperty.
-- @param ammo solstice.itemprop.const.UNLIMITEDAMMO_* (Default: solstice.itemprop.const.UNLIMITEDAMMO_BASIC)
function M.UnlimitedAmmo(ammo)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.UNLIMITED_AMMUNITION, ammo or solstice.itemprop.const.UNLIMITEDAMMO_BASIC, 14)
   return eff
end

function M.LimitUseByAlign(align_group) end

--- Creates a class use limitation item property
-- @param class solstice.itemprop.const.CLASS_*
function M.LimitUseByClass(class)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.USE_LIMITATION_CLASS, class, 0)
   return eff
end

--- Creates a race use limitation item property
-- @param race Racial type
function M.LimitUseByRace(race)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.USE_LIMITATION_RACIAL_TYPE, race, 0)
   return eff
end

function M.LimitUseBySAlign(nAlignment) end

--- Creates vampiric regeneration effect.
-- @param amount [1,20]
function M.VampiricRegeneration(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.REGENERATION_VAMPIRIC, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates a trap item property
-- @param level solstice.itemprop.const.TRAPSTRENGTH_*
-- @param trap_type solstice.itemprop.const.TRAPTYPE_*
function M.Trap(level, trap_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.TRAP, trap_type, 17, level)
   return eff
end

--- Creates true seeing item property
function M.TrueSeeing()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.TRUE_SEEING, nil, 0)
   return eff
end

--- Creates on monster hit item property.
-- NOTE: Item property is bugged.  See NWN Lexicon.
-- @param prop solstice.itemprop.const.ONMONSTERHIT_*
-- @param special ???
function M.OnMonsterHitProperties(prop, special)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ON_MONSTER_HIT, prop, 0, special)
   return eff
end

--- Creates a turn resistance item property.
-- @param modifier [1, 50]
function M.TurnResistance(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.TURN_RESISTANCE, nil, 25, math.clamp(modifier, 1, 50))
   return eff
end

--- Creates a massive criticals item property.
-- @param damage solstice.itemprop.const.DAMAGEBONUS_*
function M.MassiveCritical(damage)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.MASSIVE_CRITICALS, nil, 4, damage)
   return eff
end

--- Creates a free action (freedom of movement) itemproperty.
function M.Freedom()
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.FREEDOM_OF_MOVEMENT, nil, 0)
   return eff
end

--- Creates Monster Damage effect.
-- @param damage solstice.itemprop.const.MONSTERDAMAGE_*
function M.MonsterDamage(damage)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.MONSTER_DAMAGE, nil, 19, damage)
   return eff
end

--- Create an "immunity to spell level" item property.
-- @param level Spell level [1,9]
function M.ImmunityToSpellLevel(level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.IMMUNITY_SPELLS_BY_LEVEL, nil, 23, level)
   return eff
end

--- Creates a special walk itemproperty.
-- @param[opt=0] walk Only 0 is a valid argument
function M.SpecialWalk(walk)
   walk = walk or 0
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.SPECIAL_WALK, walk)
   return eff
end

--- Creates a healers' kit item property.
-- @param modifier [1,12]
function M.HealersKit(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.HEALERS_KIT, nil, 25, modifier)
   return eff
end

--- Creates material item property
-- @param material The material type should be [0, 77] based on 
-- iprp_matcost.2da.
function M.Material(material)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.MATERIAL, nil, 28, material)
   return eff
end

--- Creates an "on hit cast spell" item property.
-- @param spell solstice.itemprop.const.ONHIT_CASTSPELL_*
-- @param level Level spell is cast at.
function M.OnHitCastSpell(spell, level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ONHITCASTSPELL, spell, 26, level)
   return eff
end

--- Creates quality item property
-- @param quality solstice.itemprop.const.QUALITY_*
function M.Quality(quality)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.QUALITY, nil, 29, quality)
   return eff
end

--- Creates additional item property
-- @param addition solstice.itemprop.const.ADDITIONAL_* 
function M.Additional(addition)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.ADDITIONAL, nil, 30, addition)
   return eff
end

--- Creates a visual effect item property
-- @param effect solstice.itemprop.const.VISUAL_*
function M.VisualEffect(effect)
   local eff = M.CreateItempropEffect()
   eff:SetValues(M.VISUALEFFECT, effect)
   return eff
end

return M