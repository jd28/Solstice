----
-- @module creature

--- AI
-- @section AI

local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Creature = M.Creature

function Creature:GetAILevel()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(712, 1)
   return NWE.StackPopInteger()
end

function Creature:SetAILevel(ai_level)
   NWE.StackPushInteger(ai_level);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(713, 2);
end
