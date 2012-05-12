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

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

ffi.cdef (string.gsub([[

typedef struct DamageResult {
   int32_t    damages[$NS_OPT_NUM_DAMAGES];
   int32_t    immunity_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    resist_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    soak_adjust;
} DamageResult;
]], "%$([%w_]+)", { NS_OPT_NUM_DAMAGES = NS_OPT_NUM_DAMAGES }))

ffi.cdef(string.gsub([[
typedef struct DamageRoll {
   uint32_t    damage_power;

   DiceRoll    bonus[$NS_OPT_MAX_DMG_ROLL_MODS];
   uint32_t    bonus_type[$NS_OPT_MAX_DMG_ROLL_MODS];
   uint32_t    bonus_count;

   DiceRoll    penalty[$NS_OPT_MAX_DMG_ROLL_MODS];
   uint32_t    penalty_type[$NS_OPT_MAX_DMG_ROLL_MODS];
   uint32_t    penalty_count;

   DamageResult result;
} DamageRoll;
]], "%$([%w_]+)", { NS_OPT_MAX_DMG_ROLL_MODS = NS_OPT_MAX_DMG_ROLL_MODS }))

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
   DamageRoll *dmg_roll;
} AttackInfo;
]]

damage_result_t = ffi.typeof("DamageResult")
attack_info_t = ffi.typeof("AttackInfo")
damage_roll_t = ffi.typeof("DamageRoll")


require 'nwn.combat.attack_melee'
require 'nwn.combat.attack_ranged'
require 'nwn.combat.attack_roll'
require 'nwn.combat.attack_special'
require 'nwn.combat.critical_hit'
require 'nwn.combat.damage_format'
require 'nwn.combat.damage'
require 'nwn.combat.defensive_abilities'
require 'nwn.combat.defensive_effects'
require 'nwn.combat.post_damage'
require 'nwn.combat.situation'
require 'nwn.combat.state'

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
	    ci_weap_number = i
	    break
	 end
      end
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      attack_info.target_cr = target.obj.cre_combat_round
   end

   return attack_info
end

--- Gets the current attack weapon
-- @param attack_info AttackInfo ctype
function NSGetCurrentAttackWeapon(attack_info)
   local n = attack_info.weapon
   if n >= 0 and n <= 5 then
      local id = attacker.ci.equips[n]
      return _NL_GET_CACHED_OBJECT(id)
   end
   return nwn.OBJECT_INVALID
end

--- Get if attack is an offhand attack
-- @param cr CNWSCombatRound ctype
function NSGetOffhandAttack(cr)
   return cr.cr_current_attack + 1 > 
      cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks
end

--- Initialize number of attacks
-- @param cre Attacking object
-- @param combat_round CNWSCombatRound ctype
function NSInitializeNumberOfAttacks (cre, combat_round)
   cre = _NL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return end
   combat_round = cre.obj.cre_combat_round

   cre:UpdateCombatInfo()

   local rh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local rh_valid = rh:GetIsValid()
   local lh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local age = cre.stats.cs_age
   local style = (age / 100) % 10
   local extra_onhand = (age / 10000) % 10
   local extra_offhand = (age / 1000) % 10
   local attacks = 0
   local offhand_attacks = 0

   combat_round.cr_extra_taken = 0
   combat_round.cr_offhand_taken = 0

   if rh_valid and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_HEAVYCROSSBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_LIGHTCROSSBOW)
      and not cre:GetHasFeat(nwn.FEAT_RAPID_RELOAD)
   then
      attacks = 1
   elseif cre.stats.cs_override_atks > 0 then
      -- appearently some kind of attack override
      attacks = cre.stats.cs_override_atks
   else
      attacks = C.nwn_GetAttacksPerRound(cre.stats)
   end

   -- STYLE
   if style == 7 and not rh:GetIsValid() then
      -- sunfist
      extra_onhand = extra_onhand + 1
   elseif style == 3 and lh:GetIsValid() and -- spartan
      (lh.obj.it_baseitem == nwn.BASE_ITEM_SMALLSHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_LARGESHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_TOWERSHIELD)
   then
      extra_onhand = extra_onhand + 1;
   elseif cre:GetLevelByClass(nwn.CLASS_TYPE_RANGER) >= 40 and
      cre:GetLevelByClass(nwn.CLASS_TYPE_MONK) == 0
   then
      extra_offhand = extra_offhand + 1; 
   end

   -- FEAT
   if not rh:GetIsValid() and cre:GetKnowsFeat(nwn.FEAT_CIRCLE_KICK) then
      extra_onhand = extra_onhand + 1
   end

   offhand_attacks = C.nwn_CalculateOffHandAttacks(combat_round)

   if cre.obj.cre_slowed ~= 0 and attacks > 1 then
      attacks = attacks - 1
   end

   if cre.obj.cre_mode_combat == 10 then -- Dirty Fighting
      cre:SetCombatMode(0)
      combat_round.cr_onhand_atks = 1
      combat_round.cr_offhand_atks = 0
      return
   elseif cre.obj.cre_mode_combat == 6 and -- Rapid Shot
      rh:GetIsValid() and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_LONGBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_SHORTBOW) 
   then
      combat_round.cr_additional_atks = 1
   elseif cre.obj.cre_mode_combat == 5 and -- flurry
      (not rh:GetIsValid() or
       rh.obj.it_baseitem == 40 or
       rh:GetIsFlurryable())
   then
      combat_round.cr_additional_atks = 1
   end

   if cre.obj.cre_hasted then
      combat_round.cr_additional_atks = combat_round.cr_additional_atks + 1
   end

   -- Only give extra offhand attacks if we have one to begin with.
   if offhand_attacks > 0 then
      offhand_attacks = offhand_attacks + extra_offhand
   end

   combat_round.cr_onhand_atks = attacks + extra_onhand
   combat_round.cr_offhand_atks = offhand_attacks
end

