--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

-- TODO: cytpe

--- Gets a talent's type
function Talent:GetType()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(362, 1)
   return nwn.engine.StackPopInteger()
end

--- Gets a talent's ID
function Talent:GetId()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(363, 1)
   return nwn.engine.StackPopInteger()
end

--- Get if talent is valid
function Talent:GetIsValid()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(359, 1)
   return nwn.engine.StackPopBoolean()
end

--------------------------------------------------------------------

--- Creates a spell talent
-- @param spell nwn.SPELL_*
function nwn.TalentSpell(spell)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(301, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

--- Creates a feat talent
-- @param spell nwn.FEAT_*
function nwn.TalentFeat(feat)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.ExecuteCommand(302, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

--- Creates a skill talent
-- @param spell nwn.SKILL_*
function nwn.TalentSkill(skill)
   nwn.engine.StackPushInteger(skill)
   nwn.engine.ExecuteCommand(303, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end
