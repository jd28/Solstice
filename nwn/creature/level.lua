local ffi = require 'ffi'
local C = ffi.C

--- Calculate a creature's hit dice.
-- @param use_neg_levels If true negative levels factored in to
--    total hit dice. (Default: false)
function Creature:GetHitDice(use_neg_levels)
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
function Creature:GetEffectiveLevel()
   return self.effective_level
end

--- Gets difference between hitdice and effective level.
function Creature:GetEffectiveLevelDifference()
   local hd = self:GetHitDice()
   if self.effective_level > hd then
      return 0
   end

   return hd - self.effective_level
end

--- Gets total negative levels
function Creature:GetTotalNegativeLevels()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetTotalNegativeLevels(self.stats)
end

--- Sets a creatures effective level.
-- @param level New effective level.
function Creature:SetEffectiveLevel(level)
   self.effective_level = level
end
