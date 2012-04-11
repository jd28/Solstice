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

local DAMAGES = {}

--- Register Damage Types.
-- This function MUST only be called from OnModuleLoad!
-- @param damage_type nwn.DAMAGE_TYPE_*
function nwn.RegisterDamage(damage_type, name, color)
   table.insert(DAMAGES, damage_type)
   DAMAGES[damage_type] = { name = name,
                            color = color }
end

function nwn.GetDamageCount()
   return #DAMAGES
end

nwn.RegisterDamage(nwn.DAMAGE_TYPE_BLUDGEONING,
                   "Bludgeoning",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_PIERCING,
                   "Piercing",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SLASHING,
                   "Slashing",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_MAGICAL,
                   "Magical",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ACID,
                   "Acid",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_COLD,
                   "Cold",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_DIVINE,
                   "Divine",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ELECTRICAL,
                   "Electrical",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_FIRE,
                   "Fire",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_NEGATIVE,
                   "Negative",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_POSITIVE,
                   "Positive",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SONIC,
                   "Sonic",
                   "")
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BASE_WEAPON
                   "Physical",
                   "")

return DAMAMGES

