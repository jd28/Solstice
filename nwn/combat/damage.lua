local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local color = require 'nwn.color'

local DAMAGE_RESULTS = {}
local DAMAGE_ID = 0

local s = string.gsub([[
typedef struct DamageResult {
   int32_t    damages[$NS_OPT_NUM_DAMAGES];
   int32_t    immunity_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    resist_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    soak_adjust;
} DamageResult;

typedef struct {
   DiceRoll rolls[$NS_OPT_NUM_DAMAGES][50];
   int32_t  idxs[$NS_OPT_NUM_DAMAGES];
} DamageRoll;
]], "%$([%w_]+)", { NS_OPT_NUM_DAMAGES = NS_OPT_NUM_DAMAGES })

ffi.cdef (s)

damage_roll_t = ffi.typeof('DamageRoll')
damage_result_t = ffi.typeof("DamageResult")

function NSAddDamageToRoll(dmg, dmg_type, roll)
   if not dmg_type then return end

   local idx = nwn.GetDamageIndexFromFlag(dmg_type)
   local n = dmg.idxs[idx]

   --print("NSAddDamageToRoll", dmg, dmg_type, idx, n)

   dmg.rolls[idx][n] = roll
   dmg.idxs[idx] = n + 1
end

function NSAddDamageResultToAttack(attack_info, dmg_result)
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      if i < 13 then
	 if dmg_result.damages[i] <= 0 then
	    attack_info.attack.cad_damage[i] = 65535
	 else
	    attack_info.attack.cad_damage[i] = dmg_result.damages[i]
	 end
      else 
	 if dmg_result.damages[i] > 0 then
	    local flag = bit.lshift(1, i)
	    local eff = nwn.EffectDamage(flag, dmg_result.damages[i])
	    -- Set effect to direct so that Lua will not delete the
	    -- effect.  It will be deleted by the combat engine.
	    eff.direct = true
	    -- Add the effect to the onhit effect list so that it can
	    -- be applied when damage is signaled.
	    NSAddOnHitEffect(attack_info, attack_info.attacker, eff)
	 end
      end
   end
end

function NSCompactPhysicalDamageResult(dmg_result)
   dmg_result.damages[12] = dmg_result.damages[12] + dmg_result.damages[0] + 
      dmg_result.damages[1] + dmg_result.damages[2]

   dmg_result.damages[0], dmg_result.damages[1], dmg_result.damages[2] = 0, 0, 0
end

---
function NSGetTotalDamage(dmg_result)
   --print("NSGetTotalDamage", dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.damages[i]
   end
   return total
end

---
function NSGetTotalImmunityAdjustment(dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.immunity_adjust[i]
   end
   return total
end

---
function NSGetTotalResistAdjustment(dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.resist_adjust[i]
   end
   return total
end

--[[
function NSBroadcastDamage(attacker, target, dmg_result)
   --print("NSBroadcastDamage")
   local total = NSGetTotalDamage(dmg_result)
   local log

   if NS_OPT_NO_FLOAT_DAMAGE then
      log = NSFormatDamageRoll(attacker, target, dmg_result)
   elseif NS_OPT_NO_FLOAT_ZERO_DAMAGE and total <= 0 then
      log = NSFormatDamageRoll(attacker, target, dmg_result)
   else
      C.nwn_PrintDamage(attacker.id, target.id, total, dmg_result.damages)
      local extra = NSGetTotalDamage(dmg_result, 13)
      if extra > 0 then
         log = NSFormatDamageRoll(attacker, target, dmg_result, 13)
      end
   end

   local tloc = target:GetLocation()
   local ploc

   local imm
   if NSGetTotalImmunityAdjustment(dmg_result) > 0 then
      imm = NSFormatDamageRollImmunities(attacker, target, dmg_result)
   end

   local resist
   if NSGetTotalResistAdjustment(dmg_roll.result) > 0 then
      resist = NSFormatDamageRollResistance(attacker, target, dmg_result)
   end

   local dr 
   if dmg_result.soak_adjust > 0 then
      dr = NSFormatDamageRollReduction(attacker, target, dmg_result)
   end

   for pc in nwn.PCs() do
      ploc = pc:GetLocation()
      if tloc:GetDistanceBetween(ploc) <= 20 then
         if log then
            pc:SendMessage(log)
         end
         if dr then
            pc:SendMessage(dr)
         end
         if imm then
            pc:SendMessage(imm)
         end
         if resist then
            pc:SendMessage(resist)
         end
      end
   end
end
--]]