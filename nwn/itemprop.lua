--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local ffi = require 'ffi'
require 'nwn.ctypes.effect'

ffi.cdef [[
typedef struct Itemprop {
    CGameEffect     *eff;
    bool            direct;
} Itemprop;
]]

local itemprop_mt = { __index = Itemprop }
itemprop_t = ffi.metatype("Itemprop", itemprop_mt)

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

--- Returns the type of the itemproperty.
-- @return nwn.ITEM_PROPERTY_* or -1.
function Itemprop:GetType()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY, self)
   nwn.engine.ExecuteCommand(614, 1)

   return nwn.engine.StackPopInteger()
end

-------------------------------------------------------------------------------

EFFECT_VS_INVALID   = 0
EFFECT_VS_ALIGN     = 1
EFFECT_VS_ALIGN_GRP = 2
EFFECT_VS_RACE      = 3
EFFECT_VS_DMG_TYPE  = 4

local ip_damgebonus = {
   {[0] = nwn.IP_CONST_DAMAGEBONUS_1, [4] = nwn.IP_CONST_DAMAGEBONUS_1d4, [6] = nwn.IP_CONST_DAMAGEBONUS_1d6,
    [8] = nwn.IP_CONST_DAMAGEBONUS_1d8, [10] = nwn.IP_CONST_DAMAGEBONUS_1d10, [12] = nwn.IP_CONST_DAMAGEBONUS_1d12 }, -- 1
   {[0] = nwn.IP_CONST_DAMAGEBONUS_2, [4] = nwn.IP_CONST_DAMAGEBONUS_2d4, [6] = nwn.IP_CONST_DAMAGEBONUS_2d6,
    [8] = nwn.IP_CONST_DAMAGEBONUS_2d8, [10] = nwn.IP_CONST_DAMAGEBONUS_2d10, [12] = nwn.IP_CONST_DAMAGEBONUS_2d12 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_3, [4] = cep.IP_CONST_DAMAGEBONUS_3d4, [6] = cep.IP_CONST_DAMAGEBONUS_3d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_3d8, [10] = cep.IP_CONST_DAMAGEBONUS_3d10, [12] = cep.IP_CONST_DAMAGEBONUS_3d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_4, [4] = cep.IP_CONST_DAMAGEBONUS_4d4, [6] = cep.IP_CONST_DAMAGEBONUS_4d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_4d8, [10] = cep.IP_CONST_DAMAGEBONUS_4d10, [12] = cep.IP_CONST_DAMAGEBONUS_4d12, [20] = cep.IP_CONST_DAMAGEBONUS_4d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_5, [4] = cep.IP_CONST_DAMAGEBONUS_5d4, [6] = cep.IP_CONST_DAMAGEBONUS_5d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_5d8, [10] = cep.IP_CONST_DAMAGEBONUS_5d10, [12] = cep.IP_CONST_DAMAGEBONUS_5d12, [20] = cep.IP_CONST_DAMAGEBONUS_5d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_6, [4] = cep.IP_CONST_DAMAGEBONUS_6d4, [6] = cep.IP_CONST_DAMAGEBONUS_6d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_6d8, [10] = cep.IP_CONST_DAMAGEBONUS_6d10, [12] = cep.IP_CONST_DAMAGEBONUS_6d12, [20] = cep.IP_CONST_DAMAGEBONUS_6d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_7, [4] = cep.IP_CONST_DAMAGEBONUS_7d4, [6] = cep.IP_CONST_DAMAGEBONUS_7d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_7d8, [10] = cep.IP_CONST_DAMAGEBONUS_7d10, [12] = cep.IP_CONST_DAMAGEBONUS_7d12, [20] = cep.IP_CONST_DAMAGEBONUS_7d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_8, [4] = cep.IP_CONST_DAMAGEBONUS_8d4, [6] = cep.IP_CONST_DAMAGEBONUS_8d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_8d8, [10] = cep.IP_CONST_DAMAGEBONUS_8d10, [12] = cep.IP_CONST_DAMAGEBONUS_8d12, [20] = cep.IP_CONST_DAMAGEBONUS_8d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_9, [4] = cep.IP_CONST_DAMAGEBONUS_9d4, [6] = cep.IP_CONST_DAMAGEBONUS_9d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_9d8, [10] = cep.IP_CONST_DAMAGEBONUS_9d10, [12] = cep.IP_CONST_DAMAGEBONUS_9d12, [20] = cep.IP_CONST_DAMAGEBONUS_9d20 }, 
   {[0] = nwn.IP_CONST_DAMAGEBONUS_10, [4] = cep.IP_CONST_DAMAGEBONUS_10d4, [6] = cep.IP_CONST_DAMAGEBONUS_10d6,
    [8] = cep.IP_CONST_DAMAGEBONUS_10d8, [10] = cep.IP_CONST_DAMAGEBONUS_10d10, [12] = cep.IP_CONST_DAMAGEBONUS_10d12, [20] = cep.IP_CONST_DAMAGEBONUS_10d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_11d4, [6] = cep.IP_CONST_DAMAGEBONUS_11d6, [8] = cep.IP_CONST_DAMAGEBONUS_11d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_11d10, [12] = cep.IP_CONST_DAMAGEBONUS_11d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_12d4, [6] = cep.IP_CONST_DAMAGEBONUS_12d6, [8] = cep.IP_CONST_DAMAGEBONUS_12d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_12d10, [12] = cep.IP_CONST_DAMAGEBONUS_12d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_13d4, [6] = cep.IP_CONST_DAMAGEBONUS_13d6, [8] = cep.IP_CONST_DAMAGEBONUS_13d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_13d10, [12] = cep.IP_CONST_DAMAGEBONUS_13d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_14d4, [6] = cep.IP_CONST_DAMAGEBONUS_14d6, [8] = cep.IP_CONST_DAMAGEBONUS_14d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_14d10, [12] = cep.IP_CONST_DAMAGEBONUS_14d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_15d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_15d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_15d10, [12] = cep.IP_CONST_DAMAGEBONUS_15d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_16d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_16d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_16d10, [12] = cep.IP_CONST_DAMAGEBONUS_16d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_17d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_17d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_17d10, [12] = cep.IP_CONST_DAMAGEBONUS_17d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_18d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_18d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_18d10, [12] = cep.IP_CONST_DAMAGEBONUS_18d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_19d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_19d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_19d10, [12] = cep.IP_CONST_DAMAGEBONUS_19d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 }, 
   {[4] = cep.IP_CONST_DAMAGEBONUS_20d4, [6] = cep.IP_CONST_DAMAGEBONUS_15d6, [8] = cep.IP_CONST_DAMAGEBONUS_20d8,
    [10] = cep.IP_CONST_DAMAGEBONUS_20d10, [12] = cep.IP_CONST_DAMAGEBONUS_20d12, [20] = cep.IP_CONST_DAMAGEBONUS_3d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_21d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_22d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_23d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_24d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_25d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_26d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_27d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_28d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_29d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_30d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_31d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_32d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_33d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_34d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_35d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_36d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_37d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_38d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_39d20 },
   {[20] = cep.IP_CONST_DAMAGEBONUS_40d20 }
}

---
function nwn.GetIPDamageBonusConst(sides, dice)
   dice = dice or 0
   local const = ip_damagebonus[sides][dice]
   if not const then 
      error "Invalid Damage Bonus"
      return 
   end

   return const
end

---
-- @param
-- @param
function nwn.ItemPropertyAbilityScore(ability, bonus)
   local cmd = 616

   if bonus < 0 then
      cmd = 641
      bonus = -bonus
   end
   
   nwn.engine.StackPushInteger(bonus)
   nwn.engine.StackPushInteger(ability)
   return nwn.engine.CreateItemPropery(cmd, 2)
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
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_ITEMPROPERTY)
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
