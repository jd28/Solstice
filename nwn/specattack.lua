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

local spec_attacks = {}
local spec_attacks_ranged = {}

--- Register a melee special attack.
-- Each of the function parameters will be called with 3  arguments attacker, target, and
-- CNWSCombatAttackData ctype.   The attack data should be used with caution and treated
-- as read only.  In the resolve attack bonus and damage bonus cases, it's best to ignore it.
-- @param attack_type Special Attack type.
-- @param f_resolve A function to apply any effects to the target.
-- @param f_resolveab A function to determine additional attack bonus
-- @param f_resolvedb A function to determine additional damage bonus
function nwn.RegisterMeleeSpecialAttack(attack_type, f_resolve, f_resolveab, f_resolvedb)
   print(attack_type, f_resolve, f_resolveab, f_resolvedb)
   spec_attacks[attack_type] = { f_resolve, f_resolveab, f_resolvedb }
end

--- Register a ranged special attack.
-- Each of the function parameters will be called with 3 arguments attacker, target, and
-- CNWSCombatAttackData ctype.   The attack data should be used with caution and treated
-- as read only.  In the resolve attack bonus and damage bonus cases, it's best to ignore it.
-- @param attack_type Special Attack type.
-- @param f_resolve A function to apply any effects to the target.
-- @param f_resolveab A function to determine additional attack bonus
-- @param f_resolvedb A function to determine additional damage bonus
function nwn.RegisterRangedSpecialAttack(attack_type, f_resolve, f_resolveab, f_resolvedb)
   spec_attacks_ranged[attack_type] = { f_resolve, f_resolveab, f_resolvedb }
end

------------------------------------------------------------------------
-- Global Functions

function NSMeleeSpecialAttack(attack_type, event_type, attacker, defender, attack)
   if spec_attacks[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks[attack_type][event_type](attacker, defender, attack)
   else
      print("No special attack for attack_type: " .. attack_type .. "  " ..event_type)
   end
end

function NSMeleeRangedAttack(attack_type, event_type, attacker, defender, attack)
   if spec_attacks_ranged[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks_ranged[attack_type][event_type](attacker, defender, attack)
   end
end

------------------------------------------------------------------------

return spec_attacks
