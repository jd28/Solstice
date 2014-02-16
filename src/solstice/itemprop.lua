----------------------------------------------------------
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module itemprop


local M = {}
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Eff = Effect

M.Itemprop = inheritsFrom(Eff.Effect, "solstice.itemprop.Itemprop")

--- ctype
M.itemprop_t = ffi.metatype("Itemprop", { __index = M.Itemprop })

--- Internal ctype
M.itemprop_internal_t = ffi.typeof("CNWItemProperty")


--- Class Itemprop
-- @section sol_itemprop_Itemprop
-- @see sol_effect_Effect

--- Convert itemprop effect to formatted string.
-- Override Effect:ToStringx
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
   self:SetInt(6, 1)
   self:SetInt(7, chance) -- Chance
   self:SetInt(8, 1) -- Useable
end

-------------------------------------------------------------------------------

function M.CreateItempropInternal(type, subtype, cost, cost_val,
                                  param1, param1_val, chance)
   subtype = subtype or -1
   cost = cost or -1
   cost_val = cost_val or -1
   param1 = param1 or -1
   param1_val = param1_val or -1
   chance = chance or 100

   local ip = M.itemprop_internal_t()
   ip.ip_type = type
   ip.ip_subtype = subtype
   ip.ip_cost_table = cost
   ip.ip_cost_value = cost_val
   ip.ip_param_table = param1
   ip.ip_param_value = param1_val
   ip.ip_chance = chance
   ip.ip_useable = 1
   ip.ip_uses_per_day = 1
   return ip
end

--- Item Property creation functions.
-- @section ip_create

function M.CreateItemPropery(command, args)
    NWE.ExecuteCommand(command, args)
    return NWE.StackPopEngineStructure(NWE.STRUCTURE_ITEMPROPERTY)
end

function M.CreateItempropEffect(show_icon)
   show_icon = show_icon or 0
   local eff = M.itemprop_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetCreator(NWE.GetCommandObject())
   eff:SetNumIntegers(9)
   eff:SetAllInts(-1)
   eff:SetSubType(0)
   eff:SetDurationType(DURATION_TYPE_PERMANENT)
   eff:SetType(EFFECT_TYPE_ITEMPROPERTY)

   return eff
end

--- Create Ability bonus/penalty item property.
-- @param ability solstice.creature.ABILITY_*
-- @param mod Bonus: [1, 12], Penalty [-12, -1]
function M.AbilityScore(ability, mod)
   local eff = M.CreateItempropEffect()

   if mod < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_ABILITY_SCORE, ability, 21, math.clamp(-mod, 1, 12))
   else
      eff:SetValues(ITEM_PROPERTY_ABILITY_BONUS, ability, 1, math.clamp(mod, 1, 12))
   end

   return eff
end

--- Create AC item property
-- @param value Bonus: [1,20] Penaly [-20, -1]
function M.AC(value)
   local eff = M.CreateItempropEffect()

   if value < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_AC, -1, 20, math.clamp(-value, 1, 20))
   else
      eff:SetValues(ITEM_PROPERTY_AC_BONUS, -1, 2, math.clamp(value, 1, 20))
   end

   return eff
end

--- Creates additional item property
-- @param addition IP_CONST_ADDITIONAL_*
function M.Additional(addition)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ADDITIONAL, nil, 30, addition)
   return eff
end

--- Create arcane spell failure item property
-- @param value
function M.ArcaneSpellFailure(value)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ARCANE_SPELL_FAILURE, nil, 27, value)
   return eff
end

--- Creatures attack modifier item property
-- @param value [1,20] or [-5, -1]
function M.AttackModifier(value)
   local eff = M.CreateItempropEffect()

   if value < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, nil, 25, math.clamp(value, 1, 5))
   else
      eff:SetValues(ITEM_PROPERTY_ATTACK_BONUS, nil, 20, math.clamp(value, 1, 20))
   end
   return eff
end

--- Item Property Bonus Feat
-- @param feat IP_CONST_FEAT_*
function M.BonusFeat(feat)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_BONUS_FEAT, nil, 0, feat)
   return eff
end

--- Creates a "bonus spell of a specified level" itemproperty.
-- @param class solstice.class constant
-- @param level [0, 9]
function M.BonusLevelSpell(class, level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, class, 13, level)
   return eff
end

--- Creates a "cast spell" itemproperty.
-- @param spell IP_CONST_CASTSPELL_*
-- @param uses IP_CONST_CASTSPELL_NUMUSES_*
function M.CastSpell(spell, uses)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_CAST_SPELL, spell, 3, uses)
   return eff
end

--- Create a "reduced weight container" itemproperty.
-- @param amount IP_CONST_CONTAINERWEIGHTRED_*
function M.ContainerReducedWeight(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT, nil, 15, amount)
   return eff
end

--- Creates a damage bonus itemproperty.
-- @param damage_type solstice.damage constant.
-- @param damage solstice.damage.BONUS_*
function M.DamageBonus(damage_type, damage)
   damage_type = Rules.ConvertDamageToItempropConstant(damage_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DAMAGE_BONUS, damage_type, 4, damage)
   return eff
end

--- Creates a damage immunity itemproperty.
-- @param damage_type DAMAGE\_TYPE\_*
-- @param amount IP_CONST_DAMAGEIMMUNITY_*
function M.DamageImmunity(damage_type, amount)
   damage_type = Rules.ConvertDamageToItempropConstant(damage_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damage_type, 5, amount)
   return eff
end

--- Creatses a damage penalty itemproperty.
-- @param amount [1,5]
function M.DamagePenalty(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DECREASED_DAMAGE, nil, 20, amount)
   return eff
end

--- Creates a damage reduction itemproperty.
-- @param enhancement IP_CONST_REDUCTION_*
-- @param soak IP_CONST_SOAK_*
function M.DamageReduction(enhancement, soak)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DAMAGE_REDUCTION, enhancement, 6, soak)
   return eff
end

--- Creates damage resistance item property.
-- @param damage_type solstice.damage type constant.
-- @param amount IP_CONST_RESIST_*
function M.DamageResistance(damage_type, amount)
   damage_type = Rules.ConvertDamageToItempropConstant(damage_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DAMAGE_RESISTANCE, damage_type, 7, amount)
   return eff
end

--- Creates damage vulnerability item property.
-- @param damage_type solstice.damage type constant.
-- @param amount IP_CONST_DAMAGEVULNERABILITY_*
function M.DamageVulnerability(damage_type, amount)
   damage_type = Rules.ConvertDamageToItempropConstant(damage_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DAMAGE_VULNERABILITY, damage_type, 22, amount)
   return eff
end

--- Creates Darkvision Item Property
function M.Darkvision()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DARKVISION, nil, 0)
   return eff
end

--- Item Property Enhancement Bonus
-- @param amount If greater than 0 enhancment bonus, else penalty
function M.EnhancementModifier(amount)
   local eff = M.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER, nil, 20, math.clamp(-amount, 1, 20))
   else
      eff:SetValues(ITEM_PROPERTY_ENHANCEMENT_BONUS, nil, 2, math.clamp(amount, 1, 20))
   end

   return eff
end

--- Creates an "extra damage type" item property.
-- @param damage_type solstice.damage constant
-- @param[opt=false] is_ranged ExtraRangedDamge if true, melee if false.
function M.ExtraDamageType(damage_type, is_ranged)
   local eff = M.CreateItempropEffect()
   damage_type = Rules.ConvertDamageToItempropConstant(damage_type)

   if is_ranged then
      eff:SetValues(ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE, damage_type, 0)
   else
      eff:SetValues(ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE, damage_type, 0)
   end
   return eff
end

--- Creates a free action (freedom of movement) itemproperty.
function M.Freedom()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, nil, 0)
   return eff
end

--- Creates haste item property.
function M.Haste()
   return NWE.CreateItemPropery( 647, 0)
end

--- Creates a healers' kit item property.
-- @param modifier [1,12]
function M.HealersKit(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_HEALERS_KIT, nil, 25, modifier)
   return eff
end

--- Creates Holy Avenger item propety.
function M.HolyAvenger()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_HOLY_AVENGER, nil, 0)
   return eff
end

--- Creates immunity item property
-- @param immumity_type IMMUNITY\_TYPE\_*
function M.ImmunityMisc(immumity_type)
   local eff = M.CreateItempropEffect()
   immumity_type = Rules.ConvertImmunityToIPConstant(immumity_type)
   eff:SetValues(ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, immumity_type, 0)
   return eff
end

--- Creates Improved evasion item property.
function M.ImprovedEvasion()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_IMPROVED_EVASION, nil, 0)
   return eff
end

--- Creates keen item property
function M.Keen()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_KEEN, nil, 0)
   return eff
end

--- Creates a light item property.
-- @param brightness IP_CONST_LIGHTBRIGHTNESS_*
-- @param color IP_CONST_LIGHTCOLOR_*
function M.Light(brightness, color)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_LIGHT, nil, 18, brightness, 9, color)
   return eff
end

--- Creates a class use limitation item property
-- @param class solstice.class constant
function M.LimitUseByClass(class)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_USE_LIMITATION_CLASS, class, 0)
   return eff
end

--- Creates a race use limitation item property
-- @param race Racial type
function M.LimitUseByRace(race)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE, race, 0)
   return eff
end

--- Creates a massive criticals item property.
-- @param damage solstice.damage.BONUS_*
function M.MassiveCritical(damage)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_MASSIVE_CRITICALS, nil, 4, damage)
   return eff
end

--- Creates material item property
-- @param material The material type should be [0, 77] based on
-- iprp_matcost.2da.
function M.Material(material)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_MATERIAL, nil, 28, material)
   return eff
end

--- Creates a mighty item property.
-- @param value [1,20]
function M.Mighty(value)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_MIGHTY, nil, 2, math.clamp(value, 1, 20))
   return eff
end

--- Creates Monster Damage effect.
-- @param damage IP_CONST_MONSTERDAMAGE_*
function M.MonsterDamage(damage)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_MONSTER_DAMAGE, nil, 19, damage)
   return eff
end

--- Creates no damage item property
function M.NoDamage()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_NO_DAMAGE, nil, 0)
   return eff
end

--- Creates an "on hit cast spell" item property.
-- @param spell IP_CONST_ONHIT_CASTSPELL_*
-- @param level Level spell is cast at.
function M.OnHitCastSpell(spell, level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ONHITCASTSPELL, spell, 26, level)
   return eff
end

--- Creates on monster hit item property.
-- NOTE: Item property is bugged.  See NWN Lexicon.
-- @param prop IP_CONST_ONMONSTERHIT_*
-- @param special ???
function M.OnHitMonster(prop, special)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ON_MONSTER_HIT, prop, 0, special)
   return eff
end

--- Creates an OnHit itemproperty.
-- @param prop IP_CONST_ONHIT_*
-- @param dc IP_CONST_ONHIT_SAVEDC_*
-- @param special Meaning varies with type. (Default: 0)
function M.OnHitProps(prop, dc, special)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_ON_HIT_PROPERTIES,
		 prop,
		 24,
		 dc,
		 0,
		 special or 0)
   return eff
end

--- Creates quality item property
-- @param quality IP_CONST_QUALITY_*
function M.Quality(quality)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_QUALITY, nil, 29, quality)
   return eff
end

--- Creates a regeneration item property.
-- @param amount [1, 20]
function M.Regeneration(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_REGENERATION, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates saving throw bonus item property
-- @param save_type SAVING_THROW_*
-- @param amount [1,20] or [-20, -1]
function M.SavingThrow(save_type, amount)
   local eff = M.CreateItempropEffect()

   save_type = Rules.ConvertSaveToItempropConstant(save_type)

   if amount < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC, save_type, 20, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, save_type, 2, math.clamp(amount, 1, 50))
   end

   return eff
end

--- Creates saving throw bonus vs item property
-- @param save_type SAVING_THROW_VS_*
-- @param amount [1,20] or [-20, -1]
function M.SavingThrowVersus(save_type, amount)
   local eff = M.CreateItempropEffect()

   save_type = Rules.ConvertSaveVsToItempropConstant(save_type)

   if amount < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_SAVING_THROWS, save_type, 20, math.clamp(-amount, 1, 20))
   else
      eff:SetValues(ITEM_PROPERTY_SAVING_THROW_BONUS, save_type, 2, math.clamp(amount, 1, 20))
   end
   return eff
end

--- Creates skill modifier item property
-- @param skill solstice.skill type constant.
-- @param amount [1, 50] or [-10, -1]
function M.SkillModifier(skill, amount)
   local eff = M.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, skill, 21, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(ITEM_PROPERTY_SKILL_BONUS, skill, 25, math.clamp(amount, 1, 50))
   end

   return eff
end

--- Creates a special walk itemproperty.
-- @param[opt=0] walk Only 0 is a valid argument
function M.SpecialWalk(walk)
   walk = walk or 0
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_SPECIAL_WALK, walk)
   return eff
end

--- Create an "immunity to spell level" item property.
-- @param level Spell level [1,9]
function M.SpellImmunityLevel(level)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, nil, 23, level)
   return eff
end

--- Creates an "immunity to specific spell" itemproperty.
-- @param spell IP_CONST_IMMUNITYSPELL_*
function M.SpellImmunitySpecific(spell)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL, nil, 16, spell)
   return eff
end

--- Creates an "immunity against spell school" itemproperty.
-- @param school IP_CONST_SPELLSCHOOL_*
function M.SpellImmunitySchool(school)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL, school, 0)
   return eff
end

--- Creates a spell resistince item property
-- @param amount IP_CONST_SPELLRESISTANCEBONUS_*
function M.SpellResistance(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_SPELL_RESISTANCE, nil, 11, amount)
   return eff
end

--- Creates a thieves tool item property
-- @param modifier [1, 12]
function M.ThievesTools(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_THIEVES_TOOLS, nil, 25, math.clamp(modifier, 1, 12))
   return eff
end

--- Creates a trap item property
-- @param level IP_CONST_TRAPSTRENGTH_*
-- @param trap_type IP_CONST_TRAPTYPE_*
function M.Trap(level, trap_type)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_TRAP, trap_type, 17, level)
   return eff
end

--- Creates true seeing item property
function M.TrueSeeing()
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_TRUE_SEEING, nil, 0)
   return eff
end

--- Creates a turn resistance item property.
-- @param modifier [1, 50]
function M.TurnResistance(modifier)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_TURN_RESISTANCE, nil, 25, math.clamp(modifier, 1, 50))
   return eff
end

--- Creates an unlimited ammo itemproperty.
-- @param ammo IP_CONST_UNLIMITEDAMMO_* (Default: IP_CONST_UNLIMITEDAMMO_BASIC)
function M.UnlimitedAmmo(ammo)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_UNLIMITED_AMMUNITION, ammo or IP_CONST_UNLIMITEDAMMO_BASIC, 14)
   return eff
end

--- Creates vampiric regeneration effect.
-- @param amount [1,20]
function M.VampiricRegeneration(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_REGENERATION_VAMPIRIC, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates a visual effect item property
-- @param effect IP_CONST_VISUAL_*
function M.VisualEffect(effect)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_VISUALEFFECT, effect)
   return eff
end

--- Item Property Weight Increase
-- @param amount IP_CONST_WEIGHTINCREASE_*
function M.WeightIncrease(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_WEIGHT_INCREASE, nil, 0, nil, 11, amount)
   return eff
end

--- Item Property Weight Reuction
-- @param amount IP_CONST_REDUCEDWEIGHT_*
function M.WeightReduction(amount)
   local eff = M.CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION, nil, 10, amount)
   return eff
end

return M
