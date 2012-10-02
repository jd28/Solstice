local dc = require 'nwn.combat.default_combat'
local new_combat = inheritsFrom(dc)

-- Just a stupid example... crit multiplier 20 for all creatures.
function new_combat.GetCriticalHitMultiplier()
   return 20
end

NSLoadCombatEngine(new_combat)