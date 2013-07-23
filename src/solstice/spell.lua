--- Spells
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module spells

local M = require 'solstice.spell.init'
M.const = require 'solstice.spell.constant'
setmetatable(M, { __index = M.const })

--- Gets a random delay
-- @param min Minimum delay
-- @param max Maximum delay
function M.GetRandomDelay(min, max)
   min = min or 0.4
   max = max or 1.1
   local rand = max - min
   if rand < 0 then
      return 0
   end
   rand = rand  * 10.0
   rand = math.random(rand)

   return rand / 10 + min
end

--- Determines a delay for spell effects
-- Distance between location and object divided by 20
-- @param location Location of spell impact/caster
-- @param target Spell target
function M.GetSpellEffectDelay(location, target)
   return location:GetDistanceBetween(target:GetLocation()) / 20
end
