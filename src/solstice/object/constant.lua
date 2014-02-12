---
-- @module object

local M = {}

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

return M
