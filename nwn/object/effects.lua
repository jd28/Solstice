local ffi = require 'ffi'
local C = ffi.C

--- Applies an effect to an object.
-- @param dur_type nwn.DURATION_TYPE_*
-- @param effect Effect to apply.
-- @param duration Time in seconds for effect to last. (Default: 0.0)
function Object:ApplyEffect(dur_type, effect, duration)
   duration = duration or 0.0

   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, effect)
   nwn.engine.StackPushInteger(dur_type)
   nwn.engine.ExecuteCommand(220, 4)
end
--[[
--- Applies an effect to an object.
-- @param dur_type nwn.DURATION_TYPE_*
-- @param effect Effect to apply.
-- @param duration Time in seconds for effect to last. (Default: 0.0)
function Object:ApplyEffect(dur_type, effect, duration)
   if not self:GetIsValid() then return end

   duration = duration or 0.0

   effect:SetDurationType(dur_type)
   effect:SetDuration(duration)
   
   -- TODO: check object type
   C.nwn_ApplyEffect(self.obj.obj, effect.eff, 0, 1)
end
   --]]
--- Applies visual effect to object.
-- @param vfx nwn.VFX_*
-- @param duration Duration in seconds.  If not passed effect will be of 
--    duration type nwn.DURATION_TYPE_INSTANT
function Object:ApplyVisual(vfx, duration)
   local dur_type = duration and nwn.DURATION_TYPE_TEMPORARY or nwn.DURATION_TYPE_INSTANT
   duration = duration or 0.0

   self:ApplyEffect(dur_type, nwn.EffectVisualEffect(vfx), duration)
end

--- Recurringly applies a custom effect
-- @param effect An effect.
-- @parap duration Time in seconds that the effect will continue recurring.
-- @param dur_type nwn.DURATION_TYPE_TEMPORARY or nwn.DURATION_TYPE_PERMANENT
-- @param interval Time in seconds between effect application. Default 6s
-- @param eff_recur Default: nwn.EffectRecurring()  The only reason to pass a
--    different recurring effect here is if you need one that is Supernatural or
--    Magical.
function Object:ApplyRecurringEffect(effect, duration, dur_type, interval, eff_recur)
   dur_type = duration and nwn.DURATION_TYPE_TEMPORARY or nwn.DURATION_TYPE_PERMANENT
   duration = duration or 0
   interval = interval or 6
   eff_recur = eff_recur or nwn.EffectRecurring()
   
   if eff_recur:GetCustomType() ~= nwn.EFFECT_CUSTOM_RECURRING_EFFECT then
      error "eff_recur MUST be of custom effect type nwn.EFFECT_CUSTOM_RECURRING_EFFECT"
      return
   end

   local id = eff_recur:GetId()

   print(id, eff_type, duration, dur_type, interval)

   if dur_type == nwn.DURATION_TYPE_INSTANT then
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
                         self:ApplyEffect(nwn.DURATION_TYPE_INSTANT, effect)
                         return true
                      end)
                         
end

--- An iterator that iterates directly over applied effects
function Object:Effects()
   eff, _eff = self:GetFirstEffect()
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
   i, _i = 0
   return function()
      while i < obj.obj_effects_len do
         _i, i = i, i + 1
         if obj.obj_effects[_i] == nil then return end

         return effect_t(obj.obj_effects[_i], true)
      end
   end
end

function Object:GetEffectAtIndex(idx)
   local obj = self.obj.obj
   if idx < 0 or idx >= obj.obj_effects_len then
      return
   end
   return effect_t(obj.obj_effects[idx], true)
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
-- @param spell nwn.SPELL_* that the effect was created by.
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
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(85, 1)

   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT)
end

--- Gets first effect.
-- Use the iterator.
function Object:GetNextEffect()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(86, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT)
end

--- Logs debug strings for all effects applied to object.
function Object:LogEffects()
   if not self:GetIsValid() then return end

   local t = {}
   
   table.insert(t, string.format("Effects - %s", self:GetName()))

   for eff in self:EffectsDirect() do
      table.insert(t, eff:ToString())
   end

   nwn.WriteTimestampedLogEntry(table.concat(t, '\n\n'))
end

--- Removes an effect from object
-- @param effect Effec to remove.
function Object:RemoveEffect(effect)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, effect)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(87, 2)
end

--- Removes an effect from object by ID
-- @param id Effect id to remove.
function Object:RemoveEffectByID(id)
   if not self:GetIsValid() then return end
   C.nwn_RemoveEffectById(self.obj.obj, id)
end
