--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ne = nwn.engine

--- Determines whether an object sees another object.
-- @param target Object to determine if it is seen.
function Creature:GetIsSeen(target)
   ne.StackPushObject(self)
   ne.StackPushObject(target)
   ne.ExecuteCommand(289, 2)
   return ne.StackPopInteger()
end

--- Determines if an object can hear another object.
-- @param target The object that may be heard.
function Creature:GetIsHeard(target)
   ne.StackPushObject(self)
   ne.StackPushObject(target)
   ne.ExecuteCommand(290, 2)
   return ne.StackPopBoolean()
end