--- Object
-- @module object

local NWE = require 'solstice.nwn.engine'
local M = require 'solstice.objects.init'
local Object = M.Object

--- Class Object: Actions
-- @section action

function Object:ActionCloseDoor(door)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(door)
   NWE.ExecuteCommand(44, 1)

   NWE.SetCommandObject(temp)
end


function Object:ActionGiveItem(item, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(135, 2)

   NWE.SetCommandObject(temp)
end

function Object:ActionLockObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(484, 1)

   NWE.SetCommandObject(temp)
end

function Object:ActionOpenDoor(door)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(door)
   NWE.ExecuteCommand(43, 1)

   NWE.SetCommandObject(temp)
end

function Object:ActionPauseConversation()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(205, 0)

   NWE.SetCommandObject(temp)
end

function Object:ActionResumeConversation()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(206, 0)

   NWE.SetCommandObject(temp)
end

function Object:ActionSpeakString(message, volume)
   volume = volume or VOLUME_TALK

   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(volume)
   NWE.StackPushString(message)
   NWE.ExecuteCommand(39, 2)

   NWE.SetCommandObject(temp)
end

function Object:ActionSpeakStringByStrRef(strref, volume)
   volume = volume or VOLUME_TALK

   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(volume)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(240, 2)

   NWE.SetCommandObject(temp)
end

function Object:ActionStartConversation(target, dialog, private, hello)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   dialog = dialog or ""
   if hello == nil then hello = true end

   NWE.StackPushBoolean(hello)
   NWE.StackPushBoolean(private)
   NWE.StackPushString(dialog)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(204, 4)

   NWE.SetCommandObject(temp)
end

function Object:ActionTakeItem(item, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(136, 2)

   NWE.SetCommandObject(temp)
end

function Object:ActionUnlockObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(483, 1)

   NWE.SetCommandObject(temp)
end

function Object:ActionWait(time)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(time)
   NWE.ExecuteCommand(202, 1)

   NWE.SetCommandObject(temp)
end

function Object:ClearAllActions(clear_combat)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(clear_combat)
   NWE.ExecuteCommand(9, 1)

   NWE.SetCommandObject(temp)
end

function Object:GetCurrentAction()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(self)
   NWE.ExecuteCommand(522, 1)

   NWE.SetCommandObject(temp)
   return NWE.StackPopInteger()
end

function Object:SpeakString(text, volume)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)
   volume = volume or VOLUME_TALK

   NWE.StackPushInteger(volume);
   NWE.StackPushString(text);
   NWE.ExecuteCommand(221, 2);

   NWE.SetCommandObject(temp)
end

function Object:SpeakStringByStrRef(strref, volume)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   volume = volume or VOLUME_TALK

   NWE.StackPushInteger(volume)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(691, 2)

   NWE.SetCommandObject(temp)
end
