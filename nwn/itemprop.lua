--- 

require 'nwn.ctypes.effect'
require 'nwn.ctypes.itemprop'

local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
typedef struct Itemprop {
    CGameEffect     *eff;
    bool            direct;
} Itemprop;
]]

local itemprop_mt = { __index = Itemprop }
itemprop_t = ffi.metatype("Itemprop", itemprop_mt)

--- Convert itemprop effect to formatted string.
-- Override Effect:ToString
function Itemprop:ToString()
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
function Itemprop:GetCostTable()
   return self:GetInt(2)
end

--- Returns the cost table value of an itemproperty.
-- See the 2DA files for value definitions.
function Itemprop:GetCostTableValue()
   return self:GetInt(3)
end

--- Returns the Param1 number of the item property.
function Itemprop:GetParam1()
   return self:GetInt(4)
end

--- Returns the Param1 value of the item property.
function Itemprop:GetParam1Value()
   return self:GetInt(5)
end

--- Returns the subtype of the itemproperty
function Itemprop:GetPropertySubType()
   return self:GetInt(1)
end

--- Returns the subtype of the itemproperty
function Itemprop:GetPropertyType()
   return self:GetInt(0)
end

-- Sets the item property effect values directly.
function Itemprop:SetValues(type, subtype, cost, cost_val, param1, param1_val, chance)
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

function nwn.engine.CreateItemPropery(command, args)
    nwn.engine.ExecuteCommand(command, args)
    return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY)
end

function nwn.CreateItempropEffect(show_icon)
   show_icon = show_icon or 0
   local eff = itemprop_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetCreator(nwn.engine.GetCommandObject())
   eff:SetNumIntegers(9)
   eff:SetAllInts(-1)
   eff:SetSubType(0)
   eff:SetDurationType(nwn.DURATION_TYPE_PERMANENT)
   eff:SetTrueType(nwn.EFFECT_TRUETYPE_ITEMPROPERTY)

   return eff
end

---
-- @param
-- @param
function nwn.ItemPropertyAbilityScore(ability, bonus)
   local eff = nwn.CreateItempropEffect()

   if bonus < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_ABILITY_SCORE, ability, 21, math.clamp(-bonus, 1, 12))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_ABILITY_BONUS, ability, 1, math.clamp(bonus, 1, 12))
   end
   
   return eff
end

---
-- @param
-- @param
function nwn.ItemPropertyAC(bonus, ac_type)
   ac_type = ac_type or nwn.AC_DODGE_BONUS
   local eff = nwn.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_AC, ac_type, 20, math.clamp(-bonus, 1, 20))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_AC_BONUS, ac_type, 2, math.clamp(bonus, 1, 20))
   end
   
   return eff
end

function nwn.ItemPropertyACVsAligmentGroup() end
function nwn.ItemPropertyACVsDamage() end
function nwn.ItemPropertyACVsRace() end
function nwn.ItemPropertyACVsAligment() end

function nwn.ItemPropertyArcaneSpellFailure(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ARCANE_SPELL_FAILURE, nil, 27, amount)
   return eff
end


--- Item Property Enhancement Bonus
-- @param bonus If greater than 0 enhancment bonus, else penalty
function nwn.ItemPropertyEnhancementModifier(bonus)
   local eff = nwn.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER, nil, 20, math.clamp(-bonus, 1, 20))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_ENHANCEMENT_BONUS, nil, 2, math.clamp(bonus, 1, 20))
   end
   
   return eff
end

function nwn.ItemPropertyEnhancementModifierVsAlignmentGroup(bonus) end
function nwn.ItemPropertyEnhancementModifierVsRace(bonus) end
function nwn.ItemPropertyEnhancementModifierVsAlignmentGroup(bonus) end

--- Item Property Weight Increase
-- @param amount nwn.IP_CONST_WEIGHTINCREASE_*
function nwn.ItemPropertyWeightIncrease(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_WEIGHT_INCREASE, nil, 0, nil, 11, amount)
   return eff
end

--- Item Property Weight Reuction
-- @param amount nwn.IP_CONST_REDUCEDWEIGHT_*
function nwn.ItemPropertyWeightReduction(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION, nil, 10, amount)
   return eff
end


--- Item Property Bonus Feat
-- @param feat nwn.IP_CONST_FEAT_*
function nwn.ItemPropertyBonusFeat(feat)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_BONUS_FEAT, nil, 0, feat)
   return eff
end

--- Creates a "bonus spell of a specified level" itemproperty.
-- @param class nwn.IP_CONST_CLASS_*
-- @param level [0, 9]
function nwn.ItemPropertyBonusLevelSpell(class, level)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, class, 13, level)
   return eff
end

--- Creates a "cast spell" itemproperty.
-- @param spell nwn.IP_CONST_CASTSPELL_*
-- @param uses nwn.IP_CONST_CASTSPELL_NUMUSES_*
function nwn.ItemPropertyCastSpell(spell, uses)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_CAST_SPELL, spell, 3, uses)
   return eff
end

--- Creates a damage bonus itemproperty.
-- @param damage_type nwn.IP_CONST_DAMAGETYPE_*
-- @param damage nwn.IP_CONST_DAMAGEBONUS_*
function nwn.ItemPropertyDamageBonus(damage_type, damage)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DAMAGE_BONUS, damage_type, 4, damage)
   return eff
end

function nwn.ItemPropertyDamageBonusVsAlignmentGroup(damage_type, damage) end
function nwn.ItemPropertyDamageBonusVsRace(damage_type, damage) end
function nwn.ItemPropertyDamageBonusVsAlignment(damage_type, damage) end

--- Creates a damage immunity itemproperty.
-- @param damage_type nwn.IP_CONST_DAMAGETYPE_*
-- @param amount 
function nwn.ItemPropertyDamageImmunity(damage_type, amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damage_type, 5, amount)
   return eff
end

--- Creatses a damage penalty itemproperty.
-- @param penalty [1,5]
function nwn.ItemPropertyDamagePenalty(penalty)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_DAMAGE, nil, 20, amount)
   return eff
end

--- Creates a damage reduction itemproperty.
-- @param enhancement nwn.IP_CONST_DAMAGEREDUCTION_*
-- @param soak nwn.IP_CONST_DAMAGESOAK_*
function nwn.ItemPropertyDamageReduction(enhancement, soak)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DAMAGE_REDUCTION, enhancement, 6, soak)
   return eff
end

--- Creates damage resistance item property.
-- @param damage_type nwn.IP_CONST_DAMAGETYPE_*
-- @param amount nwn.IP_CONST_DAMAGERESIST_*
function nwn.ItemPropertyDamageResistance(damage_type, amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DAMAGE_RESISTANCE, damage_type, 7, amount)
   return eff
end

--- Creates damage vulnerability item property.
-- @param damage_type nwn.IP_CONST_DAMAGETYPE_*
-- @param amount nwn.IP_CONST_DAMAGEVULNERABILITY_*
function nwn.ItemPropertyDamageVulnerability(damage_type, amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DAMAGE_VULNERABILITY, damage_type, 22, amount)
   return eff
end

--- Creates Darkvision Item Property
function nwn.ItemPropertyDarkvision()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_DARKVISION, nil, 0)
   return eff
end

--- Creates skill modifier item property
-- @param skill nwn.SKILL_*
-- @param amount [1, 50] or [-10, -1]
function nwn.ItemPropertySkillModifier(skill, amount)
   local eff = nwn.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, skill, 21, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_SKILL_BONUS, skill, 25, math.clamp(amount, 1, 50))
   end
   
   return eff
end

--- Create a "reduced weight container" itemproperty.
-- @param container_type nwn.IP_CONST_CONTAINERWEIGHTRED_*
function nwn.ItemPropertyContainerReducedWeight(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT, nil, 15, amount)
   return eff
end

--- Creates an "extra damage type" item property.
-- @param damage_type IP_CONST_DAMAGETYPE_*
-- @param is_ranged ExtraRangedDamge if true, melee if false (Default: false)
function nwn.ItemPropertyExtraDamageType(damage_type, is_ranged)
   local eff = nwn.CreateItempropEffect()

   if is_ranged then
      eff:SetValues(nwn.ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE, damage_type, 0)
   else
      eff:SetValues(nwn.ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE, damage_type, 0)
   end
   return eff
end

--- Creates haste item property.
function nwn.ItemPropertyHaste()
   return nwn.engine.CreateItemPropery( 647, 0) 
end

--- Creates Holy Avenger item propety.
function nwn.ItemPropertyHolyAvenger()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_HOLY_AVENGER, nil, 0)
   return eff
end

--- Creates immunity item property
-- @param immumity_type nwn.IP_CONST_IMMUNITYMISC_*
function nwn.ItemPropertyImmunityMisc(immumity_type)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, immumity_type, 0)
   return eff
end

--- Creates Improved evasion item property.
function nwn.ItemPropertyImprovedEvasion()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMPROVED_EVASION, nil, 0)
   return eff
end

--- Creates a spell resistince item property
-- @param amount nwn.IP_CONST_SPELLRESISTANCEBONUS_*
function nwn.ItemPropertyBonusSpellResistance(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_SPELL_RESISTANCE, nil, 11, amount)
   return eff
end

--- Creates saving throw bonus vs item property
-- @param save_type nwn.IP_CONST_SAVEVS_*
-- @param amount [1,20] or [-20, -1]
function nwn.ItemPropertySavingThrowVsX(save_type, amount)
   local eff = nwn.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_SAVING_THROWS, save_type, 20, math.clamp(-amount, 1, 20))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_SAVING_THROW_BONUS, save_type, 2, math.clamp(amount, 1, 20))
   end
   return eff
end

--- Creates saving throw bonus item property
-- @param save_type nwn.IP_CONST_SAVEBASETYPE_*
-- @param amount [1,20] or [-20, -1]
function nwn.ItemPropertyBonusSavingThrow(save_type, amount)
   local eff = nwn.CreateItempropEffect()
   
   if amount < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC, save_type, 20, math.clamp(-amount, 1, 10))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, save_type, 2, math.clamp(amount, 1, 50))
   end
   
   return eff
end

--- Creates keen item property
function nwn.ItemPropertyKeen()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_KEEN, nil, 0)
   return eff
end

--- Creates a light item property.
-- @param brightness nwn.IP_CONST_LIGHTBRIGHTNESS_*
-- @param color nwn.IP_CONST_LIGHTCOLOR_*
function nwn.ItemPropertyLight(brightness, color)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_LIGHT, nil, 18, brightness, 9, color)
   return eff
end

--- Creates a mighty item property.
-- @param modifier [1,20]
function nwn.ItemPropertyMighty(modifier)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_MIGHTY, nil, 2, math.clamp(modifier, 1, 20))
   return eff
end

--- Creates no damage item property
function nwn.ItemPropertyNoDamage()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_NO_DAMAGE, nil, 0)
   return eff
end

--- Creates an OnHit itemproperty.
-- @param prop nwn.IP_CONST_ONHIT_*
-- @param dc nwn.IP_CONST_ONHIT_SAVEDC_*
-- @param special Meaning varies with type. (Default: 0)
function nwn.ItemPropertyOnHitProps(prop, dc, special)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ON_HIT_PROPERTIES, prop, 24, dc, 0, special)
   return eff
end

--- Creates a regeneration item property.
-- @param amount [1, 20]
function nwn.ItemPropertyRegeneration(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_REGENERATION, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates an "immunity to specific spell" itemproperty.
-- @param spell nwn.IP_CONST_IMMUNITYSPELL_*
function nwn.ItemPropertySpellImmunitySpecific(spell)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL, nil, 16, spell)
   return eff
end

--- Creates an "immunity against spell school" itemproperty.
-- @param school nwn.IP_CONST_SPELLSCHOOL_*
function nwn.ItemPropertySpellImmunitySchool(school)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL, school, 0)
   return eff
end

--- Creates a thieves tool item property
-- @param modifier [1, 12]
function nwn.ItemPropertyThievesTools(modifier)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_THIEVES_TOOLS, nil, 25, math.clamp(modifier, 1, 12))
   return eff
end

--- Creatures attack modifier item property
-- @param bonus [1,20] or [-5, -1]
function nwn.ItemPropertyAttackModifier(bonus)
   local eff = nwn.CreateItempropEffect()
   
   if bonus < 0 then
      eff:SetValues(nwn.ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, nil, 25, math.clamp(bonus, 1, 5))
   else
      eff:SetValues(nwn.ITEM_PROPERTY_ATTACK_BONUS, nil, 20, math.clamp(bonus, 1, 20))
   end
   return eff
end

function nwn.ItemPropertyAttackModifierVsAlignmentGroup(bonus) end
function nwn.ItemPropertyAttackModifierVsRace(bonus) end
function nwn.ItemPropertyAttackModifierVsAlignment(bonus) end

--- Creates an unlimited ammo itemproperty.
-- @param ammo nwn.IP_CONST_UNLIMITEDAMMO_* (Default: nwn.IP_CONST_UNLIMITEDAMMO_BASIC)
function nwn.ItemPropertyUnlimitedAmmo(ammo)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_UNLIMITED_AMMUNITION, ammo or nwn.IP_CONST_UNLIMITEDAMMO_BASIC, 14)
   return eff
end

function nwn.ItemPropertyLimitUseByAlign(align_group) end

--- Creates a class use limitation item property
-- @param class nwn.IP_CONST_CLASS_*
function nwn.ItemPropertyLimitUseByClass(class)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_USE_LIMITATION_CLASS, class, 0)
   return eff
end

--- Creates a race use limitation item property
-- @param race Racial type
function nwn.ItemPropertyLimitUseByRace(race)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE, race, 0)
   return eff
end

function nwn.ItemPropertyLimitUseBySAlign(nAlignment) end

--- Creates vampiric regeneration effect.
-- @param amount [1,20]
function nwn.ItemPropertyVampiricRegeneration(amount)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_REGENERATION_VAMPIRIC, nil, 2, math.clamp(amount, 1, 20))
   return eff
end

--- Creates a trap item property
-- @param level nwn.IP_CONST_TRAPSTRENGTH_*
-- @param trap_type nwn.IP_CONST_TRAPTYPE_*
function nwn.ItemPropertyTrap(level, trap_type)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_TRAP, trap_type, 17, level)
   return eff
end

--- Creates true seeing item property
function nwn.ItemPropertyTrueSeeing()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_TRUE_SEEING, nil, 0)
   return eff
end

--- Creates on monster hit item property.
-- NOTE: Item property is bugged.  See NWN Lexicon.
-- @param prop nwn.IP_CONST_ONMONSTERHIT_*
-- @param special ???
function nwn.ItemPropertyOnMonsterHitProperties(prop, special)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ON_MONSTER_HIT, prop, 0, special)
   return eff
end

--- Creates a turn resistance item property.
-- @param modifier [1, 50]
function nwn.ItemPropertyTurnResistance(modifier)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_TURN_RESISTANCE, nil, 25, math.clamp(modifier, 1, 50))
   return eff
end

--- Creates a massive criticals item property.
-- @param damage nwn.IP_CONST_DAMAGEBONUS_*
function nwn.ItemPropertyMassiveCritical(damage)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_MASSIVE_CRITICALS, nil, 4, damage)
   return eff
end

--- Creates a free action (freedom of movement) itemproperty.
function nwn.ItemPropertyFreedom()
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, nil, 0)
   return eff
end

--- Creates Monster Damage effect.
-- @param damage nwn.IP_CONST_MONSTERDAMAGE_*
function nwn.ItemPropertyMonsterDamage(damage)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_MONSTER_DAMAGE, nil, 19, damage)
   return eff
end

--- Create an "immunity to spell level" item property.
-- @param level Spell level [1,9]
function nwn.ItemPropertyImmunityToSpellLevel(level)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, nil, 23, level)
   return eff
end

--- Creates a special walk itemproperty.
-- @param walk Only 0 is a valid argument (Default: 0)
function nwn.ItemPropertySpecialWalk(walk)
   walk = 0
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_SPECIAL_WALK, walk)
   return eff
end

--- Creates a healers' kit item property.
-- @param modifier [1,12]
function nwn.ItemPropertyHealersKit(modifier)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_HEALERS_KIT, nil, 25, modifier)
   return eff
end

--- Creates material item property
-- @param material The material type should be [0, 77] based on 
--    iprp_matcost.2da.
function nwn.ItemPropertyMaterial(material)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_MATERIAL, nil, 28, material)
   return eff
end

--- Creates an "on hit cast spell" item property.
-- @param spell nwn.IP_CONST_ONHIT_CASTSPELL_*
-- @param level Level spell is cast at.
function nwn.ItemPropertyOnHitCastSpell(spell, level)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ONHITCASTSPELL, spell, 26, level)
   return eff
end

--- Creates quality item property
-- @param quality nwn.IP_CONST_QUALITY_*
function nwn.ItemPropertyQuality(quality)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_QUALITY, nil, 29, quality)
   return eff
end

--- Creates additional item property
-- @param addition nwn.IP_CONST_ADDITIONAL_* 
function nwn.ItemPropertyAdditional(addition)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_ADDITIONAL, nil, 30, addition)
   return eff
end

--- Creates a visual effect item property
-- @param effect nwn.ITEM_VISUAL_*
function nwn.ItemPropertyVisualEffect(effect)
   local eff = nwn.CreateItempropEffect()
   eff:SetValues(nwn.ITEM_PROPERTY_VISUALEFFECT, effect)
   return eff
end
