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

function NSResolveRangedAttack(attacker, target, attack_count, a, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   if not target:GetIsValid() or
      not attacker:GetAmmunitionAvailable(attack_count)
   then 
      --CNWSCombatRound__SetRoundPaused(*(_DWORD *)(a1 + 0xACC), 0, 0x7F000000u);
      --CNWSCombatRound__SetPauseTimer(*(_DWORD *)(a1 + 0xACC), 0, 0);
      --return (*(int (__cdecl **)(int, signed int))(*(_DWORD *)(a1 + 0xC) + 0x88))(a1, 1);
   end

   local attacks = {}
   local damage_rolls = {}

   for i = 0, attack_count - 1 do
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
         NSResolveTargetState(attacker, target, attack_info)
         NSResolveSituationalModifiers(attacker, target, attack_info)
      end

      if attack_info.attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
      end

      if attack_info.attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         if attack_info.attack.cad_special_attack < 1115 and
            attacker:GetRemainingFeatUses(attack_info.attack.cad_special_attack) == 0
         then
            attack_info.attack.cad_special_attack = 0
         end
      end

      NSResolveAttackRoll(attacker, target, nil, attack_info)
      if NSGetAttackResult(attack_info) then
         attack_info.dmg_roll = NSResolveDamage(attacker, target, false, attack_info)
         NSResolvePostRangedDamage(attacker, target, attack_info)
      else
         C.nwn_ResolveRangedMiss(attacker.obj, target.obj.obj)
      end
      C.nwn_ResolveRangedAnimations(attacker.obj, target.obj.obj, a)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack_info.attack.cad_special_attack ~= 0
         and NSGetAttackResult(attack_info)
      then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
	    and NSGetTotalDamage(attack_info.dmg_roll.result) > 0
	 then
	    attacker:DecrementRemainingFeatUses(attack_info.attack.cad_special_attack)
	    
	    -- The resolution of Special Attacks must return a boolean value indicating success and
	    -- and effect to be applied if any.
	    local success, eff = NSRangedSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE,
						       attacker, target, attack_info)
	    if success then
	       -- Check to makes sure an effect was returned.
	       if eff then
		  -- Set effect to direct so that Lua will not delete the
		  -- effect.  It will be deleted by the combat engine.
		  eff.direct = true
		  -- Add the effect to the onhit effect list so that it can
		  -- be applied when damage is signaled.
		  C.ns_AddOnHitEffect(attack_info.attack, attacker.id, eff.eff)
	       end
	    else
	       -- If the special attack failed because it wasn't
	       -- applicable or the targets skill check (for example)
	       -- was successful set the attack result to 5.
	       attack_info.attack.cad_attack_result = 5
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    attack_info.attack.cad_attack_result = 6
	 end
      end

      table.insert(attacks, attack_info)

      attack_info.attacker_cr.cr_current_attack = attack_info.attacker_cr.cr_current_attack + 1
   end
   NSSignalRangedDamage(attacker, target, attack_count, attacks)
end

