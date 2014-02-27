--- Colors
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module color

-- NOTE: Colors MUST be encoded with rgb values, string constants
-- copied from NWScript will NOT work in most cases.

local M = {}

--- Encode a color for RGB values
-- @param r Red
-- @param g Green
-- @param b Blue
function M.Encode(r, g, b)
   return "<c".. string.char(r)..string.char(g)..string.char(b)..">"
end



-- The follow are all from the PRC
-- colours for log messages
-- Colors in String messages to PCs
M.BLUE         = M.Encode(102, 204, 254)    -- used by saving throws.
M.DARK_BLUE    = M.Encode(32, 102, 254)     -- used for electric damage.
M.GRAY         = M.Encode(153, 153, 153)    -- used for negative damage.
M.GREEN        = M.Encode(32, 254, 32)      -- used for acid damage.
M.LIGHT_BLUE   = M.Encode(153, 254, 254)    -- used for the player's name, and cold damage.
M.LIGHT_GRAY   = M.Encode(176, 176, 176)    -- used for system messages.
M.LIGHT_ORANGE = M.Encode(254, 153, 32)     -- used for sonic damage.
M.LIGHT_PURPLE = M.Encode(204, 153, 204)    -- used for a target's name.
M.ORANGE       = M.Encode(254, 102, 32)     -- used for attack rolls and physical damage.
M.PURPLE       = M.Encode(204, 119, 254)    -- used for spell casts, as well as magic damage.
M.RED          = M.Encode(254, 32, 32)      -- used for fire damage.
M.WHITE        = M.Encode(254, 254, 254)    -- used for positive damage.
M.YELLOW       = M.Encode(254, 254, 32)     -- used for healing, and sent messages.
M.END          = "</c>"

return M