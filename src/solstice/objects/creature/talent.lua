--- Talent
-- @module creature

local M   = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Talent
-- @section

function Creature:GetHasTalent(talent)
   NWE.StackPushObject(self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(306, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetTalentBest(category, cr_max)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(cr_max)
   NWE.StackPushInteger(category)
   NWE.ExecuteCommand(308, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end

function Creature:GetTalentRandom(category)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(category)
   NWE.ExecuteCommand(307, 2)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end
