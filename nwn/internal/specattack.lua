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
--------------------------------------------------------------------------------

-- TODO Ranged Special Attacks.

local spec_attacks = {}
local spec_attacks_ranged = {}

function nwn.RegisterMeleeSpecialAttack(attack_type, f_resolve, f_resolveab, f_resolvedb)
   spec_attacks[attack_type] = { f_resolve, f_resolveab, f_resolvedb }
end

function nwn.RegisterRangedSpecialAttack(attack_type, f_resolve, f_resolveab, f_resolvedb)
   spec_attacks_ranged[attack_type] = { f_resolve, f_resolveab, f_resolvedb }
end

------------------------------------------------------------------------
-- Global Functions

function NSMeleeSpecialAttack(attack_type, event_type, attacker, defender, attack)
   if spec_attacks[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks[attack_type][event_type](attacker, defender, attack)
   end
end

function NSMeleeRangedAttack(attack_type, event_type, attacker, defender, attack)
   if spec_attacks_ranged[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks_ranged[attack_type][event_type](attacker, defender, attack)
   end
end

------------------------------------------------------------------------

return spec_attacks
