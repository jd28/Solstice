require 'nwn.ctypes.location'

local ffi = require 'ffi'

--- Engine Structures
local location_mt = { __index = Location
                      --__tostring = function ()
                      --   if not self:GetArea() then return end
                      --   if ((self:x() < 0) or (self:y() < 0)) then return end
                      --   return string.format("%s %.4f %.4f %.4f %.4f", GetTag(self:area()), self:x(), self:y(), self:z(), self:facing())
                      --end
}

location_t = ffi.metatype("CScriptLocation", location_mt)

--- Applies an effect to a location
-- @param eff Effect to apply.
-- @param duration Duration of an effect. (Default: 0.0)
function Location:ApplyEffect(eff, duration)
   duration = duration or 0.0
   
   if(duration > 0.0) then
      durtype = nwn.DURATION_TYPE_TEMPORARY
   else
      durtype = nwn.DURATION_TYPE_INSTANT
   end
   
   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, eff.eff)
   nwn.engine.StackPushInteger(durtype)
   nwn.engine.ExecuteCommand(216, 4)
end

--- Applies a permenant effect to a location
-- @param eff Effect to apply.
function Location:ApplyPermenantEffect(eff)
   nwn.engine.StackPushFloat(0.0)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, eff.eff)
   nwn.engine.StackPushInteger(nwn.DURATION_TYPE_PERMENANT)
   nwn.engine.ExecuteCommand(216, 4)
end

--- Applies a visual effect to a location
-- @param vfx nwn.VFX_*
function Location:ApplyVisual(vfx)
   local eff = nwn.EffectVisualEffect(vfx)
   self:ApplyEffect(eff)
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

---
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

---
function Location:Trap(nType, fSize, sTag, nFaction, sOnDisarm, sOnTriggered)
   nwn.engine.StackPushString(sOnTriggered or "")
   nwn.engine.StackPushString(sOnDisarm or "")
   nwn.engine.StackPushInteger(nFaction or STANDARD_FACTION_HOSTILE)
   nwn.engine.StackPushString(sTag or "")
   nwn.engine.StackPushFloat(fSize or 2.0)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.StackPushInteger(nTrapType)
   nwn.engine.ExecuteCommand(809, 7)

   return nwn.engine.StackPopObject()
end

---
function Location:SetTileMainLightColor(nMainLight1Color, nMainLight2Color)
   nwn.engine.StackPushInteger(nMainLight2Color)
   nwn.engine.StackPushInteger(nMainLight1Color)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(514, 3)
end

---
function Location:SetTileSourceLightColor(nSourceLight1Color, nSourceLight2Color)
   nwn.engine.StackPushInteger(nSourceLight2Color)
   nwn.engine.StackPushInteger(nSourceLight1Color)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(515, 3)
end

---
function Location:GetTileMainLight1Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(517, 1)

   return nwn.engine.StackPopInteger();
end

---
function Location:GetTileMainLight2Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(518, 1)

   return nwn.engine.StackPopInteger()
end

---
function Location:GetTileSourceLight1Color()
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, self)
   nwn.engine.ExecuteCommand(519, 1)
   return nwn.engine.StackPopInteger()
end

---
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


