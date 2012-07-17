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

function Itemprop:SetValues(type, subtype, cost, cost_val, param1, param1_val)
   subtype = subtype or -1
   cost = cost or -1
   cost_val = cost_val or -1
   param1 = param1 or -1
   param1_val = param1_val or -1

   self:SetInt(0, type)
   self:SetInt(1, subtype)
   self:SetInt(2, cost)
   self:SetInt(3, cost_val)
   self:SetInt(4, param1)
   self:SetInt(5, param1_val)
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

local function create_itemprop_eff(show_icon)
   show_icon = show_icon or 0
   local eff = itemprop_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetCreator(nwn.engine.GetCommandObject())
   eff:SetNumIntegers(9)
   eff:SetAllInts(-1)
   eff:SetInt(7, 100)
   eff:SetInt(8, 1)
   eff:SetSubType(0)
   eff:SetDurationType(nwn.DURATION_TYPE_PERMANENT)
   eff:SetTrueType(nwn.EFFECT_TRUETYPE_ITEMPROPERTY)

   return eff
end

---
-- @param
-- @param
function nwn.ItemPropertyAbilityScore(ability, bonus)
   local eff = create_itemprop_eff()

   if bonus < 0 then
      eff:SetValues(27, ability, 21, -bonus)
   else
      eff:SetValues(0, ability, 1, bonus)	    
   end
   
   return eff
end

---
-- @param
-- @param
function nwn.ItemPropertyAC(bonus, vs_type, vs)
   local args = 1
   local cmd = 617
   
   nwn.engine.StackPushInteger(bonus)
   if vs_type and vs and vs_type ~= EFFECT_VS_INVALID then
      if vs_type == EFFECT_VS_ALIGN_GRP then
         cmd = 618 
      elseif vs_type == EFFECT_VS_ALIGN then
         cmd = 621
      elseif vs_type == EFFECT_VS_RACE then
         cmd = 620
      elseif vs_type == EFFECT_VS_DMG_TYPE then
         cmd = 619 
      end
      nwn.engine.StackPushInteger(nVS)
      args = 2
   end

   return nwn.engine.CreateItemPropery(cmd, args) 
end

function nwn.ItemPropertyArcaneSpellFailure(amount)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.ExecuteCommand(758, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY)
end


---
-- @param
-- @param
function nwn.ItemPropertyEnhancementBonus(bonus, vs_type, vs)
   local cmd  = 622
   local args = 1
   nwn.engine.StackPushInteger(bonus)

   if vs_type and vs and vs_type ~= EFFECT_VS_INVALID then
      if vs_type == EFFECT_VS_ALIGN_GRP then
         cmd = 623 
      elseif vs_type == EFFECT_VS_ALIGN then
         cmd = 625
      elseif vs_type == EFFECT_VS_RACE then
         cmd = 624
      end
      nwn.engine.StackPushInteger(nVS)
      args = 2
   end
   
   return nwn.engine.CreateItemPropery(cmd, args) 
end

---
-- @param
-- @param
function nwn.ItemPropertyEnhancementPenalty(nPenalty)
   nwn.engine.StackPushInteger(nPenalty)
   return nwn.engine.CreateItemPropery( 626, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyWeightReduction(nReduction)
   nwn.engine.StackPushInteger(nReduction)
   return nwn.engine.CreateItemPropery( 627, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyBonusFeat(nFeat)
   nwn.engine.StackPushInteger(nFeat)

   return nwn.engine.CreateItemPropery( 628, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyBonusLevelSpell(class, nSpellLevel)
   nwn.engine.StackPushInteger(nSpellLevel)
   nwn.engine.StackPushInteger(class)

   return nwn.engine.CreateItemPropery( 629, 2 ) 
end

---
-- @param
-- @param
function nwn.ItemPropertyCastSpell(nSpell, nNumUses)
   nwn.engine.StackPushInteger(nNumUses)
   nwn.engine.StackPushInteger(nSpell)

   return nwn.engine.CreateItemPropery( 630, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDamageBonus(damage_type, damage, vs_type, vs)
   local cmd  = 631
   local args = 2
   
   nwn.engine.StackPushInteger(damage)
   nwn.engine.StackPushInteger(damageType)

   if vs_type and vs and vs_type ~= EFFECT_VS_INVALID then
      if vs_type == EFFECT_VS_ALIGN_GRP then
         cmd = 632
      elseif vs_type == EFFECT_VS_ALIGN then
         cmd = 634
      elseif vs_type == EFFECT_VS_RACE then
         cmd = 633
      end
      nwn.engine.StackPushInteger(nVS)
      args = 3
   end
   
   return nwn.engine.CreateItemPropery( cmd, args) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDamageImmunity(nImmuneBonus, damageType)
   nwn.engine.StackPushInteger(nImmuneBonus)
   nwn.engine.StackPushInteger(damageType)

   return nwn.engine.CreateItemPropery( 635, 2) 
end

function nwn.ItemPropertyDamagePenalty(nPenalty)
   nwn.engine.StackPushInteger(nPenalty)

   return nwn.engine.CreateItemPropery( 636, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDamageReduction(nEnhancement, nSoak)
   nwn.engine.StackPushInteger(nHPSoak)
   nwn.engine.StackPushInteger(nEnhancement)

   return nwn.engine.CreateItemPropery( 637, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDamageResistance(damageType, nResist)
   nwn.engine.StackPushInteger(nResist)
   nwn.engine.StackPushInteger(damageType)
   return nwn.engine.CreateItemPropery( 638, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDamageVulnerability(damageType, nVulnerability)
   nwn.engine.StackPushInteger(nVulnerability)
   nwn.engine.StackPushInteger(damageType)
   return nwn.engine.CreateItemPropery( 639, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDarkvision()
   return nwn.engine.CreateItemPropery( 640, 0) 
end


---
-- @param
-- @param
function nwn.ItemPropertyDecreaseAC(modifierType, nPenalty)
   nwn.engine.StackPushInteger(nPenalty)
   nwn.engine.StackPushInteger(modifierType)

   return nwn.engine.CreateItemPropery( 642, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyDecreaseSkill(nSkill, nPenalty)
   nwn.engine.StackPushInteger(nPenalty)
   nwn.engine.StackPushInteger(nSkill)
   return nwn.engine.CreateItemPropery( 643, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyContainerReducedWeight(nContainerType)
   nwn.engine.StackPushInteger(nContainerType)

   return nwn.engine.CreateItemPropery( 644, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyExtraDamageType(damageType, bRanged)
   local cmd = bRanged and 646 or 645

   nwn.engine.StackPushInteger(damageType)
   return nwn.engine.CreateItemPropery( cmd, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyHaste()
   return nwn.engine.CreateItemPropery( 647, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyHolyAvenger()
   return nwn.engine.CreateItemPropery( 648, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyImmunityMisc(nImmunityType)
   nwn.engine.StackPushInteger(nImmunityType)
   return nwn.engine.CreateItemPropery( 649, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyImprovedEvasion()
   return nwn.engine.CreateItemPropery( 650, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyBonusSpellResistance(bonus)
   nwn.engine.StackPushInteger(bonus)
   return nwn.engine.CreateItemPropery( 651, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertySavingThrowVsX(bonus_type, value)
   local cmd = 652

   if value < 0 then
      cmd = 659
      value = -value
   end

   nwn.engine.StackPushInteger(value)
   nwn.engine.StackPushInteger(bonus_type)

   return nwn.engine.CreateItemPropery( cmd, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyBonusSavingThrow(save_type, value)
   local cmd = 653

   if value < 0 then
      cmd = 660
      value = -value
   end

   nwn.engine.StackPushInteger(value)
   nwn.engine.StackPushInteger(save_type)

   return nwn.engine.CreateItemPropery( cmd, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyKeen()
   return nwn.engine.CreateItemPropery( 654, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyLight(nBrightness, nColor)
   nwn.engine.StackPushInteger(nColor)
   nwn.engine.StackPushInteger(nBrightness)
   return nwn.engine.CreateItemPropery( 655, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyMighty(modifier)
   nwn.engine.StackPushInteger(modifier)
   return nwn.engine.CreateItemPropery(656, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyNoDamage()
   return nwn.engine.CreateItemPropery(657, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyOnHitProps(nProperty, nSaveDC, nSpecial)
   nwn.engine.StackPushInteger(nSpecial)
   nwn.engine.StackPushInteger(nSaveDC)
   nwn.engine.StackPushInteger(nProperty)
   return nwn.engine.CreateItemPropery(658, 3) 
end

---
-- @param
-- @param
function nwn.ItemPropertyRegeneration(nRegenAmount)
   nwn.engine.StackPushInteger(nRegenAmount)
   return nwn.engine.CreateItemPropery(661, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertySkillBonus(nSkill, bonus)
   nwn.engine.StackPushInteger(bonus)
   nwn.engine.StackPushInteger(nSkill)
   return nwn.engine.CreateItemPropery(662, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertySpellImmunitySpecific(nSpell)
   nwn.engine.StackPushInteger(nSpell)
   return nwn.engine.CreateItemPropery(663, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertySpellImmunitySchool(nSchool)
   nwn.engine.StackPushInteger(nSchool)
   return nwn.engine.CreateItemPropery(664, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyThievesTools(modifier)
   nwn.engine.StackPushInteger(modifier)
   return nwn.engine.CreateItemPropery(655, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyAttackBonus(bonus, vs_type, vs)
   local cmd = 666
   local args = 1
   nwn.engine.StackPushInteger(bonus)

   if vs_type and vs and vs_type ~= EFFECT_VS_INVALID then
      if vs_type == EFFECT_VS_ALIGN_GRP then
         cmd = 667
      elseif vs_type == EFFECT_VS_ALIGN then
         cmd = 669 
      elseif vs_type == EFFECT_VS_RACE then
         cmd = 668
      end
      nwn.engine.StackPushInteger(nVS)
      args = 2
   end

   return nwn.engine.CreateItemPropery(cmd, args) 
end

---
-- @param
-- @param
function nwn.ItemPropertyAttackPenalty(nPenalty)
   nwn.engine.StackPushInteger(nPenalty)
   return nwn.engine.CreateItemPropery( 670, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyUnlimitedAmmo(nAmmoDamage)
   nwn.engine.StackPushInteger(nAmmoDamage or IP_CONST_UNLIMITEDAMMO_BASIC)
   return nwn.engine.CreateItemPropery(671, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyLimitUseByAlign(align_group)
   nwn.engine.StackPushInteger(align_group)
   return nwn.engine.CreateItemPropery(672, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyLimitUseByClass(class)
   nwn.engine.StackPushInteger(class)
   return nwn.engine.CreateItemPropery(673, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyLimitUseByRace(nRace)
   nwn.engine.StackPushInteger(nRace)
   return nwn.engine.CreateItemPropery(674, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyLimitUseBySAlign(nAlignment)
   nwn.engine.StackPushInteger(nAlignment)
   return nwn.engine.CreateItemPropery(675, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyVampiricRegeneration(nRegenAmount)
   nwn.engine.StackPushInteger(nRegenAmount)
   return nwn.engine.CreateItemPropery(677, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyTrap(nTrapType, nTrapLevel)
   nwn.engine.StackPushInteger(nTrapType)
   nwn.engine.StackPushInteger(nTrapLevel)
   lua_pushlightuserdata(L, pRetVal)
   return nwn.engine.CreateItemPropery( 678, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyTrueSeeing()
   return nwn.engine.CreateItemPropery(679, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyOnMonsterHitProperties(nProperty, nSpecial)
   nSpecial = nSpecial or 0
   
   nwn.engine.StackPushInteger(nSpecial)
   nwn.engine.StackPushInteger(nProperty)
   return nwn.engine.CreateItemPropery(680, 2) 
end

---
-- @param
-- @param
function nwn.ItemPropertyTurnResistance(modifier)
   nwn.engine.StackPushInteger(modifier)
   return nwn.engine.CreateItemPropery(681, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyMassiveCritical(damage)
   return nwn.engine.CreateItemPropery(682, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyFreeAction()
   return nwn.engine.CreateItemPropery(683, 0) 
end

---
-- @param
-- @param
function nwn.ItemPropertyMonsterDamage(damage)
   nwn.engine.StackPushInteger(damage)
   return nwn.engine.CreateItemPropery(684, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyImmunityToSpellLevel(level)
   nwn.engine.StackPushInteger(level)
   return nwn.engine.CreateItemPropery(685, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertySpecialWalk(nWalkType)
   nwn.engine.StackPushInteger(nWalkType)
   return nwn.engine.CreateItemPropery(686, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyHealersKit(modifier)
   nwn.engine.StackPushInteger(modifier)
   return nwn.engine.CreateItemPropery(687, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyWeightIncrease(weight)
   nwn.engine.StackPushInteger(weight)
   return nwn.engine.CreateItemPropery(688, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyMaterial(nMaterialType)
   nwn.engine.StackPushInteger(nMaterialType)
   return nwn.engine.CreateItemPropery( 845, 1) 
end

function nwn.ItemPropertyOnHitCastSpell(spell, level)
   nwn.engine.StackPushInteger(level)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(733, 2)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_ITEMPROPERTY)
end

---
-- @param
-- @param
function nwn.ItemPropertyQuality(nQuality)
   nwn.engine.StackPushInteger(nQuality)
   return nwn.engine.CreateItemPropery(846, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyAdditional(nAdditionalProperty)
   nwn.engine.StackPushInteger(nAdditionalProperty)
   return nwn.engine.CreateItemPropery( 847, 1) 
end

---
-- @param
-- @param
function nwn.ItemPropertyVisualEffect(effect)
   nwn.engine.StackPushInteger(effect)
   return nwn.engine.CreateItemPropery(739, 1) 
end
