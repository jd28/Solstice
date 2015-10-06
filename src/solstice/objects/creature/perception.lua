--- Creature module
-- @module creature

local M   = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Preception
-- @section

function Creature:GetIsSeen(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(289, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsHeard(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(290, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetLastPerceived()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return Game.GetObjectByID(self.obj.cre_last_perceived)
end

function Creature:GetLastPerceptionHeard()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_heard == 1
end

function Creature:GetLastPerceptionInaudible()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_inaudible == 1
end

function Creature:GetLastPerceptionVanished()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_vanished == 1
end

function Creature:GetLastPerceptionSeen()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_seen == 1
end
