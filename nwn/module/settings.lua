--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Get game difficulty
function Module:GetGameDifficulty()
   nwn.engine.ExecuteCommand(513, 0);
   return nwn.engine.StackPopInteger();
end

--- Sets max number of henchmen
function Module:GetMaxHenchmen()
   nwn.engine.ExecuteCommand(747, 0);
   return nwn.engine.StackPopInteger();
end

--- Sets max number of henchmen
-- @param max Max henchment
function Module:SetMaxHenchmen(max)
   nwn.engine.StackPushInteger(max);
   nwn.engine.ExecuteCommand(746, 1);
end

--- Sets XP scale
-- @param scale New XP scale.
function Module:SetModuleXPScale(scale)
   nwn.engine.StackPushInteger(scale);
   nwn.engine.ExecuteCommand(818, 1);
end

