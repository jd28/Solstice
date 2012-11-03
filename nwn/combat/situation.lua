local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveSituationalModifiers(attacker, target, attack_info)
   local flags = 0
   local x = attacker.obj.obj.obj_position.x - target.obj.obj.obj_position.x
   local y = attacker.obj.obj.obj_position.y - target.obj.obj.obj_position.y
   local z = attacker.obj.obj.obj_position.z - target.obj.obj.obj_position.z

   attacker.ci.target_distance = x ^ 2 + y ^ 2 + z ^ 2

   -- Save some time by not sqrt'ing to get magnitude
   if attacker.ci.target_distance <= 100 then
      -- Coup De Grace
      if NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_ASLEEP)
         and target:GetHitDice() <= NS_OPT_COUPDEGRACE_MAX_LEVEL
      then
         flags = bit.bor(flags, nwn.SITUATION_COUPDEGRACE)
      end

      -- In order for a sneak attack situation to be possiblle the attacker must
      -- be able to do some amount of sneak damage.
      local death = attacker.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg.dice > 0
         or attacker.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg.bonus > 0
      
      local sneak = attacker.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg.dice > 0
         or attacker.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg.bonus > 0

      -- Sneak Attack & Death Attack
      if (sneak or death) and
	 (NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
          or NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_FLATFOOTED)
          or NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_FLANKED))
      then
	 if not target:GetIsImmuneToSneakAttack(attacker) then
	    -- Death Attack.  If it's a Death Attack it's also a sneak attack.
	    if death then
	       flags = bit.bor(flags, nwn.SITUATION_FLAG_DEATH_ATTACK)
	       flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
	    end

	    -- Sneak Attack
	    if sneak then
	       flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
	    end
	 else
	    -- Send target immune to sneaks.
	    NSAddCombatMessageData(attack_info, nil, { target.id }, { 134 })
	 end
      end 
   end
   attacker.ci.situational_flags = flags
   attack_info.situational_flags = flags
end