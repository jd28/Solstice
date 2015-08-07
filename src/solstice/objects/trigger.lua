--- Trigger
-- Defines the Trigger class.
-- @module trigger

local ffi = require 'ffi'
local M = require 'solstice.objects.init'

M.Trigger = inheritsFrom({}, M.Object)

-- Internal ctype.
M.trigger_t = ffi.metatype("Trigger", { __index = M.Trigger })

