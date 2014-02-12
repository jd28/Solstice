--- Talent
-- This file contains essentially all non-member functions...
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module talent

-- TODO: cytpe

local NWE = require 'solstice.nwn.engine'

local M = {}

M.Talent = inheritsfrom(nil, "solstice.talent.Talent")

--- Class Talent
-- @section

--- Gets a talent's type
function M.Talent:GetType()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, self)
   NWE.ExecuteCommand(362, 1)
   return NWE.StackPopInteger()
end

--- Gets a talent's ID
function M.Talent:GetId()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, self)
   NWE.ExecuteCommand(363, 1)
   return NWE.StackPopInteger()
end

--- Get if talent is valid
function M.Talent:GetIsValid()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, self)
   NWE.ExecuteCommand(359, 1)
   return NWE.StackPopBoolean()
end

--- Creation
-- @section

--- Creates a spell talent
-- @param spell solstice.spell constant
function M.Spell(spell)
   NWE.StackPushInteger(spell)
   NWE.ExecuteCommand(301, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end

--- Creates a feat talent
-- @param feat solstice.feat constant
function M.Feat(feat)
   NWE.StackPushInteger(feat)
   NWE.ExecuteCommand(302, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end

--- Creates a skill talent
-- @param skill solstice.skill constant
function M.Skill(skill)
   NWE.StackPushInteger(skill)
   NWE.ExecuteCommand(303, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_TALENT)
end

return M
