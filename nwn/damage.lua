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

local DAMAGES = {
   nwn.DAMAGE_TYPE_BLUDGEONING,
   nwn.DAMAGE_TYPE_PIERCING,
   nwn.DAMAGE_TYPE_SLASHING,
   nwn.DAMAGE_TYPE_MAGICAL,
   nwn.DAMAGE_TYPE_ACID,
   nwn.DAMAGE_TYPE_COLD,
   nwn.DAMAGE_TYPE_DIVINE,
   nwn.DAMAGE_TYPE_ELECTRICAL,
   nwn.DAMAGE_TYPE_FIRE,
   nwn.DAMAGE_TYPE_NEGATIVE,
   nwn.DAMAGE_TYPE_POSITIVE,
   nwn.DAMAGE_TYPE_SONIC,
   -- The base weapon damage is the base damage delivered by the weapon before
   -- any additional types of damage (e.g. fire) have been added.
   nwn.DAMAGE_TYPE_BASE_WEAPON
}

--- Register Damage Types.
-- This function MUST only be called from OnModuleLoad!
-- @param damage_type nwn.DAMAGE_TYPE_*
function nwn.RegisterDamage(damage_type)
   table.insert(DAMAGES, damage_type)
end

function nwn.GetDamageCount()
   return #DAMAGES
end