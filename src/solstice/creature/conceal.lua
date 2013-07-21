--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

-- This file should problably be merged into another.

local M = require 'solstice.creature.init'

--- Concealment
-- @section

--- Get creatures concealment
-- @param vs Creatures attacker, if any.
function M.Creature:GetConcealment(vs)
   error "nwnxcombat"
end

--- Get creatures miss chance
function M.Creature:GetMissChance()
   error "nwnxcombat"
end