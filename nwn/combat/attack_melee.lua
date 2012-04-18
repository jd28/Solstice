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

function NSResolveMeleeAttack(attacker, target, attack_count, a)
   if target == nwn.OBJECT_INVALID.id then return end

   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)
   
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   
   NSResolveTargetState(attacker, target)
   NSResolveSituationalModifiers(attack, target)

   for i = 0, attack_count - 1 do
      attack.cad_attack_group = attack_group
      attack.cad_target = target.obj_id
      attack.cad_attack_mode = attacker.cre_mode_combat
      attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)

      if attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker)
      end

      if attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         NSResolveMeleeSpecialAttack(attacker, i, attack_count, target, a)
      else
         ResolveAttackRoll(attacker, target, attack)
         if NSGetAttackResult(attack) then
            NSResolveDamage(attacker, target)
            NSResolvePostMeleeDamage(attacker, target)
         end
         C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, a)
      end
      current_attack = current_attack + 1
      cr.cr_current_attack = current_attack
      attack = C.nwn_GetAttack(cr, current_attack)
   end
   C.nwn_SignalMeleeDamage(attacker, target, attack_count)
end
