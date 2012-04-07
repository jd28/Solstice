--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

--- An action that causes an object to close a door.
-- @param door Door to close
function Creature:ActionCloseDoor(door)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(door)
   nwn.engine.ExecuteCommand(44, 1)

   nwn.engine.SetCommandObjectId(temp)
end


--- Gives a specified item to a target creature.
-- @param item Item to give.
-- @param target Receiver
function Object:ActionGiveItem(item, target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(135, 2)

   nwn.engine.SetCommandObjectId(temp)
end

--- An action that will cause a creature to lock a door or 
-- other unlocked object.
-- @param target Door or placeable object that will be the
--     target of the lock attempt.
function Creature:ActionLockObject(target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(484, 1)

   nwn.engine.SetCommandObjectId(temp)
end

--- An action that will cause a creature to open a door.
-- @param door Door to open
function Creature:ActionOpenDoor(door)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(door)
   nwn.engine.ExecuteCommand(43, 1)

   nwn.engine.SetCommandObjectId(temp)
end

--- Pause the current conversation.
function Object:ActionPauseConversation()
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.ExecuteCommand(205, 0)

   nwn.engine.SetCommandObjectId(temp)
end

--- Resume a conversation after it has been paused.
function Object:ActionResumeConversation()
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.ExecuteCommand(206, 0)

   nwn.engine.SetCommandObjectId(temp)
end

--- Causes an object to speak.
-- @param message String to be spoken.
-- @param volume nwn.TALKVOLUME_* (Default: nwn.TALKVOLUME_TALK) 
function Object:ActionSpeakString(message, volume)
   volume = volume or nwn.TALKVOLUME_TALK
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushInteger(volume)
   nwn.engine.StackPushString(message)
   nwn.engine.ExecuteCommand(39, 2)

   nwn.engine.SetCommandObjectId(temp)
end

--- Causes the creature to speak a translated string.
-- @param strref Reference of the string in the talk table
-- @param volume nwn.TALKVOLUME_* (Default: nwn.TALKVOLUME_TALK) 
function Object:ActionSpeakStringByStrRef(strref, volume)
   volume = volume or nwn.TALKVOLUME_TALK
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushInteger(volume)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(240, 2)

   nwn.engine.SetCommandObjectId(temp)
end

--- Action to start a conversation with a PC
-- @param target An object to converse with.
-- @param dialog The resource reference (filename) of a conversation.
--     (Default: "") 
-- @param private Specify whether the conversation is audible to everyone
--     or only to the PC. (Default: false) 
-- @param hello Determines if initial greeting is played. (Default: true) 
function Object:ActionStartConversation(target, dialog, private, hello)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   dialog = dialog or ""
   if hello == nil then hello = true end
   
   nwn.engine.StackPushInteger(hello)
   nwn.engine.StackPushInteger(private)
   nwn.engine.StackPushString(dialog)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(204, 4)

   nwn.engine.SetCommandObjectId(temp)
end

--- Takes an item from an object
-- @param item The item to take.
-- @param target The object from which to take the item.
function Object:ActionTakeItem(oItem, oTakeFrom)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(oTakeFrom)
   nwn.engine.StackPushObject(oItem)
   nwn.engine.ExecuteCommand(136, 2)

   nwn.engine.SetCommandObjectId(temp)
end

--- Causes a creature to unlock a door or other locked object.
-- @param target Door or placeable object that will be the
--     target of the unlock attempt.
function Creature:ActionUnlockObject(target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(483, 1)

   nwn.engine.SetCommandObjectId(temp)
end

--- Adds a wait action to an objects queue.
-- @param time Time in seconds to wait.
function Object:ActionWait(time)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushFloat(time)
   nwn.engine.ExecuteCommand(202, 1)

   nwn.engine.SetCommandObjectId(temp)
end

--- Removes all actions from an action queue.
-- @param Stop combat along with all other actions. (Default: false) 
function Object:ClearAllActions(clear_combat)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushBoolean(clear_combat)
   nwn.engine.ExecuteCommand(9, 1)

   nwn.engine.SetCommandObjectId(temp)
end

--- Returns the currently executing Action.
function Object:GetCurrentAction()
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(522, 1)

   nwn.engine.SetCommandObjectId(temp)
   return nwn.engine.StackPopInteger()
end

--- Forces an object to immediately speak.
-- @param text Text to be spoken.
-- @param volume nwn.TALKVOLUME_* (Default: nwn.TALKVOLUME_TALK) 
function Object:SpeakString(text, volume)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   volume = volume or nwn.TALKVOLUME_TALK

   nwn.engine.StackPushInteger(volume);
   nwn.engine.StackPushString(text);
   nwn.engine.ExecuteCommand(221, 2);

   nwn.engine.SetCommandObjectId(temp)
end

--- Causes an object to instantly speak a translated string.
-- @param strref TLK string reference to speak.
-- @param volume nwn.TALKVOLUME_* (Default: nwn.TALKVOLUME_TALK) 
function Object:SpeakStringByStrRef(strref, volume)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nTalkVolume = nTalkVolume or nwn.TALKVOLUME_TALK

   nwn.engine.StackPushInteger(volume)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(691, 2)

   nwn.engine.SetCommandObjectId(temp)
end



