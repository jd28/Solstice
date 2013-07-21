--- Armor Class
-- @module creature

local M = require 'solstice.creature.init'

--- Armor Class
-- @section

--- Get Armor Check Penalty.
function M.Creature:GetArmorCheckPenalty()
   if not self:GetIsValid() then
      return 0
   end

   return self.stats.cs_acp_armor + self.stats.cs_acp_shield
end
