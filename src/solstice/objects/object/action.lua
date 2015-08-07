--- Object
-- @module object

local NWE = require 'solstice.nwn.engine'
local M = require 'solstice.objects.init'
local Object = M.Object

--- Class Object: Actions
-- @section action

--- An action that causes an object to close a door.
-- @param door Door to close
function Object:ActionCloseDoor(door)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(door)
   NWE.ExecuteCommand(44, 1)

   NWE.SetCommandObject(temp)
end


--- Gives a specified item to a target creature.
-- @param item Item to give.
-- @param target Receiver
function Object:ActionGiveItem(item, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(135, 2)

   NWE.SetCommandObject(temp)
end

--- An action that will cause a creature to lock a door or
-- other unlocked object.
-- @param target Door or placeable object that will be the
--     target of the lock attempt.
function Object:ActionLockObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(484, 1)

   NWE.SetCommandObject(temp)
end

--- An action that will cause a creature to open a door.
-- @param door Door to open
function Object:ActionOpenDoor(door)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(door)
   NWE.ExecuteCommand(43, 1)

   NWE.SetCommandObject(temp)
end

--- Pause the current conversation.
function Object:ActionPauseConversation()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(205, 0)

   NWE.SetCommandObject(temp)
end

--- Resume a conversation after it has been paused.
function Object:ActionResumeConversation()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(206, 0)

   NWE.SetCommandObject(temp)
end

--- Causes an object to speak.
-- @param message String to be spoken.
-- @param[opt=VOLUME_TALK] volume VOLUME_*
function Object:ActionSpeakString(message, volume)
   volume = volume or VOLUME_TALK

   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(volume)
   NWE.StackPushString(message)
   NWE.ExecuteCommand(39, 2)

   NWE.SetCommandObject(temp)
end

--- Causes the creature to speak a translated string.
-- @param strref Reference of the string in the talk table
-- @param[opt=VOLUME_TALK] volume VOLUME_*
function Object:ActionSpeakStringByStrRef(strref, volume)
   volume = volume or VOLUME_TALK

   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(volume)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(240, 2)

   NWE.SetCommandObject(temp)
end

--- Action to start a conversation with a PC
-- @param target An object to converse with.
-- @param[opt=""] dialog The resource reference (filename) of a conversation.
-- @param[opt=false] private Specify whether the conversation is audible to everyone
--     or only to the PC.
-- @param[opt=true] hello Determines if initial greeting is played.
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

--- Takes an item from an object
-- @param item The item to take.
-- @param target The object from which to take the item.
function Object:ActionTakeItem(item, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(136, 2)

   NWE.SetCommandObject(temp)
end

--- Causes a creature to unlock a door or other locked object.
-- @param target Door or placeable object that will be the
--     target of the unlock attempt.
function Object:ActionUnlockObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(483, 1)

   NWE.SetCommandObject(temp)
end

--- Adds a wait action to an objects queue.
-- @param time Time in seconds to wait.
function Object:ActionWait(time)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(time)
   NWE.ExecuteCommand(202, 1)

   NWE.SetCommandObject(temp)
end

--- Removes all actions from an action queue.
-- @param[opt=false] clear_combat combat along with all other actions.
function Object:ClearAllActions(clear_combat)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(clear_combat)
   NWE.ExecuteCommand(9, 1)

   NWE.SetCommandObject(temp)
end

--- Returns the currently executing Action.
function Object:GetCurrentAction()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(self)
   NWE.ExecuteCommand(522, 1)

   NWE.SetCommandObject(temp)
   return NWE.StackPopInteger()
end

--- Forces an object to immediately speak.
-- @param text Text to be spoken.
-- @param[opt=VOLUME_TALK] volume VOLUME_*
function Object:SpeakString(text, volume)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)
   volume = volume or VOLUME_TALK

   NWE.StackPushInteger(volume);
   NWE.StackPushString(text);
   NWE.ExecuteCommand(221, 2);

   NWE.SetCommandObject(temp)
end

--- Causes an object to instantly speak a translated string.
-- @param strref TLK string reference to speak.
-- @param[opt=VOLUME_TALK] volume VOLUME_*
function Object:SpeakStringByStrRef(strref, volume)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   volume = volume or VOLUME_TALK

   NWE.StackPushInteger(volume)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(691, 2)

   NWE.SetCommandObject(temp)
end
