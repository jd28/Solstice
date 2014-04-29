--- Game
-- @module game

--- Events
-- @section events

local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.game.init'

--- Create activate item even.
-- @param item Item.
-- @param location Target location.
-- @param target Target object.
function M.EventActivateItem(item, location, target)
   NWE.StackPushObject(target)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(424, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

--- Create conversation event.
function M.EventConversation()
   NWE.ExecuteCommand(295, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

--- Create user defined event.
-- @param event An integer id.
function M.EventUserDefined(event)
   NWE.StackPushInteger(event)
   NWE.ExecuteCommand(132, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

--- Creature spell cast at event.
-- @param caster Spell caster.
-- @param spell SPELL\_*
-- @bool is_harmful Is spell harmful to target.
function M.EventSpellCastAt(caster, spell, is_harmful)
   NWE.StackPushBoolean(is_harmful)
   NWE.StackPushInteger(spell)
   NWE.StackPushObject(caster)
   NWE.ExecuteCommand(244, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EVENT)
end

--- Get last clicking object.
function M.GetClickingObject()
   NWE.ExecuteCommand(326, 0)
   return NWE.StackPopObject()
end

--- Get last object to enter.
function M.GetEnteringObject()
   NWE.ExecuteCommand(25, 0)
   return NWE.StackPopObject()
end

--- Get last object to exit.
function M.GetExitingObject()
   NWE.ExecuteCommand(26, 0)
   return NWE.StackPopObject()
end

--- Gets the item activated.
function M.GetItemActivated()
   NWE.ExecuteCommand(439, 0)
   return NWE.StackPopObject()
end

--- Gets object that activated item.
function M.GetItemActivator()
   NWE.ExecuteCommand(440, 0)
   return NWE.StackPopObject()
end

--- Gets item activated event location.
function M.GetItemActivatedTargetLocation()
   NWE.ExecuteCommand(441, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

--- Gets item activated event target.
function M.GetItemActivatedTarget()
   NWE.ExecuteCommand(442, 0)
   return NWE.StackPopObject()
end

--- Gets last player died.
function M.GetLastPlayerDied()
   NWE.ExecuteCommand(291, 0)
   return NWE.StackPopObject()
end

--- Gets last player dying.
function M.GetLastPlayerDying()
   NWE.ExecuteCommand(410, 0)
   return NWE.StackPopObject()
end

--- Gets last PC to cancel cutscene.
function M.GetLastPCToCancelCutscene()
   NWE.ExecuteCommand(693, 0)
   return NWE.StackPopObject()
end

--- Gets last object to use something.
function M.GetLastUsedBy()
   NWE.ExecuteCommand(330, 0)
   return NWE.StackPopObject()
end

--- Gets last pc chat speaker.
function M.GetPCChatSpeaker()
   NWE.ExecuteCommand(838, 0);
   return NWE.StackPopObject();
end

--- Gets last PC that leveled up.
function M.GetPCLevellingUp()
   NWE.ExecuteCommand(542, 0)
   return NWE.StackPopObject()
end

--- Get last object to click a placeable.
function M.GetPlaceableLastClickedBy()
   NWE.ExecuteCommand(826, 0)
   return NWE.StackPopObject()
end

--- Get user defined event number.
function M.GetUserDefinedEventNumber()
   NWE.ExecuteCommand(247, 0)
   return NWE.StackPopInteger()
end

--- Signal an event.
-- @param object
-- @param event
function M.SignalEvent(object, event)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EVENT, event)
   NWE.StackPushObject(object)
   NWE.ExecuteCommand(131, 2)
end

return M
