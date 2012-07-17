local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

-- @param weap Attack weapon, if nil then the call is coming from the plugin.
function NSGetCriticalHitMultiplier(attacker, offhand, weap_num)
   local result
   if weap_num then
      result = attacker.ci.equips[weap_num].crit_mult
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      offhand = offhand == 1
      local cr = attacker.obj.cre_combat_round

      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritMultiplier(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritMultBonus()

   print("NSGetCriticalHitMultiplier", attacker, offhand, weap_num, result)

   return result
end

--- Get critical hit range
-- @param attacker Attacker
-- @param offhand true if attack is an offhand attack.
-- @param attack_info AttackInfo ctype
function NSGetCriticalHitRange(attacker, offhand, weap_num)
   local result
   if weap_num then
      result = attacker.ci.equips[weap_num].crit_range
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      offhand = offhand == 1
      local cr = attacker.obj.cre_combat_round
      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritRange(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritRangeBonus()

   print("NSGetCriticalHitRange", attacker, offhand, weap_num, result)

   return result
end


--- Get critical hit roll
-- @param attacker Attacker
-- @param offhand true if attack is an offhand attack.
-- @param attack_info AttackInfo ctype
function NSGetCriticalHitRoll(attacker, offhand, weap_num)
   return 21 - NSGetCriticalHitRange(attacker, offhand, weap_num)
end