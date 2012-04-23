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

nwn = {}

require "nwn.constants"


--- Main NWN Table...
nwn.engine = {}

-- NWN Objects 'method tables'
Object    = inheritsFrom( nil )
Creature  = inheritsFrom( Object )
Module    = inheritsFrom( Object )
Area      = inheritsFrom( Object )
Item      = inheritsFrom( Object )
Lock      = inheritsFrom( nil )
Trigger   = inheritsFrom( Object )
Placeable = inheritsFrom( Object )
Door      = inheritsFrom( Object )
AoE       = inheritsFrom( Object )
Encounter = inheritsFrom( Object )
Waypoint  = inheritsFrom( Object )
Store     = inheritsFrom( Object )
Trap      = inheritsFrom( nil )

-- Engine Structures.
Effect   = {}
Itemprop = inheritsFrom(Effect)
Location = {}
Talent   = {}
Vector   = {}

require "nwn.internal.internal"
require "nwn.ctypes.foundation"
require "nwn.vector"
require "nwn.dice"
require "nwn.logger"
require "nwn.location"
require "nwn.object"
require "nwn.aoe"
require "nwn.area"
require "nwn.combat"
require "nwn.damage"
require "nwn.weapons"
require "nwn.creature"
require "nwn.effects"
require "nwn.encounter"
require "nwn.item"
require "nwn.engine"
require "nwn.itemprop"
require "nwn.module"
require "nwn.placeable"
require "nwn.rules"
require "nwn.store"
require "nwn.talent"
require "nwn.toplevel"
require "nwn.trap"
require "nwn.trigger"
require "nwn.door"
require "nwn.waypoint"
require "nwn.chat"
require "nwn.event"


