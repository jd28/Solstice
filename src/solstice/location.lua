--- Location
-- @module location
-- @alias M

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Vec = require 'solstice.vector'
local Obj = require 'solstice.object'
local Eff = require 'solstice.effect'

local M = {}
local Location = {}
M.Location = Location

-- Internal ctype
M.location_t = ffi.metatype("CScriptLocation",
                            { __index = M.Location })

--- Invalid location.
-- Aliased globally as LOCATION_INVALID.
M.INVALID = M.location_t(Vec.vector_t(0,0,0),
                         Vec.vector_t(0,0,0),
                         Obj.INVALID.id)

--- Create a new location
-- @param position Location's position
-- @param orientation Location's orientation
-- @param area Location's area
function M.Create(position, orientation, area)
   NWE.StackPushFloat(orientation)
   NWE.StackPushVector(position)
   NWE.StackPushObject(area)
   NWE.ExecuteCommandUnsafe(215, 3)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

--- Class Location
-- @section

--- Applies an effect to a location
-- @param durtype Duration type.
-- @param eff Effect to apply.
-- @param[opt=0.0] duration Duration of an effect.
function Location:ApplyEffect(durtype, eff, duration)
   duration = duration or 0.0

   NWE.StackPushFloat(duration)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, eff.eff)
   NWE.StackPushInteger(durtype)
   NWE.ExecuteCommand(216, 4)
end

--- Applies a visual effect to a location
-- @param vfx VFX_*
-- @param[opt] duration Duration in seconds.  If not passed the visual
-- will be applied as DURATION\_TYPE\_INSTANT.
function Location:ApplyVisual(vfx, duration)
   local durtype = duration and Eff.DURATION_TYPE_TEMPORARY or Eff.DURATION_TYPE_INSTANT
   duration = duration or 0

   local eff = Eff.VisualEffect(vfx)
   self:ApplyEffect(durtype, eff)
end

--- Gets nearest object to location
-- @param mask solstice.object type mask.
-- @param[opt=1] nth Which object to find.
function Location:GetNearestObject(mask, nth)
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.StackPushInteger(mask)
   NWE.ExecuteCommand(228, 3)

   return NWE.StackPopObject()
end

--- Gets nearest creature to location.
-- @param type1 First criteria type
-- @param value1 First crieria value
-- @param nth Nth nearest.
-- @param[opt=-1] type2 Second criteria type.
-- @param[opt=-1] value2 Second criteria value.
-- @param[opt=-1] type3 Third criteria type.
-- @param[opt=-1] value3 Third criteria value.
function Location:GetNearestCreature(type1, value1, nth, ...)
   local type2, value2, type3, value3 = ...

   NWE.StackPushInteger(value3 or -1)
   NWE.StackPushInteger(type3 or -1)
   NWE.StackPushInteger(value2 or -1)
   NWE.StackPushInteger(type2 or -1)
   NWE.StackPushInteger(nth or 1)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.StackPushInteger(value1)
   NWE.StackPushInteger(type1)
   NWE.ExecuteCommand(226, 8)

   return NWE.StackPopObject()
end


--- Convert location to string
function Location:ToString()
   local area = self:GetArea()
   if not area:GetIsValid() then return "" end

   local pos = area:GetPosition()
   if pos.x < 0 or pos.y < 0 then return "" end

   return string.format("%s %s %.4f", area:GetTag(), pos:ToString(), self:GetFacing())
end

--- Create square trap at location.
-- @param type TRAP_BASE_TYPE_*
-- @param[opt=2.0] size (Default 2.0)
-- @param[opt=""] tag Trap tag.
-- @param[opt=STANDARD_FACTION_HOSTILE] faction Trap faction.
-- @param[opt=""] on_disarm OnDisarm script.
-- @param[opt=""] on_trigger OnTriggered script.
function Location:Trap(type, size, tag, faction, on_disarm, on_trigger)
   NWE.StackPushString(on_trigger or "")
   NWE.StackPushString(on_disarm or "")
   NWE.StackPushInteger(faction or STANDARD_FACTION_HOSTILE)
   NWE.StackPushString(tag or "")
   NWE.StackPushFloat(size or 2.0)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.StackPushInteger(type)
   NWE.ExecuteCommand(809, 7)

   return NWE.StackPopObject()
end

--- Sets the main light colors for a tile.
-- @param color1 AREA_TILE_SOURCE_MAIN_COLOR_*
-- @param color2 AREA_TILE_SOURCE_MAIN_COLOR_*
function Location:SetTileMainLightColor(color1, color2)
   NWE.StackPushInteger(color2)
   NWE.StackPushInteger(color1)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(514, 3)
end

--- Sets the source light color for a tile.
-- @param color1 AREA_TILE_SOURCE_LIGHT_COLOR_*
-- @param color2 AREA_TILE_SOURCE_LIGHT_COLOR_*
function Location:SetTileSourceLightColor(color1, color2)
   NWE.StackPushInteger(color2)
   NWE.StackPushInteger(color1)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(515, 3)
end

--- Determines the color of the first main light of a tile.
-- @return AREA_TILE_SOURCE_MAIN_COLOR_*
function Location:GetTileMainLight1Color()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(517, 1)

   return NWE.StackPopInteger();
end

--- Determines the color of the second main light of a tile.
-- @return AREA_TILE_SOURCE_MAIN_COLOR_*
function Location:GetTileMainLight2Color()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(518, 1)

   return NWE.StackPopInteger()
end

--- Determines the color of the first source light of a tile.
-- @return AREA_TILE_SOURCE_LIGHT_COLOR_*
function Location:GetTileSourceLight1Color()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(519, 1)
   return NWE.StackPopInteger()
end

--- Determines the color of the second source light of a tile.
-- @return AREA_TILE_SOURCE_LIGHT_COLOR_*
function Location:GetTileSourceLight2Color()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(520, 1)
   return NWE.StackPopInteger()
end

--- Get area from location.
function Location:GetArea()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(224, 1)
   return NWE.StackPopObject()
end

--- Gets distance between two locations.
-- @param to The location to get the distance from.
function Location:GetDistanceBetween(to)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, to)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(298, 2)

   return NWE.StackPopFloat()
end

--- Gets orientation of a location
function Location:GetFacing()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(225, 1)

   return NWE.StackPopFloat()
end

--- Gets position vector of a location
function Location:GetPosition()
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, self)
   NWE.ExecuteCommand(223, 1)

   return NWE.StackPopVector()
end

--- Convert string to location.
-- @string str String
function M.FromString(str)
   local area, x, y, z, orient = string.match(str, "([%w_]+) %(([%d%.]+), ([%d%.]+), ([%d%.]+)%) ([%d%.]+)")
   area = Obj.GetByTag(area)
   local pos = vector_t(x, y, z)

   return M.Create(pos, orient, area)
end

return M
