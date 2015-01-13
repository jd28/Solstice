--- XP
-- @module creature

local M = require 'solstice.creature.init'
local ne = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local Creature = M.Creature

--- Experience
-- @section

--- Gets a creatures XP
function Creature:GetXP()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_stats.cs_xp
end

--- Modifies a creatures XP.
-- @param amount Amount of XP to give or take.
-- @bool[opt=false] direct If true the xp amount is set directly with
-- no feedback to player.
function Creature:ModifyXP(amount, direct)
   local cmd = 393
   if amount < 0 then
      amount = -amount
   end

   if direct then
      self:SetXP(self:GetXP() + amount, direct)
      self:SendMessage(string.format("Experience Gained: %d", amount))
   else
      ne.StackPushInteger(amount)
      ne.StackPushObject(self)
      ne.ExecuteCommand(393, 2)
   end
end


--- Sets a creatures XP
-- @param amount Amount to set XP to
-- @bool[opt=false] direct If true the xp amount is set directly with
-- no feedback to player.
function Creature:SetXP(amount, direct)
   if direct then
      if not self:GetIsValid() then return end
      self.obj.cre_stats.cs_xp = amount
   else
      ne.StackPushInteger(amount)
      ne.StackPushObject(self)
      ne.ExecuteCommand(394, 2)
   end
end
