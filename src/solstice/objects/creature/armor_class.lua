----
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature

local clamp = math.clamp
local max   = math.max

--- Armor Class
-- @section

--- Get Armor Check Penalty.
function Creature:GetArmorCheckPenalty()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_stats.cs_acp_armor + self.obj.cre_stats.cs_acp_shield
end

---- Determines AC vs creature.
-- The last three parameters should only be used from the combat engine.
-- @param vs Attacking creature
-- @bool touch If true it's a touch attack.
-- @bool[opt] is_ranged From ranged attack.
-- @bool[opt] attack Attack ctype
-- @param[opt] state Creature state.
function Creature:GetACVersus(vs, touch, is_ranged, attack, state)
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

   ac = ac + Rules.GetModeModifier(self.obj.cre_combat_mode, ATTACK_MODIFIER_AC, cre)

   -- Area, class, feat, race, size bonuses.
   for i=0, COMBAT_MOD_SKILL - 1 do
      ac = ac + Rules.GetCombatModifier(i, ATTACK_MODIFIER_AC, self)
   end

   if not attack then
      -- If not an attack we can include skills and dex modifier without
      -- worrying about being flatfooted, etc

      -- Dodge AC
      dodge = self.obj.cre_stats.cs_ac_dodge_bonus - self.obj.cre_stats.cs_ac_dodge_penalty

      -- Skill: Tumble...
      ac = ac + Rules.GetCombatModifier(COMBAT_MOD_SKILL, ATTACK_MODIFIER_AC, self)

      -- Dex Mod.
      local val = self:GetDexMod(not self:GetIsPolymorphed())
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
            ac = ac + Rules.GetCombatModifier(COMBAT_MOD_SKILL, ATTACK_MODIFIER_AC, self)

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

function Creature:DebugArmorClass()
   local t = {}
   table.insert(t, "Armor Class:")
   table.insert(t, string.format("  Total: %d, Touch: %d",
                                 self:GetACVersus(OBJECT_INVALID, false),
                                 self:GetACVersus(OBJECT_INVALID, true)))
   table.insert(t, "  Base: 10")
   table.insert(t, string.format("  Base Natural AC: %d", self.obj.cre_stats.cs_ac_natural_base))
   table.insert(t, string.format("  Base Armor AC: %d", self.obj.cre_stats.cs_ac_armour_base))
   table.insert(t, string.format("  Base Shield AC: %d", self.obj.cre_stats.cs_ac_shield_base))

   table.insert(t, string.format("  Dexterity Modifier: %d", self:GetDexMod(not self:GetIsPolymorphed())))

   table.insert(t, string.format("  Armor AC: %d (%d - %d)",
                                 self.obj.cre_stats.cs_ac_armour_bonus - self.obj.cre_stats.cs_ac_armour_penalty,
                                 self.obj.cre_stats.cs_ac_armour_bonus,
                                 self.obj.cre_stats.cs_ac_armour_penalty))

   table.insert(t, string.format("  Deflect AC: %d (%d - %d)",
                                 self.obj.cre_stats.cs_ac_deflection_bonus - self.obj.cre_stats.cs_ac_deflection_penalty,
                                 self.obj.cre_stats.cs_ac_deflection_bonus,
                                 self.obj.cre_stats.cs_ac_deflection_penalty))

   table.insert(t, string.format("  Sheild AC: %d (%d - %d)",
                                 self.obj.cre_stats.cs_ac_shield_bonus - self.obj.cre_stats.cs_ac_shield_penalty,
                                 self.obj.cre_stats.cs_ac_shield_bonus,
                                 self.obj.cre_stats.cs_ac_shield_penalty))

   table.insert(t, string.format("  Natural AC: %d (%d - %d)",
                                 self.obj.cre_stats.cs_ac_natural_bonus - self.obj.cre_stats.cs_ac_natural_penalty,
                                 self.obj.cre_stats.cs_ac_natural_bonus,
                                 self.obj.cre_stats.cs_ac_natural_penalty))

   table.insert(t, string.format("  Dodge AC: %d (%d - %d)",
                                 self.obj.cre_stats.cs_ac_dodge_bonus - self.obj.cre_stats.cs_ac_dodge_penalty,
                                 self.obj.cre_stats.cs_ac_dodge_bonus,
                                 self.obj.cre_stats.cs_ac_dodge_penalty))

   table.insert(t, string.format("  Mode AC: %d", self.ci.mod_mode.ac))


   table.insert(t, "  Combat Modifiers:")
   table.insert(t, string.format("    AC Area Modifier: %d", self.ci.mods[COMBAT_MOD_AREA].ac))
   table.insert(t, string.format("    AC Class Modifier: %d", self.ci.mods[COMBAT_MOD_CLASS].ac))
   table.insert(t, string.format("    AC Feat Modifier: %d", self.ci.mods[COMBAT_MOD_FEAT].ac))
   table.insert(t, string.format("    AC Race Modifier: %d", self.ci.mods[COMBAT_MOD_RACE].ac))
   table.insert(t, string.format("    AC Size Modifier: %d", self.ci.mods[COMBAT_MOD_SIZE].ac))
   table.insert(t, string.format("    AC Skill Modifier: %d", self.ci.mods[COMBAT_MOD_SKILL].ac))
   table.insert(t, string.format("    AC Training Vs Modifier: %d", self.ci.mods[COMBAT_MOD_TRAINING_VS].ac))
   table.insert(t, string.format("    AC Favored Enemy Modifier: %d", self.ci.mods[COMBAT_MOD_FAVORED_ENEMY].ac))

   return table.concat(t, "\n")
end


--- Determine maximum armor class modifier
function Creature:GetMaxArmorClassMod()
   return 20
end

--- Determine minimum armor class modifier
function Creature:GetMinArmorClassMod()
   return -20
end
