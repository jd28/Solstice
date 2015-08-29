--- Door
-- @module door

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Door = inheritsFrom({}, M.Object)
M.Door = Door

local Signal = require 'solstice.external.signal'
Door.signals = {
  OnAreaTransitionClick = Signal.signal(),
  OnClose = Signal.signal(),
  OnOpen = Signal.signal(),
  OnDamaged = Signal.signal(),
  OnDeath = Signal.signal(),
  OnHeartbeat = Signal.signal(),
  OnPhysicalAttacked = Signal.signal(),
  OnSpellCastAt = Signal.signal(),
  OnUserDefined = Signal.signal(),
  OnFailToOpen = Signal.signal(),
  OnLock = Signal.signal(),
  OnUnlock = Signal.signal(),
  OnDisarm = Signal.signal(),
  OnTrapTriggered = Signal.signal(),
}

function Door.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_DOOR
      },
      { __index = Door })
end

--- Actions
-- @section

--- Determines whether an action can be used on a door.
-- @param action DOOR_ACTION_*
function Door:GetIsActionPossible(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(337, 2)
   return NWE.StackPopBoolean()
end

--- Does specific action to target door.
-- @param action DOOR_ACTION_*
function Door:DoAction(action)
   NWE.StackPushInteger(action);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(338, 2);
end
