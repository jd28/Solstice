require 'nwn.ctypes.location'

local ffi = require 'ffi'

--- Engine Structures
local location_mt = { __index = Location }

location_t = ffi.metatype("CScriptLocation", location_mt)

--- Applies an effect to a location
-- @param eff Effect to apply.
-- @param duration Duration of an effect. (Default: 0.0)
function Location:ApplyEffect(durtype, eff, duration)
   duration = duration or 0.0
      
   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, eff.eff)
   nwn.engine.StackPushInteger(durtype)
   nwn.engine.ExecuteCommand(216, 4)
end

--- Applies a visual effect to a location
-- @param vfx nwn.VFX_*
function Location:ApplyVisual(vfx, duration)
   local durtype = duration and nwn.DURATION_TYPE_TEMPORARY or nwn.DURATION_TYPE_INSTANT
   duration = duration or 0

   local eff = nwn.EffectVisualEffect(vfx)
   self:ApplyEffect(durtype, eff)
end

--- Gets nearest object to location
-- @param mask nwn.OBJECT_TYPE_* mask.
-- @param nth Which object to find. (Default: 1)
function Location:GetNearestObject(mask, nth)
   nth = nth or 1 
   
   nwn.engine.StackPushInteger(nth)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushInteger(mask)
   nwn.engine.ExecuteCommand(228, 3)

   return nwn.engine.StackPopObject()
end

--- Gets nearest creature to location.
-- @param type1 First criteria type
-- @param value1 First crieria value
-- @param nth Nth nearest.
-- @param type2 (Default: -1)
-- @param value2 (Default: -1)
-- @param type3 (Default: -1)
-- @param value3 (Default: -1)
function Location:GetNearestCreature(type1, value1, nth, ...)
   local type2, value2, type3, value3 = ...

   nwn.engine.StackPushInteger(value3 or -1)
   nwn.engine.StackPushInteger(type3 or -1)
   nwn.engine.StackPushInteger(value2 or -1)
   nwn.engine.StackPushInteger(type2 or -1)
   nwn.engine.StackPushInteger(nth or 1)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushInteger(value1)
   nwn.engine.StackPushInteger(type1)
   nwn.engine.ExecuteCommand(226, 8)
   
   return nwn.engine.StackPopObject()
end

function Location.FromString(str)
   local area, x, y, z, orient = string.match(str, "([%w_]+) %(([%d%.]+), ([%d%.]+), ([%d%.]+)%) ([%d%.]+)")
   area = nwn.GetObjectByTag(area)
   local pos = vector_t(x, y, z)

   return nwn.Location(pos, orient, area)
end

function Location:ToString()
   local area = self:GetArea()
   if not area:GetIsValid() then return "" end

   local pos = area:GetPosition()
   if pos.x < 0 or pos.y < 0 then return "" end

   return string.format("%s %s %.4f", area:GetTag(), pos:ToString(), self:GetFacing())
end

--- Create square trap at location.
-- @param type nwn.TRAP_BASE_TYPE_*
-- @param size (Default 2.0)
-- @param tag Trap tag (Default: "")
-- @param faction Trap faction (Default: nwn.STANDARD_FACTION_HOSTILE)
-- @param on_disarm OnDisarm script (Default: "")
-- @param on_trigger OnTriggered script (Default: "")
function Location:Trap(type, size, tag, faction, on_disarm, on_trigger)
   nwn.engine.StackPushString(on_trigger or "")
   nwn.engine.StackPushString(on_disarm or "")
   nwn.engine.StackPushInteger(faction or nwn.STANDARD_FACTION_HOSTILE)
   nwn.engine.StackPushString(tag or "")
   nwn.engine.StackPushFloat(size or 2.0)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushInteger(type)
   nwn.engine.ExecuteCommand(809, 7)

   return nwn.engine.StackPopObject()
end

--- Sets the main light colors for a tile.
-- @param color1 nwn.TILE_SOURCE_MAIN_COLOR_*
-- @param color2 nwn.TILE_SOURCE_MAIN_COLOR_*
function Location:SetTileMainLightColor(color1, color2)
   nwn.engine.StackPushInteger(color2)
   nwn.engine.StackPushInteger(color1)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(514, 3)
end

--- Sets the source light color for a tile.
-- @param color1 nwn.TILE_SOURCE_LIGHT_COLOR_*
-- @param color2 nwn.TILE_SOURCE_LIGHT_COLOR_*
function Location:SetTileSourceLightColor(color1, color2)
   nwn.engine.StackPushInteger(color2)
   nwn.engine.StackPushInteger(color1)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(515, 3)
end

--- Determines the color of the first main light of a tile.
-- @return nwn.TILE_SOURCE_MAIN_COLOR_*
function Location:GetTileMainLight1Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(517, 1)

   return nwn.engine.StackPopInteger();
end

--- Determines the color of the second main light of a tile.
-- @return nwn.TILE_SOURCE_MAIN_COLOR_*
function Location:GetTileMainLight2Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(518, 1)

   return nwn.engine.StackPopInteger()
end

--- Determines the color of the first source light of a tile.
-- @return nwn.TILE_SOURCE_LIGHT_COLOR_*
function Location:GetTileSourceLight1Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(519, 1)
   return nwn.engine.StackPopInteger()
end

--- Determines the color of the second source light of a tile.
-- @return nwn.TILE_SOURCE_LIGHT_COLOR_*
function Location:GetTileSourceLight2Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(520, 1)
   return nwn.engine.StackPopInteger()
end

--- Get area from location.
function Location:GetArea()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(224, 1)
   return nwn.engine.StackPopObject()
end

--- Gets distance between two locations.
-- @param to The location to get the distance from.
function Location:GetDistanceBetween(to)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, to)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(298, 2)

   return nwn.engine.StackPopFloat()
end

--- Gets orientation of a location
function Location:GetFacing()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(225, 1)

   return nwn.engine.StackPopFloat()
end

--- Gets position vector of a location
function Location:GetPosition()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(223, 1)

   return nwn.engine.StackPopVector()
end


