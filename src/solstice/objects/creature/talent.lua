--- Talent
-- @module creature

local M   = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Talent
-- @section

--- Determines whether a creature has a specific talent.
-- @param talent The talent which will be checked for on the given creature.
function Creature:GetHasTalent(talent)
   NWE.StackPushObject(self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(306, 2)
   return NWE.StackPopBoolean()
end

--- Determines the best talent of a creature from a group of talents.
-- @param category TALENT_CATEGORY_*
-- @param cr_max The maximum Challenge Rating of the talent.
function Creature:GetTalentBest(category, cr_max)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(cr_max)
   NWE.StackPushInteger(category)
   NWE.ExecuteCommand(308, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end

--- Retrieves a random talent from a group of talents that a creature possesses.
-- @param category TALENT_CATEGORY_*
function Creature:GetTalentRandom(category)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(category)
   NWE.ExecuteCommand(307, 2)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end
