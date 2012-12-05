
--- Determines damage adjustment.
-- This function is merely for hooking purposes.
-- @param target Attack target.
-- @param amt Damage amount.
-- @param dmgidx Damage index [0, NS_OPT_NUM_DAMAGES]
-- @return Both the adjusted damage amt and the amount of adjustment MUST
--    be returned.
function Creature:GetDamageAdjustment(target, amt, dmgidx)
   return amt, 0
end

--- Determines damage immunity adjustment.
-- @param dmgidx Damage index [0, NS_OPT_NUM_DAMAGES]
-- @param flags Base weapon damage flags.  This MUST be passed
--    if dmgidx == 12
-- @return Both the adjusted damage amt and the amount resisted will
--    be returned.
function Creature:GetDamageImmunityAdj(amt, dmgidx, flags)
   local imm, imm_adj
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= NS_OPT_NUM_DAMAGES then
      return amt, 0
   end

   -- No need to apply immunity to a damage that is zero.
   -- Most likely if this is the case than something is horribly
   -- wrong.
   if amt <= 0 then return amt, 0 end

   -- Base weapon damage at index 12 needs to be handled specially because
   -- if there are multiple base damages immunity favors the attacker,
   -- so the minimum has to be found.
   if dmgidx == 12 then
      imm = self:GetDamageImmunityVsFlags(flags, true)
   else
      imm = self:GetDamageImmunity(dmgidx)
   end

   -- Immunity
   imm_adj = math.floor((imm * amt) / 100)

   return amt - imm_adj, imm_adj
end

--- Determines a creatures damage resistance.
-- @param amt Damage amount
-- @param dmgidx Damage index [0, NS_OPT_NUM_DAMAGES]
-- @param flags Base weapon damage flags.  This MUST be passed
--    if dmgidx == 12
-- @param burn_eff If true then if there is an applicable resistant effect 
--    with a total damage limit, the limit will be used  and if exhausted
--    the effect will be removed. (Default: false)
-- @return Both the adjusted damage amt and the amount resisted will
--    be returned.
function Creature:GetDamageResistAdj(amt, dmgidx, flags, burn_eff)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= NS_OPT_NUM_DAMAGES then
      return amt, 0
   end

   -- No need to apply immunity to a damage that is zero.
   -- Most likely if this is the case than something is horribly
   -- wrong.
   if amt <= 0 then return amt, 0 end

   local use_eff, resist, eff
   local total = 0
   local resist_adj = 0

   -- If the damage index is 12 and attack info was passed to the function
   -- then this is a combat situation.
   if dmgidx == 12 then
      -- Damage resistance favors the defender.  It will return the maximum innate resistance
      -- and the highest applicable resistance effect.  It doesn't return a resist effect index
      -- but the actual effect that applies as an effect_t ctype.
      resist, eff = self:GetDamageResistVsFlags(flags, false)
   else
      resist = self.ci.resist[dmgidx]
      local eff_idx = self.ci.eff_resist[dmgidx]
      -- If there is a resist effect for this damage, use it.
      if eff_idx >= 0 then
	 eff = self:GetEffectAtIndex(eff_idx)
      end
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
	       self:RemoveEffectByID(use_eff:GetId())
	    end
	 elseif burn_eff then
	    use_eff:SetInt(2, eff_limit - eff_resist_adj)
	 end
      end
      resist_adj = resist_adj + eff_resist_adj
   end
   return amt - resist_adj, resist_adj
end

--- Determines a creatures damage reduction.
-- @param base_damage Base damage amount
-- @param damage_power Enhancement of the weapon/damage used...
-- @param burn_eff If true then if there is an applicable resistant effect 
--    with a total damage limit, the limit will be used  and if exhausted
--    the effect will be removed. (Default: false)
-- @return Both the adjusted damage amt and the amount soaked will
--    be returned.
function Creature:GetDamageReductionAdj(base_damage, damage_power, burn_eff)
   if damage_power > 20 or damage_power <= 0 then
      return base_damage, 0
   end

   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = self.ci.soak
   local use_eff

   -- If damage power is greater then 20 or less than zero something is most
   -- likely wrong so don't bother with effects
   if damage_power < 20 and damage_power >= 0 then
      -- Loop through the soak effects and find a soak that is a) higher than innate soak
      -- and b) is greater than the damage power.
      for i = damage_power + 1, 20 do
         local eff_idx = self.ci.eff_soak[i]
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
		  self:RemoveEffectByID(use_eff:GetId())
	       end
	    elseif burn_eff then
	       use_eff:SetInt(2, eff_limit - highest_soak)
	    end
	 end
      end
   end

   return base_damage - highest_soak, highest_soak
end
