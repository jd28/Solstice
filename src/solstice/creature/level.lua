--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'
local ffi = require 'ffi'
local C = ffi.C

--- Level
-- @section level

--- Calculate a creature's hit dice.
-- @param[opt=false] use_neg_levels If true negative levels factored in to
-- total hit dice.
function M.Creature:GetHitDice(use_neg_levels)
   local total = 0
   for cl in self:Classes() do
      -- Class level can never be negative.
      if use_neg_levels then
         total = total + math.max(0, cl.cl_level - cl.cl_negative_level)
      else
         total = total + cl.cl_level
      end
   end
   return total
end

--- Gets a creatures effective level.
function M.Creature:GetEffectiveLevel()
   error "???"
end

--- Gets difference between hitdice and effective level.
function M.Creature:GetEffectiveLevelDifference()
   error "???"
   local hd = self:GetHitDice()
   if self.effective_level > hd then
      return 0
   end

   return hd - self.effective_level
end

--- Gets total negative levels
function M.Creature:GetTotalNegativeLevels()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetTotalNegativeLevels(self.stats)
end

--- Sets a creatures effective level.
-- @param level New effective level.
function M.Creature:SetEffectiveLevel(level)
   error "???"
   self.effective_level = level
end
