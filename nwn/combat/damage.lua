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

function NSGetDamageRoll(attacker, target, offhand, unknown, sneak, death, ki_damage)

end

function NSGetDamageBonus(attacker, target, int)
end

function NSResolveDamage ()
   -- Epic Dodge : Don't want to use it unless we take damage.
   if hit
      and cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- Send Epic Dodge Message
      cr.cr_epic_dodge_used = 1
   end
end

function NSSignalMeleeDamage(attacker, target, attack_count)

end

function NSSignalRangedDamage(attacker, target, attack_count)

end