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

local bit = require 'bit'
local DAMAGES = {}
local color = require 'nwn.color'
require 'nwn.dice'

DAMAGES.roll = {}
DAMAGES.index = {}
DAMAGES.format = {}

--- Register Damage Types.
-- This function MUST only be called from OnModuleLoad!
-- @param damage_type nwn.DAMAGE_TYPE_*
function nwn.RegisterDamage(damage_type, index, name, dmg_color, melee_vfx)
   table.insert(DAMAGES, damage_type)
   DAMAGES[damage_type] = { name = name,
                            color = dmg_color,
                            melee_vfx = melee_vfx
   }
   DAMAGES.index[damage_type] = index
   DAMAGES.format[index] = dmg_color .. "%d " .. name  .. color.END
end

function nwn.RegisterDamageRoll(id, dice, side, bonus)
   if dice == 0 and bonus == 0 then
      error "The number of dice or a bonus amount must be specified"
      return
   end

--   print(id)

   DAMAGES.roll[id] = dice_roll_t(dice, side, bonus)
end

function nwn.GetDamageFormatByIndex(idx)
   return DAMAGES.format[idx]
end

function nwn.GetDamageIndexFromFlag(flag)
   local idx = DAMAGES.index[flag]
   if not idx then
      error(string.format("INVALID DAMAGE FLAG : %d \n\n %s", flag, debug.traceback()))
      return -1
   end
   return idx
end

function nwn.GetDamageRollFromConstant(id)
   return DAMAGES.roll[id] or dice_roll_t(0,0,0)
end

function nwn.GetDamageVFX(flag, is_ranged)
   if is_ranaged then
      return
   end

   return DAMAGES[flag].melee_vfx
end

-- nwn.RegisterDamage registers a particular damage type, its index, name, color, and color.
-- all combat damage formating will take care of itself.
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BLUDGEONING, 0, "Bludgeoning", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_PIERCING, 1, "Piercing", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SLASHING, 2, "Slashing", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_MAGICAL, 3, "Magical", color.PURPLE, 76)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ACID, 4, "Acid", color.GREEN, 283)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_COLD, 5, "Cold", color.LIGHT_BLUE, 281)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_DIVINE, 6, "Divine", color.YELLOW, 289)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ELECTRICAL, 7, "Electrical", color.DARK_BLUE, 282)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_FIRE, 8, "Fire", color.RED, 280)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_NEGATIVE, 9, "Negative", color.GRAY, 282)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_POSITIVE, 10, "Positive", color.WHITE, 289)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SONIC, 11, "Sonic", color.LIGHT_ORANGE, 284)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BASE_WEAPON, 12, "Physical", color.ORANGE)

return DAMAGES

