--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'
local Object = M.Object

--- Class Object: Hitpoints
-- @section hp

--- Gets an object's current hitpoints
function Object:GetCurrentHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_cur
end

--- Modifies an object's current hitpoints
-- @param amount Amount to modifiy.
function Object:ModifyCurrentHitPoints(amount)
   local hp = self:GetCurrentHitPoints() + amount
   self:SetCurrentHitPoints(hp)
end

--- Sets an object's current hitpoints.
-- @param hp A number between 1 and 10000
function Object:SetCurrentHitPoints(hp)
   if not self:GetIsValid() then return -1 end

   if hp < 1 then hp = 1
   elseif hp > 10000 then hp = 10000
   end

   self.obj.obj.obj_hp_cur = hp

   return self.obj.obj.obj_hp_cur
end

--- Get object's max hitpoints
function Object:GetMaxHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_max
end

--- Sets an object's max hitpoints
function Object:SetMaxHitPoints(hp)
   if not self:GetIsValid() then return -1 end
   if hp < 1 then hp = 1 end

   self.obj.obj.obj_hp_max = hp
   return self.obj.obj.obj_hp_max
end
