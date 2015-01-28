local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local fmt = string.format
local sm = string.strip_margin
local GetObjectByID = Game.GetObjectByID

--- Bridge functions.

function NWNXSolstice_GetArmorClass(cre)
   cre = Game.GetObjectByID(cre)
   if not cre:GetIsValid() or cre.type ~= OBJECT_TRUETYPE_CREATURE then
      return 0
   end
   return cre:GetACVersus(OBJECT_INVALID, false)
end

function NWNXSolstice_DoMeleeAttack()
   local ce = Rules.GetCombatEngine()
   ce.DoMeleeAttack()
end

function NWNXSolstice_DoRangedAttack()
   local ce = Rules.GetCombatEngine()
   ce.DoRangedAttack()
end

function NWNXSolstice_ResolvePreAttack(attacker_, target_)
   local ce = Rules.GetCombatEngine()
   ce.DoPreAttack(GetObjectByID(attacker_), GetObjectByID(target_))
end

function NWNXSolstice_UpdateCombatInfo(attacker)
   attacker = GetObjectByID(attacker)
   attacker:UpdateCombatInfo(true)
   local ce = Rules.GetCombatEngine()
   if ce and ce.UpdateCombatInformation then
      ce.UpdateCombatInformation(GetObjectByID(attacker))
   end
end
