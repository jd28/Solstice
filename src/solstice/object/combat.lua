--- Object
-- @module object

local NWE = require 'solstice.nwn.engine'

local ffi = require 'ffi'
local C = ffi.C
local random = math.random
local floor  = math.floor
local min    = math.min
local max    = math.max

local bit    = require 'bit'
local bor    = bit.bor
local band   = bit.band
local lshift = bit.lshift

local M = require 'solstice.object.init'

--- Class Object: Combat
-- @section

---
function M.Object:DoDamage(amount)
   print("Object:DoDamage")
   return C.nwn_DoDamage(self.obj.obj, self.type, amount)
end

--- Get an objects AC versus
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable AC.
-- @param attacker Whoever is attacking the object
-- @param attack Attack instance, just in case.
function M.Object:GetACVersus(attacker, attack)
   return 0
end

--- Get an objects concealment
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable concealment.
function M.Object:GetConcealment()
   return 0
end

---
function M.Object:GetHardness()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(796, 1)
   return NWE.StackPopInteger()
end

---
function M.Object:GetIsImmune(immunity)
   return false
end

--- Determine who last attacked a creature, door or placeable object.
function M.Object:GetLastAttacker()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_attacker

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Get the object which last damaged a creature or placeable object.
function M.Object:GetLastDamager()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_damager

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Gets the object's killer.
-- @return Killer or solstice.object.INVALID
function M.Object:GetKiller()
   if not self:GetIsValid() then return M.INVALID end

   local actor = self.obj.obj.obj_killer
   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Gets the last living, non plot creature that performed a
-- hostile act against the object.
-- @return Killer or OBJECT_INVALID
function M.Object:GetLastHostileActor()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Set's an object's hardness.q
-- @param hardness New hardness value.
function M.Object:SetHardness(hardness)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(hardness)
   NWE.ExecuteCommand(797, 2)
end

--- Sets the last hostile actor
-- Source: nwnx_funcs by Acaos
function M.Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end

   self.obj.obj.obj_last_hostile_actor = actor.id
end

function M.Object:GetDamageImmunity(dmgidx)
   return 0
end

--- Determines damage immunity adjustment.
-- @param amt Damage amount.
-- @param dmgidx Damage index DAMAGE\_INDEX\_*
-- @return Both the adjusted damage amt and the amount resisted will
-- be returned.
function M.Object:DoDamageImmunity(amt, dmgidx, info)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM or amt <= 0 then
      return amt, 0
   end

   local imm = self:GetDamageImmunity(dmgidx)
   local imm_adj = math.floor((imm * amt) / 100)

   return amt - imm_adj, imm_adj
end

function M.Object:GetBestDamageResistEffect(dmgidx, start)
   start = start or 0

   local cur, camount, climit
   local flag = bit.lshift(1, dmgidx)

   for i = start, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_RESISTANCE then
         return cur
      end

      if self.obj.obj.obj_effects[i].eff_integers[0] > flag then
         return cur, start
      end

      local amount = self.obj.obj.obj_effects[i].eff_integers[1]
      local limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if amount > 0 and self.obj.obj.obj_effects[i].eff_integers[0] == flag then
         if not cur then
            cur, camount, climit = self.obj.obj.obj_effects[i], amount, limit
         else
            -- If the resist amount is higher, set the resist effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount or (amount == camount and limit > climit) then
               cur, camount, climit = self.obj.obj.obj_effects[i], amount, limit
            end
         end
      end
   end
end

function M.Object:GetBestDamageReductionEffect(power, start)
   local cur, camount, climit
   start = start or 0

   for i = start, self.obj.obj.obj_effects_len - 1 do
      -- Only check damage reduction effects.
      if self.obj.obj.obj_effects[i].eff_type ~=
         EFFECT_TYPE_DAMAGE_REDUCTION then return cur end

      if self.obj.obj.obj_effects[i].eff_integers[1] >= power then
         return cur
      end

      local amount = self.obj.obj.obj_effects[i].eff_integers[0]
      local dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
      local limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if not cur and amount > 0 then
         cur, camount, climit = self.obj.obj.obj_effects[i], amount, limit
      else
         -- If the soak amount is higher, set the soak effect list to the effect index.
         -- If they are equal prefer the one with the highest damage limit.
         if amount > camount or (amount == camount and limit > climit) then
            cur, camount, climit = self.obj.obj.obj_effects[i], amount, limit
         end
      end
   end
end

function M.Object:GetBaseResist(dmgidx)
   return 0
end

function M.Object:DoDamageResistance(amt, eff, dmgidx, info)
   if amt <= 0 then return amt end

   local resist = self:GetBaseResist(dmgidx)

   local total = 0
   local resist_adj = 0

   -- Innate / Feat resistance.  In the case of damage reduction these stack
   -- with damage resistance effects.
   -- If the resistance is greater than zero, use it.
   if resist > 0 then
      -- Take the minimum of damage and resistance, since you can't resist
      -- more damage than you take.
      resist_adj = min(amt, resist)
      total = amt - resist_adj
   end

   if total > 0 and eff then
      -- Take the minimum of current damage told and effect resistance.
      local eff_resist_adj = min(eff.eff_integers[1], total)
      local eff_limit = eff.eff_integers[2]
      if eff_limit > 0 then
         -- If the remaining damage limit is less than the amount to resist.
         -- then resist only what is left and remove the effect.
         -- Else modifiy the effects damage limit by the resist amount.
         if eff_limit <= eff_resist_adj then
            eff_resist_adj = eff_limit
            self:RemoveEffectByID(use_eff.eff_id)
         else
            eff.eff_integers[2] = eff_limit - eff_resist_adj
         end
      end
      resist_adj = resist_adj + eff_resist_adj
   end
   return amt - resist_adj
end

function M.Object:DoDamageReduction(amt, eff, power, info)
   if amt <= 0 or power <= 0 then return amt end
   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = self:GetHardness()
   local use_eff

   if eff then
      use_eff = eff.eff_integers[0] > highest_soak
      highest_soak = max(eff.eff_integers[0], highest_soak)
   end

   -- Now that the highest soak amount has been found, determine the minimum of it and
   -- the base damage.  I.e. you can't soak more than your damamge.
   highest_soak = min(amt, highest_soak)

   -- If using a soak effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      --- Don't destroy the effect unless this is a REAL attack.
      if attack then
         local eff_limit = eff.eff_integers[2]
         if eff_limit > 0 then
            -- If the effect damage limit is less than the highest soak amount then
            -- the effect needs to be remove and the highest soak amount adjusted. I.e.
            -- You can't soak more than the remaing limit on soak damage.
            -- Else the current limit must be adjusted by the highest soak amount.
            if eff_limit <= highest_soak then
               highest_soak = eff_limit
               if burn_eff then
                  self:RemoveEffectByID(use_eff.eff_id)
               end
            elseif burn_eff then
               use_eff.eff_integers[2] = eff_limit - highest_soak
            end
         end
      end
   end

   return amt - highest_soak
end
