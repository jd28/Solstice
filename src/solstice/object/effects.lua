--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'

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

--- Recurringly applies a custom effect
-- @param effect An effect.
-- @param duration Time in seconds that the effect will continue recurring.
-- @param dur_type DURATION_TYPE_TEMPORARY or DURATION_TYPE_PERMANENT
-- @param interval Time in seconds between effect application. Default 6s
-- @param[opt=solstice.effect.Recurring()] eff_recur The only reason to pass a
-- different recurring effect here is if you need one that is Supernatural or
-- Magical.
function Object:ApplyRecurringEffect(effect, duration, dur_type, interval, eff_recur)
   error "TODO"
   dur_type = duration and DURATION_TYPE_TEMPORARY or DURATION_TYPE_PERMANENT
   duration = duration or 0
   interval = interval or 6
   eff_recur = eff_recur or ffi.Recurring()

   if eff_recur:GetType() ~= EFFECT_CUSTOM_RECURRING_EFFECT then
      error "eff_recur MUST be of custom effect type solstice.nwn.EFFECT_CUSTOM_RECURRING_EFFECT"
      return
   end

   local id = eff_recur:GetId()

   print(id, eff_type, duration, dur_type, interval)

   if dur_type == DURATION_TYPE_INSTANT then
      error "Recurring effects must have a duration type temporary or permanent"
      return
   else
      self:ApplyEffect(dur_type, eff_recur, duration)
   end

   self:RepeatCommand(interval,
                      function()
                         if not self:GetHasEffectById(id) then
                            return false
                         end
                         self:ApplyEffect(Eff.DURATION_TYPE_INSTANT, effect)
                         return true
                      end)

end

--- An iterator that iterates directly over applied effects
function Object:Effects()
   local eff, _eff = self:GetFirstEffect()
   return function()
      while eff:GetIsValid() do
         _eff, eff = eff, self:GetNextEffect()
         return _eff
      end
   end
end

--- An iterator that iterates directly over applied effects
function Object:EffectsDirect()
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

function Object:GetEffectAtIndex(idx)
   local obj = self.obj.obj
   if idx < 0 or idx >= obj.obj_effects_len then
      return
   end
   return Eff.effect_t(obj.obj_effects[idx], true)
end

function Object:GetEffectCount()
   return self.obj.obj.obj_effects_len - 1
end

--- Get if an object has an effecy by ID
-- @param id Effect ID.
function Object:GetHasEffectById(id)
   for eff in self:EffectsDirect() do
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
   for eff in self:EffectsDirect() do
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

   for eff in self:EffectsDirect() do
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
-- @param type EFFECT\_TYPE\_*
function Object:RemoveEffectsByType(type)
   local t = {}
   for eff in self:EffectsDirect() do
      if type == eff:GetType() then
         t[eff:GetId()] = true
      end
   end
   for k, _ in pairs(t) do
      self:RemoveEffectByID(k)
   end
end

jit.off(Object.RemoveEffectByID)
