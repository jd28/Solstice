--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveMissChance(attacker, target, hit, cr, attack)
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end

   -- Miss Chance
   local miss_chance = attacker:GetMissChance(attack)
   -- Conceal
   local conceal = target:GetConcealment(attacker, attack)

   if conceal > 0 or miss_chance > 0 then
      if miss_chance < conceal then
         if math.random(1, 100) >= conceal
            or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
                and math.random(1, 100) >= conceal)
         then
            attack.cad_attack_result = 8
            attack.cad_concealment = math.floor((conceal ^ 2) / 100)
            attack.cad_missed = 1
            return true
         end
      else
         if math.random(1, 100) >= miss_chance
            or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
                and math.random(1, 100) >= miss_chance)
         then
            attack.cad_attack_result = 9
            attack.cad_concealment = math.floor((miss_chance ^ 2) / 100)
            attack.cad_missed = 1
            return true
         end
      end
   end
   return false
end