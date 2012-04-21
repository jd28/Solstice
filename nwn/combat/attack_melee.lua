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

function NSResolveMeleeAttack(attacker, target, attack_count, a, from_hook)
   local cr, current_attack, attack, attack_group
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end
   cr = attacker.obj.cre_combat_round
   current_attack = cr.cr_current_attack
   attack = C.nwn_GetAttack(cr, current_attack)
   attack_group = attack.cad_attack_group

   local damamge_rolls = {}
   
   if not target:GetIsValid() then return end   

   NSResolveTargetState(attacker, target)
   NSResolveSituationalModifiers(attacker, target)
   print(current_attack)
   for i = 0, attack_count - 1 do
      attack.cad_attack_group = attack_group
      attack.cad_target = target.id
      attack.cad_attack_mode = attacker.obj.cre_mode_combat
      attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)

      if attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
      end

      if attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         NSResolveMeleeSpecialAttack(attacker, i, attack_count, target, a)
      else
         NSResolveAttackRoll(attacker, target, nil)
         if NSGetAttackResult(attack) then
            NSResolveDamage(attacker, target, false)
            NSResolvePostMeleeDamage(attacker, target)
         end
         C.nwn_ResolveMeleeAnimations(attacker.obj, i, attack_count, target.obj.obj, a)
      end
      current_attack = current_attack + 1
      cr.cr_current_attack = current_attack
      attack = C.nwn_GetAttack(cr, current_attack)
   end
   NSSignalMeleeDamage(attacker, target, attack_count)
end


