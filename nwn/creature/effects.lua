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
local C = ffi.C

--- Versus Info ctype
-- @name VersusInfo
-- @field race Test
-- @field goodevil Test
-- @field lawchaos Test
-- @field deity_id Test
-- @field subrace_id Test
-- @field obj_id Test
ffi.cdef[[
typedef struct VersusInfo {
   int32_t race;
   int32_t goodevil;
   int32_t lawchaos;
   int32_t deity_id;
   int32_t subrace_id;
   uint32_t target;
} VersusInfo;
]]

ffi.cdef[[
typedef struct EffectInfo {
   int32_t index;
   int32_t type_dec;
   int32_t type_inc;
   bool stack;
   bool item_stack;
   bool spell_stack;
} EffectInfo;
]]

versus_info_t = ffi.typeof("VersusInfo")
effect_info_t = ffi.typeof("EffectInfo")

--- Get creatures concealment
-- @param vs Creatures attacker, if any.
-- @param attack CNWSCombatAttackData ctype (Default: nil).  This parameter
--    should only ever be passed from the combat engine.
function Creature:GetConcealment(vs, attack)
   local race, lawchaos, goodevil, subrace, deity, target
   local amount

   local total = 0
   local eff_type

   -- Self-Conceal Feats
   local feat = self:GetHighestFeatInRange(nwn.FEAT_EPIC_SELF_CONCEALMENT_10,
                                           nwn.FEAT_EPIC_SELF_CONCEALMENT_50)

   if feat ~= -1 then
      total = (feat - nwn.FEAT_EPIC_SELF_CONCEALMENT_10 + 1) * 10
   end
   
   local vs_info
   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
   end


   local valid = false
   local pass = false

   for i = self.stats.cs_first_conceal_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_CONCEALMENT then
         break
      end
      
      amount    = self.obj.obj.obj_effects[i].eff_integers[0]
      race      = self.obj.obj.obj_effects[i].eff_integers[1]
      lawchaos  = self.obj.obj.obj_effects[i].eff_integers[2]
      goodevil  = self.obj.obj.obj_effects[i].eff_integers[3]
      miss_type = self.obj.obj.obj_effects[i].eff_integers[4]
      subrace   = self.obj.obj.obj_effects[i].eff_integers[5]
      deity     = self.obj.obj.obj_effects[i].eff_integers[6]
      target    = self.obj.obj.obj_effects[i].eff_integers[7]
      valid     = false
      pass      = false
            
      if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
         or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
         or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
      then
         valid = true
      end

      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
      then
         if eff_type == nwn.EFFECT_TRUETYPE_MISS_CHANCE then
            if amount == 2 
               and bit.band(self.obj.cre_vision_type, 2) == 0
               and bit.band(self.obj.cre_vision_type, 4) == 0
            then
               total = 50
               pass = true
            elseif amount ~= 2
               and bit.band(self.obj.cre_vision_type, 1) == 0
               and bit.band(self.obj.cre_vision_type, 4) == 0
            then
               total = 50
               pass = true
            end
         end
         if not pass
            and eff_type == nwn.EFFECT_TRUETYPE_CONCEALMENT 
            and total > amount
         then
            if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
               or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
               or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
            then
               total = amount
            end
         end
      end
   end
   return total
end

--- Get creatures attack bonus from effects/weapons.
-- @param vs Creatures target
-- @param attack_type Current attack type.  See nwn.ATTACK_TYPE_*
function Creature:GetEffectAttackBonus(vs, attack_type)
   local function valid(eff, vs_info)
      local atk_type  = eff.eff_integers[1]
      local race      = eff.eff_integers[2]
      local lawchaos  = eff.eff_integers[3]
      local goodevil  = eff.eff_integers[4]
      local subrace   = eff.eff_integers[5]
      local deity     = eff.eff_integers[6]
      local vs        = eff.eff_integers[7]
      local valid     = false

      if atk_type == nwn.ATTACK_BONUS_MISC or atk_type == attack_type then
         valid = true
      elseif attack_type == 6 and (atk_type == nwn.ATTACK_BONUS_ONHAND or nwn.ATTACK_BONUS_CWEAPON1) then
         valid = true
      elseif attack_type == 8 and atk_type == nwn.ATTACK_BONUS_UNARMED then
         valid = true
      end

      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (vs == 0 or vs == vs_info.target)
      then
         return true
      end
      return false
   end

   local function range(type)
      if type > nwn.EFFECT_TRUETYPE_ATTACK_DECREASE
         or type < nwn.EFFECT_TRUETYPE_ATTACK_INCREASE
      then
         return false
      end
      return true
   end


   local function get_amount(eff)
      return eff.eff_integers[1]
   end

   local info = effect_info_t(self.stats.cs_first_ab_eff, 
                              nwn.EFFECT_TRUETYPE_ATTACK_DECREASE,
                              nwn.EFFECT_TRUETYPE_ATTACK_INCREASE,
                              NS_OPT_EFFECT_AB_STACK, 
			      NS_OPT_EFFECT_AB_STACK_GEAR, 
			      NS_OPT_EFFECT_AB_STACK_SPELL)

   return math.clamp(self:GetTotalEffectBonus(vs, info, range, valid, get_amount),
                     0, self:GetMaxAttackBonus())
end

--- Get armor class from effects/equips.
-- @oaran vs Creatures attacker
-- @param touch Is touch attack (Default: false).
function Creature:GetEffectArmorClassBonus(vs, touch)
   local race, lawchaos, goodevil, subrace, deity, target
   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge = 0, 0, 0, 0, 0
   local eff_nat_neg, eff_armor_neg, eff_shield_neg, eff_deflect_neg = 0, 0, 0, 0
   local eff_type, damage, ac_type

   local dmg_flags = 0

   local vs_info
   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
      dmg_flags = vs:GetDamageFlags()
   end

   local valid = false
   for i = self.stats.cs_first_ac_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_AC_DECREASE then
         break
      end

      ac_type  = self.obj.obj.obj_effects[i].eff_integers[0]
      amount   = self.obj.obj.obj_effects[i].eff_integers[1]
      race     = self.obj.obj.obj_effects[i].eff_integers[2]
      lawchaos = self.obj.obj.obj_effects[i].eff_integers[3]
      goodevil = self.obj.obj.obj_effects[i].eff_integers[4]
      damage   = self.obj.obj.obj_effects[i].eff_integers[5]
      subrace  = self.obj.obj.obj_effects[i].eff_integers[6]
      deity    = self.obj.obj.obj_effects[i].eff_integers[7]
      target   = self.obj.obj.obj_effects[i].eff_integers[8]
      valid    = false

      if damage == nwn.AC_VS_DAMAGE_TYPE_ALL 
         or bit.band(dmg_flags, damage) ~= 0
      then
         valid = true
      end

      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
      then
         if eff_type == nwn.EFFECT_TRUETYPE_AC_DECREASE then
            if ac_type == nwn.AC_DODGE_BONUS then
               eff_dodge = eff_dodge - amount
            elseif not touch then
               if ac_type == nwn.AC_NATURAL_BONUS then
                  if amount > eff_nat_neg then
                     eff_nat_neg = amount
                  end
               elseif ac_type == nwn.AC_ARMOUR_ENCHANTMENT_BONUS then
                  if amount > eff_armor_neg then
                     eff_armor_neg = amount
                  end
               elseif ac_type == nwn.AC_SHIELD_ENCHANTMENT_BONUS then
                  if amount > eff_shield_neg then
                     eff_shield_neg = amount
                  end
               elseif ac_type == nwn.AC_DEFLECTION_BONUS then
                  if amount > eff_deflect_neg then
                     eff_deflect_neg = amount
                  end
               end
            end
         elseif eff_type == nwn.EFFECT_TRUETYPE_AC_INCREASE then
            if ac_type == nwn.AC_DODGE_BONUS then
               eff_dodge = eff_dodge + amount
            elseif not touch then
               if ac_type == nwn.AC_NATURAL_BONUS then
                  if amount > eff_nat then
                     eff_nat = amount
                  end
               elseif ac_type == nwn.AC_ARMOUR_ENCHANTMENT_BONUS then
                  if amount > eff_armor then
                     eff_armor = amount
                  end
               elseif ac_type == nwn.AC_SHIELD_ENCHANTMENT_BONUS then
                  if amount > eff_shield then
                     eff_shield = amount
                  end
               elseif ac_type == nwn.AC_DEFLECTION_BONUS then
                  if amount > eff_deflect then
                     eff_deflect = amount
                  end
               end
            end
         end 
      end
   end
   return (eff_nat - eff_nat_neg),
          (eff_armor - eff_armor_neg),
          (eff_shield - eff_shield_neg),
          (eff_deflect - eff_deflect_neg),
          eff_dodge
end

--- Get effect bonus from critical hit multiplier.
-- @param vs Creature's target.
function Creature:GetEffectCritMultBonus()
   local amount, percent
   local eff_type
   local total = 0

   for i = self.ci.first_cm_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_CUSTOM or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE)
      then
         break
      end

      eff_type = self.obj.obj.obj_effects[i].eff_integers[0]
      amount   = self.obj.obj.obj_effects[i].eff_integers[1]
      percent  = self.obj.obj.obj_effects[i].eff_integers[2]

      if eff_type == nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE then
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      else
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      end
   end
   return total
end

--- Get effect bonus from critical range multiplier.
-- @param vs Creature's target
function Creature:GetEffectCritRangeBonus()
   local amount, percent
   local total = 0

   for i = self.ci.first_cr_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_CUSTOM or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_DECREASE)
      then
         break
      end

      eff_type = self.obj.obj.obj_effects[i].eff_integers[0]
      amount   = self.obj.obj.obj_effects[i].eff_integers[1]
      percent  = self.obj.obj.obj_effects[i].eff_integers[2]

      if eff_type == nwn.EFFECT_CUSTOM_CRIT_RANGE_DECREASE then
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      else
	 if math.random(100) <= percent then
	    total = total + amount
	 end
      end 
   end
   return total
end

--- Get Hitpoint bonus from effects.
function Creature:GetEffectHitpointBonus()
   local eff_hp = 0
   for eff in self:EffectsDirect() do
      local type = eff:GetTrueType()
      if type > nwn.EFFECT_TRUETYPE_CUSTOM then
	 break
      end
      if type == nwn.EFFECT_CUSTOMTYPE_HITPOINTS then
	 eff_hp = math.max(eff_hp, eff.eff.eff_integers[1])
      end
   end
   return eff_hp
end

--- Determine if creature has an immunity.
-- @param vs Creature's attacker.
-- @param imm_type nwn.IMMUNITY_TYPE_*
function Creature:GetEffectImmunity(vs, imm_type)
   local race, lawchaos, goodevil, subrace, deity, immunity, percent
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id, target

   local total = 0
   local eff_type

   local vs_info
   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
   end

   for i = self.stats.cs_first_imm_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_IMMUNITY then
         break
      end
      
      immunity  = self.obj.obj.obj_effects[i].eff_integers[0]
      race      = self.obj.obj.obj_effects[i].eff_integers[1]
      lawchaos  = self.obj.obj.obj_effects[i].eff_integers[2]
      goodevil  = self.obj.obj.obj_effects[i].eff_integers[3]
      percent   = self.obj.obj.obj_effects[i].eff_integers[4]
      subrace   = self.obj.obj.obj_effects[i].eff_integers[5]
      deity     = self.obj.obj.obj_effects[i].eff_integers[6]
      target    = self.obj.obj.obj_effects[i].eff_integers[6]
            
      if immunity == imm_type
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
      then
         total = total + percent
      end
   end

   if total >= 100 then 
      return true
   elseif total <= 0 then
      return false
   elseif total > math.random(100) then
      return true
   end

   return false
end

--- Determins if creature has a feat effect.
-- @param nwn.FEAT_*
function Creature:GetHasFeatEffect(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then 
      error "Invalid feat."
      return false 
   end
   return self:GetHasSpellEffect(f.feat_spell_id)
end

--- Determins if target is invisible.
-- @param vs Creature to test again.
function Creature:GetIsInvisible(vs)
   if vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, vs.obj.obj)
   end

   return false
end

--- Gets innate damage immunity.
-- @param dmg_idx damage type index
function Creature:GetDamageImmunity(dmg_idx)
   return self.ci.immunity[dmg_idx]
end

--- Gets innate damage immunity.
function Creature:GetInnateDamageReduction()
   return self.ci.soak
end

--- Get innate/feat damage resistance.
-- @param dmg_idx
function Creature:GetInnateDamageResistance(dmg_idx)
   return self.ci.resist[dmg_idx]
end

--- Get if creature has immunity.
-- @param immunity nwn.IMMUNITY_TYPE_*
-- @param versus (Default: nwn.OBJECT_INVALID)
function Creature:GetIsImmune(immunity, versus)
   versus = versus or nwn.OBJECT_INVALID
   return self:GetEffectImmunity(versus, immunity)
end

--- Get creatures miss chance
-- @param attack CNWSCombatAttackData ctype (Default: nil).  This parameter
--    should only ever be passed from the combat engine.
function Creature:GetMissChance(attack)
   local total = 0
   local eff_type, amount, miss_type

   for i = self.stats.cs_first_misschance_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_MISS_CHANCE then
         break
      end
      
      amount    = self.obj.obj.obj_effects[i].eff_integers[0]
      miss_type = self.obj.obj.obj_effects[i].eff_integers[1]

      if eff_type == nwn.EFFECT_TRUETYPE_MISS_CHANCE
         and amount > total
      then
         if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
            or (miss_type == nwn.MISS_CHANCE_TYPE_DARKNESS and bit.band(self.obj.cre_vision_type, 2) ~= 0 )
            or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
            or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
         then
            total = amount
         end
      end
   end
   return total
end

--- Deterimines total effect bonus for a particular type.
-- @param vs Versus target, if any.
-- @param eff_info EffectInfo ctype
-- @param range_check Function that takes effect type and determines if the current effect
--    is in the proper range.
-- @param validity_check Function that takes the effect and a VersusInfo ctype to determine if the
--    effect is applicable versus the target passed in vs.
-- @param get_amount Function which takes the effect and returns it's respective 'amount' which 
--    differs depending on effect type.
function Creature:GetTotalEffectBonus(vs, eff_info, range_check, validity_check, get_amount)
   local total = 0
   local eff_type, vs_info, eff_creator, eff, amount

   if not vs then
      print(debug.traceback())
   end

   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
   end

   local bonus = {}
   local pen = {}

   local spell_bonus, item_bonus, spell_pen, item_pen
   if not spell_stack then
      spell_bonus = {}
      spell_pen = {}
   end

   if not item_stack then
      item_bonus = {}
      item_pen = {}
   end

   for i = eff_info.index, self.obj.obj.obj_effects_len - 1 do
      eff = self.obj.obj.obj_effects[i]
      eff_type = eff.eff_type

      amount = get_amount(eff)

      -- If the effect is not in the effect type range then there is nothing left to do.
      if not range_check(eff_type) then break end

      -- Check if this effect is applicable versus the target.
      if validity_check(eff, vs_info) then
         if eff_type == eff_info.type_dec then
            -- If effects from items do not stack and the effect was applied by an item,
            -- find the highest applying
            if not item_stack and not C.nwn_GetItemById(eff.eff_creator) == nil then
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the bonus.
               if not item_pen[eff.eff_creator] then
                  item_pen[eff.eff_creator] = math.max(item_pen[eff.eff_creator], amount)
               else
                  item_pen[eff.eff_creator] = amount
               end
            -- If spells do not stack and the effect was applied via a spell, find the hightest
            -- applying
            elseif not spell_stack and eff.eff_spellid ~= -1 then
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the bonus.
               if not spell_pen[eff.eff_creator] then
                  spell_pen[eff.eff_spellid] = math.max(spell_pen[eff.eff_spellid], amount)
               else
                  spell_pen[eff.eff_spellid] = amount
               end
            else
               table.insert(pen, amount)
            end
         elseif eff_type == eff_info.type_inc then
            -- If effects from items do not stack and the effect was applied by an item,
            -- find the highest applying
            if not item_stack and not C.nwn_GetItemById(eff.eff_creator) == nil then 
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if not item_bonus[eff.eff_creator] then
                  item_bonus[eff.eff_creator] = math.max(item_bonus[eff.eff_creator], amount)
               else
                  item_bonus[eff.eff_creator] = amount
               end
            -- If spells do not stack and the effect was applied via a spell, find the hightest
            -- applying
            elseif not spell_stack and eff.eff_spellid ~= -1 then
               -- If the effect was applied by a spell and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if not spell_bonus[eff.eff_creator] then
                  spell_bonus[eff.eff_spellid] = math.max(spell_bonus[eff.eff_spellid] or 0, amount)
               else
                  spell_bonus[eff.eff_spellid] = amount
               end
            else
               table.insert(bonus, amount)
            end
         end
      end
   end

   local total = 0
   local total_pen = 0

   for _, amount in ipairs(bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end
   
   for _, amount in ipairs(spell_bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end

   for _, amount in ipairs(item_bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end

   for _, amount in ipairs(pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end

   for _, amount in ipairs(spell_pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end

   for _, amount in ipairs(item_pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end
   
   return total - total_pen
end

--- Update creature's damage resistance
-- Loops through creatures resistance effects and determines what the highest
-- applying effect is vs any particular damage.
function Creature:UpdateDamageResistance()
   local eff_type, amount, dmg_flg, idx
   local cur_eff

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      self.ci.eff_resist[i] = -1
   end

   for i = self.stats.cs_first_dresist_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_RESISTANCE then
         break
      end

      dmg_flag = self.obj.obj.obj_effects[i].eff_integers[0]
      amount = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if dmg_flag > 0 then
         idx = nwn.GetDamageIndexFromFlag(dmg_flag)
         cur_eff = self.ci.eff_resist[idx]
         if cur_eff < 0 then
            self.ci.eff_resist[idx] = i
         else
            local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[1]
            local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
            
            -- If the resist amount is higher, set the resist effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount 
               or (amount == camount and limit > climit)
            then
               self.ci.eff_resist[idx] = i
            end
         end
      end
   end
end

--- Update creature's damage reduction
-- Loops through creatures DR effects and determines what the highest
-- applying effect is at each damage power.
function Creature:UpdateDamageReduction()
   local eff_type, amount, dmg_power, dur_type, limit
   local cur_eff
   
   -- Reset the soak effect index list.
   for i = 0, 20 do
      self.ci.eff_soak[i] = -1
   end

   for i = self.stats.cs_first_dred_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      -- 
      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_REDUCTION then
         break
      end

      amount = self.obj.obj.obj_effects[i].eff_integers[0]
      dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]
      
      cur_eff = self.ci.eff_soak[dmg_power]
      if cur_eff < 0 then
         self.ci.eff_soak[dmg_power] = i
      else
         local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[0]
         local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
         
         -- If the soak amount is higher, set the soak effect list to the effect index.
         -- If they are equal prefer the one with the highest damage limit.
         if amount > camount 
            or (amount == camount and limit > climit)
         then
            self.ci.eff_soak[dmg_power] = i
         end
      end
   end
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Internal GetEffectImmunity function.
-- Called from the nwnx_solstice plugin.
-- @param cre Creature to test for immunity.
-- @param vs Creature to test versus.
-- @param imm_type nwn.IMMUNITY_TYPE_*
function NSGetEffectImmunity(cre, vs, imm_type)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)
   return cre:GetEffectImmunity(vs, imm_type)
end

--- Internal SetDamageImmunity function.
-- Called from the nwnx_solstice plugin.
-- @param obj Object
-- @param dmg_flag nwn.DAMAGE_TYPE_*
-- @param amount Immunity percent.
function NSSetDamageImmunity(obj, dmg_flag, amount)
   obj = _NL_GET_CACHED_OBJECT(obj)
   local idx = nwn.GetDamageIndexFromFlag(dmg_flag)
   if obj.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      obj.ci.immunity[idx] = amount
   end
end
