--- Area module
-- @module area

--- Class Area
-- @section area

local NWE = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C
local Obj = require 'solstice.object'
local GetObjectByID = Game.GetObjectByID

local M = {}
local Area = inheritsFrom({}, Obj.Object)
M.Area = Area

-- Internal ctype
M.area_t = ffi.metatype("Area", { __index = Area })

--- Determines if there is a clear line of sight between two objects
-- @param loc1 Location A
-- @param loc2 Location B
function Area:ClearLineOfSight(loc1, loc2)
   local result = C.nwn_ClearLineOfSight(self.obj, loc1.position, loc2.position)
   return result
end

--- Get area type.
function Area:GetType()
   if not self:GetIsValid() then return 0 end
   return self.obj.area_type
end

--- Get area player count.
function Area:GetPlayerCount()
   if not self:GetIsValid() then return -1 end
   return self.obj.area_num_players
end

--- Gets the sky that is displayed in the specified area.
function Area:GetSkyBox()
   if not self:GetIsValid() then return -1 end
   return self.obj.area_skybox
end

--- Gets the Tileset Resref for the specified area.
function Area:GetTilesetResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(814, 1)

   return NWE.StackPopString()
end

--- Recomputes the lighting in an area based on current static lighting conditions.
function Area:RecomputeStaticLighting()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(516, 1)
end

--- Gets the position of specified object in the areas object list.
function Area:GetObjectIndex(object)
   if not self:GetIsValid() then return end
   for i = 0, self.obj.area_objects_len - 1 do
      if self.obj.area_objects[i] == object.id then
         return i
      end
   end
   return -1
end

--- Returns the object at specifed index of the area's object array.
-- @param idx Index of the object desired.
function Area:GetObjectAtIndex(idx)
   if not self:GetIsValid() then return OBJECT_INVALID end
   if idx >= 0 and idx < self.obj.area_objects_len then
      return GetObjectByID(self.obj.area_objects[idx])
   end
   return OBJECT_INVALID
end

--- Iterator returning all objects in a specified area.
function Area:Objects()
   local i = 0
   return function()
      local obj = self:GetObjectIndex(i)
      if obj:GetIsValid() then
         i = i + 1
         return obj
      end
   end
end

--- Changes the ambient soundtracks of an area.
-- @param day Day track number to change to.  If nil the track is unchanged
-- @param night Night track number to change to.  If nil the track is unchanged
function Area:AmbientSoundChange(day, night)
   if day then
      NWE.StackPushInteger(day)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(435, 2)
   end
   if night then
      NWE.StackPushInteger(night)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(436, 2)
   end
end

--- Starts ambient sounds playing in an area.
function Area:AmbientSoundPlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(433, 1)
end

--- Stops ambient sounds playing in an area.
function Area:AmbientSoundStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(434, 1)
end

--- Changes the ambient sound volumes of an area.
-- @param day The day volume (0-100) to change to.  If nil the volume is unchanged.
-- @param night The night volume (0-100) to change to.  If nil the volume is unchanged.
function Area:AmbientSoundSetVolume(day, night)
   if day then
      NWE.StackPushInteger(day)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(567, 2)
   end
   if night then
      NWE.StackPushInteger(night)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(568, 2)
   end
end

--- Changes the background music for the area specified.
-- @param day Day track number to change to.  If nil the track is unchanged
-- @param night Night track number to change to.  If nil the track is unchanged
function Area:MusicBackgroundChange(day, night)
   if day then
      NWE.StackPushInteger(day)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(428, 2)
   end
   if night then
      NWE.StackPushInteger(night)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(429, 2)
   end
end

--- Gets the background battle track for an area.
function Area:MusicBackgroundGetBattleTrack()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(569, 1)
   NWE.StackPopInteger()
end

--- Gets the daytime background track for an area.
-- @param[opt=false] is_night If true returns the night track,
-- else the day track
function Area:MusicBackgroundGetTrack(is_night)
   if not is_night then
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(558, 1)
      return NWE.StackPopInteger()
   else
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(559, 1)
      return NWE.StackPopInteger()
   end
end

--- Starts the currently selected background track playing.
function Area:MusicBackgroundPlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(426, 1)
end

--- Changes the delay (in milliseconds) of the background music.
function Area:MusicBackgroundSetDelay(delay)
   NWE.StackPushInteger(delay)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(427, 2)
end

--- Stops the currently selected background track playing.
function Area:MusicBackgroundStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(425, 1)
end

--- Stops the currently selected background track playing.
-- @param track Music track number.
function Area:MusicBattleChange(track)
   NWE.StackPushInteger(track)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(432, 2)
end

--- Starts the currently selected battle track playing
function Area:MusicBattlePlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(431, 1)
end

--- Stops the currently selected battle track playing
function Area:MusicBattleStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(430, 1)
end

--- Sets the graphic shown when a PC moves between two different areas in a module.
-- @param predef A predifined AREA_TRANSITION_* constant.
-- @param[opt=""] custom File name of an area transition bitmap.
function Area:SetAreaTransitionBMP(predef, custom)
   NWE.StackPushString(custom or "")
   NWE.StackPushInteger(predef)
   NWE.ExecuteCommand(203, 2)
end

--- Gets the sky that is displayed in the specified area.
-- @param skybox A SKYBOX_* constant (associated with skyboxes.2da)
function Area:SetSkyBox(skybox)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(skybox)
   NWE.ExecuteCommand(777, 2)
end

--- Sets the weather in the specified area.
-- @param weather AREA_WEATHER_*
function Area:SetWeather(weather)
   NWE.StackPushInteger(weather)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(507, 2)
end

return M
