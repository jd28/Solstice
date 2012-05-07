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

local ATTACK_ID = 1

function NSGetAttackInfo(attacker, target)
   local attack_info = attack_info_t()
   attack_info.attacker_cr = attacker.obj.cre_combat_round
   attack_info.current_attack = attack_info.attacker_cr.cr_current_attack
   attack_info.attacker = attacker.id
   attack_info.target = target.id
   attack_info.attack_id = ATTACK_ID
   ATTACK_ID = ATTACK_ID + 1
   attack_info.attack = C.nwn_GetAttack(attack_info.attacker_cr, attack_info.current_attack)
   attack_info.attack.cad_attack_group = attack_info.attack.cad_attack_group
   attack_info.attack.cad_target = target.id
   attack_info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   attack_info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(attack_info.attacker_cr)
   attack_info.is_offhand = NSGetOffhandAttack(attack_info.attacker_cr)

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack_info.target_cr = target.obj.cre_combat_round
   end

   return attack_info
end

function NSResolveMeleeAttack(attacker, target, attack_count, anim, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end
   if not target:GetIsValid() then return end 

   local attacks = {}

   for i = 0, attack_count - 1 do
      local attack_info = NSGetAttackInfo(attacker, target)

      if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
         NSResolveTargetState(attacker, target, attack_info)
         NSResolveSituationalModifiers(attacker, target, attack_info)
      end

      if attack_info.attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
      end

      if attack_info.attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         if attack_info.attack.cad_special_attack < 1115 and
            attacker:GetRemainingFeatUses(attack.cad_special_attack) == 0
         then
            attack_info.attack.cad_special_attack = 0
         end
      end

      NSResolveAttackRoll(attacker, target, false, attack_info)
      if NSGetAttackResult(attack_info) then
         attack_info.dmg_roll = NSResolveDamage(attacker, target, false, attack_info)
         NSResolvePostMeleeDamage(attacker, target, attack_info)
      end
      C.nwn_ResolveMeleeAnimations(attacker.obj, i, attack_count, target.obj.obj, anim)

      if attack_info.attack.cad_special_attack ~= 0
         and NSGetAttackResult(attack_info) then
         attacker:DecrementRemainingFeatUses(attack_info.attack.cad_special_attack)
         NSMeleeSpecialAttack(attack_info.attack.cad_special_attack, 0, attacker, target, attack_info.attack)
      end

      table.insert(attacks, attack_info)

      attack_info.attacker_cr.cr_current_attack = attack_info.attacker_cr.cr_current_attack + 1
   end
   NSSignalMeleeDamage(attacker, target, attack_count, attacks)
end


