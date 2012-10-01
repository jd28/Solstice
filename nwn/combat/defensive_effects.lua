local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local random = math.random

--- Determine miss chance / concealment.
-- @param attacker Attacker
-- @param target Target
-- @return Returns true if the attacker failed to over come miss chance
--    or concealment.
function NSResolveMissChance(attacker, target, hit, attack_info)
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end

   -- Miss Chance
   local miss_chance = attacker:GetMissChance(attack_info.attack)
   -- Conceal
   local conceal = target:GetConcealment(attacker, attack_info.attack)

   -- If concealment and mis-chance are less than or equal to zero
   -- there is no chance of them affecting the outcome of an attack.
   if conceal <= 0 and miss_chance <= 0 then return false end

   local chance, attack_result

   -- Deterimine which of miss chance and concealment is higher.
   -- attack_result is a magic number for the NWN combat engine that
   -- determines which combat messages are sent to the player.
   if miss_chance < conceal then
      chance = conceal
      attack_result = 8
   else
      chance = miss_chance
      attack_result = 9
   end

   -- The attacker has two possible chances to over come miss chance / concealment
   -- if they posses the blind fight feat.  If not they only have one chance to do so.
   if random(100) >= chance
      or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and random(100) >= chance)
   then
      return false
   else
      attack_info.attack.cad_attack_result = attack_result
      -- Show the modified conceal/miss chance in the combat log.
      attack_info.attack.cad_concealment = math.floor((chance ^ 2) / 100)
      attack_info.attack.cad_missed = 1
      return true
   end
end
