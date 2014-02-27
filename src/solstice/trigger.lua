--- Triggers
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module trigger

local ffi = require 'ffi'
local Obj = require 'solstice.object'

local M = {}

M.Trigger = inheritsFrom({}, Obj.Object)

--- Internal ctype.
M.trigger_t = ffi.metatype("Trigger", { __index = M.Trigger })

return M
