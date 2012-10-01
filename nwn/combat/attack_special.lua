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

function NSResolveSpecialAttackAttackBonus(attacker, target, attack_info)
   return NSMeleeSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_AB, attacker, target, attack_info) or 0
end

function NSResolveSpecialAttackDamageBonus(attacker, target, attack_info)
   local dice, sides, bonus = 
      NSMeleeSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_DAMAGE, attacker, target, attack_info)
end

function NSResolveMeleeSpecialAttack(attacker, attack_in_grp, attack_count, target, a)
   if not target:GetIsValid() then return end
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   local sa = attack.cad_special_attack

   if attack.cad_special_attack < 1115 and
      attacker:GetFeatRemaintingUses(attack.cad_special_attack) == 0
   then
      attack.cad_special_attack = 0
   end

   NSResolveAttackRoll(attacker, target, attack)
   if NSGetAttackResult(attack) then
      NSResolveDamage(attacker, target)
      NSResolvePostMeleeDamage(attacker, target)
   end
   C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, a)

   if not nwn.GetAttackResult(attack) then return end
   
   attacker:DecrementFeatRemaintingUses(attack.cad_special_attack)
   NSMeleeSpecialAttack(attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, attack)
end

function NSResolveRangedSpecialAttack(attacker, attack_in_grp, attack_count, target, a)
   if not target:GetIsValid() then return end
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   local sa = attack.cad_special_attack

   if attack.cad_special_attack < 1115 and
      attacker:GetFeatRemaintingUses(attack.cad_special_attack) == 0
   then
      attack.cad_special_attack = 0
   end

   ResolveAttackRoll(attacker, target, attack)
   if NSGetAttackResult(attack) then
      NSResolveDamage(attacker, target)
      NSResolvePostRangedDamage(attacker, target)
   end
   C.nwn_ResolveRangedAnimations(attacker.obj, target.obj.obj, a)

   if not nwn.GetAttackResult(attack) then return end
   
   attacker:DecrementFeatRemaintingUses(attack.cad_special_attack)
   NSRangedSpecialAttack(attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, attack)
end