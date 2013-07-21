--- Talent
-- This file contains essentially all non-member functions...
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module talent

-- TODO: cytpe

local NWE = require 'solstice.nwn.engine'

local M = {
   SPELL = 0,
   FEAT  = 1,
   SKILL = 2,

   CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT   = 1,
   CATEGORY_HARMFUL_RANGED                    = 2,
   CATEGORY_HARMFUL_TOUCH                     = 3,
   CATEGORY_BENEFICIAL_HEALING_AREAEFFECT     = 4,
   CATEGORY_BENEFICIAL_HEALING_TOUCH          = 5,
   CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT = 6,
   CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE     = 7,
   CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT = 8,
   CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE     = 9,
   CATEGORY_BENEFICIAL_ENHANCEMENT_SELF       = 10,
   CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT = 11,
   CATEGORY_BENEFICIAL_PROTECTION_SELF        = 12,
   CATEGORY_BENEFICIAL_PROTECTION_SINGLE      = 13,
   CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT  = 14,
   CATEGORY_BENEFICIAL_OBTAIN_ALLIES          = 15,
   CATEGORY_PERSISTENT_AREA_OF_EFFECT         = 16,
   CATEGORY_BENEFICIAL_HEALING_POTION         = 17,
   CATEGORY_BENEFICIAL_CONDITIONAL_POTION     = 18,
   CATEGORY_DRAGONS_BREATH                    = 19,
   CATEGORY_BENEFICIAL_PROTECTION_POTION      = 20,
   CATEGORY_BENEFICIAL_ENHANCEMENT_POTION     = 21,
   CATEGORY_HARMFUL_MELEE                     = 22,
}

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