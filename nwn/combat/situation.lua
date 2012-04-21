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

function NSResolveSituationalModifiers(attacker, target)
   local flags = 0
   local x = attacker.obj.obj.obj_position.x - target.obj.obj.obj_position.x
   local y = attacker.obj.obj.obj_position.y - target.obj.obj.obj_position.y
   local z = attacker.obj.obj.obj_position.z - target.obj.obj.obj_position.z

   attacker.ci.target_distance = x ^ 2 + y ^ 2 + z ^ 2

   -- Save some time by not sqrt'ing to get magnitude
   if attacker.ci.target_distance <= 100 then
      -- Coup De Grace
      if bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ASLEEP)
         and target:GetHitDice() < 5
      then
         flags = bit.bor(flags, nwn.SITUATION_COUPDEGRACE)
      end

      local death = attacker.ci.situational[nwn.SITUATION_FLAG_DEATH_ATTACK].dmg.dice > 0
         or attacker.ci.situational[nwn.SITUATION_FLAG_DEATH_ATTACK].dmg.bonus > 0
      
      local sneak = attacker.ci.situational[nwn.SITUATION_FLAG_SNEAK_ATTACK].dmg.dice > 0
         or attacker.ci.situational[nwn.SITUATION_FLAG_SNEAK_ATTACK].dmg.bonus > 0

      -- Sneak Attack & Death Attack
      if (sneak or death) and
         (bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN) ~= 0
          or bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED) ~= 0
          or bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLANKED)) ~= 0
      then
         -- Death Attack.  If it's a Death Attack it's also a sneak attack.
         if death then
            flags = bit.bor(flags, nwn.SITUATION_FLAG_DEATH_ATTACK)
            flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
         end

         -- Sneak Attack
         if sneak then
            flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
         end
      end 
   end
   attacker.ci.situational_flags = flags
end