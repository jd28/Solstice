--- Area module
-- @module area

--- Class Area
-- @section area


local NWE = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C
local Obj = require 'solstice.object'

local M = require 'solstice.area.init'
require 'solstice.area.constant'

M.Area = inheritsFrom(Obj.Object, 'solstice.area.Area')

--- Internal ctype
M.area_t = ffi.metatype("Area", { __index = M.Area })


--- Determines if there is a clear line of sight between two objects
-- @param loc1 Location A
-- @param loc2 Location B
function M.Area:ClearLineOfSight(loc1, loc2)
   local result = C.nwn_ClearLineOfSight(self.obj, loc1.position, loc2.position)
   return result
end

--- Get area type.
function M.Area:GetType()
   if not self:GetIsValid() then return 0 end
   return self.obj.area_type
end

--- Get area player count.
function M.Area:GetPlayerCount()
   if not self:GetIsValid() then return -1 end
   return self.obj.area_num_players
end

--- Gets the sky that is displayed in the specified area.
function M.Area:GetSkyBox()
   if not self:GetIsValid() then return -1 end
   return self.obj.area_skybox
end

--- Gets the Tileset Resref for the specified area.
function M.Area:GetTilesetResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(814, 1)
   
   return NWE.StackPopString()
end

--- Recomputes the lighting in an area based on current static lighting conditions.
function M.Area:RecomputeStaticLighting()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(516, 1)
end

--- Gets the position of specified object in the areas object list.
function M.Area:GetObjectIndex(object)
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
function M.Area:GetObjectAtIndex(idx)
   if not self:GetIsValid() then return Obj.INVALID end
   if idx >= 0 and idx < self.obj.area_objects_len then
      return _SOL_GET_CACHED_OBJECT(self.obj.area_objects[idx])
   end
   return Obj.INVALID
end

--- An iterator returning all objects in a specified area.
-- @func[opt] predicate A function taking one parameter (an object)
-- returning a boolean.  This function can be used to filter the 
-- iterator in arbitrary ways.
function M.Area:Objects(predicate)
   local function t(obj) return true end
   predicate = predicate or t
   local i, _i = 0

   return function () 
      while self:GetIsValid() and i < self.obj.area_objects_len do
	 _i, i = i, i + 1
	 local o = _SOL_GET_CACHED_OBJECT(self.obj.area_objects[_i])
	 if predicate(o) then
	    return o
	 end
      end
   end
end

--- Changes the ambient soundtracks of an area.
-- @param day Day track number to change to.  If nil the track is unchanged
-- @param night Night track number to change to.  If nil the track is unchanged
function M.Area:AmbientSoundChange(day, night)
   if daytrack then
      NWE.StackPushInteger(day)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(435, 2)
   end
   if nighttrack then
      NWE.StackPushInteger(night)
      NWE.StackPushObject(area)
      NWE.ExecuteCommand(436, 2)
   end
end

--- Starts ambient sounds playing in an area.
function M.Area:AmbientSoundPlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(433, 1)
end

--- Stops ambient sounds playing in an area.
function M.Area:AmbientSoundStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(434, 1)
end

--- Changes the ambient sound volumes of an area.
-- @param day The day volume (0-100) to change to.  If nil the volume is unchanged. 
-- @param night The night volume (0-100) to change to.  If nil the volume is unchanged.
function M.Area:AmbientSoundSetVolume(day, night)
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
function M.Area:MusicBackgroundChange(day, night)
   if day then
      NWE.StackPushInteger(day)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(428, 2)
   end
   if night then
      NWE.StackPushInteger(nTrack)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(429, 2)
   end
end

--- Gets the background battle track for an area.
function M.Area:MusicBackgroundGetBattleTrack()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(569, 1)
   NWE.StackPopInteger()
end

--- Gets the daytime background track for an area.
-- @param[opt=false] is_night If true returns the night track,
-- else the day track
function M.Area:MusicBackgroundGetTrack(is_night)
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
function M.Area:MusicBackgroundPlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(426, 1)
end

--- Changes the delay (in milliseconds) of the background music.
function M.Area:MusicBackgroundSetDelay(delay)
   NWE.StackPushInteger(delay)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(427, 2)
end

--- Stops the currently selected background track playing.
function M.Area:MusicBackgroundStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(425, 1)
end

--- Stops the currently selected background track playing.
-- @param track Music track number.
function M.Area:MusicBattleChange(track)
   NWE.StackPushInteger(track)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(432, 2)
end

--- Starts the currently selected battle track playing
function M.Area:MusicBattlePlay()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(431, 1)
end

--- Stops the currently selected battle track playing
function M.Area:MusicBattleStop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(430, 1)
end

--- Sets the graphic shown when a PC moves between two different areas in a module.
-- @param predef A predifined solstice.area.TRANSITION\_* constant.
-- @param[opt=""] custom File name of an area transition bitmap.
function M.Area:SetAreaTransitionBMP(predef, custom)
   NWE.StackPushString(custom or "")
   NWE.StackPushInteger(predef)
   NWE.ExecuteCommand(203, 2)
end

--- Gets the sky that is displayed in the specified area.
-- @param skybox A solstice.area.SKYBOX_* constant (associated with skyboxes.2da)
function M.Area:SetSkyBox(skybox)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(skyBox)
   NWE.ExecuteCommand(777, 2)
end

--- Sets the weather in the specified area.
-- @param weather solstice.area.WEATHER_*
function M.Area:SetWeather(weather)
   NWE.StackPushInteger(weather)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(507, 2)
end

return M
