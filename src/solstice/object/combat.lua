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

--- Determine object's 'hardness'
function M.Object:GetHardness()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(796, 1)
   return NWE.StackPopInteger()
end

--- Determines if object is immune to an effect.
-- @param immunity IMMUNITY\_TYPE\_*
-- @return Always `false`.
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

--- Get objects damage immunity.
-- NOTE: Not default behavior
-- @param dmgidx DAMAGE\_INDEX\_*
function M.Object:GetDamageImmunity(dmgidx)
   return 0
end


--- Debug damage immunities.
function M.Object:DebugDamageImmunities()
   local t = {}
   table.insert(t, "Damage Immunity:")
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      table.insert(t, string.format('  %s: Innate: %d, Effect: %d',
                                    Rules.GetDamageName(i),
                                    self.ci.defense.immunity_base[i],
                                    self.ci.defense.immunity[i]))
   end
   return table.concat(t, '\n')
end

--- Debug damage resistance.
function M.Object:DebugDamageResistance()
   local t = {}
   local eff
   local start = self.obj.cre_stats.cs_first_dresist_eff
   if start <= 0 then start = 0 end

   table.insert(t, "Damage Resist:")

   for i = 0, DAMAGE_INDEX_NUM - 1 do
      eff, start = self:GetBestDamageResistEffect(i, start)

      if eff then
        table.insert(t, string.format('  %s: Innate: %d, Effect: %d/- Limit: %d, Stacking: %d',
                                      Rules.GetDamageName(i),
                                      self.ci.defense.resist[i],
                                      eff.eff_integers[1],
                                      eff.eff_integers[2],
                                      self.ci.defense.resist_stack[i]))
      else
         table.insert(t, string.format('  %s: Innate: %d, Stacking: %d',
                                       Rules.GetDamageName(i),
                                       self.ci.defense.resist[i],
                                       self.ci.defense.resist_stack[i]))
      end
   end
   return table.concat(t, '\n')
end

--- Debug damage reduction.
function M.Object:DebugDamageReduction()
   local t = {}
   local eff
   local start = self.obj.cre_stats.cs_first_dred_eff
   if start <= 0 then start = 0 end

   table.insert(t, "Damage Reduction:")
   table.insert(t, string.format('  Innate: %d', self:GetHardness()))

   for i=0, DAMAGE_POWER_NUM - 1 do
      eff, start = self:GetBestDamageReductionEffect(i, start)
      if eff then
         table.insert(t, string.format('  %d: Effect: %d/+%d Limit: %d, Stacking: %d',
                                       i,
                                       eff.eff_integers[0],
                                       i,
                                       eff.eff_integers[2],
                                       self.ci.defense.soak_stack[i]))
      else
         table.insert(t, string.format('  %d: Stacking: %d',
                                       i, self.ci.defense.soak_stack[i]))
      end
   end
   return table.concat(t, '\n')
end

--- Determines damage immunity adjustment.
-- @param amt Damage amount.
-- @param dmgidx Damage index DAMAGE\_INDEX\_*
-- @return Both the adjusted damage amt and the amount resisted will
-- be returned.
function M.Object:DoDamageImmunity(amt, dmgidx)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM or amt <= 0 then
      return amt, 0
   end

   local imm = self:GetDamageImmunity(dmgidx)
   local imm_adj = math.floor((imm * amt) / 100)

   return amt - imm_adj, imm_adj
end

--- Determine best damage reduction effect.
-- @param dmgidx DAMAGE\_INDEX\_*
-- @param[opt=0] start Place in object effect array to start looking.
function M.Object:GetBestDamageResistEffect(dmgidx, start)
   start = start or 0

   local cur, camount, climit
   local flag = bit.lshift(1, dmgidx)

   for i = start, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > EFFECT_TYPE_DAMAGE_RESISTANCE then
         return cur, i
      end

      if self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_RESISTANCE then
         if self.obj.obj.obj_effects[i].eff_integers[0] > flag then
            return cur, i
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
end

--- Determine best damage reduction effect.
-- @param power Damage power.
-- @param[opt=0] start Place in object effect array to start looking.
function M.Object:GetBestDamageReductionEffect(power, start)
   local cur, camount, climit
   start = start or 0

   for i = start, self.obj.obj.obj_effects_len - 1 do
      -- Only check damage reduction effects.
      if self.obj.obj.obj_effects[i].eff_type >
         EFFECT_TYPE_DAMAGE_REDUCTION then return cur end

      if self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_REDUCTION then
         local amount = self.obj.obj.obj_effects[i].eff_integers[0]
         local dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
         local limit = self.obj.obj.obj_effects[i].eff_integers[2]

         if dmg_power > power then
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
   end
end

--- Get objects base damage resistance.
-- @param dmgidx DAMAGE\_INDEX\_*
-- @return Always 0
function M.Object:GetBaseResist(dmgidx)
   return 0
end

--- Resolves damage resistance.
-- @param amt Damage amount.
-- @param eff Damage Resistance effect if any.
-- @param dmgidx DAMAGE\_INDEX\_*
-- @return Adjusted damage amount.
-- @return Adjustment amount.
function M.Object:DoDamageResistance(amt, eff, dmgidx)
   if amt <= 0 then return amt, 0 end

   local resist = 0
   if self.type == OBJBECT_TRUETYPE_CREATURE then
      resist = self.ci.defense.resist[dmgidx]
   end

   local total = amt
   local resist_adj = 0
   local remove_effect = false

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
            C.nwn_RemoveEffectById(self.obj.obj, eff.eff_id)
            remove_effect = true
         else
            eff.eff_integers[2] = eff_limit - eff_resist_adj
         end
      end
      resist_adj = resist_adj + eff_resist_adj
   end
   return amt - resist_adj, resist_adj, remove_effect
end

--- Resolves damage reduction.
-- @param amt Damage amount.
-- @param eff Damage reduction effect if any.
-- @param power DAMAGE\_POWER\_*
-- @return Adjusted damage amount.
-- @return Adjustment amount.
function M.Object:DoDamageReduction(amt, eff, power)
   if amt <= 0 or power <= 0 then return amt, 0 end
   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = self:GetHardness()
   local use_eff
   local remove_effect = false

   if eff then
      use_eff = eff.eff_integers[0] > highest_soak
      highest_soak = max(eff.eff_integers[0], highest_soak)
   end

   -- Now that the highest soak amount has been found, determine the minimum of it and
   -- the base damage.  I.e. you can't soak more than your damamge.
   highest_soak = min(amt, highest_soak)


   -- If using a soak effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      local eff_limit = eff.eff_integers[2]
      if eff_limit > 0 then
         -- If the effect damage limit is less than the highest soak amount then
         -- the effect needs to be remove and the highest soak amount adjusted. I.e.
         -- You can't soak more than the remaing limit on soak damage.
         -- Else the current limit must be adjusted by the highest soak amount.
         if eff_limit <= highest_soak then
            highest_soak = eff_limit
            C.nwn_RemoveEffectById(self.obj.obj, eff.eff_id)
            remove_effect = true
         else
            eff.eff_integers[2] = eff_limit - highest_soak
         end
      end
   end

   return amt - highest_soak, highest_soak, remove_effect
end

-- Bridge functions.

function NWNXSolstice_DoDamageImmunity(obj, vs, amt, dmgidx, no_feedback)
   obj = _SOL_GET_CACHED_OBJECT(obj)
   vs = _SOL_GET_CACHED_OBJECT(vs)
   local new, adj = obj:DoDamageImmunity(amt, dmgidx)

   return new
end

function NWNXSolstice_DoDamageReduction(obj, vs, amt, power, no_feedback)
   obj = _SOL_GET_CACHED_OBJECT(obj)
   vs = _SOL_GET_CACHED_OBJECT(vs)

   local start = 0
   if obj.type == OBJECT_TRUETYPE_CREATURE
      and obj.obj.cre_stats.cs_first_dred_eff > 0
   then
      start = obj.obj.cre_stats.cs_first_dred_eff
   end

   local eff = obj:GetBestDamageReductionEffect(power, start)

   local new, adj = obj:DoDamageResistance(amt, eff, power)

   return new
end

function NWNXSolstice_DoDamageResistance(obj, vs, amt, dmgidx, no_feedback)
   obj = _SOL_GET_CACHED_OBJECT(obj)
   vs = _SOL_GET_CACHED_OBJECT(vs)

   local start = 0
   if obj.type == OBJECT_TRUETYPE_CREATURE
      and obj.obj.cre_stats.cs_first_dresist_eff > 0
   then
      start = obj.obj.cre_stats.cs_first_dresist_eff
   end

   local eff = obj:GetBestDamageResistEffect(dmgidx, start)
   local new, adj = obj:DoDamageReduction(amt, eff, power)

   return new
end
