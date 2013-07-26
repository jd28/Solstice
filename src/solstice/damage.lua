local M = {}
M.const = require 'solstice.damage.constant'
setmetatable(M, { __index = M.const })
return M
