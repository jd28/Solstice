--- Object
-- @module object

local M = require 'solstice.objects.init'

local Log = System.GetLogger()
local Eff = require 'solstice.effect'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Effects
-- @section effects

--- Applies an effect to an object.
-- @param dur_type DURATION_TYPE_*
-- @param effect Effect to apply.
-- @param[opt=0.0] duration Time in seconds for effect to last.
function Object:ApplyEffect(dur_type, effect, duration)
   duration = duration or 0.0

   NWE.StackPushFloat(duration)
   NWE.StackPushObject(self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, effect)
   NWE.StackPushInteger(dur_type)
   NWE.ExecuteCommand(220, 4)
end

--- Applies visual effect to object.
-- @param vfx solstice.vfx constant
-- @param duration Duration in seconds.  If not passed effect will be of
-- duration type DURATION_TYPE_INSTANT
function Object:ApplyVisual(vfx, duration)
   local dur_type = duration and DURATION_TYPE_TEMPORARY or DURATION_TYPE_INSTANT
   duration = duration or 0.0

   self:ApplyEffect(dur_type, Eff.VisualEffect(vfx), duration)
end

--- An iterator that iterates over applied effects.
-- Note: if direct is true, the actual effect will be returned.  Modyfying
-- it will modify the applied effect.  If direct is false, a copy of the
-- effect will be returned.
function Object:Effects(direct)
   if not direct then
      local eff, _eff = self:GetFirstEffect()
      return function()
         while eff:GetIsValid() do
            _eff, eff = eff, self:GetNextEffect()
            return _eff
         end
      end
   else
      local obj = self.obj.obj
      local i, _i = 0
      return function()
         while i < obj.obj_effects_len do
            _i, i = i, i + 1
            if obj.obj_effects[_i] == nil then return end

            return Eff.effect_t(obj.obj_effects[_i], true)
         end
      end
   end
end

--- Get an effect.
-- Note: This returns effects directly.  Modifying them will
-- modify the applied effect.
-- @param idx Index is zero based.
-- @return Effect or nil.
function Object:GetEffectAtIndex(idx)
   local obj = self.obj.obj
   if idx < 0 or idx >= obj.obj_effects_len then
      return
   end
   return Eff.effect_t(obj.obj_effects[idx], true)
end

--- Get the number effects applied to an object;
function Object:GetEffectCount()
   return self.obj.obj.obj_effects_len
end

--- Get if an object has an effecy by ID
-- @param id Effect ID.
function Object:GetHasEffectById(id)
   for eff in self:Effects(true) do
      if eff:GetId() == id then
         return true
      end
   end

   return false
end

--- Get if object has an effect applied by a spell.
-- @param spell solstice.spell constant that the effect was created by.
function Object:GetHasSpellEffect(spell)
   if not self:GetIsValid() then return false end
   for eff in self:Effects(true) do
      if eff:GetSpellId() == spell then
         return true
      end
   end

   return false
end

--- Gets first effect.
-- Use the iterator.
function Object:GetFirstEffect()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(85, 1)

   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EFFECT)
end

--- Gets first effect.
-- Use the iterator.
function Object:GetNextEffect()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(86, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EFFECT)
end

--- Logs debug strings for all effects applied to object.
function Object:LogEffects()
   if not self:GetIsValid() then return end

   local t = {}

   table.insert(t, string.format("Effects - %s", self:GetName()))

   for eff in self:Effects(true) do
      table.insert(t, eff:ToString())
   end

   Log:info(table.concat(t, '\n\n'))
end

--- Removes an effect from object
-- @param effect Effec to remove.
function Object:RemoveEffect(effect)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, effect)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(87, 2)
end

--- Removes an effect from object by ID
-- @param id Effect id to remove.
function Object:RemoveEffectByID(id)
   if not self:GetIsValid() then return end
   C.nwn_RemoveEffectById(self.obj.obj, id)
end

--- Remove effect by type
-- @param type EFFECT_TYPE_*
function Object:RemoveEffectsByType(type)
   local t = {}
   for eff in self:Effects(true) do
      if type == eff:GetType() then
         t[eff:GetId()] = true
      end
   end
   for k, _ in pairs(t) do
      self:RemoveEffectByID(k)
   end
end

jit.off(Object.RemoveEffectByID)
