----
-- @module creature

--- AI
-- @section AI

local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.creature.init'
local Creature = M.Creature

--- Gets creature's AI level.
function Creature:GetAILevel()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(712, 1)
   return NWE.StackPopInteger()
end

--- Sets creature's AI level.
-- @param ai_level
function Creature:SetAILevel(ai_level)
   NWE.StackPushInteger(ai_level);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(713, 2);
end
