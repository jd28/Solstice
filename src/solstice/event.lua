--- Event
-- @module event

local NWE = require 'solstice.nwn.engine'

local M = {}

M.HEARTBEAT =  1001
M.PERCEIVE = 1002
M.END_COMBAT_ROUND = 1003
M.DIALOGUE = 1004
M.ATTACKED = 1005
M.DAMAGED = 1006
M.DISTURBED = 1008
M.SPELL_CAST_AT = 1011

M.REST_INVALID     = 0
M.REST_STARTED     = 1
M.REST_FINISHED    = 2
M.REST_CANCELLED   = 3

M.INVENTORY_ITEM_ADDED    = 0
M.INVENTORY_ITEM_REMOVED  = 1
M.INVENTORY_ITEM_STOLEN   = 2

M.AI_TIMED_EVENT = 1
M.AI_ENTERED_TRIGGER = 2
M.AI_LEFT_TRIGGER = 3
M.AI_REMOVE_FROM_AREA = 4
M.AI_APPLY_EFFECT = 5
M.AI_CLOSE_OBJECT = 6
M.AI_OPEN_OBJECT = 7
M.AI_SPELL_IMPACT = 8
M.AI_PLAY_ANIMATION = 9
M.AI_SIGNAL_EVENT = 10
M.AI_DESTROY_OBJECT = 11
M.AI_UNLOCK_OBJECT = 12
M.AI_LOCK_OBJECT = 13
M.AI_REMOVE_EFFECT = 14
M.AI_ON_MELEE_ATTACKED = 15
M.AI_DECREMENT_STACKSIZE = 16
M.AI_SPAWN_BODY_BAG = 17
M.AI_FORCED_ACTION = 18
M.AI_ITEM_ON_HIT_SPELL_IMPACT = 19
M.AI_BROADCAST_AOO = 20
M.AI_BROADCAST_SAFE_PROJECTILE = 21
M.AI_FEEDBACK_MESSAGE = 22
M.AI_ABILITY_EFFECT_APPLIED = 23
M.AI_SUMMON_CREATURE = 24
M.AI_ACQUIRE_ITEM = 25
M.AI_WHIRLWIND_ATTACK = 26
M.AI_BOOT_PC = 27


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