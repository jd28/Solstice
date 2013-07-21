--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'
local Cut = require 'solstice.cutscene'


--- Faction
-- @section

---
function M.Creature:BlackScreen()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(698, 1)
end

--- Fades screen from black
-- @param[opt=solstice.cutscene.FADE_SPEED_MEDIUM] speed 
-- solstice.cutscene.FADE_SPEED_*
function M.Creature:FadeFromBlack(speed)
   speed = speed or Cut.FADE_SPEED_MEDIUM
   
   NWE.StackPushFloat(speed)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(695, 2)
end

--- Fades screen to black
-- @param[opt=solstice.cutscene.FADE_SPEED_MEDIUM] speed 
-- solstice.cutscene.FADE_SPEED_*
function M.Creature:FadeToBlack(speed)
   speed = speed or Cut.FADE_SPEED_MEDIUM
   
   NWE.StackPushFloat(speed)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(696, 2)
end

--- Get cutscene camera movement rate
function M.Creature:GetCutsceneCameraMoveRate()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(742, 1)

   return NWE.StackPopFloat()
end

--- Get a creaturses cutscene mode
function M.Creature:GetCutsceneMode()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(781, 1)

   return NWE.StackPopInteger()
end

--- Locks a creatures camera direction.
-- @param locked (Default: false)
function M.Creature:LockCameraDirection(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(825, 2)
end

--- Locks a creatures camera distance.
-- @param locked (Default: false)
function M.Creature:LockCameraDistance(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(824, 2)
end

--- Locks a creatures camera pitch.
-- @param[opt=false] locked New lock value.
function M.Creature:LockCameraPitch(locked)
   NWE.StackPushBoolean(locked)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(823, 2)
end

--- Restore creatures camera orientation.
function M.Creature:RestoreCameraFacing()
   NWE.ExecuteCommand(703, 0)
end

--- Set creatures camera orientation.
-- @param direction direction to face.
-- @param[opt=-1.0] distance Camera distance.
-- @param[opt=-1.0] pitch Camera pitch.
-- @param[opt=solstice.cutscene.CAMERA_TRANSITION_TYPE_SNAP] transition_type 
-- solstice.cutscene.CAMERA_TRANSITION_TYPE_*
function M.Creature:SetCameraFacing(direction, distance, pitch, transition_type)
   distance = distance or -1.0
   pitch = pitch or -1.0
   transition_type = transition_type or Cut.CAMERA_TRANSITION_TYPE_SNAP
   
   NWE.StackPushInteger(transition_type)
   NWE.StackPushFloat(pitch)
   NWE.StackPushFloat(distance)
   NWE.StackPushFloat(direction)
   NWE.ExecuteCommand(45, 4)
end

--- Set camera height
-- @param height New height.
function M.Creature:SetCameraHeight(height)
   NWE.StackPushFloat(height or 0)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(776, 2)
end

--- Set Camera mode
-- @param mode New mode
function M.Creature:SetCameraMode(mode)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(504, 2)
end

--- Sets camera movement rate.
-- @param rate New movement rate
function M.Creature:SetCutsceneCameraMoveRate(rate)
   NWE.StackPushFloat(rate)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(743, 2)
end

--- Sets cutscene move
-- @param in_cutscene (Default: false)
-- @param leftclick_enabled (Default: false)
function M.Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)
   NWE.StackPushBoolean(leftclick_enabled)
   NWE.StackPushBoolean(in_cutscene)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(692, 3)
end

--- Stops a screen fade
function M.Creature:StopFade()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(697, 1)
end

--- Stores camera orientation.
function M.Creature:StoreCameraFacing()
   NWE.ExecuteCommand(702, 0)
end