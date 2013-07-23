---
-- @module alignment

local M = {}

M.const = {
   ALL                    = 0,
   NEUTRAL                = 1,
   LAWFUL                 = 2,
   CHAOTIC                = 3,
   GOOD                   = 4,
   EVIL                   = 5,
}

setmetatable(M, { __index = M.CONST })

return M