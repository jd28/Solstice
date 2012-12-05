local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local fmt = string.format
local sm = string.strip_margin
local socket = require 'socket'

safe_require 'nwn.ctypes.solstice'
safe_require 'nwn.attack'

---
function nwn.GetAttackTypeFromEquipNum(num)
   if num == 0 then
      return nwn.ATTACK_TYPE_ONHAND
   elseif num == 1 then
      return nwn.ATTACK_TYPE_OFFHAND
   elseif num == 2 then
      return nwn.ATTACK_TYPE_UNARMED
   elseif num == 3 then
      return nwn.ATTACK_TYPE_CWEAPON1
   elseif num == 4 then
      return nwn.ATTACK_TYPE_CWEAPON2
   elseif num == 5 then
      return nwn.ATTACK_TYPE_CWEAPON3
   else
      print(debug.traceback())
      error "Invalid Equip Number"
   end
end

function nwn.ZeroCombatMod(mod)
   mod.ab = 0
   mod.ac = 0
   mod.dmg.dice = 0
   mod.dmg.dice = 0
   mod.dmg.bonus = 0
   mod.dmg_type = nwn.DAMAGE_TYPE_BASE_WEAPON
end

--- Bridge functions.

function NSGetCriticalHitMultiplier(attacker, is_offhand)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return attacker:GetCriticalHitMultiplier(is_offhand == 1)
end

function NSGetCriticalHitRange(attacker, is_offhand)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return attacker:GetCriticalHitRange(is_offhand == 1)
end

function NSGetCriticalHitRoll(attacker, is_offhand)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return 21 - attacker:GetCriticalHitRange(is_offhand == 1)
end

function NSInitializeNumberOfAttacks(cre)
   cre = _NL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return end
   cre:InitializeNumberOfAttacks()
end

function NSResolveMeleeAttack(attacker, target, attack_count, anim)
   local start = socket.gettime() * 1000

   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)

   if not target:GetIsValid() then return end 

   local attack = Attack.new(attacker, target)
   local use_cached = false
   local damage_result

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack.info.target_state = attacker:ResolveTargetState(target)
      attack.info.situational_flags = attacker:ResolveSituationalModifiers(target, attack)
   end

   for i = 0, attack_count - 1 do
      if not attack:GetIsCoupDeGrace() then
         attack:ResolveCachedSpecialAttacks()
      end

      -- Determine if able to use special attack (if one has been used).
      if attack:GetIsSpecialAttack() then
	 local sa = attack:GetSpecialAttack()
         if sa < 1115 and attacker:GetRemainingFeatUses(sa) == 0 then
            attack:ClearSpecialAttack()
         end
      end

      attack:ResolveAttackRoll(use_cached)

      if attack:GetIsHit() then
	 damage_result = attack:ResolveDamage(use_cached)
	 attack:ResolvePostDamage(false)
      end
      attack:ResolveMeleeAnimations(i, attack_count, anim)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack:GetIsSpecialAttack() and attack:GetIsHit() then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE and damage_result:GetTotal() > 0 then
	    attacker:DecrementRemainingFeatUses(attack:GetSpecialAttack())
	    
	    -- The resolution of Special Attacks will return an effect to be applied
	    -- or nil.
	    local success, eff = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, attack)
	    if success then
	       -- Check to makes sure an effect was returned.
	       if eff then
		  -- Set effect to direct so that Lua will not delete the
		  -- effect.  It will be deleted by the combat engine.
		  eff.direct = true
		  -- Add the effect to the onhit effect list so that it can
		  -- be applied when damage is signaled.
		  attack:AddEffect(eff)
	       end
	    else
	       -- If the special attack failed because it wasn't
	       -- applicable or the targets skill check (for example)
	       -- was success full set the attack result to 5.
	       attack:SetResult(5)
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    attack:SetResult(6)
	 end
      end

      attack:UpdateInfo()
   end

   attack:SignalDamage(attack_count, false)

   local stop = socket.gettime() * 1000
   print(string.format("Resolve Melee Attack Timer: Attacks %d, Time: %.4f", attack_count, stop-start))
end

-- called by nwnx
function NSResolveRangedAttack(attacker, target, attack_count, anim)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)

   local start = socket.gettime() * 1000

   -- Attack count can be modified if, say, a creature only has less arrows left than attacks
   -- or none at all.
   attack_count = attacker:GetAmmunitionAvailable(attack_count)

   -- TODO
   if not target:GetIsValid() or attack_count == 0 then
      NSResolveOutOfAmmo(attacker)
      return
   end

   local attack = Attack.new(attacker, target)
   local use_cached = false
   local dmg_result

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack.info.target_state = attacker:ResolveTargetState(target)
      attack.info.situational_flags = attacker:ResolveSituationalModifiers(target, attack)
   end

   for i = 0, attack_count - 1 do
      if not attack:GetIsCoupDeGrace() then
         attack:ResolveCachedSpecialAttacks()
      end

      -- Special Attack
      -- Determine if able to use special attack (if one has been used).
      if attack:GetIsSpecialAttack() then
	 local sa = attack:GetSpecialAttack()
         if sa < 1115 and attacker:GetRemainingFeatUses(sa) == 0 then
            attack:ClearSpecialAttack()
         end
      end

      attack:ResolveAttackRoll(use_cached)

      if attack:GetIsHit() then
	 damage_result = attack:ResolveDamage(use_cached)
	 attack:ResolvePostDamage(true)
      else
         attack:ResolveRangedMiss()
      end
      attack:ResolveRangedAnimations(anim)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack:GetIsSpecialAttack() and attack:GetIsHit() then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
	    and damage_result:GetTotal() > 0
	 then
	    attacker:DecrementRemainingFeatUses(attack:GetSpecialAttack())
	    
	    -- The resolution of Special Attacks will return an effect to be applied
	    -- or nil.
	    local success, eff = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, attack_info)
	    if success then
	       -- Check to makes sure an effect was returned.
	       if eff then
		  -- Set effect to direct so that Lua will not delete the
		  -- effect.  It will be deleted by the combat engine.
		  eff.direct = true
		  -- Add the effect to the onhit effect list so that it can
		  -- be applied when damage is signaled.
		  attack:AddEffect(eff)
	       end
	    else
	       -- If the special attack failed because it wasn't
	       -- applicable or the targets skill check (for example)
	       -- was success full set the attack result to 5.
	       attack:SetAttackResult(5)
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    attack:SetAttackResult(6)
	 end
      end

      attack:UpdateAttackInfo()
   end
   attack:SignalDamage(attack_count, true)

   local stop = socket.gettime() * 1000
   print(string.format("Resolve Ranged Attack Timer: Attacks %d, Time: %.4f", attack_count, stop-start))

end

-- This function is called by others get worst faction AC...
function NSGetArmorClassVersus(target, attacker, touch)
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)
   return target:GetACVersus(attacker, touch)
end

-- this function is called by a few others, EquipMostDamaging...
function NSGetAttackModifierVersus(attacker, target, attack_info, attack_type)
   return 0
--   attacker = _NL_GET_CACHED_OBJECT(attacker)
--   target = _NL_GET_CACHED_OBJECT(target)
--   return attacker:GetABVersus(target)
end

function NSSavingThrowRoll(cre, save_type, dc, immunity_type, vs, send_feedback, feat, from_combat)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)

   return cre:SavingThrowRoll(cre, save_type, dc, immunity_type, vs, send_feedback, feat, from_combat)
end
