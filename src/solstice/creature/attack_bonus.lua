--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature


local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local USE_VERSUS = OPT.USE_VERSUS

local M = require 'solstice.creature.init'

--- Attack Bonus
-- @section

--- Get attack bonus vs target.
-- @param target Target object.
-- @param equip EQUIP\_TYPE\_*
function M.Creature:GetAttackBonusVs(target, equip)
   local ab = self.ci.offense.ab_base
      + self.ci.offense.ab_transient
      + self.ci.equips[equip].ab_mod
      + self.ci.equips[equip].transient_ab_mod
      + self.ci.equips[equip].ab_ability

   if equip == EQUIP_TYPE_ONHAND then
      ab = ab - self.ci.offense.offhand_penalty_on
   elseif equip == EQUIP_TYPE_OFFHAND then
      ab = ab - self.ci.offense.offhand_penalty_off
   end

   for i = 0, COMBAT_MOD_SKILL do
      ab = ab + self.ci.mods[i].ab
   end

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
