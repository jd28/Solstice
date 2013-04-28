local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

--- Get creature's arcane spell failure.
function Creature:GetArcaneSpellFailure()
   if not self:GetIsValid() then return 0 end
   local amt = self.stats.cs_arcane_sp_fail_2 + self.stats.cs_arcane_sp_fail_1 + self.stats.cs_arcane_sp_fail_3
   return math.clamp(amt, 0, 100)
end

--- Get creature's attack target
function Creature:GetAttackTarget()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local obj = cre.obj.cre_attack_target
   return _NL_GET_CACHED_OBJECT(obj)
end

--- Get creature's attempted attack target
function Creature:GetAttemptedAttackTarget()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end

   nwn.engine.ExecuteCommand(361, 0)
   return nwn.engine.StackPopObject()
end

--- Get creature's attempted spell target
function Creature:GetAttemptedSpellTarget()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end

   nwn.engine.ExecuteCommand(375, 0)
   return nwn.engine.StackPopObject()
end

--- Get creature's challenge rating
function Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_cr
end

--- Get creature's combat mode
function Creature:GetCombatMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_mode_combat
end

--- Get creature's damage flags.
function Creature:GetDamageFlags()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetDamageFlags(self.obj)
end

--- Get creatures attacker.
function Creature:GetGoingToBeAttackedBy()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end

   local obj = self.obj.cre_attacker
   return _NL_GET_CACHED_OBJECT(obj)
end

--- Determines if creature is immune to critical hits.
-- @param attacker Attacker
function Creature:GetIsImmuneToCriticalHits(attacker)
   if self:GetRacialType() == nwn.RACIAL_TYPE_UNDEAD
      or self:GetEffectImmunity(attacker, nwn.IMMUNITY_TYPE_CRITICAL_HIT)
      or self:GetHasFeat(nwn.FEAT_DEATHLESS_MASTERY)
   then
      return true
   end
   return false
end

--- Determines if creature is immune to sneak/death attacks.
--    Ignores immunity to critical hits.
-- @param attacker Attacker
function Creature:GetIsImmuneToSneakAttack(attacker)
   if self:GetRacialType() == nwn.RACIAL_TYPE_UNDEAD
      or self:GetEffectImmunity(attacker, nwn.IMMUNITY_TYPE_BACKSTAB)
      or self:GetHasFeat(nwn.FEAT_DEATHLESS_MASTERY)
   then
      return true
   end
   return false
end

--- Determines if creature is in combat.
function Creature:GetIsInCombat()
   if not self:GetIsValid() then return false end
   return self.obj.cre_combat_state ~= 0
end

--- Determines if creature is visible to another creature.
-- @param target Target to test.
function Creature:GetIsVisibile(target)
   if not self:GetIsValid() then return false end
   return C.nwn_GetIsVisible(self.obj, target.id)
end

--- Get's last attack type used by creature.
function Creature:GetLastAttackType()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_type
end

--- Get's last attack mode used by creature.
function Creature:GetLastAttackMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_mode
end

--- Get's last trap detected by creature.
function Creature:GetLastTrapDetected()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local obj = cre.obj.cre_last_trap_detected
   return _NL_GET_CACHED_OBJECT(obj)
end

--- Get's last weapon used by creature.
function Creature:GetLastWeaponUsed()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local obj = self.obj.obj.obj_last_attack_weapon
   return _NL_GET_CACHED_OBJECT(obj)
end

--- Determines creatures maximum attack range.
-- @param target Target to attack
function Creature:GetMaxAttackRange(target)
   return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

--- Determines reflex saved damage adjustment.
-- @param damage Total damage.
-- @param dc Difficulty class
-- @param savetype nwn.SAVING_THROW_TYPE_*
-- @param versus Creature to roll against.
function Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   nwn.engine.StackPushObject(versus)
   nwn.engine.StackPushInteger(savetype)
   nwn.engine.StackPushInteger(dc)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(damage)
   nwn.engine.ExecuteCommand(299, 5)
   return nwn.engine.StackPopInteger()
end

--- Determines turn resistance hit dice.
function Creature:GetTurnResistanceHD()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(478, 1)
   nwn.engine.StackPopInteger()
end

--- Restores a creature's base number of attacks.
function Creature:RestoreBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(756, 1)
end

--- Sets a creature's base number of attacks.
-- @param amount Amount of attacks.
function Creature:SetBaseAttackBonus(amount)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.ExecuteCommand(755, 2)
end

--- Causes all creatures in a 10 meter (1 tile) radius to stop actions.
-- Improves the creature's reputation with nearby enemies for 3 minutes. Only works for NPCs.
function Creature:SurrenderToEnemies()
   nwn.engine.ExecuteCommand(476, 0);
end

--- Resolve situational attack state.
-- @param target Attack target
-- @param attack Optional.  Only needs to be passed by Solstice combat engine
--    in order to send an Immune to Death/Sneaks message.
function Creature:ResolveSituationalModifiers(target, attack)
   if not target:GetIsValid() then return 0 end

   local flags = 0
   local x = self.obj.obj.obj_position.x - target.obj.obj.obj_position.x
   local y = self.obj.obj.obj_position.y - target.obj.obj.obj_position.y
   local z = self.obj.obj.obj_position.z - target.obj.obj.obj_position.z

   self.ci.target_distance = x ^ 2 + y ^ 2 + z ^ 2

   -- Save some time by not sqrt'ing to get magnitude
   if self.ci.target_distance <= 100 then
      -- Coup De Grace
      if self:CheckTargetState(nwn.COMBAT_TARGET_STATE_ASLEEP)
         and target:GetHitDice() <= NS_OPT_COUPDEGRACE_MAX_LEVEL
      then
         flags = bit.bor(flags, nwn.SITUATION_COUPDEGRACE)
      end

      -- In order for a sneak attack situation to be possiblle the attacker must
      -- be able to do some amount of sneak damage.
      local death = self.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg.dice > 0
         or self.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg.bonus > 0
      
      local sneak = self.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg.dice > 0
         or self.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg.bonus > 0

      -- Sneak Attack & Death Attack
      if (sneak or death) and
	 (self:CheckTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
          or self:CheckTargetState(nwn.COMBAT_TARGET_STATE_FLATFOOTED)
          or self:CheckTargetState(nwn.COMBAT_TARGET_STATE_FLANKED))
      then
	 if not target:GetIsImmuneToSneakAttack(self) then
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
	    if attack then
	       -- Send target immune to sneaks.
	       attack:AddCCMessage(nil, { target.id }, { 134 })
	    end
	 end
      end 
   end
   self.ci.situational_flags = flags
   return flags
end

--- Resolve attack targets state
-- TODO: ???
-- @param target Attack target
function Creature:ResolveTargetState(target)
   self:ClearTargetState()
   if not target:GetIsValid() then return 0 end

   if target:GetIsBlind() then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_BLIND)
   end

   if self:GetIsInvisible(target) then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
   end

   if target:GetIsInvisible(self) then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_INVIS)
   end

   if not target:GetIsVisibile(self) then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
   end

   if not self:GetIsVisibile(target) then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_UNSEEN)
   end

   if target.obj.obj.obj_anim == 4
      or target.obj.obj.obj_anim == 87
      or target.obj.obj.obj_anim == 86
   then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_MOVING)
   end

   if target.obj.obj.obj_anim == 36       
      or target.obj.obj.obj_anim == 33
      or target.obj.obj.obj_anim == 32
      or target.obj.obj.obj_anim == 7
      or target.obj.obj.obj_anim == 5
   then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_PRONE)
   end

   if target.obj.cre_state == 6 then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_STUNNED)
   end

   if target:GetIsFlanked(self) then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_FLANKED)
   end

   if target:GetIsFlatfooted() then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_FLATFOOTED)
   end

   if target.obj.cre_state == 9 or target.obj.cre_state == 8 then
      self:SetTargetState(nwn.COMBAT_TARGET_STATE_ASLEEP)
   end

   return self.ci.target_state_mask
end
