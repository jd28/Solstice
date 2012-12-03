--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Get if object is listening
function Object:GetIsListening()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(174, 1)

   return nwn.engine.StackPopBoolean()
end

---
function Object:SetListening(bListening)
   nwn.engine.StackPushInteger(bListening)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(175, 2)
end

---
function Object:SetListenPattern(sPattern, nNumber)
   nNumber = nNumber or 0

   nwn.engine.StackPushInteger(nNumber)
   nwn.engine.StackPushString(sPattern)
   nwn.engine.StackPushObject(nNumber)
   nwn.engine.ExecuteCommand(176, 3)
end
