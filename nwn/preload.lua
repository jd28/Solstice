--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

nwn = {}

require "nwn.constants"
require 'lua.lua_preload'

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
safe_require 'nwn.attack'
require "nwn.combat"
require "nwn.damage"
safe_require 'nwn.damage_roll'
require "nwn.weapons"
require "nwn.creature"
require "nwn.effects"
require "nwn.encounter"
require "nwn.feats"
require "nwn.item"
require "nwn.engine"
require "nwn.itemprop"
require "nwn.module"
require "nwn.placeable"
require "nwn.skills"
require "nwn.store"
require "nwn.talent"
require "nwn.toplevel"
require "nwn.trap"
require "nwn.trigger"
require "nwn.door"
require "nwn.waypoint"
require "nwn.chat"
require "nwn.event"


