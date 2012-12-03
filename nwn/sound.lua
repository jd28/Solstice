--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

function Sound:Play()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(413, 1)
end

function Sound:Stop()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(414, 1)
end

function Sound:SetVolume(volume)
   nwn.engine.StackPushInteger(volume)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(415, 2);
end

function Sound:SetPosition(position)
   nwn.engine.StackPushVector(position)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(416, 2)
end