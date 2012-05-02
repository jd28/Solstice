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

---
function Creature:BlackScreen()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(698, 1)
end

--- Fades screen from black
-- @param speed nwn.FADE_SPEED_ (Default: nwn.FADE_SPEED_MEDIUM)
function Creature:FadeFromBlack(speed)
   speed = speed or nwn.FADE_SPEED_MEDIUM
   
   nwn.engine.StackPushFloat(speed)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(695, 2)
end

--- Fades screen to black
-- @param speed nwn.FADE_SPEED_ (Default: nwn.FADE_SPEED_MEDIUM)
function Creature:FadeToBlack(speed)
   speed = speed or nwn.FADE_SPEED_MEDIUM
   
   nwn.engine.StackPushFloat(speed)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(696, 2)
end

--- Get cutscene camera movement rate
function Creature:GetCutsceneCameraMoveRate()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(742, 1)

   return nwn.engine.StackPopFloat()
end

--- Get a creaturses cutscene mode
function Creature:GetCutsceneMode()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(781, 1)

   return nwn.engine.StackPopInteger()
end

--- Locks a creatures camera direction.
-- @param locked (Default: false)
function Creature:LockCameraDirection(locked)
   nwn.engine.StackPushBoolean(locked)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(825, 2)
end

--- Locks a creatures camera distance.
-- @param locked (Default: false)
function Creature:LockCameraDistance(locked)
   nwn.engine.StackPushBoolean(locked)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(824, 2)
end

--- Locks a creatures camera pitch.
-- @param locked (Default: false)
function Creature:LockCameraPitch(locked)
   nwn.engine.StackPushBoolean(locked)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(823, 2)
end

--- Restore creatures camera orientation.
function Creature:RestoreCameraFacing()
   nwn.engine.ExecuteCommand(703, 0)
end

--- Set creatures camera orientation.
-- @param direction direction to face
-- @param distance Camera distance (Default: -1)
-- @param pitch Camera pitch (Default: -1)
-- @param transition_type nwn.CAMERA_TRANSITION_TYPE_*
function Creature:SetCameraFacing(direction, distance, pitch, transition_type)
   distance = distance or -1.0
   pitch = pitch or -1.0
   transition_type = transition_type or nwn.CAMERA_TRANSITION_TYPE_SNAP
   
   nwn.engine.StackPushInteger(transition_type)
   nwn.engine.StackPushFloat(pitch)
   nwn.engine.StackPushFloat(distance)
   nwn.engine.StackPushFloat(direction)
   nwn.engine.ExecuteCommand(45, 4)
end

--- Set camera height
-- @param height New height.
function Creature:SetCameraHeight(height)
   nwn.engine.StackPushFloat(height or 0)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(776, 2)
end

--- Set Camera mode
-- @param mode New mode
function Creature:SetCameraMode(mode)
   nwn.engine.StackPushInteger(mode)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(504, 2)
end

--- Sets camera movement rate.
-- @param rate New movement rate
function Creature:SetCutsceneCameraMoveRate(rate)
   nwn.engine.StackPushFloat(rate)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(743, 2)
end

--- Sets cutscene move
-- @param in_cutscene (Default: false)
-- @param leftclick_enabled (Default: false)
function Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)
   nwn.engine.StackPushBoolean(leftclick_enabled)
   nwn.engine.StackPushBoolean(in_cutscene)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(692, 3)
end

--- Stops a screen fade
function Creature:StopFade()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(697, 1)
end

--- Stores camera orientation.
function Creature:StoreCameraFacing()
   nwn.engine.ExecuteCommand(702, 0)
end