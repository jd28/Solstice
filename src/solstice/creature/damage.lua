--- Creature
-- @module creature

local ffi = require 'ffi'
local M = require 'solstice.creature.init'

--- Determines damage adjustment.
-- This function is merely for hooking purposes.
-- @param target Attack target.
-- @param amt Damage amount.
-- @param dmgidx Damage index DAMAGE\_INDEX\_*
-- @return Both the adjusted damage amt and the amount of adjustment MUST
-- be returned.
function M.Creature:GetDamageAdjustment(target, amt, dmgidx)
   return amt, 0
end

--- Determines damage immunity adjustment.
-- @param amt Damage amount.
-- @param dmgidx Damage index DAMAGE\_INDEX\_*
-- @return Both the adjusted damage amt and the amount resisted will
-- be returned.
function M.Creature:GetDamageImmunityAdj(amt, dmgidx)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM or amt <= 0 then
      return amt, 0
   end

   local imm = self:GetDamageImmunity(dmgidx)
   local imm_adj = math.floor((imm * amt) / 100)

   return amt - imm_adj, imm_adj
end

function M.Creature:GetDamageImmunity(dmgidx)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM then
      return 0
   end
   return math.clamp(self.ci.defense.immunity[dmgidx] +
                     self.ci.defense.immunity_base[dmgidx],
                     0, 100)
end

--- Determines a creatures damage resistance.
-- @param amt Damage amount
-- @param dmgidx Damage index DAMAGE\_INDEX\_*
-- @param[opt=false] burn_eff If true then if there is an applicable resistant effect
-- with a total damage limit, the limit will be used  and if exhausted
-- the effect will be removed.
-- @return Both the adjusted damage amt and the amount resisted will
-- be returned.
function M.Creature:GetDamageResistAdj(amt, dmgidx, burn_eff)
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM or amt <= 0 then
      return amt, 0
   end

   local use_eff, eff
   local total = 0
   local resist_adj = 0

   local resist = self.ci.defense.resist[dmgidx]
   local eff_idx = self.ci.defense.resist_eff[dmgidx]
   -- If there is a resist effect for this damage, use it.
   if eff_idx >= 0 then
      eff = self:GetEffectAtIndex(eff_idx)
   end

   -- Innate / Feat resistance.  In the case of damage reduction these stack
   -- with damage resistance effects.
   -- If the resistance is greater than zero, use it.
   if resist > 0 then
      -- Take the minimum of damage and resistance, since you can't resist
      -- more damage than you take.
      resist_adj = math.min(amt, resist)
      total = amt - resist_adj
   end

   -- If there is any damage left to be resisted by effects and
   -- if there is an applicable resist effect, use it.
   if total > 0 and eff then
      use_eff = eff
   end

   local eff_id
   -- If using a resist effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      -- Take the minimum of current damage told and effect resistance.
      local eff_resist_adj = math.min(use_eff:GetInt(1), total)
      local eff_limit = use_eff:GetInt(2)
      if eff_limit > 0 then
         -- If the remaining damage limit is less than the amount to resist.
         -- then resist only what is left and remove the effect.
         -- Else modifiy the effects damage limit by the resist amount.
         if eff_limit <= eff_resist_adj then
            eff_resist_adj = eff_limit
            if burn_eff then
               -- Set amount to -1, so the update won't bother with it.
               use_eff:SetInt(1, -1)
               eff_id = use_eff:GetId()
               --self:RemoveEffectByID()
            end
         elseif burn_eff then
            use_eff:SetInt(2, eff_limit - eff_resist_adj)
         end
      end
      resist_adj = resist_adj + eff_resist_adj
   end
   return amt - resist_adj, resist_adj, eff_id
end

--- Determines a creatures damage reduction.
-- @param base_damage Base damage amount
-- @param damage_power Enhancement of the weapon/damage used...
-- @param[opt=false] burn_eff If true then if there is an applicable resistant effect
-- with a total damage limit, the limit will be used  and if exhausted
-- the effect will be removed.
-- @return Adjusted amount.
-- @return Amount soaked.
-- @return Effect to be removed.
function M.Creature:GetDamageReductionAdj(base_damage, damage_power, burn_eff)
   if damage_power > 20 or damage_power <= 0 then
      return base_damage, 0
   end

   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = self.ci.defense.soak
   local use_eff

   -- If damage power is greater then 20 or less than zero something is most
   -- likely wrong so don't bother with effects
   if damage_power < 20 and damage_power >= 0 then
      -- Loop through the soak effects and find a soak that is a) higher than innate soak
      -- and b) is greater than the damage power.
      for i = damage_power + 1, 20 do
         local eff_idx = self.ci.defense.soak_eff[i]
         if eff_idx >= 0 then
            local eff = self:GetEffectAtIndex(eff_idx)
            local eff_amount = eff:GetInt(0)
            -- If the soak amount is greater than the higest soak, save the effect for later use.
            -- If it has a limit it will need to be adjusted or removed.  Update the new highest
            -- soak amount.  The limit here is itself not relevent.
            if eff_amount >= highest_soak then
               highest_soak = eff_amount
               use_eff = eff
            end
         end
      end
   end

   -- Now that the highest soak amount has been found, determine the minimum of it and
   -- the base damage.  I.e. you can't soak more than your damamge.
   highest_soak = math.min(base_damage, highest_soak)

   local eff_id
   -- If using a soak effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      --- Don't destroy the effect unless this is a REAL attack.
      if attack then
         local eff_limit = use_eff:GetInt(2)
         if eff_limit > 0 then
            -- If the effect damage limit is less than the highest soak amount then
            -- the effect needs to be remove and the highest soak amount adjusted. I.e.
            -- You can't soak more than the remaing limit on soak damage.  Effect removal
            -- will trigger Creature:UpdateDamageReduction to determine the new best soak
            -- effects.
            -- Else the current limit must be adjusted by the highest soak amount.
            if eff_limit <= highest_soak then
               highest_soak = eff_limit
               if burn_eff then
                  eff_id = use_eff:GetId()
                  -- Set amount to -1, so the update won't bother with it.
                  use_eff:SetInt(0, -1)
                  --self:RemoveEffectByID(use_eff:GetId())
               end
            elseif burn_eff then
               use_eff:SetInt(2, eff_limit - highest_soak)
            end
         end
      end
   end

   return base_damage - highest_soak, highest_soak, eff_id
end

function M.Creature:SetDamageResistanceEffect(damage, effect_id)
   if damage < 0 and damage >= DAMAGE_INDEX_NUM then
      error(string.format("Invalid Damage Index: %d\n%s",
                          damage, debug.traceback()))
   end
   self.ci.defense.resist_eff[damage] = effect_id
end

function M.Creature:SetDamageReductionEffect(power, effect_id)
   if power < 0 and power >= DAMAGE_POWER_NUM then
      error(string.format("Invalid Damage Power: %d\n%s",
                          power, debug.traceback()))
   end
   self.ci.defense.soak_eff[power] = effect_id
end

function M.Creature:ModifyDamageImmunityEffect(damage, amount)
   if damage < 0 and damage >= DAMAGE_INDEX_NUM then
      error(string.format("Invalid Damage Index: %d\n%s",
                          damage, debug.traceback()))
   end

   self.ci.defense.immunity[damage] = self.ci.defense.immunity[damage] + amount
end
