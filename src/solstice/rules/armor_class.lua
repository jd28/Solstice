local M = require 'solstice.rules.init'

local ffi = require 'ffi'
local clamp = math.clamp
local sm = string.strip_margin

--- Get Armor Check Penalty.
local function GetArmorCheckPenalty(cre)
  if not cre:GetIsValid() then return 0 end
  return cre.obj.cre_stats.cs_acp_armor + cre.obj.cre_stats.cs_acp_shield
end

local function GetArmorClassModifierLimits(cre)
  return -20, 20
end


---- Determines AC vs creature.
-- The last three parameters should only be used from the combat engine.
-- @param vs Attacking creature
-- @bool touch If true it's a touch attack.
-- @bool[opt] is_ranged From ranged attack.
-- @bool[opt] attack Attack ctype
-- @param[opt] state Creature state.
local function GetACVersus(cre, vs, touch, is_ranged, attack, state)
  vs = vs or OBJECT_INVALID
  -- 10 base AC
  local ac = 10
  local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0
  local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge

  local min_mod, max_mod = GetArmorClassModifierLimits(cre)


  -- Natural AC
  ac = ac + cre.obj.cre_stats.cs_ac_natural_base

  if not cre:GetIsPolymorphed() then
    -- Armor AC
    ac = ac + cre.obj.cre_stats.cs_ac_armour_base
    -- Shield AC
    ac = ac + cre.obj.cre_stats.cs_ac_shield_base
  end

  local mode = Rules.GetModeModifier(cre:GetCombatMode(), ATTACK_MODIFIER_AC, cre)
  if mode then
    ac = ac + mode
  end

  local mod
  -- Area, class, feat, race, size bonuses.
  for i=0, COMBAT_MOD_SKILL - 1 do
    mod = Rules.GetCombatModifier(i, ATTACK_MODIFIER_AC, cre)
    if mod then
      ac = ac + mod
    end
  end

  if not attack then
    -- If not an attack we can include skills and dex modifier without
    -- worrying about being flatfooted, etc

    -- Dodge AC
    dodge = cre.obj.cre_stats.cs_ac_dodge_bonus - cre.obj.cre_stats.cs_ac_dodge_penalty

    -- Skill: Tumble...

    local mod = Rules.GetCombatModifier(COMBAT_MOD_SKILL, ATTACK_MODIFIER_AC, cre)
    if mod then
      ac = ac + mod
    end

    -- Dex Mod.
    local val = cre:GetDexMod(not cre:GetIsPolymorphed())
    ac = ac + val
  else
    -- Dex Modifier
    local dex_mod = cre:GetDexMod(not cre:GetIsPolymorphed())
    local dexed = false

    -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
    -- then target gets no Dex mod.
    if bit.band(COMBAT_TARGET_STATE_ATTACKER_INVIS, state) == 0 and
      bit.band(COMBAT_TARGET_STATE_FLATFOOTED, state) == 0
    then
      -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
      -- gets dex_mod and dodge AC
      if bit.band(COMBAT_TARGET_STATE_ATTACKER_UNSEEN, state) == 0
        or (cre:GetHasFeat(FEAT_BLIND_FIGHT) and is_ranged)
      then
        if dex_mod > 0 then
          dexed = true
        end
        -- Dodge AC
        dodge = cre.obj.cre_stats.cs_ac_dodge_bonus - cre.obj.cre_stats.cs_ac_dodge_penalty

        -- Skill: Tumble...
        ac = ac + Rules.GetCombatModifier(COMBAT_MOD_SKILL, ATTACK_MODIFIER_AC, cre)

        -- If this is an attack of opportunity and target has mobility
        -- there is a +4 ac bonus. TODO: Fix
        --if attack:GetSpecialAttack() == -534
        --  and cre:GetHasFeat(FEAT_MOBILITY)
        --then
        --  ac = ac + 4
        --end

        if cre:GetHasFeat(FEAT_DODGE) then
          if cre.obj.cre_combat_round.cr_dodge_target == OBJECT_INVALID.id then
            cre.obj.cre_combat_round.cr_dodge_target = vs.id
          end
          if cre.obj.cre_combat_round.cr_dodge_target == vs.id
            and not Rules.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
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
      and (cre:GetHasFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
      or cre:GetHasFeat(FEAT_UNCANNY_DODGE_1))
    then
      dexed = true
    end

    if dexed then ac = ac + dex_mod end
  end

  -- +4 Defensive Training Vs.
  if cre:GetHasTrainingVs(vs) then
    ac = ac + 4
  end

  -- Armor AC
  armor = cre.obj.cre_stats.cs_ac_armour_bonus - cre.obj.cre_stats.cs_ac_armour_penalty
  -- Deflect AC
  deflect = cre.obj.cre_stats.cs_ac_deflection_bonus - cre.obj.cre_stats.cs_ac_deflection_penalty
  -- Natural AC
  nat = cre.obj.cre_stats.cs_ac_natural_bonus - cre.obj.cre_stats.cs_ac_natural_penalty
  -- Shield AC
  shield = cre.obj.cre_stats.cs_ac_shield_bonus - cre.obj.cre_stats.cs_ac_shield_penalty

  if touch then return ac + dodge end

  dodge = clamp(dodge, min_mod, max_mod)
  ac = ac + nat + armor + shield + deflect + dodge
  return ac
end

local function DebugArmorClass(cre)
  local t = {}
  table.insert(t, "Armor Class:")
  table.insert(t,
    string.format("  Total: %d, Touch: %d",
                  GetACVersus(cre, OBJECT_INVALID, false),
                  GetACVersus(cre, OBJECT_INVALID, true)))
  table.insert(t, "  Base: 10")
  table.insert(t, string.format("  Base Natural AC: %d", cre.obj.cre_stats.cs_ac_natural_base))
  table.insert(t, string.format("  Base Armor AC: %d", cre.obj.cre_stats.cs_ac_armour_base))
  table.insert(t, string.format("  Base Shield AC: %d", cre.obj.cre_stats.cs_ac_shield_base))

  table.insert(t, string.format("  Dexterity Modifier: %d", cre:GetDexMod(not cre:GetIsPolymorphed())))

  table.insert(t,
    string.format("  Armor AC: %d (%d - %d)",
                  cre.obj.cre_stats.cs_ac_armour_bonus - cre.obj.cre_stats.cs_ac_armour_penalty,
                  cre.obj.cre_stats.cs_ac_armour_bonus,
                  cre.obj.cre_stats.cs_ac_armour_penalty))

  table.insert(t,
    string.format("  Deflect AC: %d (%d - %d)",
                  cre.obj.cre_stats.cs_ac_deflection_bonus - cre.obj.cre_stats.cs_ac_deflection_penalty,
                  cre.obj.cre_stats.cs_ac_deflection_bonus,
                  cre.obj.cre_stats.cs_ac_deflection_penalty))

  table.insert(t,
    string.format("  Sheild AC: %d (%d - %d)",
                  cre.obj.cre_stats.cs_ac_shield_bonus - cre.obj.cre_stats.cs_ac_shield_penalty,
                  cre.obj.cre_stats.cs_ac_shield_bonus,
                  cre.obj.cre_stats.cs_ac_shield_penalty))

  table.insert(t,
    string.format("  Natural AC: %d (%d - %d)",
                  cre.obj.cre_stats.cs_ac_natural_bonus - cre.obj.cre_stats.cs_ac_natural_penalty,
                  cre.obj.cre_stats.cs_ac_natural_bonus,
                  cre.obj.cre_stats.cs_ac_natural_penalty))

  table.insert(t,
   string.format("  Dodge AC: %d (%d - %d)",
                  cre.obj.cre_stats.cs_ac_dodge_bonus - cre.obj.cre_stats.cs_ac_dodge_penalty,
                  cre.obj.cre_stats.cs_ac_dodge_bonus,
                  cre.obj.cre_stats.cs_ac_dodge_penalty))

  local mode = Rules.GetModeModifier(cre:GetCombatMode(),
                                     ATTACK_MODIFIER_AC,
                                     cre)
  if mode then
    table.insert(t,  string.format("  Mode AC: %d", mode))
  end

  table.insert(t, "  Combat Modifiers:")
  for i=0, COMBAT_MOD_NUM - 1 do
    local mod = Rules.GetCombatModifier(i, ATTACK_MODIFIER_AC, cre)
    if mod then
      table.insert(t, string.format("  %d: %d", i, mod))
    end
  end

  table.insert(t, "")

  return table.concat(t, "\n")
end


-- Exports
M.DebugArmorClass = DebugArmorClass
M.GetArmorCheckPenalty = GetArmorCheckPenalty
M.GetACVersus = GetACVersus
M.GetArmorClassModifierLimits = GetArmorClassModifierLimits
