local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

ffi.cdef[[
typedef struct AttackInfo {
   CNWSCombatRound  *attacker_cr;
   CNWSCombatRound  *target_cr;
   CNWSCombatAttackData *attack;
   uint32_t current_attack;
   uint32_t attack_id;
   uint32_t target_state;
   uint32_t situational_flags;
   int32_t  weapon;
   bool is_offhand;
   nwn_objid_t attacker;
   nwn_objid_t target;
} AttackInfo;
]]

attack_info_t = ffi.typeof("AttackInfo")

require 'nwn.combat.bridge'
require 'nwn.combat.attack_special'
require 'nwn.combat.damage_format'
require 'nwn.combat.damage'
require 'nwn.combat.defensive_abilities'
require 'nwn.combat.defensive_effects'
require 'nwn.combat.post_damage'
require 'nwn.combat.situation'
require 'nwn.combat.state'

local dc = require 'nwn.combat.default_combat'
NSLoadCombatEngine(dc)

--- Add feedback to attack
function NSAddAttackFeedback(attack_info, feedback)
   C.ns_AddAttackFeedback(attack_info.attack, feedback)
end

local ATTACK_ID = 1

function NSGetAttackInfo(attacker, target)
   local attack_info = attack_info_t()
   attack_info.attacker_cr = attacker.obj.cre_combat_round
   attack_info.current_attack = attack_info.attacker_cr.cr_current_attack
   attack_info.attacker = attacker.id
   attack_info.target = target.id
   attack_info.attack_id = ATTACK_ID
   ATTACK_ID = ATTACK_ID + 1
   attack_info.attack = C.nwn_GetAttack(attack_info.attacker_cr, attack_info.current_attack)
   attack_info.attack.cad_attack_group = attack_info.attack.cad_attack_group
   attack_info.attack.cad_target = target.id
   attack_info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   attack_info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(attack_info.attacker_cr)
   attack_info.is_offhand = NSGetOffhandAttack(attack_info.attacker_cr)

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(attack_info.attacker_cr, attack_info.attack.cad_attack_type)
   attack_info.weapon = 3
   if weapon ~= nil then
      for i = 0, 5 do
	 if attacker.ci.equips[i].id == weapon.obj.obj_id then
	    attack_info.weapon = i
	    break
	 end
      end
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack_info.target_cr = target.obj.cre_combat_round
   end

   return attack_info
end

function NSUpdateAttackInfo(attack_info, attacker, target)
   attack_info.current_attack = attack_info.attacker_cr.cr_current_attack
   attack_info.attack_id = ATTACK_ID
   ATTACK_ID = ATTACK_ID + 1
   attack_info.attack = C.nwn_GetAttack(attack_info.attacker_cr, attack_info.current_attack)
   attack_info.attack.cad_attack_group = attack_info.attack.cad_attack_group
   attack_info.attack.cad_target = target.id
   attack_info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   attack_info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(attack_info.attacker_cr)
   attack_info.is_offhand = NSGetOffhandAttack(attack_info.attacker_cr)

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(attack_info.attacker_cr, attack_info.attack.cad_attack_type)
   attack_info.weapon = 3
   if weapon ~= nil then
      for i = 0, 5 do
	 if attacker.ci.equips[i].id == weapon.obj.obj_id then
	    attack_info.weapon = i
	    break
	 end
      end
   end
end
--- Gets the current attack weapon
-- @param attack_info AttackInfo ctype
function NSGetCurrentAttackWeapon(attacker, attack_info)
   if not attack_info then
      error(debug.traceback())
   end
   local n = attack_info.weapon
   if n >= 0 and n <= 5 then
      local id = attacker.ci.equips[n].id
      if id == 0 then
	 return nwn.OBJECT_INVALID
      else
	 return _NL_GET_CACHED_OBJECT(id)
      end
   end
   return nwn.OBJECT_INVALID
end

--- Get if attack is an offhand attack
-- @param cr CNWSCombatRound ctype
function NSGetOffhandAttack(cr)
   return cr.cr_current_attack + 1 > 
      cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks
end

function NSAddOnHitVisualEffect(attack, attacker, vfx)
   C.ns_AddOnHitVisual(attack, attacker.id, vfx)
end

function NSAddOnHitEffect(attack_info, attacker, eff)
   C.ns_AddOnHitEffect(attack_info.attack, attacker.id, eff.eff)
end

function NSGetAttackResult(attack_info)
   local t = attack_info.attack.cad_attack_result

   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

function NSSignalRangedDamage(attacker, target, attack_count)
   C.nwn_SignalRangedDamage(attacker.obj, target.obj.obj, attack_count)
end

function NSSetAttackResult(attack_info, result)
   attack_info.attack.cad_attack_result = result
end

function NSResolveItemCastSpell(attacker, target)
   C.nwn_ResolveItemCastSpell(attacker.obj, target.obj.obj)
end

function NSResolveOnHitEffects(attacker, target, attack_info, crit)
   C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, attack_info.is_offhand, crit)
end

function NSResolveMeleeAnimations(attacker, i, attack_count, target, anim)
   C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, anim)
end

function NSGetIsCriticalHit(attack_info)
   return attack_info.attack.cad_attack_result == 3
end