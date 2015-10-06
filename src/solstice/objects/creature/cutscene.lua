----
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature
local NWE = require 'solstice.nwn.engine'

--- Faction
-- @section

---
function Creature:BlackScreen()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(698, 1)
end

function Creature:FadeFromBlack(speed)
   speed = speed or FADE_SPEED_MEDIUM

   NWE.StackPushFloat(speed)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(695, 2)
end

function Creature:FadeToBlack(speed)
   speed = speed or FADE_SPEED_MEDIUM

   NWE.StackPushFloat(speed)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(696, 2)
end

function Creature:GetCutsceneCameraMoveRate()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(742, 1)

   return NWE.StackPopFloat()
end

function Creature:GetCutsceneMode()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(781, 1)

   return NWE.StackPopInteger()
end

function Creature:LockCameraDirection(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(825, 2)
end

function Creature:LockCameraDistance(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(824, 2)
end

function Creature:LockCameraPitch(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(823, 2)
end

function Creature:RestoreCameraFacing()
   NWE.ExecuteCommand(703, 0)
end

function Creature:SetCameraFacing(direction, distance, pitch, transition_type)
   distance = distance or -1.0
   pitch = pitch or -1.0
   transition_type = transition_type or CAMERA_TRANSITION_TYPE_SNAP

   NWE.StackPushInteger(transition_type)
   NWE.StackPushFloat(pitch)
   NWE.StackPushFloat(distance)
   NWE.StackPushFloat(direction)
   NWE.ExecuteCommand(45, 4)
end

function Creature:SetCameraHeight(height)
   NWE.StackPushFloat(height or 0)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(776, 2)
end

function Creature:SetCameraMode(mode)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(504, 2)
end

function Creature:SetCutsceneCameraMoveRate(rate)
   NWE.StackPushFloat(rate)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(743, 2)
end

function Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)
   NWE.StackPushBoolean(leftclick_enabled)
   NWE.StackPushBoolean(in_cutscene)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(692, 3)
end

function Creature:StopFade()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(697, 1)
end

function Creature:StoreCameraFacing()
   NWE.ExecuteCommand(702, 0)
end
