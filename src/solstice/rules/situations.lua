--- Rules
-- @module rules

local function ZeroSituationMod(cre, situ)
   cre.ci.mod_situ[situ].ab = 0
   cre.ci.mod_situ[situ].ac = 0
   cre.ci.mod_situ[situ].hp = 0
   cre.ci.mod_situ[situ].dmg.roll.dice = 0
   cre.ci.mod_situ[situ].dmg.roll.sides = 0
   cre.ci.mod_situ[situ].dmg.roll.bonus = 0
   cre.ci.mod_situ[situ].dmg.type = 12
end

local function coupdegrace(cre)
   ZeroSituationMod(cre, 0)
end

local function sneak_attack(cre)
   ZeroSituationMod(cre, 1)

   local feat
   local normal = false

   -- Normal sneak.
   feat = cre:GetHighestFeatInRange(FEAT_SNEAK_ATTACK_11,
                                    FEAT_SNEAK_ATTACK_20)

   if feat ~= -1 then
      cre.ci.mod_situ[1].dmg.roll.dice = feat - FEAT_SNEAK_ATTACK_11 + 11
      cre.ci.mod_situ[1].dmg.roll.sides = 6
      normal = true
   end

   if not normal then
      feat = cre:GetHighestFeatInRange(FEAT_SNEAK_ATTACK_2,
                                       FEAT_SNEAK_ATTACK_10)

      if feat ~= -1 then
         cre.ci.mod_situ[1].dmg.roll.dice = feat - FEAT_SNEAK_ATTACK_2 + 2
         cre.ci.mod_situ[1].dmg.roll.sides = 6
         normal = true
      end
   end

   if not normal and cre:GetHasFeat(FEAT_SNEAK_ATTACK_1) then
      cre.ci.mod_situ[1].dmg.roll.dice = 1
      cre.ci.mod_situ[1].dmg.roll.sides = 6
   end

   local bg = false

   feat = cre:GetHighestFeatInRange(FEAT_BLACKGUARD_SNEAK_ATTACK_4D6,
                                    FEAT_BLACKGUARD_SNEAK_ATTACK_15D6)

   if feat ~= -1 then
      local add = feat - FEAT_BLACKGUARD_SNEAK_ATTACK_4D6 + 4
      cre.ci.mod_situ[1].dmg.roll.dice = cre.ci.mod_situ[1].dmg.roll.dice + add
      cre.ci.mod_situ[1].dmg.roll.sides = 6
      bg = true
   end

   if not bg then
      feat = cre:GetHighestFeatInRange(FEAT_BLACKGUARD_SNEAK_ATTACK_1D6,
                                       FEAT_BLACKGUARD_SNEAK_ATTACK_3D6)
      if feat ~= -1 then
         local add = feat - FEAT_BLACKGUARD_SNEAK_ATTACK_1D6 + 1
         cre.ci.mod_situ[1].dmg.roll.dice = cre.ci.mod_situ[1].dmg.roll.dice + add
         cre.ci.mod_situ[1].dmg.roll.sides = 6
         bg = true
      end
   end

   -- Improved Sneak Attack
   feat = cre:GetHighestFeatInRange(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1,
                                    FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10)
   if feat ~= -1 then
      local add = feat - FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1 + 1
      cre.ci.mod_situ[1].dmg.roll.dice = cre.ci.mod_situ[1].dmg.roll.dice + add
      cre.ci.mod_situ[1].dmg.roll.sides = 6
   end
end

local function death_attack(cre)
   ZeroSituationMod(cre, 2)
   local death = false
   local feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_9,
                                          FEAT_PRESTIGE_DEATH_ATTACK_20)
   if feat ~= -1 then
      cre.ci.mod_situ[2].dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_9 + 9
      cre.ci.mod_situ[2].dmg.roll.sides = 6
      death = true
   end

   if not death then
      feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_6,
                                       FEAT_PRESTIGE_DEATH_ATTACK_8)

      if feat ~= -1 then
         cre.ci.mod_situ[2].dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_6 + 6
         cre.ci.mod_situ[2].dmg.roll.sides = 6
         death = true
      end
   end

   if not death then
      feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_1,
                                       FEAT_PRESTIGE_DEATH_ATTACK_5)

      if feat ~= -1 then
         cre.ci.mod_situ[2].dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_1 + 1
         cre.ci.mod_situ[2].dmg.roll.sides = 6
      end
   end
end

local _SITU_MOD = {
   [0] = coupdegrace,
   sneak_attack,
   death_attack,
}

--- Situation Modifiers
-- @section

--- Override Situation Modifier.
-- @param situation SITUATION_* see situations.2da
-- @param func A function taking a creature paramater
-- that calculates the combat modifier for a situation
-- at a given index.
local function SetSituationModiferOverride(situation, func)
   if situation < 0 or situation >= SITUATION_NUM then
      error "Invalid situation constant"
   end
   _SITU_MOD[situation] = func
end

--- Resolves situation modifier.
-- @param type SITUATION_* see situations.2da
-- @param cre Creature object.
local function ResolveSituationModifier(type, cre)
   local f = _SITU_MOD[type]
   if f then f(cre) else error "Invalid situation mod function" end
end

--- Resolves all situation modifiers
-- @param cre Creature object
local function ResolveSituationModifiers(cre)
   for i=0, SITUATION_NUM - 1 do
      ResolveSituationModifier(i, cre)
   end
end

local M = require 'solstice.rules.init'
M.SetSituationModiferOverride = SetSituationModiferOverride
M.ResolveSituationModifier    = ResolveSituationModifier
M.ResolveSituationModifiers   = ResolveSituationModifiers
