require 'nwn.effects'

local ffi = require 'ffi'
local max = math.max

function Creature:GetArmorCheckPenalty()
   if not self:GetIsValid() then
      return 0
   end

   return self.stats.cs_acp_armor + self.stats.cs_acp_shield
end
