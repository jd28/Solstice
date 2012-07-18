local socket = require 'socket'
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveMeleeAttack(attacker, target, attack_count, anim, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   if not target:GetIsValid() then return end 

   local attack_info = NSGetAttackInfo(attacker, target)
   local damage_result

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSResolveTargetState(attacker, target, attack_info)
      NSResolveSituationalModifiers(attacker, target, attack_info)
   end

   for i = 0, attack_count - 1 do
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

      NSResolveAttackRoll(attacker, target, false, attack_info)
      if NSGetAttackResult(attack_info) then
	 local start = socket.gettime() * 1000
         damage_result = NSResolveDamage(attacker, target, false, attack_info)
	 local stop  = socket.gettime() * 1000
	 print("NSResolveDamage", stop - start)
         NSResolvePostMeleeDamage(attacker, target, attack_info)
      end
      C.nwn_ResolveMeleeAnimations(attacker.obj, i, attack_count, target.obj.obj, anim)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack_info.attack.cad_special_attack ~= 0
         and NSGetAttackResult(attack_info)
      then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
	    and NSGetTotalDamage(damage_result) > 0
	 then
	    attacker:DecrementRemainingFeatUses(attack_info.attack.cad_special_attack)
	    
	    -- The resolution of Special Attacks will return an effect to be applied
	    -- or nil.
	    local success, eff = NSMeleeSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE,
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
	       -- was success full set the attack result to 5.
	       attack_info.attack.cad_attack_result = 5
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    attack_info.attack.cad_attack_result = 6
	 end
      end

      attack_info.attacker_cr.cr_current_attack = attack_info.attacker_cr.cr_current_attack + 1
      NSUpdateAttackInfo(attack_info, attacker, target)
   end
   C.nwn_SignalMeleeDamage(attacker.obj, target.obj.obj, attack_count)
end


