--- Event
-- @module event

local NWE = require 'solstice.nwn.engine'

local M = {}

M.const = {
   HEARTBEAT =  1001,
   PERCEIVE = 1002,
   END_COMBAT_ROUND = 1003,
   DIALOGUE = 1004,
   ATTACKED = 1005,
   DAMAGED = 1006,
   DISTURBED = 1008,
   SPELL_CAST_AT = 1011,

   REST_INVALID     = 0,
   REST_STARTED     = 1,
   REST_FINISHED    = 2,
   REST_CANCELLED   = 3,

   INVENTORY_ITEM_ADDED    = 0,
   INVENTORY_ITEM_REMOVED  = 1,
   INVENTORY_ITEM_STOLEN   = 2,

   AI_TIMED_EVENT = 1,
   AI_ENTERED_TRIGGER = 2,
   AI_LEFT_TRIGGER = 3,
   AI_REMOVE_FROM_AREA = 4,
   AI_APPLY_EFFECT = 5,
   AI_CLOSE_OBJECT = 6,
   AI_OPEN_OBJECT = 7,
   AI_SPELL_IMPACT = 8,
   AI_PLAY_ANIMATION = 9,
   AI_SIGNAL_EVENT = 10,
   AI_DESTROY_OBJECT = 11,
   AI_UNLOCK_OBJECT = 12,
   AI_LOCK_OBJECT = 13,
   AI_REMOVE_EFFECT = 14,
   AI_ON_MELEE_ATTACKED = 15,
   AI_DECREMENT_STACKSIZE = 16,
   AI_SPAWN_BODY_BAG = 17,
   AI_FORCED_ACTION = 18,
   AI_ITEM_ON_HIT_SPELL_IMPACT = 19,
   AI_BROADCAST_AOO = 20,
   AI_BROADCAST_SAFE_PROJECTILE = 21,
   AI_FEEDBACK_MESSAGE = 22,
   AI_ABILITY_EFFECT_APPLIED = 23,
   AI_SUMMON_CREATURE = 24,
   AI_ACQUIRE_ITEM = 25,
   AI_WHIRLWIND_ATTACK = 26,
   AI_BOOT_PC = 27,
}

setmetatable(M, { __index = M.const })

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