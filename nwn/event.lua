---
function nwn.EventActivateItem(item, location, target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, location)
   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(424, 3)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EVENT)
end

---
function nwn.EventConversation()
   nwn.engine.ExecuteCommand(295, 0)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EVENT)
end

---
function nwn.EventUserDefined(event)
   nwn.engine.StackPushInteger(event)
   nwn.engine.ExecuteCommand(132, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EVENT)
end

---
function nwn.EventSpellCastAt(caster, spell, is_harmful)
   nwn.engine.StackPushInteger(is_harmful)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.StackPushObject(caster)
   nwn.engine.ExecuteCommand(244, 3)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EVENT)
end

---
function nwn.GetClickingObject()
   nwn.engine.ExecuteCommand(326, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetEnteringObject()
   nwn.engine.ExecuteCommand(25, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetExitingObject()
   nwn.engine.ExecuteCommand(26, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetItemActivated()
   nwn.engine.ExecuteCommand(439, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetItemActivator()
   nwn.engine.ExecuteCommand(440, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetItemActivatedTargetLocation()
   nwn.engine.ExecuteCommand(441, 0)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION)
end

---
function nwn.GetItemActivatedTarget()
   nwn.engine.ExecuteCommand(442, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetLastPerceived()
   nwn.engine.ExecuteCommand(256, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetLastPerceptionHeard()
   nwn.engine.ExecuteCommand(257, 0)
   return nwn.engine.StackPopBoolean()
end

---
function nwn.GetLastPerceptionInaudible()
   nwn.engine.ExecuteCommand(258, 0)
   return nwn.engine.StackPopBoolean()
end

---
function nwn.GetLastPerceptionVanished()
   nwn.engine.ExecuteCommand(261, 0)
   return nwn.engine.StackPopBoolean()
end

---
function nwn.GetLastPerceptionSeen()
   nwn.engine.ExecuteCommand(259, 0)
   return nwn.engine.StackPopBoolean()
end

---
function nwn.GetLastPlayerDied()
   nwn.engine.ExecuteCommand(291, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetLastPlayerDying()
   nwn.engine.ExecuteCommand(410, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetLastPCToCancelCutscene()
   nwn.engine.ExecuteCommand(693, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetLastUsedBy()
   nwn.engine.ExecuteCommand(330, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetPCChatSpeaker()
   nwn.engine.ExecuteCommand(838, 0);
   return nwn.engine.StackPopObject();
end

---
function nwn.GetPCChatMessage()
   nwn.engine.ExecuteCommand(839, 0)
   return nwn.engine.StackPopString()
end

---
function nwn.GetPCChatVolume()
   nwn.engine.ExecuteCommand(840, 0);
   nwn.engine.StackPopInteger();
end

---
function nwn.SetPCChatMessage(message)
   message = message or ""
   nwn.engine.StackPushString(message)
   nwn.engine.ExecuteCommand(841, 1)
end

---
function nwn.SetPCChatVolume(volume)
   volume = volume or nwn.TALKVOLUME_TALK
   
   nwn.engine.StackPushInteger(volume)
   nwn.engine.ExecuteCommand(842, 1)
end

---
function nwn.GetPCLevellingUp()
   nwn.engine.ExecuteCommand(542, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetPlaceableLastClickedBy()
   nwn.engine.VM_ExecuteCommand(826, 0)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetUserDefinedEventNumber()
   nwn.engine.ExecuteCommand(247, 0)
   return nwn.engine.StackPopInteger()
end

---
function nwn.SignalEvent(object, event)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EVENT, event)
   nwn.engine.StackPushObject(object)
   nwn.engine.ExecuteCommand(131, 2)
end