--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Gets creature's AI level.
function Creature:GetAILevel()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(712, 1)
   return nwn.engine.StackPopInteger()
end

--- Sets creature's AI level.
-- @param ai_level nwn.AI_LEVEL_*
function Creature:SetAILevel(ai_level)
   nwn.engine.StackPushInteger(ai_level);
   nwn.engine.StackPushObject(self);
   nwn.engine.ExecuteCommand(713, 2);
end
