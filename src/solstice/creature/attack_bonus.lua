--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local USE_VERSUS = OPT.USE_VERSUS
local sm     = string.strip_margin

local M = require 'solstice.creature.init'

--- Attack Bonus
-- @section

--- Get attack bonus vs target.
-- @param target Target object.
-- @param equip EQUIP\_TYPE\_*
function M.Creature:GetAttackBonusVs(target, equip)
   local trans_ab = math.clamp(self.ci.offense.ab_transient + self.ci.equips[equip].transient_ab_mod, -20, 20)
   local ab = self.ci.offense.ab_base
      + self.ci.equips[equip].ab_mod
      + self.ci.equips[equip].ab_ability
      + trans_ab

   if equip == EQUIP_TYPE_ONHAND then
      ab = ab + self.ci.offense.offhand_penalty_on
   elseif equip == EQUIP_TYPE_OFFHAND then
      ab = ab + self.ci.offense.offhand_penalty_off
   end

   for i = 0, COMBAT_MOD_SKILL do
      ab = ab + self.ci.mods[i].ab
   end

   if OPT.TA and not self:GetIsPC() and not self:GetMaster():GetIsValid() then
      ab = ab + self:GetSkillRank(SKILL_RIDE, OBJECT_INVALID, true)
   end

   ab = ab + self.ci.mod_mode.ab

   return ab
end

--- Determine creature's BAB.
function M.Creature:GetBaseAttackBonus()
   return Rules.GetBaseAttackBonus(self)
end

--- Get ranged attack bonus/penalty vs a target.
-- @param target Creature's target.
-- @param distance Distance to target.
function M.Creature:GetRangedAttackMod(target, distance)
   local ab = 0

   -- Point Blank Shot
   if distance <= 25 and self:GetHasFeat(FEAT_POINT_BLANK_SHOT) then
      ab = ab + 1
   end

   if target.type == OBJECT_TRUETYPE_CREATURE then
      -- Ranged Attack in Melee Target Range
      local max = target:GetMaxAttackRange(self)
      local weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if distance <= max * max
         and weap:GetIsValid()
         and not weap:GetIsRangedWeapon()
      then
         ab = ab - 4
      end
   end

   return ab
end

function M.Creature:DebugAttackBonus()
   local t = {}

   table.insert(t, "Attack Bonus")
   table.insert(t, string.format("  BAB: %d", self.ci.offense.ab_base))
   table.insert(t, string.format("  Dual Wield Penalty: On: %d, Off: %d",
                                 self.ci.offense.offhand_penalty_on,
                                 self.ci.offense.offhand_penalty_off))
   table.insert(t, string.format("  Effect AB Bonus: %d", self.ci.offense.ab_transient))
   table.insert(t, "  Combat Modifiers:")
   table.insert(t, string.format("    AB Area Modifier: %d", self.ci.mods[COMBAT_MOD_AREA].ab))
   table.insert(t, string.format("    AB Class Modifier: %d", self.ci.mods[COMBAT_MOD_CLASS].ab))
   table.insert(t, string.format("    AB Feat Modifier: %d", self.ci.mods[COMBAT_MOD_FEAT].ab))
   table.insert(t, string.format("    AB Race Modifier: %d", self.ci.mods[COMBAT_MOD_RACE].ab))
   table.insert(t, string.format("    AB Size Modifier: %d", self.ci.mods[COMBAT_MOD_SIZE].ab))
   table.insert(t, string.format("    AB Skill Modifier: %d", self.ci.mods[COMBAT_MOD_SKILL].ab))
   table.insert(t, string.format("    AB Training Vs Modifier: %d", self.ci.mods[COMBAT_MOD_TRAINING_VS].ab))
   table.insert(t, string.format("    AB Favored Enemy Modifier: %d", self.ci.mods[COMBAT_MOD_FAVORED_ENEMY].ab))

   table.insert(t, "  Weapons")
   local fmt = sm([[    ID: %x:
                   |    Ability AB: %d,
                   |    AB Modifier : %d,
                   |    Effect AB Modifier: %d]])

   for i = 0, 5 do
      table.insert(t, string.format(fmt,
                                    self.ci.equips[i].id,
                                    self.ci.equips[i].ab_ability,
                                    self.ci.equips[i].ab_mod,
                                    self.ci.equips[i].transient_ab_mod))
      table.insert(t, "")
   end

   return table.concat(t, '\n')
end
