local M = {}

M.const = {
   LEVEL_INVALID = -1,
   LEVEL_DEFAULT = -1,
   LEVEL_VERY_LOW = 0,
   LEVEL_LOW = 1,
   LEVEL_NORMAL = 2,
   LEVEL_HIGH = 3,
   LEVEL_VERY_HIGH = 4,
}

setmetatable(M, { __index = M.const })

return M