require 'nwn.ctypes.area'
local ffi = require 'ffi'
local C = ffi.C

ffi.cdef[[
typedef struct Area {
    uint32_t        type;
    uint32_t        id;
    CNWSArea       *obj;
} Area;
]]

local area_mt = { __index = Area }
area_t = ffi.metatype("Area", area_mt)

-- Determines if there is a clear line of sight between two objects
-- @param loc1 Location A
-- @param loc2 Location B
function Area:ClearLineOfSight(loc1, loc2)
   local result = C.nwn_ClearLineOfSight(self.obj, loc1.position, loc2.position)
   return result
end

function Area:GetType()
   if not self:GetIsValid() then return 0 end
   return self.obj.area_type
end

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
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(814, 1)
   
   return nwn.engine.StackPopString()
end

--- Recomputes the lighting in an area based on current static lighting conditions.
function Area:RecomputeStaticLighting()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(516, 1)
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
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   if idx >= 0 and idx < self.obj.area_objects_len then
      return _NL_GET_CACHED_OBJECT(self.obj.area_objects[idx])
   end
   return nwn.OBJECT_INVALID
end

--- An iterator returning all objects in a specified area.
function Area:Objects()
   local i, _i = 0
   return function () 
      while self:GetIsValid() and i < self.obj.area_objects_len do
         _i, i = i, i + 1
         return _NL_GET_CACHED_OBJECT(self.obj.area_objects[_i])
      end
   end
end

--- Changes the ambient soundtracks of an area.
-- @param day Day track number to change to.  If nil the track is unchanged
-- @param night Night track number to change to.  If nil the track is unchanged
function Area:AmbientSoundChange(day, night)
   if daytrack then
      nwn.engine.StackPushInteger(day)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(435, 2)
   end
   if nighttrack then
      nwn.engine.StackPushInteger(night)
      nwn.engine.StackPushObject(area)
      nwn.engine.ExecuteCommand(436, 2)
   end
end

--- Starts ambient sounds playing in an area.
function Area:AmbientSoundPlay()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(433, 1)
end

--- Stops ambient sounds playing in an area.
function Area:AmbientSoundStop()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(434, 1)
end

--- Changes the ambient sound volumes of an area.
-- @param day The day volume (0-100) to change to.  If nil the volume is unchanged. 
-- @param night The night volume (0-100) to change to.  If nil the volume is unchanged.
function Area:AmbientSoundSetVolume(day, night)
   if day then
      nwn.engine.StackPushInteger(day)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(567, 2)
   end
   if night then
      nwn.engine.StackPushInteger(night)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(568, 2)
   end
end

--- Changes the background music for the area specified.
-- @param day Day track number to change to.  If nil the track is unchanged
-- @param night Night track number to change to.  If nil the track is unchanged
function Area:MusicBackgroundChange(day, night)
   if day then
      nwn.engine.StackPushInteger(day)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(428, 2)
   end
   if night then
      nwn.engine.StackPushInteger(nTrack)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(429, 2)
   end
end

--- Gets the background battle track for an area.
function Area:MusicBackgroundGetBattleTrack()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(569, 1)
   nwn.engine.StackPopInteger()
end

--- Gets the daytime background track for an area.
-- @param is_night If true returns the night track. Default: false
function Area:MusicBackgroundGetTrack(is_night)
   if not is_night then
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(558, 1)
      return nwn.engine.StackPopInteger()
   else
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(559, 1)
      return nwn.engine.StackPopInteger()
   end
end

--- Starts the currently selected background track playing.
function Area:MusicBackgroundPlay()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(426, 1)
end

--- Changes the delay (in milliseconds) of the background music.
function Area:MusicBackgroundSetDelay(delay)
   nwn.engine.StackPushInteger(delay)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(427, 2)
end

--- Stops the currently selected background track playing.
function Area:MusicBackgroundStop()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(425, 1)
end

--- Stops the currently selected background track playing.
-- @param track Music track number.
function Area:MusicBattleChange(track)
   nwn.engine.StackPushInteger(track)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(432, 2)
end

--- Starts the currently selected battle track playing
function Area:MusicBattlePlay()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(431, 1)
end

--- Stops the currently selected battle track playing
function Area:MusicBattleStop()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(430, 1)
end

--- Sets the graphic shown when a PC moves between two different areas in a module.
-- @param predef A predifined nwn.AREA_TRANSITION_* constant.
-- @param custom File name of an area transition bitmap. (Default: "")
function Area:SetAreaTransitionBMP(predef, custom)
   nwn.engine.StackPushString(custom or "")
   nwn.engine.StackPushInteger(predef)
   nwn.engine.ExecuteCommand(203, 2)
end

--- Gets the sky that is displayed in the specified area.
-- @param skybox A nwn.SKYBOX_* constant (associated with skyboxes.2da)
function Area:SetSkyBox(skybox)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(skyBox)
   nwn.engine.ExecuteCommand(777, 2)
end

--- Sets the weather in the specified area.
-- @param weather nwn.WEATHER_*
function Area:SetWeather(weather)
   nwn.engine.StackPushInteger(weather)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(507, 2)
end

--[[
   function Area:GetObjectIndexByX(x)
   for i = 0, self.obj.area_objects_len - 1 do
   if self.obj.area_objects[i] == object.id then
   return i
   end
   end
   return -1
   end
   --]]

--[[ Obsolete
---
-- @param 
-- @return
function Area:GetFirstObject()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(93, 1)

   return nwn.engine.StackPopObject()
end

---
-- @param 
-- @return
function Area:GetNextObject()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(94, 1)
   
   return nwn.engine.StackPopObject()
   end
   --]]