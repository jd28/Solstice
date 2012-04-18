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
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

-- @param weap Attack weapon, if nil then the call is coming from the plugin.
function NSGetCriticalHitMultiplier(attacker, offhand, weap, weap_num)
   local result
   if weap then
      result = attacker.ci.equips[weap_num].crit_mult
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      local cr = attacker.obj.cre_combat_round
      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritMultiplier(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritMultBonus()

   return result
end

-- @param weap Attack weapon, if nil then the call is coming from the plugin.
function NSGetCriticalHitRoll(attacker, offhand, weap, weap_num)
   local result
   if weap then
      result = attacker.ci.equips[weap_num].crit_range
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      local cr = attacker.obj.cre_combat_round
      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritRange(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritRangeBonus()

   return 21 - result
end