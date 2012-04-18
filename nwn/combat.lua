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
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

require 'nwn.combat.attack_melee'
require 'nwn.combat.attack_ranged'
require 'nwn.combat.attack_roll'
require 'nwn.combat.attack_special'
require 'nwn.combat.critical_hit'
require 'nwn.combat.damage'
require 'nwn.combat.defensive_abilities'
require 'nwn.combat.defensive_effects'
require 'nwn.combat.post_damage'
require 'nwn.combat.situation'
require 'nwn.combat.state'

function NSGetCurrentAttackWeapon(combat_round, attack_type, attacker)
   local weapon = C.nwn_GetCurrentAttackWeapon(combat_round, attack_type)
   local ci_weap_number = -1

   if attacker then
      for i = 0, 5 do
         if attacker.ci.equips[i].id == weapon.obj.obj_id then
            ci_weap_number = i
            break
         end
      end
   end
   return _NL_GET_CACHED_OBJECT(weapon.obj.obj_id), ci_weap_number
end

function NSGetOffhandAttack(cr)
   return cr.cr_current_attack + 1 > 
      cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks
end

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

