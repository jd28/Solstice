--- Saving Throw
-- @module save

local M = require 'solstice.save.init'
M.const = require 'solstice.save.constant'
setmetatable(M, { __index = M.const })

