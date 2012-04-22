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
local bit = require 'bit'

function NSResolveDeflectArrow(attacker, target, hit, attack_info)
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end
   -- Deflect Arrow
   if hit 
      and attack_info.attacker_cr.cr_deflect_arrow == 1
      and attack_info.attack.cad_ranged_attack ~= 0
      and bit.band(attacker.ci.target_state, nwn.COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(nwn.FEAT_DEFLECT_ARROWS)
   then
      local on = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      local off = target:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)

      if not on:GetIsValid()
         or (target:GetRelativeWeaponSize(on) <= 0
             and not on:GetIsRangedWeapon()
             and not off:GetIsValid())
      then
         on = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         on = on:GetBaseType()
         local bow
         if on ~= nwn.BASE_ITEM_DART 
            and on ~= nwn.BASE_ITEM_THROWINGAXE 
            and on ~= nwn.BASE_ITEM_SHURIKEN
         then
            bow = 0
         else
            bow = 1
         end
         local v = vector_t(target.obj.obj.obj_position.x,
                            target.obj.obj.obj_position.y,
                            target.obj.obj.obj_position.z)

         C.nwn_CalculateProjectileTimeToTarget(attacker.obj, v, bow)
         attack_info.attacker_cr.cr_deflect_arrow = 0
         attack_info.attack.cad_attack_result = 2
         attack_info.attack.cad_attack_deflected = 1
         return true
      end
   end
   return false
end

function NSResolveParry(attacker, target, hit, attack_info)
   if attack_info.attack.cad_attack_roll == 20
      or attacker.obj.cre_mode_combat ~= nwn.COMBAT_MODE_PARRY
      or attack_info.attacker_cr.cr_parry_actions == 0
      or attack_info.attacker_cr.cr_round_paused ~= 0
      or attack_info.attack.cad_ranged_attack ~= 0
   then
      return false
   end
   
   -- Can not Parry when using a Ranged Weapon.
   local on = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   if on:GetIsValid() and on:GetIsRangedWeapon() then
      return false
   end

   local roll = math.random(20) + target:GetSkillRank(nwn.SKILL_PARRY)
   attack_info.target_cr.cr_parry_actions = attack_info.target_cr.cr_parry_actions - 1

   if roll >= attack_info.attack.cad_attack_roll + attack_info.attack.cad_attack_mod then
      if roll - 10 >= attack_info.attack.cad_attack_roll + attack_info.attack.cad_attack_mod then
         target:AddParryAttack(attacker)
      end
      attack_info.attack.cad_attack_result = 2
      return true
   end

   C.nwn_AddParryIndex(attack_info.target_cr)
   return false
end