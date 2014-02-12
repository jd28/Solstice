--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

local NWE = require 'solstice.nwn.engine'

--- Combat
-- @section


--- Get creature's arcane spell failure.
function M.Creature:GetArcaneSpellFailure()
   if not self:GetIsValid() then return 0 end
   local amt = self.stats.cs_arcane_sp_fail_2 + self.stats.cs_arcane_sp_fail_1 + self.stats.cs_arcane_sp_fail_3
   return math.clamp(amt, 0, 100)
end

--- Get creature's attack target
function M.Creature:GetAttackTarget()
   if not self:GetIsValid() then return OBJECT_INVALID end
   local obj = cre.obj.cre_attack_target
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Get creature's attempted attack target
function M.Creature:GetAttemptedAttackTarget()
   if not self:GetIsValid() then return OBJ.INVALID end

   NWE.ExecuteCommand(361, 0)
   return NWE.StackPopObject()
end

--- Get creature's attempted spell target
function M.Creature:GetAttemptedSpellTarget()
   if not self:GetIsValid() then return OBJ.INVALID end

   NWE.ExecuteCommand(375, 0)
   return NWE.StackPopObject()
end

--- Get creature's challenge rating
function M.Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_cr
end

--- Get creature's combat mode
function M.Creature:GetCombatMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_mode_combat
end

--- Get creature's damage flags.
function M.Creature:GetDamageFlags()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetDamageFlags(self.obj)
end

--- Get creatures attacker.
function M.Creature:GetGoingToBeAttackedBy()
   if not self:GetIsValid() then return OBJ.INVALID end

   local obj = self.obj.cre_attacker
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Determines if creature is immune to critical hits.
-- @param attacker Attacker
function M.Creature:GetIsImmuneToCriticalHits(attacker)
   error "nwnxcombat"
end

--- Determines if creature is immune to sneak/death attacks.
--    Ignores immunity to critical hits.
-- @param attacker Attacker
function M.Creature:GetIsImmuneToSneakAttack(attacker)
   error "nwnxcombat"
end

--- Determines if creature is in combat.
function M.Creature:GetIsInCombat()
   if not self:GetIsValid() then return false end
   return self.obj.cre_combat_state ~= 0
end

--- Determines if creature is visible to another creature.
-- @param target Target to test.
function M.Creature:GetIsVisibile(target)
   if not self:GetIsValid() then return false end
   return C.nwn_GetIsVisible(self.obj, target.id)
end

--- Get's last attack type used by creature.
function M.Creature:GetLastAttackType()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_type
end

--- Get's last attack mode used by creature.
function M.Creature:GetLastAttackMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_mode
end

--- Get's last trap detected by creature.
function M.Creature:GetLastTrapDetected()
   if not self:GetIsValid() then return OBJ.INVALID end
   local obj = cre.obj.cre_last_trap_detected
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Get's last weapon used by creature.
function M.Creature:GetLastWeaponUsed()
   if not self:GetIsValid() then return OBJ.INVALID end
   local obj = self.obj.obj.obj_last_attack_weapon
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Determines creatures maximum attack range.
-- @param target Target to attack
function M.Creature:GetMaxAttackRange(target)
   return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

--- Determines reflex saved damage adjustment.
-- @param damage Total damage.
-- @param dc Difficulty class
-- @param savetype solstice.save constant.
-- @param versus Creature to roll against.
function M.Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   NWE.StackPushObject(versus)
   NWE.StackPushInteger(savetype)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(damage)
   NWE.ExecuteCommand(299, 5)
   return NWE.StackPopInteger()
end

--- Determines turn resistance hit dice.
function M.Creature:GetTurnResistanceHD()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(478, 1)
   NWE.StackPopInteger()
end

--- Restores a creature's base number of attacks.
function M.Creature:RestoreBaseAttackBonus()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(756, 1)
end

--- Sets a creature's base number of attacks.
-- @param amount Amount of attacks.
function M.Creature:SetBaseAttackBonus(amount)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(amount)
   NWE.ExecuteCommand(755, 2)
end

--- Causes all creatures in a 10 meter (1 tile) radius to stop actions.
-- Improves the creature's reputation with nearby enemies for 3 minutes. Only works for NPCs.
function M.Creature:SurrenderToEnemies()
   NWE.ExecuteCommand(476, 0);
end
