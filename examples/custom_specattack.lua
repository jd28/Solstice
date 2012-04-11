local nisa = require 'nwn.internal.specattack'

nisa.RegisterSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_KNOCKDOWN_IMPROVED,
   function (attacker, defender, attack)
      attacker:SendMessage("Special Attack Resolve")
   end,
   function(attacker, defender)
      attacker:SendMessage("Special Attack AB")
   end,
   function(attacker, defender)
      attacker:SendMessage("Special Attack Damage")
   end)
