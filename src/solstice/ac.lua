--- Armor Class
-- @module ac

local M = {}

M.const = {
   DODGE      = 0,
   NATURAL    = 1,
   ARMOR      = 2, -- Alias US spelling.
   ARMOUR     = 2,
   SHIELD     = 3,
   DEFLECTION = 4,
}

setmetatable(M, { __index = M.const })

return M