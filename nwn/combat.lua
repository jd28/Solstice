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
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C

--nwn.WIELD_TYPE_CREATURE
--nwn.WIELD_TYPE_SINGLE
--nwn.WIELD_TYPE_DUAL
--nwn.WIELD_TYPE_UNARMED

--nwn.COMBAT_CATEGORY_AB
--nwn.COMBAT_CATEGORY_AC
--nwn.COMBAT_CATEGORY_CONCEALMENT
--nwn.COMBAT_CATEGORY_DAMAGE
--nwn.COMBAT_CATEGORY_CRIT_MULT
--nwn.COMBAT_CATEGORY_CRIT_RANGE

nwn.COMBAT_BONUS_ABILITY = 1
nwn.COMBAT_BONUS_CLASS = 2
nwn.COMBAT_BONUS_FEAT = 3
nwn.COMBAT_BONUS_SKILL = 4
nwn.COMBAT_BONUS_MASTER_FEAT = 5
nwn.COMBAT_BONUS_SUBRACE = 6
nwn.COMBAT_BONUS_DEITY = 7
nwn.COMBAT_BONUS_MODE = 8

function nwn.RegisterCombatBonus(bonus_type, cat, id, val)
end

local COMBAT_BONUS = {}
local TRANSIENT_COMBAT_BONUS = {}

--- Register a transient combat bonus.
-- A transient combat bonus is one that must be calculated every attack.
-- @param f A function called with the attacker, target, and weapon.
--     e,g. function (attack, attacker, target, weapon) ... end
function nwn.RegisterTransientCombatBonus(f)
   table.insert(TRANSIENT_COMBAT_BONUS, f)
end

function nwn.GetAttackResult(attack_data)
   local t = attack_data.cad_attack_result

   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

--- Register a combat bonus.
-- These are combat bonuses that don't need to be calculated every round.
-- and therefor can cached and updated only when necessary.
-- @param val Integer or Function 
function nwn.RegisterCombatBonus(f)
   table.insert(TRANSIENT_COMBAT_BONUS, f)
end

---
function nwn.GetCombatBonus(obj, bonus_type, cat, id)
   local val = COMBAT_BONUS[bonus_type][id]
   if not val then return 0 end 

   if type(val) == "function" then
      return val(obj)
   elseif type(val) == "number" then
      return val
   end
end

function nwn.ApplyTransientCombatBonus(attack, attacker, target, weapon)
   for _, cb in ipairs(TRANSIENT_COMBAT_BONUS) do
      cb(attack, attacker, target, weapon)
   end
end

function NSResolveDamage ()
end

function NSResolvePostMeleeDamage(attacker, target, attack_data)
   if not target:GetIsValid() then return end

   local cr = attacker.cre_combat_round
end

function GetCurrentAttackWeapon(combat_round)

end

function GetAttackModifierVs(att_stats, target)
   local attack
   local combat_round

   local attack_type = attack.cad_weapon_type
   local attack_num = combat_round.cr_current_attack
   local weap = GetCurrentAttackWeapon(combat_round)

   local bab = attacker.ci.bab - (attack_num * weap.iter)

   local ab_clamp = nwn.GetMaxABBonus(attacker)
   local ab_abil = attacker:GetAbilityModifier(attacker.ci.ab_ability)

   is_offhand = nwn.GetOffhandAttack(cr)

   if attacker.ci.onhand and attacker.ci.onhand.id == weap.obj_id then
      weap = attacker.ci.onhand
   elseif attacker.ci.offhand.id == weap.obj_id then
      weap = attacker.ci.offhand
   elseif attacker.ci.onhand.id == weap.obj_id then
      weap = attacker.ci.onhand
   end

   -- Base Attack Bonus

   -- Offhand Attack Penalty

   -- Size Modifier

   -- Attack Mode Modifier

   -- Special Attack Modifier

   -- Area Modifier

   -- Feat Modifier

   -- Race Modifier

   -- 


   local ab_mod = weap.ab

   local trace = target:GetRacialType()
   local tgoodevil = target:GetGoodEvilValue()
   local tlawchaos = target:GetLawChaosValue()
   local tdeity_id = target:GetDeityId()
   local tsubrace_id = target:GetSubraceId()

   for i = 0, attacker.ab_mod_count - 1 do
      local add = true
      if attacker.ab_mods[i].vs_race >= 0 and
         attacker.ab_mods[i].vs_race ~= trace 
      then
         add = false
      end
      if attacker.ab_mods[i].vs_goodevil >= 0 and
         attacker.ab_mods[i].vs_goodevil ~= tgoodevil
      then
         add = false
      end
      if attacker.ab_mods[i].vs_lawchaos >= 0 and
         attacker.ab_mods[i].vs_lawchaos ~= tlawchaos
      then
         add = false
      end
      if attacker.ab_mods[i].vs_deity >= 0 and
         attacker.ab_mods[i].vs_deity ~= tdeity_id
      then
         add = false
      end
      if attacker.ab_mods[i].vs_subrace >= 0 and
         attacker.ab_mods[i].vs_subrace ~= tsubrace_id
      then
         add = false
      end

      if add then
         ab_mod = ab_mod + amount
      end

      if ab_mod > ab_clamp then
         ab_mod = ab_clamp
         break
      end
   end

   return roll + bab + ab_abil + ab_mod + attacker.ab_mode
end

function NS_RESOLVE_ATTACK_ROLL(attacker, target)
   local roll = math.random(20)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)

   local ab = 0 
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      GetAttackModifierVs(attacker.stats, target)
   end
end

function _NS_RESOLVE_MELEE_ATTACK(attacker, target, attack_count, a4)
   if target == nil then return end

   att = _NL_GET_CACHED_OBJECT(attacker.obj.obj_id)
   tar = _NL_GET_CACHED_OBJECT(target.obj_id)
   
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group

   for i = 0, attack_count - 1 do
      attack.cad_attack_group = attack_group
      attack.cad_target = target.obj_id
      attack.cad_attack_mode = attacker.cre_mode_combat
      attack.cad_weapon_type = C.nwn_GetWeaponAttackType(cr)

      if attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker)
      end

      if attack.cad_attack_type ~= 0 then
         -- Special Attack... 
      else
         ResolveAttackRoll(attacker, target, attack_data)
         if GetAttackResult(attack) then

         end
         C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, a4)
      end
      current_attack = current_attack + 1
      cr.cr_current_attack = current_attack
      attack = C.nwn_GetAttack(cr, current_attack)
   end
   C.nwn_SignalMeleeDamage(attacker, target, attack_count)
end