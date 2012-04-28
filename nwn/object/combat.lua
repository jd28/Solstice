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

function NSOnApplyDamage(obj, a)
   obj = _NL_GET_CACHED_OBJECT(obj)
   local eff = C.Local_GetLastDamageEffect()

   -- If object is already dead, no need to damage it.
   if obj:GetIsDead() then return 1 end
   
   -- Only Creatures, Doors, and Placeables can be damaged.
   if obj.type ~= nwn.GAME_OBJECT_TYPE_CREATURE
      and obj.type ~= nwn.GAME_OBJECT_TYPE_DOOR
      and obj.type ~= nwn.GAME_OBJECT_TYPE_PLACEABLE
   then
      return 1
   end

   local is_combat = eff.eff_integers[0]   
   local is_melee  = eff.eff_integers[1]
   local is_ranged = eff.eff_integers[2]
   local dmg_power = eff.eff_integers[3]
   local delay     = eff.eff_integers[4]

   local attacker = _NL_GET_CACHED_OBJECT(eff.eff_creator)
   
   local dmg = damage_result_t()
   
   for i = 0, 12 do
      dmg.damages[i] = eff.eff_integers[5 + i]
   end

   if is_combat ~= 1 then
      NSFormatDamageRoll(attacker, obj, dmg)
      NSFormatDamageRollImmunities(attacker, obj, dmg)

      NSDoDamageAdjustments(attacker, obj, dmg, dmg_power)
   end

   local total = NSGetTotalDamage(dmg)

   obj:DoDamage(total)
   -- OnDamagedEvent

   -- To do these VFX really aren't worthwhile.
   if obj.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      local c = nwn.Get2DAString("appearance", "BLOODCOLR", obj:GetAppearanceType())
      local vfx
      if c == "W" or obj.obj.cre_state == 15 then
         vfx = 239
      elseif c == "R" then
         vfx = 239
      elseif c == "G" then
         vfx = 116
      elseif c == "Y" then
            vfx = 117
      end
      print(c, vfx)
      if vfx then
         obj:ApplyVisual(vfx)
      end
   end

   -- If after applying the damage the target isn't 'dead'
   -- there's nothing left to do.  If however they are dead
   -- a death effect must be applied.
   if not obj:GetIsDead() then
      return 1
   end

   local death = nwn.EffectDeath(true, true)
   death:SetCreator(attacker)
   
   obj:ApplyEffect(death)
end

---
function Object:DoDamage(amount)
   return C.nwn_DoDamage(self.obj, self.type, amount)
end

---
function Object:GetHardness()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(796, 1)
   return nwn.engine.StackPopInteger()
end

--- Determine who last attacked a creature, door or placeable object.
function Object:GetLastAttacker()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_attacker
   
   return _NL_GET_CACHED_OBJECT(actor)
end

--- Get the object which last damaged a creature or placeable object.
function Object:GetLastDamager()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_damager
   
   return _NL_GET_CACHED_OBJECT(actor)
end

--- Gets the last living, non plot creature that performed a
-- hostile act against the object.
function Object:GetLastHostileActor()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor
   
   return _NL_GET_CACHED_OBJECT(actor)
end

---
function Object:SetHardness(hardness)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(hardness)
   nwn.engine.ExecuteCommand(797, 2)
end

--- Sets the last hostile actor
-- Source: nwnx_funcs by Acaos
function Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end
   
   self.obj.obj.obj_last_hostile_actor = actor.id
end