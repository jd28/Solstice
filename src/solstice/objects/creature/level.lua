----
-- @module creature

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local Creature = M.Creature

--- Level
-- @section level

--- Calculate a creature's hit dice.
-- @param[opt=false] use_neg_levels If true negative levels factored in to
-- total hit dice.
function Creature:GetHitDice(use_neg_levels)
   local total = 0
   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      -- Class level can never be negative.
      if use_neg_levels then
         total = total + math.max(0, self.obj.cre_stats.cs_classes[i].cl_level -
                                  self.obj.cre_stats.cs_classes[i].cl_negative_level)
      else
         total = total + self.obj.cre_stats.cs_classes[i].cl_level
      end
   end
   return total
end

--- Gets a creatures effective level.
function Creature:GetEffectiveLevel()
   error "???"
end

--- Gets difference between hitdice and effective level.
function Creature:GetEffectiveLevelDifference()
   error "???"
   local hd = self:GetHitDice()
   if self.effective_level > hd then
      return 0
   end

   return hd - self.effective_level
end

--- Gets total negative levels
function Creature:GetTotalNegativeLevels()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetTotalNegativeLevels(self.obj.cre_stats)
end

--- Sets a creatures effective level.
-- @param level New effective level.
function Creature:SetEffectiveLevel(level)
   error "???"
   self.effective_level = level
end
