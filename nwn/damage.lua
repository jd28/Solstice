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

return DAMAGES

