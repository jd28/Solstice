---
-- @module object

local M = require 'solstice.object.init'

M.NONE              = 0
M.CREATURE          = 1
M.ITEM              = 2
M.TRIGGER           = 4
M.DOOR              = 8
M.AREA_OF_EFFECT    = 16
M.WAYPOINT          = 32
M.PLACEABLE         = 64
M.STORE             = 128
M.ENCOUNTER         = 256
M.ALL               = 32767

M.ACTION_MOVETOPOINT        = 0
M.ACTION_PICKUPITEM         = 1
M.ACTION_DROPITEM           = 2
M.ACTION_ATTACKOBJECT       = 3
M.ACTION_CASTSPELL          = 4
M.ACTION_OPENDOOR           = 5
M.ACTION_CLOSEDOOR          = 6
M.ACTION_DIALOGOBJECT       = 7
M.ACTION_DISABLETRAP        = 8
M.ACTION_RECOVERTRAP        = 9
M.ACTION_FLAGTRAP           = 10
M.ACTION_EXAMINETRAP        = 11
M.ACTION_SETTRAP            = 12
M.ACTION_OPENLOCK           = 13
M.ACTION_LOCK               = 14
M.ACTION_USEOBJECT          = 15
M.ACTION_ANIMALEMPATHY      = 16
M.ACTION_REST               = 17
M.ACTION_TAUNT              = 18
M.ACTION_ITEMCASTSPELL      = 19
M.ACTION_COUNTERSPELL       = 31
M.ACTION_HEAL               = 33
M.ACTION_PICKPOCKET         = 34
M.ACTION_FOLLOW             = 35
M.ACTION_WAIT               = 36
M.ACTION_SIT                = 37
M.ACTION_SMITEGOOD          = 40
M.ACTION_KIDAMAGE           = 41
M.ACTION_RANDOMWALK         = 43
M.ACTION_INVALID            = 65535

-- The following are internal object types.
M.internal = {}
M.internal.GUI              = 1
M.internal.TILE             = 2
M.internal.MODULE           = 3
M.internal.AREA             = 4
M.internal.CREATURE         = 5
M.internal.ITEM             = 6
M.internal.TRIGGER          = 7
M.internal.PROJECTILE       = 8
M.internal.PLACEABLE        = 9
M.internal.DOOR             = 10
M.internal.AREA_OF_EFFECT   = 11
M.internal.WAYPOINT         = 12
M.internal.ENCOUNTER        = 13
M.internal.STORE            = 14
M.internal.PORTAL           = 15
M.internal.SOUND            = 16
