local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local random = math.random
local socket = require 'socket'

require 'nwn.combat.damage'

local DefaultCombat = {}

function DefaultCombat.DoDamageAdjustments(attacker, target, dmg_result, damage_power, attack_info)
   local dmg, resist, imm, imm_adj

   local weap = NSGetCurrentAttackWeapon(attacker, attack_info)
   local basetype, basemask = nwn.GetWeaponBaseDamageType(weap:GetBaseType())

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      -- When the index is the base weapon damage type, use the weapons base type
      -- to determine what immunity applies
      if i == 12 then
	 imm = target:GetDamageImmunity(nwn.GetDamageIndexFromFlag(basetype))
      else
	 imm = target:GetDamageImmunity(i)
      end

      dmg = dmg_result.damages[i]
      if dmg ~= 0 then
	 imm_adj = math.floor((imm * dmg) / 100)
	 -- Immunity
	 dmg_result.immunity_adjust[i] = imm_adj
	 dmg_result.damages[i] = dmg - imm_adj
      end
   end

   -- Resist
   target:DoDamageResistance(attacker, dmg_result, attack_info)
   
   -- Damage Reduction
   target:DoDamageReduction(attacker, dmg_result, damage_power)
end


---
function DefaultCombat.DoDamageRoll(bonus, penalty, mult)
   --print("NSDoDamageRoll", bonus, penalty, mult)
   local roll, prev, idx
   local res = damage_result_t()

   for i = 1, mult do
      for j = 0, NS_OPT_NUM_DAMAGES - 1 do
	 --print("bonus", j)
	 for k = 0, bonus.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] + nwn.DoDiceRoll(bonus.rolls[j][k])
	    --print(k, nwn.FormatDiceRoll(bonus.rolls[j][k]))
	 end

	 --print("penalty", j)
	 for k = 0, penalty.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] - nwn.DoDiceRoll(penalty.rolls[j][k])
	    --print(k, nwn.FormatDiceRoll(bonus.rolls[j][k]))
	 end

	 if res.damages[j] < 0 then
	    res.damages[j] = 0
	 end
      end
   end
   
   return res
end

function DefaultCombat.GetArmorClassVersus(target, attacker, touch, from_hook, attack)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      target:UpdateCombatInfo()
   else
      target:UpdateCombatInfo()
   end

   -- 10 base AC
   local ac = 10
   local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0

   -- Size Modifier
   ac = ac + target.ci.size.ac

   -- Armor AC
   ac = ac + target.stats.cs_ac_armour_base
   armor = target.stats.cs_ac_armour_bonus
   armorpen = target.stats.cs_ac_armour_penalty

   -- Deflect AC
   deflect = target.stats.cs_ac_deflection_bonus - target.stats.cs_ac_deflection_penalty

   -- Natural AC
   ac = ac + target.stats.cs_ac_natural_base
   nat = target.stats.cs_ac_natural_bonus - target.stats.cs_ac_natural_penalty

   -- Shield AC
   ac = ac + target.stats.cs_ac_shield_base
   shield = target.stats.cs_ac_shield_bonus - target.stats.cs_ac_shield_penalty

   -- Class: Monk, RDD, PM, ...
   ac = ac + target.ci.class.ac

   -- Attack Mode Modifier
   ac = ac + attacker.ci.mode.ac

   -- Feat: Armor Skin, etc
   ac = ac + target.ci.feat.ac

   -- Dex Modifier
   local dex_mod = target:GetDexMod(true)
   local dexed = false

   -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
   -- then target gets no Dex mod.
   if not NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
      and not NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_FLATFOOTED)
   then
      -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
      -- gets dex_mod and dodge AC
      if bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN) == 0
         or (target:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and attack.cad_ranged_attack == 0)
      then
         if dex_mod > 0 then
            dexed = true
         end
         -- Dodge AC
         dodge = target.stats.cs_ac_dodge_bonus - target.stats.cs_ac_dodge_penalty

         -- Skill: Tumble...
         ac = ac + target.ci.skill.ac
         
         -- If this is an attack of opportunity and target has mobility
         -- there is a +4 ac bonus.
         if attack.cad_special_attack == -534 
            and target:GetHasFeat(nwn.FEAT_MOBILITY)
         then
            ac = ac + 4
         end
         
         if target:GetHasFeat(nwn.FEAT_DODGE) then
            if target.obj.cre_combat_round.cr_dodge_target == nwn.OBJECT_INVALID.id then
               target.obj.cre_combat_round.cr_dodge_target = attacker.id
            end
            if target.obj.cre_combat_round.cr_dodge_target == attacker.id
               and not target:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
            then
               ac = ac + 1
            end
         end
      end
   -- If dex_mod is negative we add it in.
   elseif dex_mod < 0 then
      dexed = true
   end

   -- If target has Uncanny Dodge 1 or Defensive Awareness 1, target gets
   -- dex modifier.
   if not dexed
      and dex_mod > 0
      and (target:GetHasFeat(nwn.FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
           or target:GetHasFeat(nwn.FEAT_UNCANNY_DODGE_1))
   then
      dexed = true
   end

   if dexed then
      ac = ac + dex_mod
   end

   -- +4 Defensive Training Vs.
   if target.ci.training_vs_mask ~= 0 
      and attacker.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(target.ci.training_vs_mask, bit.lshift(1, attacker:GetRacialType())) ~= 0
   then
      ac = ac + 4
   end

   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge =
      target:GetEffectArmorClassBonus(attacker, touch)

   dodge = dodge + eff_dodge
   local max_dodge_ac = target:GetMaxDodgeAC()
   if dodge > max_dodge_ac then
      dodge = max_dodge_ac
   end

   if touch then
      return ac + dodge
   end

   if eff_nat > nat then nat = eff_nat end
   if eff_armor > armor then armor = eff_armor end
   if eff_shield > shield then shield = eff_shield end
   if eff_deflect > deflect then deflect = eff_deflect end

   return ac + nat + armor + shield + deflect + dodge
end

function DefaultCombat.GetAttackModifierVersus(attacker, target, attack_info, attack_type)
   if not attack_info then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
      attack_info = NSGetAttackInfo(attacker, target)
      attack_type = attack_info.attack.cad_attack_type
   end
   
   local bab

   if attack_type == 2 then
      bab = attacker.ci.bab - (5 * attack_info.attacker_cr.cr_offhand_taken)
      attack_info.attacker_cr.cr_offhand_taken = attack_info.attacker_cr.cr_offhand_taken + 1
   elseif attack_type == 6 or attack_type == 8 then
      bab = attacker.ci.bab
      if attack_info.attack.cad_special_attack ~= 867 
         or attack_info.attack.cad_special_attack ~= 868
         or attack_info.attack.cad_special_attack ~= 391
      then
         bab = bab - (5 * attack_info.attacker_cr.cr_extra_taken)
      end
      attack_info.attacker_cr.cr_extra_taken = attack_info.attacker_cr.cr_extra_taken + 1
   else
      if attack_info.attack.cad_special_attack == 65002 
         or attack_info.attack.cad_special_attack == 6
         or attack_info.attack.cad_special_attack == 391
      then
         bab = attacker.ci.bab
      else
         bab = attacker.ci.bab - (attack_info.current_attack * attacker.ci.equips[attack_info.weapon].iter)
      end
   end

   local ab_abil = attacker:GetAbilityModifier(attacker.ci.equips[attack_info.weapon].ab_ability)

   -- Base Attack Bonus
   local ab = bab

   -- Offhand Attack Penalty
   if attack_info.is_offhand then
      ab = ab + attacker.ci.offhand_penalty_off
   else
      ab = ab + attacker.ci.offhand_penalty_on      
   end

   -- Size Modifier
   ab = ab + attacker.ci.size.ab

   -- Area Modifier
   ab = ab + attacker.ci.area.ab

   -- Feat Modifier
   ab = ab + attacker.ci.feat.ab

   -- Attack Mode Modifier
   ab = ab + attacker.ci.mode.ab

   -- Special Attack Modifier
   if attack_info.attack.cad_special_attack > 0 then
      ab = ab + NSResolveSpecialAttackAttackBonus(attacker, target, attack_info)
   end

   -- Favored Enemies
   if attacker.ci.fe_mask ~= 0 
      and target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(attacker.ci.fe_mask, bit.lshift(1, target:GetRacialType())) ~= 0
   then
      ab = ab + attacker.ci.fe.ab
   end

   -- +1 Offensive Training Vs.
   if attacker.ci.training_vs_mask ~= 0 
      and target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(attacker.ci.training_vs_mask, bit.lshift(1, target:GetRacialType())) ~= 0
   then
      ab = ab + 1
   end

   -- Race Modifier
   ab = ab + attacker.ci.race.ab

   -- Weapon AB Mod.  i.e, WF, SWF, EWF, etc
   ab = ab + attacker.ci.equips[attack_info.weapon].ab_mod

   -- Target State
   local state = attacker:GetEnemyStateAttackBonus(attack_info.attack.cad_ranged_attack)
   ab = ab + state

   -- Ranged Attacker Modifications
   if attack_info.attack.cad_ranged_attack == 1 then
      local r = attacker:GetRangedAttackMod(target)
      ab = ab + r
   end
   
   local eff_ab = attacker:GetEffectAttackBonus(target, attack_type)

   local sit_ab = attacker:GetSituationalAttackBonus()

   return ab + ab_abil + eff_ab + sit_ab
end

function DefaultCombat.GetCriticalHitMultiplier(attacker, offhand, weap_num)
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

   --print("NSGetCriticalHitMultiplier", attacker, offhand, weap_num, result)

   return result
end

function DefaultCombat.GetCriticalHitRange(attacker, offhand, weap_num)
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

   --print("NSGetCriticalHitRange", attacker, offhand, weap_num, result)

   return result
end

function DefaultCombat.GetCriticalHitRoll(attacker, offhand, weap_num)
   return 21 - NSGetCriticalHitRange(attacker, offhand, weap_num)
end

function DefaultCombat.GetDamageBonus(attacker, target, dmg_roll)
   if attacker.ci.area.dmg.dice > 0 or attacker.ci.area.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.area.dmg_type, attacker.ci.area.dmg)
   end
   if attacker.ci.class.dmg.dice > 0 or attacker.ci.class.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.class.dmg_type, attacker.ci.class.dmg)
   end
   if attacker.ci.feat.dmg.dice > 0 or attacker.ci.feat.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.feat.dmg_type, attacker.ci.feat.dmg)
   end   
   if attacker.ci.mode.dmg.dice > 0 or attacker.ci.mode.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.mode.dmg_type, attacker.ci.mode.dmg)
   end
   if attacker.ci.race.dmg.dice > 0 or attacker.ci.race.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.race.dmg_type, attacker.ci.race.dmg)
   end
   if attacker.ci.size.dmg.dice > 0 or attacker.ci.size.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.size.dmg_type, attacker.ci.size.dmg)
   end
   if attacker.ci.skill.dmg.dice > 0 or attacker.ci.skill.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.skill.dmg_type, attacker.ci.skill.dmg)
   end

   -- Favored Enemies
   if attacker.ci.fe_mask ~= 0 
      and (attacker.ci.fe.dmg.dice > 0 or attacker.ci.fe.dmg.bonus > 0)
   then
      if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
         and bit.band(attacker.ci.fe_mask, bit.lshift(1, target:GetRacialType())) ~= 0
      then
         NSAddDamageToRoll(dmg_roll, attacker.ci.fe.dmg_type, attacker.ci.fe.dmg)
      end
   end
end

function DefaultCombat.GetDamageRoll(attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   --print("NSGetDamageRoll", attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   -- If attack_info is nil then we're coming from the hook.
   if not attack_info then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      attack_info = NSGetAttackInfo(attacker, target)
   end

   local base = 0
   local attack_type

   if offhand then 
      attack_type = nwn.ATTACK_TYPE_OFFHAND
   else
      attack_type = nwn.GetAttackTypeFromEquipNum(attack_info.weapon)
   end

   -- Determine Damage Bonuses/Penalties from effects/item properties.
   local bonus, penalty = attacker:GetEffectDamageBonus(target, attack_type)

   -- Add weapons base damage to damage roll.
   NSAddDamageToRoll(bonus, nwn.DAMAGE_TYPE_BASE_WEAPON, attacker.ci.equips[attack_info.weapon].base_dmg)

   -- Add any damage bonuses from combat modifiers. E,g. size, race, etc.
   NSGetDamageBonus(attacker, target, bonus)

   -- If this is a critical hit determine the multiplier.
   local mult = 1
   if crit then
      -- Add any addition damage from the weapons crit_dmg bonus.  E,g from Overwhelming Critical.
      NSAddDamageToRoll(bonus, nwn.DAMAGE_TYPE_BASE_WEAPON, attacker.ci.equips[attack_info.weapon].crit_dmg)
      mult = NSGetCriticalHitMultiplier(attacker, offhand, attack_info.weapon)
   end

   -- Roll all the damage.
   local dmg_result = NSDoDamageRoll(bonus, penalty, mult)
   NSCompactPhysicalDamageResult(dmg_result)

   local damage_power = 1 -- TODO: FIX THIS!!

   -- situational

   -- If the target is a creature modify the damage roll by their immunities, resistances,
   -- soaks.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSDoDamageAdjustments(attacker, target, dmg_result, damage_power, attack_info)
   end

   --print(NSCreateDamageResultDebugString(attacker, target, dmg_result))

   return dmg_result
end

-- Following has some non-default stuff that needs to be fixed.
function DefaultCombat.InitializeNumberOfAttacks(cre, combat_round)
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

function DefaultCombat.ResolveAttackRoll(attacker, target, from_hook, attack_info)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
      attack_info = NSGetAttackInfo(attacker, target)
   end

   local attack_type = attack_info.attack.cad_attack_type

   local ab = 0
   local ac = 0

   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      target = nwn.OBJECT_INVALID
   end

   -- Modifier Vs
   ab = ab + NSGetAttackModifierVersus(attacker, target, attack_info, attack_type)
   attack_info.attack.cad_attack_mod = ab

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      ac = ac + NSGetArmorClassVersus(target, attacker, false, false, attack_info.attack)
   end

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in 
   -- NSResolvePostMelee/RangedDamage
   if attack_info.attack.cad_coupdegrace == 1 then
      attack_info.attack.cad_attack_result = 7
      attack_info.attack.cad_attack_roll = 20
      return
   end

   local roll = random(20)
   attack_info.attack.cad_attack_roll = roll 

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1

   if NSResolveMissChance(attacker, target, hit, attack_info)
      or NSResolveDeflectArrow(attacker, target, hit, attack_info)
      or NSResolveParry(attacker, target, hit, attack_info)
   then
      return
   end

   if not hit then
      NSSetAttackResult(attack_info, 4)
      if roll == 1 then
         attack_info.attack.cad_missed = 1
      else
         attack_info.attack.cad_missed = ac - ab + roll
      end
      return
   else
      NSSetAttackResult(attack_info, 1)
   end


   if roll > NSGetCriticalHitRoll(attacker, is_offhand, attack_info.weapon) then
      attack_info.attack.cad_threat_roll = random(20)
      attack_info.attack.cad_critical_hit = 1

      if attack_info.attack.cad_threat_roll + ab >= ac then
         if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
            and not target:GetIsImmuneToCriticalHits(attacker)
         then
            -- Is critical hit
	    NSSetAttackResult(attack_info, 3)
         else
            -- Send target immune to crits.
         end
      end
   end
end

function DefaultCombat.ResolveMeleeAttack(attacker, target, attack_count, anim, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   if not target:GetIsValid() then return end 

   local start = socket.gettime() * 1000

   local attack_info = NSGetAttackInfo(attacker, target)
   local damage_result

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSResolveTargetState(attacker, target, attack_info)
      NSResolveSituationalModifiers(attacker, target, attack_info)
   end

   for i = 0, attack_count - 1 do
      if attack_info.attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
      end

      if attack_info.attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         if attack_info.attack.cad_special_attack < 1115 and
            attacker:GetRemainingFeatUses(attack_info.attack.cad_special_attack) == 0
         then
            attack_info.attack.cad_special_attack = 0
         end
      end

      NSResolveAttackRoll(attacker, target, false, attack_info)
      if NSGetAttackResult(attack_info) then
         damage_result = NSResolveDamage(attacker, target, false, attack_info)
         NSResolvePostDamage(attacker, target, attack_info, false)
      end
      C.nwn_ResolveMeleeAnimations(attacker.obj, i, attack_count, target.obj.obj, anim)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack_info.attack.cad_special_attack ~= 0
         and NSGetAttackResult(attack_info)
      then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
	    and NSGetTotalDamage(damage_result) > 0
	 then
	    attacker:DecrementRemainingFeatUses(attack_info.attack.cad_special_attack)
	    
	    -- The resolution of Special Attacks will return an effect to be applied
	    -- or nil.
	    local success, eff = NSMeleeSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE,
						      attacker, target, attack_info)
	    if success then
	       -- Check to makes sure an effect was returned.
	       if eff then
		  -- Set effect to direct so that Lua will not delete the
		  -- effect.  It will be deleted by the combat engine.
		  eff.direct = true
		  -- Add the effect to the onhit effect list so that it can
		  -- be applied when damage is signaled.
		  C.ns_AddOnHitEffect(attack_info.attack, attacker.id, eff.eff)
	       end
	    else
	       -- If the special attack failed because it wasn't
	       -- applicable or the targets skill check (for example)
	       -- was success full set the attack result to 5.
	       attack_info.attack.cad_attack_result = 5
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    attack_info.attack.cad_attack_result = 6
	 end
      end

      attack_info.attacker_cr.cr_current_attack = attack_info.attacker_cr.cr_current_attack + 1
      NSUpdateAttackInfo(attack_info, attacker, target)
   end
   C.nwn_SignalMeleeDamage(attacker.obj, target.obj.obj, attack_count)

   local stop  = socket.gettime() * 1000
   print("NSResolveMeleeAttack", stop - start)
end

function DefaultCombat.ResolveRangedAttack(attacker, target, attack_count, a, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end
   
   -- Attack count can be modified if, say, a creature only has less arrows left than attacks
   -- or none at all.
   attack_count = attacker:GetAmmunitionAvailable(attack_count)

   -- TODO
   if not target:GetIsValid() or attack_count == 0 then
      --CNWSCombatRound__SetRoundPaused(*(_DWORD *)(a1 + 0xACC), 0, 0x7F000000u);
      --CNWSCombatRound__SetPauseTimer(*(_DWORD *)(a1 + 0xACC), 0, 0);
      --return (*(int (__cdecl **)(int, signed int))(*(_DWORD *)(a1 + 0xC) + 0x88))(a1, 1);
      return
   end

   local attack_info = NSGetAttackInfo(attacker, target)
   local dmg_result

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSResolveTargetState(attacker, target, attack_info)
      NSResolveSituationalModifiers(attacker, target, attack_info)
   end

   for i = 0, attack_count - 1 do
      if attack_info.attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
      end

      if attack_info.attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         if attack_info.attack.cad_special_attack < 1115 and
            attacker:GetRemainingFeatUses(attack_info.attack.cad_special_attack) == 0
         then
            attack_info.attack.cad_special_attack = 0
         end
      end

      -- Determmine if attack is a hit.
      NSResolveAttackRoll(attacker, target, attack_info)

      if NSGetAttackResult(attack_info) then
         dmg_result = NSResolveDamage(attacker, target, attack_info)
         NSResolvePostDamage(attacker, target, attack_info, true)
      else
         C.nwn_ResolveRangedMiss(attacker.obj, target.obj.obj)
      end

      C.nwn_ResolveRangedAnimations(attacker.obj, target.obj.obj, a)

      -- Attempt to resolve a special attack one was
      -- a) Used
      -- b) The attack is a hit.
      if attack_info.attack.cad_special_attack ~= 0
         and NSGetAttackResult(attack_info)
      then
	 -- Special attacks only apply when the target is a creature
	 -- and damage is greater than zero.
	 if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
	    and NSGetTotalDamage(dmg_result) > 0
	 then
	    attacker:DecrementRemainingFeatUses(attack_info.attack.cad_special_attack)
	    
	    -- The resolution of Special Attacks must return a boolean value indicating success and
	    -- and effect to be applied if any.
	    local success, eff = NSRangedSpecialAttack(attack_info.attack.cad_special_attack, nwn.SPECIAL_ATTACK_EVENT_RESOLVE,
						       attacker, target, attack_info)
	    if success then
	       -- Check to makes sure an effect was returned.
	       if eff then
		  -- Set effect to direct so that Lua will not delete the
		  -- effect.  It will be deleted by the combat engine.
		  eff.direct = true
		  -- Add the effect to the onhit effect list so that it can
		  -- be applied when damage is signaled.
		  NSAddOnHitEffect(attack_info, attacker, eff)
	       end
	    else
	       -- If the special attack failed because it wasn't
	       -- applicable or the targets skill check (for example)
	       -- was successful set the attack result to 5.
	       NSSetAttackResult(attack_info, 5)
	    end
	 else
	    -- If the target is not a creature or no damage was dealt set attack result to 6.
	    NSSetAttackResult(attack_info, 6)
	 end
      end

      attack_info.attacker_cr.cr_current_attack = attack_info.attacker_cr.cr_current_attack + 1
      NSUpdateAttackInfo(attack_info, attacker, target)
   end
   NSSignalRangedDamage(attacker, target, attack_count)
end

function DefaultCombat.ResolveDamage(attacker, target, from_hook, attack_info)
   --print("NSResolveDamage", attacker, target, from_hook, attack_info)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
      attack_info = NSGetAttackInfo(attacker, target)
   end

   local ki_strike = attack_info.attack.cad_special_attack == 882
   local crit = attack_info.attack.cad_attack_result == 3

   -- Following should be dealt with in special attacks.
   --if ki_strike then
   --   attack:DecrementRemainingFeatUses(882)
   --end

   local damage_result = NSGetDamageRoll(attacker, 
					 target, 
					 attack_info.is_offhand,
					 crit,
					 attack_info.attack.cad_sneak_attack == 1,
					 attack_info.attack.cad_death_attack == 1,
					 ki_strike,
					 attack_info)

   local total = NSGetTotalDamage(damage_result)

   --Defensive Roll
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and not NSCheckTargetState(attacker, nwn.COMBAT_TARGET_STATE_FLATFOOTED)
      and target:GetHasFeat(nwn.FEAT_DEFENSIVE_ROLL)
   then
      target:DecrementRemainingFeatUses(nwn.FEAT_DEFENSIVE_ROLL)
      
      if target:ReflexSave(total, nwn.SAVING_THROW_TYPE_DEATH, attacker) then
         -- TODO: Adjust individual damages.
         total = math.floor(total / 2)
      end
   end

   -- Death Attack

   -- Add the damage result info to the CNWSCombatAttackData and
   -- and EffectDamages for any custom damage
   NSAddDamageResultToAttack(attack_info, damage_result)
  
   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and total > 0
      and attack_info.attacker_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message
      
      attack_info.attack.cad_attack_result = 4
      attack_info.attacker_cr.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      end

      if total > 0 then
         C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, attack_info.is_offhand, crit)
      end

      C.nwn_ResolveItemCastSpell(attacker.obj, target.obj.obj)

      if total > 0 then
         NSResolveOnHitVisuals(attacker, target, attack_info.attack, damage_result)
      end
   end

   return damage_result
end

-- This is not default behavior.
function DefaultCombat.ResolveOnHitVisuals(attacker, target, attack, dmg_result)
   local flag
   local highest = 0
   local highest_vfx
   local vfx

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      flag = bit.lshift(1, i)
      vfx = nwn.GetDamageVFX(flag, attack.cad_ranged_attack == 1)
      if vfx and dmg_result.damages[i] > highest then
         highest_vfx = vfx
         highest = dmg_result.damages[i]
      end
   end

   if highest_vfx then
      NSAddOnHitVisualEffect(attack, attacker, highest_vfx)
   end
end

-- not default behavior
function DefaultCombat.ResolvePostDamage(attacker, target, attack_info, is_ranged)
   if not target:GetIsValid() 
      or target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE
   then 
      return
   end

   if is_ranged then
      return
   else
      NSResolveDevCrit(attacker, target, attack_info)
   end
end

return DefaultCombat