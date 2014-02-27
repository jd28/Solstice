--- Event
-- @module event

local NWE = require 'solstice.nwn.engine'

local M = {}

---
function M.ActivateItem(item, location, target)
   NWE.StackPushObject(target)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(424, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

---
function M.Conversation()
   NWE.ExecuteCommand(295, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

---
function M.UserDefined(event)
   NWE.StackPushInteger(event)
   NWE.ExecuteCommand(132, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

---
function M.SpellCastAt(caster, spell, is_harmful)
   NWE.StackPushInteger(is_harmful)
   NWE.StackPushInteger(spell)
   NWE.StackPushObject(caster)
   NWE.ExecuteCommand(244, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

---
function M.GetClickingObject()
   NWE.ExecuteCommand(326, 0)
   return NWE.StackPopObject()
end

---
function M.GetEnteringObject()
   NWE.ExecuteCommand(25, 0)
   return NWE.StackPopObject()
end

---
function M.GetExitingObject()
   NWE.ExecuteCommand(26, 0)
   return NWE.StackPopObject()
end

---
function M.GetItemActivated()
   NWE.ExecuteCommand(439, 0)
   return NWE.StackPopObject()
end

---
function M.GetItemActivator()
   NWE.ExecuteCommand(440, 0)
   return NWE.StackPopObject()
end

---
function M.GetItemActivatedTargetLocation()
   NWE.ExecuteCommand(441, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

---
function M.GetItemActivatedTarget()
   NWE.ExecuteCommand(442, 0)
   return NWE.StackPopObject()
end

---
function M.GetLastPerceived()
   NWE.ExecuteCommand(256, 0)
   return NWE.StackPopObject()
end

---
function M.GetLastPerceptionHeard()
   NWE.ExecuteCommand(257, 0)
   return NWE.StackPopBoolean()
end

---
function M.GetLastPerceptionInaudible()
   NWE.ExecuteCommand(258, 0)
   return NWE.StackPopBoolean()
end

---
function M.GetLastPerceptionVanished()
   NWE.ExecuteCommand(261, 0)
   return NWE.StackPopBoolean()
end

---
function M.GetLastPerceptionSeen()
   NWE.ExecuteCommand(259, 0)
   return NWE.StackPopBoolean()
end

---
function M.GetLastPlayerDied()
   NWE.ExecuteCommand(291, 0)
   return NWE.StackPopObject()
end

---
function M.GetLastPlayerDying()
   NWE.ExecuteCommand(410, 0)
   return NWE.StackPopObject()
end

---
function M.GetLastPCToCancelCutscene()
   NWE.ExecuteCommand(693, 0)
   return NWE.StackPopObject()
end

---
function M.GetLastUsedBy()
   NWE.ExecuteCommand(330, 0)
   return NWE.StackPopObject()
end

---
function M.GetPCChatSpeaker()
   NWE.ExecuteCommand(838, 0);
   return NWE.StackPopObject();
end

---
function M.GetPCLevellingUp()
   NWE.ExecuteCommand(542, 0)
   return NWE.StackPopObject()
end

---
function M.GetPlaceableLastClickedBy()
   NWE.VM_ExecuteCommand(826, 0)
   return NWE.StackPopObject()
end

---
function M.GetUserDefinedEventNumber()
   NWE.ExecuteCommand(247, 0)
   return NWE.StackPopInteger()
end

---
function M.SignalEvent(object, event)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EVENT, event)
   NWE.StackPushObject(object)
   NWE.ExecuteCommand(131, 2)
end

return M
