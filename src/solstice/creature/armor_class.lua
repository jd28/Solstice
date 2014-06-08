--- Armor Class
-- @module creature

local M = require 'solstice.creature.init'

local clamp = math.clamp
local max   = math.max

--- Armor Class
-- @section

--- Get Armor Check Penalty.
function M.Creature:GetArmorCheckPenalty()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_stats.cs_acp_armor + self.obj.cre_stats.cs_acp_shield
end

---- Determines AC vs creature.
-- The last three parameters should only be used from the combat engine.
-- @param vs Attacking creature
-- @param touch If true it's a touch attack.
-- @param[opt] is_ranged From ranged attack.
-- @bool[opt] attack Attack ctype
-- @param[opt] state Creature state.
function M.Creature:GetACVersus(vs, touch, is_ranged, attack, state)
   vs = vs or OBJECT_INVALID
   -- 10 base AC
   local ac = 10
   local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0
   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge

   local min_mod, max_mod = self:GetMinArmorClassMod(), self:GetMaxArmorClassMod()


   -- Natural AC
   ac = ac + self.obj.cre_stats.cs_ac_natural_base

   if not self:GetIsPolymorphed() then
      -- Armor AC
      ac = ac + self.obj.cre_stats.cs_ac_armour_base
      -- Shield AC
      ac = ac + self.obj.cre_stats.cs_ac_shield_base
   end

   ac = ac + self.ci.mod_mode.ac

   -- Area, class, feat, race, size bonuses.
   for i=0, COMBAT_MOD_SKILL - 1 do
      ac = ac + self.ci.mods[i].ac
   end

   if not attack then
      -- If not an attack we can include skills and dex modifier without
      -- worrying about being flatfooted, etc

      -- Dodge AC
      dodge = self.obj.cre_stats.cs_ac_dodge_bonus - self.obj.cre_stats.cs_ac_dodge_penalty

      -- Skill: Tumble...
      ac = ac + self.ci.mods[COMBAT_MOD_SKILL].ac

      -- Dex Mod.
      val = self:GetDexMod(not self:GetIsPolymorphed())
      ac = ac + val
   else
      -- Dex Modifier
      local dex_mod = self:GetDexMod(not self:GetIsPolymorphed())
      local dexed = false

      -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
      -- then target gets no Dex mod.
      if bit.band(COMBAT_TARGET_STATE_ATTACKER_INVIS, state) == 0 and
         bit.band(COMBAT_TARGET_STATE_FLATFOOTED, state) == 0
      then
         -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
         -- gets dex_mod and dodge AC
         if bit.band(COMBAT_TARGET_STATE_ATTACKER_UNSEEN, state) == 0
            or (self:GetHasFeat(FEAT_BLIND_FIGHT) and is_ranged)
         then
            if dex_mod > 0 then
               dexed = true
            end
            -- Dodge AC
            dodge = self.obj.cre_stats.cs_ac_dodge_bonus - self.obj.cre_stats.cs_ac_dodge_penalty

            -- Skill: Tumble...
            ac = ac + self.ci.mods[COMBAT_MOD_SKILL].ac

            -- If this is an attack of opportunity and target has mobility
            -- there is a +4 ac bonus. TODO: Fix
            --if attack:GetSpecialAttack() == -534
            --   and self:GetHasFeat(FEAT_MOBILITY)
            --then
            --   ac = ac + 4
            --end

            if self:GetHasFeat(FEAT_DODGE) then
               if self.obj.cre_combat_round.cr_dodge_target == OBJECT_INVALID.id then
                  self.obj.cre_combat_round.cr_dodge_target = vs.id
               end
               if self.obj.cre_combat_round.cr_dodge_target == vs.id
                  and not Rules.CanUseClassAbilities(self, CLASS_TYPE_MONK)
               then
                  ac = ac + 1
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
         and (self:GetHasFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
         or self:GetHasFeat(FEAT_UNCANNY_DODGE_1))
      then
         dexed = true
      end

      if dexed then ac = ac + dex_mod end
   end

   -- +4 Defensive Training Vs.
   if self:GetHasTrainingVs(vs) then
      ac = ac + 4
   end

   -- Armor AC
   armor = self.obj.cre_stats.cs_ac_armour_bonus - self.obj.cre_stats.cs_ac_armour_penalty
   -- Deflect AC
   deflect = self.obj.cre_stats.cs_ac_deflection_bonus - self.obj.cre_stats.cs_ac_deflection_penalty
   -- Natural AC
   nat = self.obj.cre_stats.cs_ac_natural_bonus - self.obj.cre_stats.cs_ac_natural_penalty
   -- Shield AC
   shield = self.obj.cre_stats.cs_ac_shield_bonus - self.obj.cre_stats.cs_ac_shield_penalty


   if touch then return ac + dodge end

   dodge = clamp(dodge, min_mod, max_mod)
   ac = ac + nat + armor + shield + deflect + dodge
   return ac
end


--- Determine maximum armor class modifier
function M.Creature:GetMaxArmorClassMod()
   return 20
end

--- Determine minimum armor class modifier
function M.Creature:GetMinArmorClassMod()
   return -20
end
