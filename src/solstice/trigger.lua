--- Trigger
-- Defines the Trigger class.
-- @module trigger

local ffi = require 'ffi'
local Obj = require 'solstice.object'

local M = {}

M.Trigger = inheritsFrom({}, Obj.Object)

-- Internal ctype.
M.trigger_t = ffi.metatype("Trigger", { __index = M.Trigger })

return M
