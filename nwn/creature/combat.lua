require 'nwn.creature.weapons'
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

--- Adds parry attack.
-- @param attacker Attacker to do parry attack against.
function Creature:AddParryAttack(attacker)
   C.nwn_AddParryAttack(self.obj.cre_combat_round, attacker.id)
end

--- Checks if target state flag is set
-- @param state nwn.COMBAT_TARGET_STATE_*
function Creature:CheckTargetState(state)
   return bit.band(self.ci.target_state_mask, state) ~= 0
end

--- Clears target state
function Creature:ClearTargetState()
   self.ci.target_state_mask = 0
end

--- Determines creature's attack bonus
-- @param is_offhand If true attack is using offhand weapon.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetAB(is_offhand, attack, log)
   local ab = self.ci.bab
   local wp_num = attack and attack.info.weapon or self:GetEquipNumFromEquips(is_offhand)

   local ab_abil = self:GetAbilityModifier(self.ci.equips[wp_num].ab_ability)

   ab = ab + ab_abil
   -- Size Modifier
   ab = ab + self.ci.size.ab
   -- Area Modifier
   ab = ab + self.ci.area.ab
   -- Feat Modifier
   ab = ab + self.ci.feat.ab
   -- Mode Modifier
   ab = ab + self.ci.mode.ab
   -- Race Modifier
   ab = ab + self.ci.race.ab

   -- Weapon AB Mod.  i.e, WF, SWF, EWF, etc
   ab = ab + self.ci.equips[wp_num].ab_mod

   -- Offhand Attack Penalty
   if is_offhand then
      ab = ab + self.ci.offhand_penalty_off
   else
      ab = ab + self.ci.offhand_penalty_on
   end

   -- Only debug if this is an attack
   if attack then
      nwn.LogTableAdd(log, "Ability Modifier: %d", ab_abil)
      nwn.LogTableAdd(log, "Area: %d", self.ci.area.ab)
      nwn.LogTableAdd(log, "Base Attack Bonus: %d", self.ci.bab)
      nwn.LogTableAdd(log, "Dual Wield Off Penalty: %d", self.ci.offhand_penalty_off)
      nwn.LogTableAdd(log, "Dual Wield On Penalty: %d", self.ci.offhand_penalty_on)
      nwn.LogTableAdd(log, "Feat: %d", self.ci.feat.ab)
      nwn.LogTableAdd(log, "Mode: %d", self.ci.mode.ab)
      nwn.LogTableAdd(log, "Race: %d", self.ci.race.ab)
      nwn.LogTableAdd(log, "Size: %d", self.ci.size.ab)
      nwn.LogTableAdd(log, "Weapon Feat: %d", self.ci.equips[attack.info.weapon].ab_mod)
   else
      -- Cannot be included if there is an attack do to their possibly being
      -- Versus effects
      ab = ab + self:GetEffectAttackBonus(nwn.OBJECT_INVALID, attack_type)
   end
   
   return ab
end

--- Determines creature's attack bonus vs object.
-- @param tar Attack target
-- @param is_offhand If true attack is using offhand weapon.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetABVersus(tar, is_offhand, attack, log)
   local att = self
   local att_type = attack:GetType()
   local ab = att:GetAB(is_offhand, attack)

   -- Favored Enemies
   if att:GetIsFavoredEnemy(tar) then
      ab = ab + att.ci.fe.ab
   end

   local eff_ab = att:GetEffectAttackBonus(tar, att_type)

   -- +1 Offensive Training Vs.
   if att:GetHasOffensiveTrainingVs(tar) then
      ab = ab + 1
   end

   -- This is as far as we can go if this is not called from the combat engine.
   if not attack then return ab + eff_ab end

   -- Debugging info for the results calculated above.  NOTE: Offensive traing is currently hardcoded
   nwn.LogTableAdd(log, "Favored Enemy: %d", att.ci.fe.ab)
   nwn.LogTableAdd(log, "Offensive Training Vs: %d", 1)
   nwn.LogTableAdd(log, "Effect Bonus: %d", eff_ab)

   -- Special Attack Modifier
   if attack:GetIsSpecialAttack() then
      local val = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_AB, att, tar, attack)
      nwn.LogTableAdd(log, "Special Attack (%d), %d", attack:GetIsSpecialAttack(), val)
      ab = ab + val
   end

   local is_ranged = attack:GetIsRangedAttack()
   
   -- Target State
   local state = att:GetEnemyStateAttackBonus(is_ranged)
   nwn.LogTableAdd(log, "Enemy State: %d", state)
   ab = ab + state

   -- Ranged Attacker Modifications
   if is_ranged then
      local r = att:GetRangedAttackMod(tar)
      ab = ab + r
   end

   local sit_ab = att:GetSituationalAttackBonus()
   nwn.LogTableAdd(log, "Situation Bonus: %d", sit_ab)

   return ab + eff_ab + sit_ab
end

--- Get creature's AC
-- @param touch If true it's a touch attack.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetAC(touch, attack, log)
   -- 10 base AC
   local ac = 10

   -- Armor AC
   ac = ac + self.stats.cs_ac_natural_base
   -- Natural AC
   ac = ac + self.stats.cs_ac_armour_base
   -- Shield AC
   ac = ac + self.stats.cs_ac_shield_base
   -- Size Modifier
   ac = ac + self.ci.size.ac
   -- Class: Monk, RDD, PM, ...
   ac = ac + self.ci.class.ac
   -- Attack Mode Modifier
   ac = ac + self.ci.mode.ac
   -- Feat: Armor Skin, etc
   ac = ac + self.ci.feat.ac

   nwn.LogTableAdd(log, "Base: %d", 10)
   nwn.LogTableAdd(log, "Base Armor: %d", self.stats.cs_ac_armour_base)
   nwn.LogTableAdd(log, "Base Natural: %d", self.stats.cs_ac_natural_base)
   nwn.LogTableAdd(log, "Base Shield: %d", self.stats.cs_ac_shield_base)
   nwn.LogTableAdd(log, "Class: %d", self.ci.class.ac)
   nwn.LogTableAdd(log, "Feat: %d", self.ci.feat.ac)
   nwn.LogTableAdd(log, "Mode: %d", self.ci.mode.ac)
   nwn.LogTableAdd(log, "Size: %d", self.ci.size.ac)

   if not attack then
      local val = self.stats.cs_ac_armour_bonus - self.stats.cs_ac_armour_penalty
      -- Armor AC
      ac = ac + val
      nwn.LogTableAdd(log, "Armor Bonus: %d", val)

      -- Deflect AC
      val = self.stats.cs_ac_deflection_bonus - self.stats.cs_ac_deflection_penalty
      ac = ac + val
      nwn.LogTableAdd(log, "Deflection Bonus: %d", val)

      -- Natural AC
      val = self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty
      ac = ac + val
      nwn.LogTableAdd(log, "Natural Bonus: %d", val)

      -- Skill: Tumble...
      ac = ac + self.ci.skill.ac   
      nwn.LogTableAdd(log, "Skills: %d", self.ci.skill.ac)

      -- Shield AC
      val = self.stats.cs_ac_shield_bonus - self.stats.cs_ac_shield_penalty
      ac = ac + val
      nwn.LogTableAdd(log, "Shield Bonus: %d", val)

      -- Dodge AC
      val = self.stats.cs_ac_dodge_bonus - self.stats.cs_ac_dodge_penalty
      ac = ac + val
      nwn.LogTableAdd(log, "Dodge Bonus: %d", val)

      -- Dex Mod.
      val = self:GetDexMod(true)
      ac = ac + val
      nwn.LogTableAdd(log, "Dexterity Modifier: %d", val)
   end

   return ac
end

--- Determines AC vs creature
-- @param att Attacking creature
-- @param touch If true it's a touch attack.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetACVersus(att, touch, attack, log)
   local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0
   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge
   local ac = self:GetAC(touch, attack, log)

   -- A huge chunk of this function only really makes sense when it's called from
   -- the solstice combat engine.  The few other locations that it would be called from
   -- would be GetFactionBest/WorstAC, and DoTouchAttack.
   if attack then
      -- Armor AC
      armor = self.stats.cs_ac_armour_bonus - self.stats.cs_ac_armour_penalty
      -- Deflect AC
      deflect = self.stats.cs_ac_deflection_bonus - self.stats.cs_ac_deflection_penalty
      -- Natural AC
      nat = self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty
      -- Shield AC
      shield = self.stats.cs_ac_shield_bonus - self.stats.cs_ac_shield_penalty

      -- Dex Modifier
      local dex_mod = self:GetDexMod(true)
      local dexed = false

      -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
      -- then target gets no Dex mod.
      if not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
	 and not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_FLATFOOTED)
      then
	 -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
	 -- gets dex_mod and dodge AC
	 if not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
	    or (self:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and attack:GetIsRangedAttack())
	 then
	    if dex_mod > 0 then
	       dexed = true
	    end 
	    -- Dodge AC
	    dodge = self.stats.cs_ac_dodge_bonus - self.stats.cs_ac_dodge_penalty

	    -- Skill: Tumble...
	    nwn.LogTableAdd(log, "Skills: %d", self.ci.skill.ac)
	    ac = ac + self.ci.skill.ac
	    
	    -- If this is an attack of opportunity and target has mobility
	    -- there is a +4 ac bonus.
	    if attack:GetSpecialAttack() == -534 
	       and self:GetHasFeat(nwn.FEAT_MOBILITY)
	    then
	       nwn.LogTableAdd(log, "AoO Mobility Bonus: %d", 4)
	       ac = ac + 4
	    end
	    
	    if self:GetHasFeat(nwn.FEAT_DODGE) then
	       if self.obj.cre_combat_round.cr_dodge_target == nwn.OBJECT_INVALID.id then
		  self.obj.cre_combat_round.cr_dodge_target = att.id
	       end
	       if self.obj.cre_combat_round.cr_dodge_target == att.id
		  and not self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
	       then
		  ac = ac + 1
		  nwn.LogTableAdd(log, "Dodge Feat: %d", 1)
	       end
	    end
	 end
	 -- If dex_mod is negative we add it in.
      elseif dex_mod < 0 then
	 dexed = true
      end

      -- If target has Uncanny Dodge 1 or Defensive Awareness 1, target gets
      -- dex modifier.
      if not dexed
	 and dex_mod > 0
	 and (self:GetHasFeat(nwn.FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
	 or self:GetHasFeat(nwn.FEAT_UNCANNY_DODGE_1))
      then
	 dexed = true
      end

      if dexed then
	 nwn.LogTableAdd(log, "Dexterity Modifier: %d", dex_mod)
	 ac = ac + dex_mod
      end
   end
   -- +4 Defensive Training Vs.
   if self:GetHasDefensiveTrainingVs(att) then
      nwn.LogTableAdd(log, "Defensive Training Vs: %d", 4)
      ac = ac + 4
   end

   if touch then
      nwn.LogTableAdd(log, "Touch Attack: true")
      return ac + dodge
   end

   eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge =
      self:GetEffectArmorClassBonus(att, touch)

   if eff_nat > nat then nat = eff_nat end
   if eff_armor > armor then armor = eff_armor end
   if eff_shield > shield then shield = eff_shield end
   if eff_deflect > deflect then deflect = eff_deflect end

   nwn.LogTableAdd(log, "Deflection: %d", deflect)
   nwn.LogTableAdd(log, "Natural: %d", nat)
   nwn.LogTableAdd(log, "Shield: %d", shield)

   dodge = dodge + eff_dodge
   local max_dodge_ac = self:GetMaxDodgeAC()
   if dodge > max_dodge_ac then
      dodge = max_dodge_ac
   end
   nwn.LogTableAdd(log, "Dodge: %d", dodge)

   nwn.LogTableAdd(log, "Touch Attack: false")

   return ac + nat + armor + shield + deflect + dodge
end

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

function Creature:GetCriticalHitMultiplier(offhand, weap_num)
   local result
   if weap_num then
      result = self.ci.equips[weap_num].crit_mult
   else
      -- The following code is for when the function is called from the NWN Engine
      -- rather than the Solstice combat engine.
      local weapon
      local cr = self.obj.cre_combat_round
      if offhand then
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = self:GetWeaponCritMultiplier(weapon)
      end
   end
   
   return result
end

--- Gets creatures critical threat range
-- @param is_offhand If true calculate for offhand weapon.
-- @param weap_num
function Creature:GetCriticalHitRange(is_offhand, weap_num)
   local result
   if weap_num then
      result = self.ci.equips[weap_num].crit_range
   else
      -- The following is code that is necessary when the funciton is called
      -- from the NWN engine rather than the Solstice combat engine.
      local weapon

      local cr = self.obj.cre_combat_round
      if is_offhand then
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = self:GetWeaponCritRange(weapon)
      end
   end
   
   return result
end

--- Get creature's damage flags.
function Creature:GetDamageFlags()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetDamageFlags(self.obj)
end

function Creature:GetDamageRollVersus(target, is_offhand, mult, is_sneak, is_death, is_kistrike, attack)
   local base = 0
   local attack_type
   local wp_num = attack and attack.info.weapon or self:GetEquipNumFromEquips(is_offhand)

   if is_offhand then 
      attack_type = nwn.ATTACK_TYPE_OFFHAND
   else
      attack_type = nwn.GetAttackTypeFromEquipNum(wp_num)
   end

   local dmgroll = DamageRoll.new(self, target, attack_type)
   dmgroll:ResolveEffectModifiers()
   dmgroll:ResolveBonusModifiers(attack)
   dmgroll:AddBonus(nwn.DAMAGE_TYPE_BASE_WEAPON, self.ci.equips[wp_num].base_dmg)

   -- If this is a critical hit determine the multiplier.
   if mult > 1 then
      -- Add any addition damage from the weapons crit_dmg bonus.  E,g from Overwhelming Critical.
      dmgroll:AddBonus(nwn.DAMAGE_TYPE_BASE_WEAPON, self.ci.equips[wp_num].crit_dmg)
   end
   
   -- Special Damage Modifier
   if attack and attack:GetIsSpecialAttack() then
      local dmgtype, roll = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_DAMAGE, attack.attacker, attack.target, attack)
      if dmgtype and roll then
	 dmgroll:AddBonus(dmgtype, roll)
      end
   end

   -- Roll all the damage.
   dmgroll:ResolveResult(mult)

   -- situational - Sneak attacks and Death attacks are added after the
   -- the roll, to ensure that they aren't multiplied in the crit roll.
   if is_sneak then
      dmgroll:AddToResult(self.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg_type,
			  self.ci.situational[nwn.SITUATION_SNEAK_ATTACK].dmg)
   end
   
   if is_death then
      dmgroll:AddToResult(self.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg_type,
			  self.ci.situational[nwn.SITUATION_DEATH_ATTACK].dmg)
   end

   dmgroll:CompactPhysicalDamage()
   dmgroll.power = 1 -- TODO

   -- If the target is a creature modify the damage roll by their immunities, resistances,
   -- soaks.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      dmgroll:ResolveDamageAdjustments(is_offhand, attack)
   end

   return dmgroll
end

--- Determines attack bonus based on target's state.
-- See nwn.COMBAT_TARGET_STATE_*
-- @param is_ranged true if current attack is a ranged attack.
function Creature:GetEnemyStateAttackBonus(is_ranged)
   local ab = 0
   local mask = self.ci.target_state_mask

   -- Target State
   if is_ranged then
      -- -2 when target is moving.
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_MOVING) ~= 0 then
         ab = ab - 2
      end

      -- -4 When target is prone and attacker ranged. 
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_PRONE) ~= 0 then
         ab = ab - 4
      end
   else
      -- +4 When target is prone and attacker melee. 
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_PRONE) ~= 0 then
         ab = ab + 4
      end
   end

   -- +2 when attacker is invisible
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS) ~= 0 then
      ab = ab + 2
   end 

   -- +2 if target blind
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_BLIND) ~= 0 then
      ab = ab + 2
   end 

   -- +2 When target is stunned. 
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_STUNNED) ~= 0 then
      ab = ab + 2
   end

   -- -4 When attack can't see target. 
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_UNSEEN) ~= 0 then
      ab = ab -4
   end

   return ab
end

--- Determines if creature has offensive training vs target
-- @param target Attack target
function Creature:GetHasOffensiveTrainingVs(target)
   return self.ci.training_vs_mask ~= 0 
      and target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(self.ci.training_vs_mask, bit.lshift(1, target:GetRacialType())) ~= 0
end

--- Determines if creature has defensive training vs target
-- @param target Attack target
function Creature:GetHasDefensiveTrainingVs(attacker)
   return self.ci.training_vs_mask ~= 0 
      and attacker.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(self.ci.training_vs_mask, bit.lshift(1, attacker:GetRacialType())) ~= 0
end

--- Determines if target is a favored enemy
-- @param target Attack target
function Creature:GetIsFavoredEnemy(target)
   return self.ci.fe_mask ~= 0 
      and target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(self.ci.fe_mask, bit.lshift(1, target:GetRacialType())) ~= 0
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

--- Determines creature's maximum dodge AC from gear/effects.
function Creature:GetMaxDodgeAC()
   return 20
end

--- Determines a creatures damage resistance
-- @param flags Damage flags
-- @param min if true the lowest applying resistince, 
function Creature:GetDamageResistVsFlags(flags, min)
   local selector = min and math.min or math.max
   local result = 0
   local idx = 1
   local eff
   local dmg_idx

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      if bit.band(flags, idx) ~= 0 then
	 dmg_idx = nwn.GetDamageIndexFromFlag(idx)
	 result = selector(result, self:GetInnateDamageResistance(dmg_idx))
	 
	 -- If there is no effect yet, use the first one found.
	 if not eff then
	    eff = self:GetEffectAtIndex(self.ci.eff_resist[i])
	 else
	    eff = nwn.DetermineResistEffect(eff, self:GetEffectAtIndex(self.ci.eff_resist[i]), min)
	 end
      end
      idx = bit.lshift(idx, 1)
   end
   return result, eff
end

function Creature:GetDamageImmunityVsFlags(flags, min)
   local selector = min and math.min or math.max
   local result = 0
   local idx = 1

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      if bit.band(flags, idx) ~= 0 then
	 result = selector(result, self:GetDamageImmunity(nwn.GetDamageIndexFromFlag(idx)))
      end
      idx = bit.lshift(idx, 1)
   end
   return result
end

--- Determines creatures offhand attack penalty.
function Creature:GetOffhandAttackPenalty()
   local on = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local off = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local ab_on, ab_off = 0, 0
   local off_is_weap
   local on_bi, off_bi
   

   if not on:GetIsValid() or not off:GetIsValid() then
      return ab_on, ab_off
   end

   if on:GetIsValid() then
      on_bi = C.nwn_GetBaseItem(on:GetBaseType())
      -- Not sure about this.  Double sided weapons don't have offhand penalties?
      -- I saw this in MaxRock's windows plugin, 
      --if on_bi == nil or on_bi.bi_weapon_wield == 8 then
      --   return ab
      --end
   else
      -- If either item is invalid we can't be dual wielding.
      return ab_on, ab_off
   end

   if off:GetIsValid() then
      off_bi = C.nwn_GetBaseItem(off:GetBaseType())
      -- Check if this is a weapon
      if off_bi.bi_damage_type == 0 then
         return ab_on, ab_off
      end
   else
      -- If either item is invalid we can't be dual wielding.
      return ab_on, ab_off
   end

   if self:GetRelativeWeaponSize(off) <= -1 or on_bi.bi_weapon_wield == 8 then
      ab_on  = -4
      ab_off = -8
   else
      ab_on  = -6
      ab_off = -10
   end

   if self:GetHasFeat(374) then
      ab_on  = ab_on + 2
      ab_off = ab_off + 6
   else
      if self:GetHasFeat(nwn.FEAT_TWO_WEAPON_FIGHTING) then
         ab_on  = ab_on + 2
         ab_off = ab_off + 2
      end
      
      if self:GetHasFeat(nwn.FEAT_AMBIDEXTERITY) then
         ab_off = ab_off + 4
      end
   end
      
   return ab_on, ab_off
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

--- Determines attack bonus from situational factors.
-- See nwn.SITUATION_*
function Creature:GetSituationalAttackBonus()
   local situ_mask = self.ci.situational_flags
   local ab = 0
   local idx = 1
   for i = 0, 2 do
      if bit.band(situ_mask, idx) then
         ab = ab + self.ci.situational[i].ab      
      end
      idx = bit.lshift(idx, 1)
   end
   return ab
end

--- Determines turn resistance hit dice.
function Creature:GetTurnResistanceHD()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(478, 1)
   nwn.engine.StackPopInteger()
end

--- Initializes how many attacks the creature has.
-- Following has some non-default stuff that needs to be fixed.
function Creature:InitializeNumberOfAttacks()
   combat_round = self.obj.cre_combat_round

   self:UpdateCombatInfo()

   local rh = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local rh_valid = rh:GetIsValid()
   local lh = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local age = self.stats.cs_age
   local style = (age / 100) % 10
   local extra_onhand = (age / 10000) % 10
   local extra_offhand = (age / 1000) % 10
   local attacks = 0
   local offhand_attacks = 0

   combat_round.cr_extra_taken = 0
   combat_round.cr_offhand_taken = 0

   if rh_valid and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_HEAVYCROSSBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_LIGHTCROSSBOW)
      and not self:GetHasFeat(nwn.FEAT_RAPID_RELOAD)
   then
      attacks = 1
   elseif self.stats.cs_override_atks > 0 then
      -- appearently some kind of attack override
      attacks = self.stats.cs_override_atks
   else
      attacks = C.nwn_GetAttacksPerRound(self.stats)
   end

   -- STYLE
   if style == 7 and not rh:GetIsValid() then
      -- sunfist
      extra_onhand = extra_onhand + 1
   elseif style == 3 and lh:GetIsValid() and -- spartan
      (lh.obj.it_baseitem == nwn.BASE_ITEM_SMALLSHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_LARGESHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_TOWERSHIELD)
   then
      extra_onhand = extra_onhand + 1;
   elseif self:GetLevelByClass(nwn.CLASS_TYPE_RANGER) >= 40 and
      self:GetLevelByClass(nwn.CLASS_TYPE_MONK) == 0
   then
      extra_offhand = extra_offhand + 1; 
   end

   -- FEAT
   if not rh:GetIsValid() and self:GetKnowsFeat(nwn.FEAT_CIRCLE_KICK) then
      extra_onhand = extra_onhand + 1
   end

   offhand_attacks = C.nwn_CalculateOffHandAttacks(combat_round)

   if self.obj.cre_slowed ~= 0 and attacks > 1 then
      attacks = attacks - 1
   end

   if self.obj.cre_mode_combat == 10 then -- Dirty Fighting
      self:SetCombatMode(0)
      combat_round.cr_onhand_atks = 1
      combat_round.cr_offhand_atks = 0
      return
   elseif self.obj.cre_mode_combat == 6 and -- Rapid Shot
      rh:GetIsValid() and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_LONGBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_SHORTBOW) 
   then
      combat_round.cr_additional_atks = 1
   elseif self.obj.cre_mode_combat == 5 and -- flurry
      (not rh:GetIsValid() or
       rh.obj.it_baseitem == 40 or
       rh:GetIsFlurryable())
   then
      combat_round.cr_additional_atks = 1
   end

   if self.obj.cre_hasted then
      combat_round.cr_additional_atks = combat_round.cr_additional_atks + 1
   end

   -- Only give extra offhand attacks if we have one to begin with.
   if offhand_attacks > 0 then
      offhand_attacks = offhand_attacks + extra_offhand
   end

   combat_round.cr_onhand_atks = attacks + extra_onhand
   combat_round.cr_offhand_atks = offhand_attacks
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

--- Get ranged attack bonus/penalty vs a target.
-- @param target Creature's target.
function Creature:GetRangedAttackMod(target)
   local ab = 0

   -- Point Blank Shot
   if self.ci.target_distance <= 25
      and self:GetHasFeat(nwn.FEAT_POINT_BLANK_SHOT)
   then
      ab = ab + 1
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      -- Ranged Attack in Melee Target Range
      local max = target:GetMaxAttackRange(self)
      local weap = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      if self.ci.target_distance <= max * max
         and weap:GetIsValid()
         and not weap:GetIsRangedWeapon()
      then
         ab = ab - 4
      end
   end

   return ab
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

--- Sets target state flag 
-- @param state nwn.COMBAT_TARGET_STATE_*
function Creature:SetTargetState(state)
   self.ci.target_state_mask = bit.bor(self.ci.target_state_mask, state)
   return self.ci.target_state_mask
end
