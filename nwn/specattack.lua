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

function NSSpecialAttack(event_type, attacker, target, attack_info)
   if NSGetIsRangedAttack(attack_info) then
      return NSMeleeRangedAttack(NSGetSpecialAttack(attack_info), event_type, attacker, defender, attack_info)
   else
      return NSMeleeSpecialAttack(NSGetSpecialAttack(attack_info), event_type, attacker, defender, attack_info)
   end
end

function NSMeleeSpecialAttack(attack_type, event_type, attacker, defender, attack_info)
   if spec_attacks[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks[attack_type][event_type](attacker, defender, attack_info)
   elseif event_type == nwn.SPECIAL_ATTACK_EVENT_AB then
      return 0
   end
end

function NSMeleeRangedAttack(attack_type, event_type, attacker, defender, attack_info)
   if spec_attacks_ranged[attack_type] and spec_attacks[attack_type][event_type] then
      return spec_attacks_ranged[attack_type][event_type](attacker, defender, attack_info)
   elseif event_type == nwn.SPECIAL_ATTACK_EVENT_AB then
      return 0
   end
end

------------------------------------------------------------------------

return spec_attacks
