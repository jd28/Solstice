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

local ffi = require 'ffi'
local C = ffi.C

--[[
function Object:ApplyCustomDamage(type, amount, power)
   if not _CUSTOM_DAMAGE[type] then 
      error("Invalid Custom Damage Type")
   end
   for eff in self:EffectsDirect() do
      if eff:GetTrueType() == EFFECT_TRUETYPE_TEMPORARY_HITPOINTS then
         local thp = eff:GetInt(0)
         if thp > amount then
            eff:SetInt(0, thp - amount)
         else
            amount = amount - thp
            self:RemoveEffectById(eff.eff.eff_id)
         end
      end
   end
end
--]]

--- Applies damage to an object.
-- @param type Damage type. (Default: nwn.DAMAGE_TYPE_MAGICAL)
-- @param amount Amount of damage.
-- @param power Damage power. (Default: nwn.DAMAGE_POWER_NORMAL)
function Object:ApplyDamage(type, amount, power)
   type = type or nwn.DAMAGE_TYPE_MAGICAL
   power = power or nwn.DAMAGE_POWER_NORMAL

   if type > nwn.DAMAGE_TYPE_BASE_WEAPON then
      self:ApplyEffect(nwn.EffectDamage(type, amount, power))
   else
      self:ApplyCustomDamage(type, amount, power)
   end
end

--- Applies an effect to an object.
-- @param effect Effect to apply.
-- @param duration Time in seconds for effect to last. (Default: 0.0)
--    If duration is not passed effect will have nwn.DURATION_TYPE_INSTANT,
--    otherwise nwn.DURATION_TYPE_TEMPORARY
function Object:ApplyEffect(effect, duration)
   dur_type = duration and nwn.DURATION_TYPE_TEMPORARY or nwn.DURATION_TYPE_INSTANT
   duration = duration or 0.0

   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, effect)
   nwn.engine.StackPushInteger(dur_type)
   nwn.engine.ExecuteCommand(220, 4)
end

--- Applies visual effect to object.
-- @param vfx nwn.VFX_*
-- @param duration Duration in seconds.  If not passed effect will be of 
--    duration type nwn.DURATION_TYPE_INSTANT
function Object:ApplyVisual(vfx, duration)
   self:ApplyEffect(nwn.EffectVisualEffect(vfx), duration)
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

   if dur_type == nwn.DURATION_TYPE_TEMPORARY then
      self:ApplyEffect(eff_recur, duration)
   elseif dur_type == nwn.DURATION_TYPE_PERMANENT then
      self:ApplyPermenantEffect(eff_recur, duration)
   else
      error "Recurring effects must have a duration type temporary or permanent"
      return
   end
   self:ApplyEffect(effect)
   self:RepeatCommand(interval,
                      function()
                         if not self:GetHasEffectById(id) then
                            return false
                         end
                         self:ApplyEffect(effect)
                         --_NL_CUSTOM_EFFECT(eff_type, self, true)
                         return true
                      end)
                         
end

--- Applies a permenant effect.
-- As defined by nwn.DURATION_TYPE_PERMANENT
-- @param effect Effect too apply.
function Object:ApplyPermenantEffect(effect)
   nwn.engine.StackPushFloat(0.0)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, effect)
   nwn.engine.StackPushInteger(nwn.DURATION_TYPE_PERMANENT)
   nwn.engine.ExecuteCommand(220, 4)
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

--- Get if an object has an effecy by ID
-- @param id Effect ID.
function Object:GetHasEffectById(id)
   for eff in self:Effects() do
      if eff:GetId() == id then
         return true
      end
   end

   return false
end

--- Get if object has an effect applied by a spell.
-- @param spell SPELL_* that the effect was created by.
function Object:GetHasSpellEffect(nSpell)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nSpell)
   nwn.engine.ExecuteCommand(304, 2)
   return nwn.engine.StackPopBoolean()
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

--- Removes an effect from object
function Object:RemoveEffect(effect)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, effect)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(87, 2)
end

--- Removes an effect from object by ID
function Object:RemoveEffectByID(id)
   C.nwn_RemoveEffectById(self.obj.obj, id)
end
