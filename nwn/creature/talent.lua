--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ne = nwn.engine

--- Determines whether a creature has a specific talent.
-- @param talent The talent which will be checked for on the given creature.
function Creature:GetHasTalent(talent)
   ne.StackPushObject(self)
   ne.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_TALENT, talent)
   ne.ExecuteCommand(306, 2)
   return ne.StackPopBoolean()
end

--- Determines the best talent of a creature from a group of talents.
-- @param category nwn.TALENT_CATEGORY_*
-- @param cr_max The maximum Challenge Rating of the talent.
function Creature:GetTalentBest(category, cr_max)
   ne.StackPushObject(self)
   ne.StackPushInteger(cr_max)
   ne.StackPushInteger(category)
   ne.ExecuteCommand(308, 3)
   return ne.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_TALENT)
end

--- Retrieves a random talent from a group of talents that a creature possesses.
-- @param category nwn.TALENT_CATEGORY_*
function Creature:GetTalentRandom(category)
   ne.StackPushObject(self)
   ne.StackPushInteger(category)
   ne.ExecuteCommand(307, 2)
   return ne.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_TALENT)
end

