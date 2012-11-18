local ne = nwn.engine
local ffi = require 'ffi'

--- Gets a creatures XP
function Creature:GetXP()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_xp
end

--- Modifies a creatures XP.
-- @param amount Amount of XP to give or take.
-- @param direct If true the xp amount is set directly. (Default: false)
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
-- @param direct If true the xp amount is set directly. (Default: false)
function Creature:SetXP(amount, direct)
   if direct then
      if not self:GetIsValid() then return end
      self.stats.cs_xp = amount
   else
      ne.StackPushInteger(amount)
      ne.StackPushObject(self)
      ne.ExecuteCommand(394, 2)
   end
end



