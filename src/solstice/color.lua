---
-- Colors should probably be encoded with rgb values or hext strings, string constants
-- copied from NWScript will not work 99.9% of the time in most cases due to character
-- encoding issues.
-- @module color

local M = {}

--- Encode a color for RGB values
-- @param r Red
-- @param g Green
-- @param b Blue
function M.Encode(r, g, b)
   return "<c".. string.char(r)..string.char(g)..string.char(b)..">"
end

--- Encodes hex color strings.
-- @param hex Same for max as HTML.  "#000000"
function M.EncodeHex(hex)
    return M.Encode(hex:sub(2,3), 16), tonumber(hex:sub(4,5), 16), tonumber(hex:sub(6,7), 16)
end

--- Constants
-- @section constants

-- The follow are all from the PRC
-- colours for log messages
-- Colors in String messages to PCs

--- RGB(102, 204, 254)
M.BLUE         = M.Encode(102, 204, 254)    -- used by saving throws.

--- RGB(32, 102, 254)
M.DARK_BLUE    = M.Encode(32, 102, 254)     -- used for electric damage.

--- RGB(153, 153, 153)
M.GRAY         = M.Encode(153, 153, 153)    -- used for negative damage.

--- RGB(32, 254, 32)
M.GREEN        = M.Encode(32, 254, 32)      -- used for acid damage.

--- RGB(153, 254, 254)
M.LIGHT_BLUE   = M.Encode(153, 254, 254)    -- used for the player's name, and cold damage.

--- RGB(176, 176, 176)
M.LIGHT_GRAY   = M.Encode(176, 176, 176)    -- used for system messages.

--- RGB(254, 153, 32)
M.LIGHT_ORANGE = M.Encode(254, 153, 32)     -- used for sonic damage.

--- RGB(204, 153, 204)
M.LIGHT_PURPLE = M.Encode(204, 153, 204)    -- used for a target's name.

--- RGB(254, 102, 32)
M.ORANGE       = M.Encode(254, 102, 32)     -- used for attack rolls and physical damage.

--- RGB(204, 119, 254)
M.PURPLE       = M.Encode(204, 119, 254)    -- used for spell casts, as well as magic damage.

--- RGB(254, 32, 32)
M.RED          = M.Encode(254, 32, 32)      -- used for fire damage.

--- RGB(254, 254, 254)
M.WHITE        = M.Encode(254, 254, 254)    -- used for positive damage.

--- RGB(254, 254, 32)
M.YELLOW       = M.Encode(254, 254, 32)     -- used for healing, and sent messages.

--- Colored text terminator.
M.END          = "</c>"

return M
