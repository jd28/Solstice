--- Trigger
-- Defines the Trigger class.
-- @module trigger

local ffi = require 'ffi'
local M = require 'solstice.objects.init'

M.Trigger = inheritsFrom({}, M.Object)

function M.Trigger.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_TRIGGER
      },
      { __index = M.Trigger })
end
