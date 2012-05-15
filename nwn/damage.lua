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
DAMAGES.ip_type = {}

--- Register Damage Types.
-- This function MUST only be called from OnModuleLoad!
-- @param damage_type nwn.DAMAGE_TYPE_*
function nwn.RegisterDamage(damage_type, index, name, dmg_color, melee_vfx, ranged_vfx, ip_type)
   table.insert(DAMAGES, damage_type)
   DAMAGES[damage_type] = { name = name,
                            color = dmg_color,
                            melee_vfx = melee_vfx,
			    ranged_vfx = ranged_vfx,
			    ip_type = ip_type
   }
   DAMAGES.ip_type[ip_type] = damage_type
   DAMAGES.index[damage_type] = index
   DAMAGES.format[index] = dmg_color .. "%d " .. name  .. color.END
end

--- Register a dice roll to a nwn.DAMAGE_BONUS_* constant.
-- @param id nwn.DAMAGE_BONUS_*
-- @param dice Number of dice
-- @param side Number of sides
-- @param bonus Bonus added to roll
function nwn.RegisterDamageRoll(id, dice, side, bonus)
   if dice == 0 and bonus == 0 then
      error "The number of dice or a bonus amount must be specified"
      return
   end

--   print(id)

   DAMAGES.roll[id] = dice_roll_t(dice, side, bonus)
end

--- Get damage flag from IP Constant
function nwn.GetDamageFlagFromIPConst(ip_type)
   return DAMAGES.ip_type[ip_type] or -1
end

--- Get damage format by index
-- @param idx Value gotten by calling nwn.GetDamageIndexFromFlag on a nwn.DAMAGE_TYPE_*
function nwn.GetDamageFormatByIndex(idx)
   return DAMAGES.format[idx]
end

--- Get damage index from flag.
-- @param flag nwn.DAMAGE_TYPE_*
function nwn.GetDamageIndexFromFlag(flag)
   local idx = DAMAGES.index[flag]
   if not idx then
      error(string.format("INVALID DAMAGE FLAG : %d \n\n %s", flag, debug.traceback()))
      return -1
   end
   return idx
end

--- Get damage roll from constant
-- @param id nwn.DAMAGE_BONUS_*
function nwn.GetDamageRollFromConstant(id)
   return DAMAGES.roll[id] or dice_roll_t(0,0,0)
end

--- Get damage vfx
-- @param flag nwn.DAMAGE_TYPE_*
-- @param is_ranged If true damage was done by ranged attack (Default: false)
function nwn.GetDamageVFX(flag, is_ranged)
   if is_ranaged then
      return
   end

   return DAMAGES[flag].melee_vfx
end

-- nwn.RegisterDamage registers a particular damage type, its index, name, color, and color.
-- all combat damage formating will take care of itself.
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BLUDGEONING, 0, "Bludgeoning", color.ORANGE, nil, nil, nwn.IP_CONST_DAMAGETYPE_BLUDGEONING)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_PIERCING, 1, "Piercing", color.ORANGE, nil, nil, nwn.IP_CONST_DAMAGETYPE_PIERCING)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SLASHING, 2, "Slashing", color.ORANGE, nil, nil, nwn.IP_CONST_DAMAGETYPE_SLASHING)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_MAGICAL, 3, "Magical", color.PURPLE, 76, nil, nwn.IP_CONST_DAMAGETYPE_MAGICAL)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ACID, 4, "Acid", color.GREEN, 283, nil, nwn.IP_CONST_DAMAGETYPE_ACID)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_COLD, 5, "Cold", color.LIGHT_BLUE, 281, nil, nwn.IP_CONST_DAMAGETYPE_COLD)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_DIVINE, 6, "Divine", color.YELLOW, 289, nil, nwn.IP_CONST_DAMAGETYPE_DIVINE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ELECTRICAL, 7, "Electrical", color.DARK_BLUE, 282, nil, nwn.IP_CONST_DAMAGETYPE_ELECTRICAL)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_FIRE, 8, "Fire", color.RED, 280, nil, nwn.IP_CONST_DAMAGETYPE_FIRE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_NEGATIVE, 9, "Negative", color.GRAY, 282, nil, nwn.IP_CONST_DAMAGETYPE_NEGATIVE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_POSITIVE, 10, "Positive", color.WHITE, 289, nil, nwn.IP_CONST_DAMAGETYPE_POSITIVE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SONIC, 11, "Sonic", color.LIGHT_ORANGE, 284, nil, nwn.IP_CONST_DAMAGETYPE_SONIC)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BASE_WEAPON, 12, "Physical", color.ORANGE, nil, nil, nwn.IP_CONST_DAMAGETYPE_PHYSICAL)

return DAMAGES

