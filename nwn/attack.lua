local ffi = require 'ffi'
local C = ffi.C
local random = math.random
local socket = require 'socket'

Attack = {}
local Attack_mt = { __index = Attack }

function Attack.new(attacker, target, attack_info)
   local t = {}
   setmetatable(t, Attack_mt)
   t.info = attack_info or t:CreateAttackInfo(attacker, target)
   t.attacker = attacker
   t.target = target
   
   if NS_OPT_DEBUG_COMBAT then
      t.dbg = {
	 ab = {},
	 ac = {},
	 dmg_mod = {},
	 gen = {},
	 --cc_message = {},
	 --feedback = {},
	 --effects = {},
	 --vfx = {},

	 start = 0,
	 stop = 0
      }
   end
   
   return t
end

--- Adds combat message to an attack.
function Attack:AddCCMessage(type, objs, ints)
   --self.cc_message[#self.cc_message + 1] = {type, objs, ints}

   C.nwn_AddCombatMessageData(self.info.attack, type or 0, #objs, objs[1] or 0, objs[2] or 0, 
			      #ints, ints[1] or 0, ints[2] or 0, ints[3] or 0, ints[4] or 0)
end

--- Add feedback to attack
function Attack:AddFeedback(feedback)
   --self.feedback[#self.feedback + 1] = feedback
   C.ns_AddAttackFeedback(self.info.attack, feedback)
end

--- Adds an onhit effect to an attack.
function Attack:AddEffect(eff)
   --self.effects[#self.effects + 1] = eff
   C.ns_AddOnHitEffect(self.info.attack, self.attacker.id, eff.eff)
end

--- Adds an onhit visual effect to an attack.
function Attack:AddVFX(vfx)
   --self.vfx[#self.vfx + 1] = eff
   C.ns_AddOnHitVisual(self.info.attack, self.attacker.id, vfx)
end

function Attack:ClearSpecialAttack()
   self.info.attack.cad_special_attack = 0
end

function Attack:CopyDamageToNWNAttackData(dmg)
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      if i < 13 then
	 if dmg.result.damages[i] <= 0 then
	    self.info.attack.cad_damage[i] = 65535
	 else
	    self.info.attack.cad_damage[i] = dmg.result.damages[i]
	 end
      else 
	 if dmg.result.damages[i] > 0 then
	    local flag = bit.lshift(1, i)
	    local eff = nwn.EffectDamage(flag, dmg.result.damages[i])
	    -- Set effect to direct so that Lua will not delete the
	    -- effect.  It will be deleted by the combat engine.
	    eff.direct = true
	    -- Add the effect to the onhit effect list so that it can
	    -- be applied when damage is signaled.
	    self:AddEffect(eff)
	 end
      end
   end
end

function Attack:CreateAttackInfo(attacker, target)
   local attack_info = attack_info_t()
   local cr = attacker.obj.cre_combat_round
   attack_info.attacker_cr = cr
   attack_info.current_attack = cr.cr_current_attack
   attack_info.attack = C.nwn_GetAttack(cr, attack_info.current_attack)
   attack_info.attack.cad_attack_group = attack_info.attack.cad_attack_group
   attack_info.attack.cad_target = target.id
   attack_info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   attack_info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)
   attack_info.is_offhand = cr.cr_current_attack + 1 > cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(attack_info.attacker_cr, attack_info.attack.cad_attack_type)
   attack_info.weapon = 3
   if weapon ~= nil then
      for i = 0, 5 do
	 if attacker.ci.equips[i].id == weapon.obj.obj_id then
	    attack_info.weapon = i
	    break
	 end
      end
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack_info.target_cr = target.obj.cre_combat_round
   end

   return attack_info
end

--- Forces people to equip ammunition.
-- NWN just doesn't seem to like letting Throwaxes, shurikens, darts... so we're forcing them
-- to auto-equip them (if they have none they will default to normal behavior, unarmed attacks)
-- @param attack_count Number of attacks in attack group.
function Attack:ForceEquipAmmunition(attack_count)
   C.ns_ForceEquipAmmunition(self.attacker.obj, attack_count, self.attacker.ci.ranged_type)
end

--- Determines if creature has ammunition available.
-- @param attack_count Number of attacks in attack group.
function Attack:GetAmmunitionAvailable(attack_count)
   local rng_type = self.attacker.ci.ranged_type
   return C.ns_GetAmmunitionAvailable(self.attacker.obj, attack_count, rng_type)
end


--- Gets the total attack roll.
function Attack:GetAttackRoll()
   return self.info.attack.cad_attack_roll + self.info.attack.cad_attack_mod
end

--- Get critical hit roll.
function Attack:GetCriticalHitRoll()
   local att = self.attacker
   return 21 - att:GetCriticalHitRange(self.info.is_offhand, self.info.weapon)
end

function Attack:GetCurrentWeapon()
   if self.info == nil then
      error(debug.traceback())
   end

   local n = self.info.weapon
   if n >= 0 and n <= 5 then
      local id = self.attacker.ci.equips[n].id
      if id == 0 then
	 return nwn.OBJECT_INVALID
      else
	 return _NL_GET_CACHED_OBJECT(id)
      end
   end
   return nwn.OBJECT_INVALID
end

--- Returns whether attack is a coup de grace
function Attack:GetIsCoupDeGrace()
   return self.info.attack.cad_coupdegrace ~= 0
end

--- Determines if attack results in a critical hit
function Attack:GetIsCriticalHit()
   return self:GetResult() == 3
end

function Attack:GetIsDeathAttack()
   return self.info.attack.cad_death_attack == 1
end

--- Determines if the attack results in a hit.
function Attack:GetIsHit()
   local t = self:GetResult()
   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

function Attack:GetIsOffhandAttack()
   local cr = self.info.attacker_cr
   return cr.cr_current_attack + 1 > 
      cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks
end

--- Determines if attack is ranged.
function Attack:GetIsRangedAttack()
   return self.info.attack.cad_ranged_attack == 1
end

function Attack:GetIsSneakAttack()
   return self.info.attack.cad_sneak_attack == 1
end

--- Determines if attack is a special attack
function Attack:GetIsSpecialAttack()
   return self.info.attack.cad_special_attack ~= 0
end

--- Determines the attack penalty based on attack count.
function Attack:GetIterationPenalty(log)
   local iter_pen = 0
   local spec_att = self:GetSpecialAttack()
   local att = self.attacker

   -- Deterimine the iteration penalty for an attack.  Not all attack types are
   -- have it.
   if att_type == 2 then
      iter_pen = 5 * self.info.attacker_cr.cr_offhand_taken
      self.info.attacker_cr.cr_offhand_taken = self.info.attacker_cr.cr_offhand_taken + 1
   elseif att_type == 6 or att_type == 8 then
      if spec_att ~= 867 or spec_att ~= 868 or spec_att ~= 391 then
	 iter_pen = 5 * self.info.attacker_cr.cr_extra_taken
      end
      self.info.attacker_cr.cr_extra_taken = self.info.attacker_cr.cr_extra_taken + 1
   elseif spec_att ~= 65002 and spec_att ~= 6 and spec_att ~= 391 then
      iter_pen = self.info.current_attack * att.ci.equips[self.info.weapon].iter
   end

   nwn.LogTableAdd(log, "Iteration Penalty: -%d", iter_pen)
   return iter_pen
end

--- Returns attack result.
function Attack:GetResult()
   return self.info.attack.cad_attack_result
end

--- Returns special attack
function Attack:GetSpecialAttack()
   return self.info.attack.cad_special_attack
end

--- Returns the attack type.  See nwn.ATTACK_TYPE_*
function Attack:GetType()
   return self.info.attack.cad_attack_type
end

--- Resolves Armor Class Roll
--     A large part of the AC is calculated in Creature:GetAC, only those parts
--     that are potentially determined by the target are calculated below.
-- NOTE: This function is only ever called by the combat engine.
function Attack:ResolveArmorClass(use_cached)
   local target = self.target
   if not use_cached then
      self.ac_cache = target:GetACVersus(self.attacker, false, self) -- todo touch
   end
   return self.ac_cache
end

--- Resolves that attack bonus of the creature.
-- @param use_cached If true we use a cached value.
function Attack:ResolveAttackModifier(use_cached)
   local att = self.attacker
   if not use_cached then
      self.ab_cache = att:GetABVersus(self.target, self:GetIsOffhandAttack(), self)
   end
   return self.ab_cache
end

function Attack:ResolveAttackRoll(use_cached, log)
   local attacker = self.attacker
   local target = self.target
   local attack_type = self.info.attack.cad_attack_type
   local ab, ac = 0, 0

   -- Determine attack modifier
   ab = self:ResolveAttackModifier(use_cached) - self:GetIterationPenalty()
   self:SetAttackMod(ab)

   -- Determine AC
   ac = ac + self:ResolveArmorClass(use_cached)

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in 
   -- NSResolvePostMelee/RangedDamage
   if self:GetIsCoupDeGrace() then
      self:SetResult(7)
      self:SetAttackRoll(20)
      return
   end

   local roll = random(20)
   nwn.LogTableAdd(log, "Attack Roll: %d", roll)
   self:SetAttackRoll(roll)

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1

   if self:ResolveMissChance(hit) 
      or self:ResolveDeflectArrow(hit)
      or self:ResolveParry(hit)
   then
      return 
   end

   if not hit then
      self:SetResult(4)
      if roll == 1 then
	 self:SetMissedBy(1)
      else
	 self:SetMissedBy(ac - ab + roll)
      end
      return
   else
      self:SetResult(1)
   end

   -- Determine if this is a critical hit.
   if roll > self:GetCriticalHitRoll() then
      local threat = random(20)
      self:SetCriticalResult(threat, 1)

      if threat + ab >= ac then
         if not target:GetIsImmuneToCriticalHits(attacker) then
            -- Is critical hit
	    self:SetResult(3)
         else
            -- Send target immune to crits.
	    self:AddCCMessage(nil, { target.id }, { 126 })
         end
      end
   end
end

function Attack:ResolveCachedSpecialAttacks()
   C.nwn_ResolveCachedSpecialAttacks(self.attacker.obj)
end

--- Resolves that damage of the creature.
-- NOTE: This function is only ever called by the combat engine.
function Attack:ResolveDamage(use_cached)
   local attacker = self.attacker
   local target = self.target

   local ki_strike = self:GetSpecialAttack() == 882
   -- If this is a critical hit determine the multiplier.
   local mult = 1
   if self:GetIsCriticalHit() then
      mult = attacker:GetCriticalHitMultiplier(self.info.is_offhand, self.info.weapon)
   end

   local dmg_roll = attacker:GetDamageRollVersus(target, 
						 is_offhand, 
						 mult, 
						 self:GetIsSneakAttack(), 
						 self:GetIsDeathAttack(), 
						 ki_strike, 
						 self)
   local total = dmg_roll:GetTotal()

   -- Defensive Roll
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and not attacker:CheckTargetState(nwn.COMBAT_TARGET_STATE_FLATFOOTED)
      and target:GetHasFeat(nwn.FEAT_DEFENSIVE_ROLL)
   then
      target:DecrementRemainingFeatUses(nwn.FEAT_DEFENSIVE_ROLL)
      
      if target:ReflexSave(total, nwn.SAVING_THROW_TYPE_DEATH, attacker) then
	 dmg_roll:MapResult(function (amt) return math.floor(amt / 2) end)
      end
   end

   local total = dmg_roll:GetTotal()

   -- Add the damage result info to the CNWSCombatAttackData
   self:CopyDamageToNWNAttackData(dmg_roll)
  
   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and total > 0
      and self.info.target_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message
      
      self:SetResult(4)
      self.info.target_cr.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      else
	 -- Item onhit cast spells are done regardless of whether weapon damage is
	 -- greater than zero.
	 self:ResolveItemCastSpell()
      end

      if total > 0 then
	 self:ResolveOnHitEffect()
         self:ResolveOnHitVFX(dmg_roll)
      end
   end

   return dmg_roll
end

function Attack:ResolveDeflectArrow(hit)
   if self.target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end
   
   local attacker = self.attacker
   local target = self.target

   -- Deflect Arrow
   if hit 
      and self.info.attacker_cr.cr_deflect_arrow == 1
      and self.info.attack.cad_ranged_attack ~= 0
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
         self.info.attacker_cr.cr_deflect_arrow = 0
	 self:SetResult(2)
         self.info.attack.cad_attack_deflected = 1
         return true
      end
   end
   return false
end

function Attack:ResolveDevCrit()
   local attacker = self.attacker
   local target = self.target

   if not self:GetIsCriticalHit()
      or NS_OPT_DEVCRIT_DISABLE_ALL 
      or (NS_OPT_DEVCRIT_DISABLE_PC and attacker:GetIsPC())
   then
      return
   end

   local dc = 10 + math.floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(nwn.ABILITY_STRENGTH)

   if target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_DEATH, attacker) == 0 then
      local eff = nwn.EffectDeath(true, true)
      eff:SetSubType(nwn.SUBTYPE_SUPERNATURAL)
      target:ApplyEffect(nwn.DURATION_TYPE_INSTANT, eff)

      self:SetResult(10)
   end
end

-- probably broken.
function Attack:ResolveEpicDodge()
   if self.target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end

   -- Epic Dodge : Don't want to use it unless we take damage.
   if self.info.attacker_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message
      self:SetResult(4)
      self.info.attacker_cr.cr_epic_dodge_used = 1
      return true
   end

   return false
end

function Attack:ResolveItemCastSpell()
   C.nwn_ResolveItemCastSpell(self.attacker.obj, self.target.obj.obj)
end

function Attack:ResolveMeleeAnimations(i, attack_count, anim)
   C.nwn_ResolveMeleeAnimations(self.attacker.obj, i, attack_count, self.target.obj.obj, anim)
end

--- Determine miss chance / concealment.
-- @param attacker Attacker
-- @param target Target
-- @return Returns true if the attacker failed to over come miss chance
--    or concealment.
function Attack:ResolveMissChance(hit, use_cached)
   local attacker = self.attacker
   local target = self.target

   if not use_cached then
      self.misschance_cache = attacker:GetMissChance(self.info.attack)
      self.conceal_cache = target:GetConcealment(attacker, self.info.attack)
   end

   -- Miss Chance
   local miss_chance = self.misschance_cache
   -- Conceal
   local conceal = self.conceal_cache

   -- If concealment and mis-chance are less than or equal to zero
   -- there is no chance of them affecting the outcome of an attack.
   if conceal <= 0 and miss_chance <= 0 then return false end

   local chance, attack_result

   -- Deterimine which of miss chance and concealment is higher.
   -- attack_result is a magic number for the NWN combat engine that
   -- determines which combat messages are sent to the player.
   if miss_chance < conceal then
      chance = conceal
      attack_result = 8
   else
      chance = miss_chance
      attack_result = 9
   end

   -- The attacker has two possible chances to over come miss chance / concealment
   -- if they posses the blind fight feat.  If not they only have one chance to do so.
   if random(100) >= chance
      or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and random(100) >= chance)
   then
      return false
   else
      self:SetResult(attack_result)
      -- Show the modified conceal/miss chance in the combat log.
      self:SetConcealment(math.floor((chance ^ 2) / 100))
      self:SetMissedBy(1)
      return true
   end
end

function Attack:ResolveOnHitEffect()
   C.nwn_ResolveOnHitEffect(self.attacker.obj, self.target.obj.obj, self.info.is_offhand, self:GetIsCriticalHit())
end

-- This is not default behavior.
function Attack:ResolveOnHitVFX(dmg)
   local flag, highest_vfx, vfx
   local highest = 0

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      flag = bit.lshift(1, i)
      vfx = nwn.GetDamageVFX(flag, self:GetIsRangedAttack())
      if vfx and dmg.result.damages[i] > highest then
         highest_vfx = vfx
         highest = dmg.result.damages[i]
      end
   end

   if highest_vfx then
      self:AddVFX(highest_vfx)
   end
end

function Attack:ResolveOutOfAmmo()
   C.nwn_SetRoundPaused(self.attacker.obj.cre_combat_round, 0, 0x7F000000)
   C.nwn_SetPauseTimer(self.attacker.obj.cre_combat_round, 0, 0)
   C.nwn_SetAnimation(self.attacker.obj, 1)
end

function Attack:ResolveParry(hit)
   if self.target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end

   local attacker, target = self.attacker, self.target

   if self.info.attack.cad_attack_roll == 20
      or attacker.obj.cre_mode_combat ~= nwn.COMBAT_MODE_PARRY
      or self.info.attacker_cr.cr_parry_actions == 0
      or self.info.attacker_cr.cr_round_paused ~= 0
      or self.info.attack.cad_ranged_attack ~= 0
   then
      return false
   end
   
   -- Can not Parry when using a Ranged Weapon.
   local on = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   if on:GetIsValid() and on:GetIsRangedWeapon() then
      return false
   end

   local roll = math.random(20) + target:GetSkillRank(nwn.SKILL_PARRY)
   self.info.target_cr.cr_parry_actions = self.info.target_cr.cr_parry_actions - 1

   if roll >= self.info.attack.cad_attack_roll + self.info.attack.cad_attack_mod then
      if roll - 10 >= self.info.attack.cad_attack_roll + self.info.attack.cad_attack_mod then
         target:AddParryAttack(attacker)
      end
      NSSetAttackResult(self.info, 2)
      return true
   end

   C.nwn_AddParryIndex(self.info.target_cr)
   return false
end

function Attack:ResolvePostDamage(is_ranged)
   local attacker = self.attacker
   local target = self.target
   if not target:GetIsValid() or target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return
   end

   if is_ranged then
      return
   else
      return
      self:ResolveDevCrit()
   end
end

function Attack:ResolveRangedAnimations(anim)
   C.nwn_ResolveRangedAnimations(self.attacker.obj, self.target.obj.obj, anim)
end

function Attack:ResolveRangedMiss()
   C.nwn_ResolveRangedMiss(self.attacker.obj, self.target.obj.obj)
end

--- Sets attack modifier
-- @param ab Attack modifier
function Attack:SetAttackMod(ab)
   self.info.attack.cad_attack_mod = ab
end

--- Sets attack roll
-- @param roll The 1d20 attack roll.
function Attack:SetAttackRoll(roll)
   self.info.attack.cad_attack_roll = roll
end

function Attack:SetConcealment(conceal)
   self.info.attack.cad_concealment = conceal
end

function Attack:SetCriticalResult(threat, result)
   self.info.attack.cad_threat_roll = threat
   self.info.attack.cad_critical_hit = result
end

function Attack:SetMissedBy(roll)
   self.info.attack.cad_missed = roll
end

--- Sets the attack result.
-- @param result See...
function Attack:SetResult(result)
   self.info.attack.cad_attack_result = result
end

function Attack:SignalDamage(attack_count, is_ranged)
   if is_ranged then
      C.nwn_SignalRangedDamage(self.attacker.obj, self.target.obj.obj, attack_count)
   else
      C.nwn_SignalMeleeDamage(self.attacker.obj, self.target.obj.obj, attack_count)
   end
end

function Attack:UpdateInfo()
   local attacker = self.attacker
   local target = self.target

   local cr = self.info.attacker_cr

   cr.cr_current_attack = cr.cr_current_attack + 1
   self.info.current_attack = cr.cr_current_attack
   self.info.attack = C.nwn_GetAttack(cr, self.info.current_attack)
   self.info.attack.cad_attack_group = self.info.attack.cad_attack_group
   self.info.attack.cad_target = target.id
   self.info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   self.info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)
   self.info.is_offhand = cr.cr_current_attack + 1 > cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(self.info.attacker_cr, self.info.attack.cad_attack_type)
   self.info.weapon = 3
   if weapon ~= nil then
      for i = 0, 5 do
	 if attacker.ci.equips[i].id == weapon.obj.obj_id then
	    self.info.weapon = i
	    break
	 end
      end
   end
end