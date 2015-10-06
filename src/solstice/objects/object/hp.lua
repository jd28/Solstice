--- Object
-- @module object

local M = require 'solstice.objects.init'
local Object = M.Object

--- Class Object: Hitpoints
-- @section hp

function Object:GetCurrentHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_cur
end

function Object:ModifyCurrentHitPoints(amount)
   local hp = self:GetCurrentHitPoints() + amount
   self:SetCurrentHitPoints(hp)
end

function Object:SetCurrentHitPoints(hp)
   if not self:GetIsValid() then return -1 end

   if hp < 1 then hp = 1
   elseif hp > 10000 then hp = 10000
   end

   self.obj.obj.obj_hp_cur = hp

   return self.obj.obj.obj_hp_cur
end

function Object:GetMaxHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_max
end

function Object:SetMaxHitPoints(hp)
   if not self:GetIsValid() then return -1 end
   if hp < 1 then hp = 1 end

   self.obj.obj.obj_hp_max = hp
   return self.obj.obj.obj_hp_max
end
