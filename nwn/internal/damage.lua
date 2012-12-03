--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

-- TODO passing proper arguments, etc.

local damage = {}

local weighted_damage_handler = function () return nil end

function damage.SetWeightedDamageHandler(func)
   weighted_damage_handler = func
end

------------------------------------------------------------------------
-- Global Functions
-- The following are for communicating with lua from NWNX.  Probably
-- shouldn't change these unless you understand what they're doing.

function _NL_WEIGHTED_DAMAGE_HANDLER()
   weighted_damage_handler()
end

-- Global Functions
------------------------------------------------------------------------

return damage