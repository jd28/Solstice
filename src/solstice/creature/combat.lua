--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

local TDA = require 'solstice.2da'
local ffi = require 'ffi'
local C = ffi.C

local random = math.random
local floor  = math.floor
local min    = math.min
local max    = math.max

local bit    = require 'bit'
local lshift = bit.lshift
local bor    = bit.bor
local band   = bit.band
local sm     = string.strip_margin

local NWE = require 'solstice.nwn.engine'

local Creature = M.Creature

--- Combat
-- @section

local M = require 'solstice.creature.init'

--- Get creatures total damage immunity.
-- @param dmgidx DAMAMGE\_INDEX\_*
function M.Creature:GetDamageImmunity(dmgidx)
   -- If the damage index is invalid... skip it.
   if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM then
      return 0
   end
   return math.clamp(self.ci.defense.immunity[dmgidx] +
                     self.ci.defense.immunity_base[dmgidx],
                     0, 100)
end

--- Gets innate damage immunity.
-- @param dmg_idx damage type index
function Creature:GetInnateDamageImmunity(dmg_idx)
   return Rules.GetBaseDamageImmunity(self, dmg_idx)
end

--- Gets innate damage immunity.
function Creature:GetInnateDamageReduction()
   return Rules.GetBaseDamageReduction(self)
end

--- Get innate/feat damage resistance.
-- @param dmg_idx
function Creature:GetInnateDamageResistance(dmg_idx)
   return Rules.GetBaseDamageResistance(self, dmg_idx)
end

--- Get creatures innate soak.
-- Note: This name was chosen to match other
-- on creature objects, that have Hardness.
function M.Creature:GetHardness()
   return self.ci.defense.soak
end

--- Adds parry attack.
-- @param attacker Attacker to do parry attack against.
function M.Creature:AddParryAttack(attacker)
   C.nwn_AddParryAttack(self.obj.cre_combat_round, attacker.id)
end

--- Get creature's arcane spell failure.
function M.Creature:GetArcaneSpellFailure()
   if not self:GetIsValid() then return 0 end
   local amt = self.obj.cre_stats.cs_arcane_sp_fail_2 + self.obj.cre_stats.cs_arcane_sp_fail_1 + self.obj.cre_stats.cs_arcane_sp_fail_3
   return math.clamp(amt, 0, 100)
end

--- Get creature's attack target
function M.Creature:GetAttackTarget()
   if not self:GetIsValid() then return OBJECT_INVALID end
   local obj = self.obj.cre_attack_target
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Get creature's attempted attack target
function M.Creature:GetAttemptedAttackTarget()
   if not self:GetIsValid() then return OBJECT_INVALID end

   NWE.ExecuteCommand(361, 0)
   return NWE.StackPopObject()
end

--- Get creature's attempted spell target
function M.Creature:GetAttemptedSpellTarget()
   if not self:GetIsValid() then return OBJECT_INVALID end

   NWE.ExecuteCommand(375, 0)
   return NWE.StackPopObject()
end

--- Get creature's challenge rating
function M.Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_stats.cs_cr
end

--- Get creature's combat mode
function M.Creature:GetCombatMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_mode_combat
end

--- Get Concealment
function M.Creature:GetConcealment(vs, is_ranged)
   return Rules.GetConcealment(self, vs, is_ranged)
end

---
function M.Creature:GetCriticalHitMultiplier(is_offhand, equip)
   return self.ci.equips[equip].crit_mult
end

---
function M.Creature:GetCriticalHitRange(is_offhand, equip)
   return self.ci.equips[equip].crit_range
end

--- Get creature's damage flags.
function M.Creature:GetDamageFlags()
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetDamageFlags(self.obj)
end

--- Get creatures attacker.
function M.Creature:GetGoingToBeAttackedBy()
   if not self:GetIsValid() then return OBJECT_INVALID end

   local obj = self.obj.cre_attacker
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Determines if creature is immune to critical hits.
-- @param attacker Attacker
function M.Creature:GetIsImmuneToCriticalHits(attacker)
   --TODO: FIx or Remove
   return false
end

--- Determines if creature is immune to sneak/death attacks.
--    Ignores immunity to critical hits.
-- @param attacker Attacker
function M.Creature:GetIsImmuneToSneakAttack(attacker)
   --TODO: FIx or Remove
   return false
end

--- Determines if creature is in combat.
function M.Creature:GetIsInCombat()
   if not self:GetIsValid() then return false end
   return self.obj.cre_combat_state ~= 0
end

--- Get's last attack type used by creature.
function M.Creature:GetLastAttackType()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_type
end

--- Get's last attack mode used by creature.
function M.Creature:GetLastAttackMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_last_attack_mode
end

--- Get's last trap detected by creature.
function M.Creature:GetLastTrapDetected()
   if not self:GetIsValid() then return OBJECT_INVALID end
   local obj = self.obj.cre_last_trap_detected
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Get's last weapon used by creature.
function M.Creature:GetLastWeaponUsed()
   if not self:GetIsValid() then return OBJECT_INVALID end
   local obj = self.obj.obj.obj_last_attack_weapon
   return _SOL_GET_CACHED_OBJECT(obj)
end

--- Determines creatures maximum attack range.
-- @param target Target to attack
function M.Creature:GetMaxAttackRange(target)
   return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

--- Get miss chance
function M.Creature:GetMissChance(vs, is_ranged)
   return Rules.GetMissChance(self, vs, is_ranged)
end

--- Determines reflex saved damage adjustment.
-- @param damage Total damage.
-- @param dc Difficulty class
-- @param savetype solstice.save constant.
-- @param versus Creature to roll against.
function M.Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   NWE.StackPushObject(versus)
   NWE.StackPushInteger(savetype)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(damage)
   NWE.ExecuteCommand(299, 5)
   return NWE.StackPopInteger()
end

--- Get target state bit mask.
-- @param target Creature target.
function M.Creature:GetTargetState(target)
   if not target:GetIsValid() or
      target.type ~= OBJECT_TRUETYPE_CREATURE
   then
      return 0
   end

   local res = 0
   if target:GetIsBlind() then
      res = bor(res, COMBAT_TARGET_STATE_BLIND)
   end

   if target:GetIsInvisible(self) then
      res = bor(res, COMBAT_TARGET_STATE_ATTACKER_INVIS)
   end

   if self:GetIsInvisible(target) then
      res = bor(res, COMBAT_TARGET_STATE_INVIS)
   end

   if not self:GetIsSeen(target) then
      res = bor(res, COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
   end

   if not target:GetIsSeen(self) then
      res = bor(res, COMBAT_TARGET_STATE_UNSEEN)
   end

    if target.obj.obj.obj_anim == 4  or
       target.obj.obj.obj_anim == 87 or
       target.obj.obj.obj_anim == 86
    then
       res = bor(res, COMBAT_TARGET_STATE_MOVING)
    end

    if target.obj.obj.obj_anim == 36  or
       target.obj.obj.obj_anim == 33 or
       target.obj.obj.obj_anim == 32 or
       target.obj.obj.obj_anim == 5
    then
       res = bor(res, COMBAT_TARGET_STATE_PRONE)
    end

    if target.obj.cre_state == 6 then
       res = bor(res, COMBAT_TARGET_STATE_STUNNED)
    end

    if target.obj.cre_state == 9 or target.obj.cre_state == 8 then
       res = bor(res, COMBAT_TARGET_STATE_ASLEEP)
    end

    if self:GetIsFlanked(target) then
       res = bor(res, COMBAT_TARGET_STATE_FLANKED)
    end

    if target:GetIsFlatfooted() then
       res = bor(res, COMBAT_TARGET_STATE_FLATFOOTED)
    end

    return res
end

--- Determine Creatures Favored Enemey Bit Mask.
function M.Creature:GetFavoredEnemenyMask()
   local res = 0

   local function FE(feat, race)
      if self:GetHasFeat(feat) then
         res = bor(res, lshift(1, race))
      end
   end

   FE(FEAT_FAVORED_ENEMY_DWARF, RACIAL_TYPE_DWARF);
   FE(FEAT_FAVORED_ENEMY_ELF, RACIAL_TYPE_ELF);
   FE(FEAT_FAVORED_ENEMY_GNOME, RACIAL_TYPE_GNOME);
   FE(FEAT_FAVORED_ENEMY_HALFLING, RACIAL_TYPE_HALFLING);
   FE(FEAT_FAVORED_ENEMY_HALFELF, RACIAL_TYPE_HALFELF);
   FE(FEAT_FAVORED_ENEMY_HALFORC, RACIAL_TYPE_HALFORC);
   FE(FEAT_FAVORED_ENEMY_HUMAN, RACIAL_TYPE_HUMAN);
   FE(FEAT_FAVORED_ENEMY_ABERRATION, RACIAL_TYPE_ABERRATION);
   FE(FEAT_FAVORED_ENEMY_ANIMAL, RACIAL_TYPE_ANIMAL);
   FE(FEAT_FAVORED_ENEMY_BEAST, RACIAL_TYPE_BEAST);
   FE(FEAT_FAVORED_ENEMY_CONSTRUCT, RACIAL_TYPE_CONSTRUCT);
   FE(FEAT_FAVORED_ENEMY_DRAGON, RACIAL_TYPE_DRAGON);
   FE(FEAT_FAVORED_ENEMY_GOBLINOID, RACIAL_TYPE_HUMANOID_GOBLINOID);
   FE(FEAT_FAVORED_ENEMY_MONSTROUS, RACIAL_TYPE_HUMANOID_MONSTROUS);
   FE(FEAT_FAVORED_ENEMY_ORC, RACIAL_TYPE_HUMANOID_ORC);
   FE(FEAT_FAVORED_ENEMY_REPTILIAN, RACIAL_TYPE_HUMANOID_REPTILIAN);
   FE(FEAT_FAVORED_ENEMY_ELEMENTAL, RACIAL_TYPE_ELEMENTAL);
   FE(FEAT_FAVORED_ENEMY_FEY, RACIAL_TYPE_FEY);
   FE(FEAT_FAVORED_ENEMY_GIANT, RACIAL_TYPE_GIANT);
   FE(FEAT_FAVORED_ENEMY_MAGICAL_BEAST, RACIAL_TYPE_MAGICAL_BEAST);
   FE(FEAT_FAVORED_ENEMY_OUTSIDER, RACIAL_TYPE_OUTSIDER);
   FE(FEAT_FAVORED_ENEMY_SHAPECHANGER, RACIAL_TYPE_SHAPECHANGER);
   FE(FEAT_FAVORED_ENEMY_UNDEAD, RACIAL_TYPE_UNDEAD);
   FE(FEAT_FAVORED_ENEMY_VERMIN, RACIAL_TYPE_VERMIN);

   return res
end

--- Determine if creature is favored enemy.
function M.Creature:GetIsFavoredEnemy(vs)
   if not vs:GetIsValid()
      or vs.type ~= OBJECT_TRUETYPE_CREATURE
   then
      return false
   end

   return band(self.ci.fe_mask, lshift(1, vs:GetRacialType())) ~= 0
end

--- Determine if creature training vs.
function M.Creature:GetHasTrainingVs(vs)
   if not vs:GetIsValid()
      or vs.type ~= OBJECT_TRUETYPE_CREATURE
   then
      return false
   end
   return band(self.ci.training_vs_mask, lshift(1, vs:GetRacialType())) ~= 0
end

function M.Creature:GetTrainingVsMask()
   local res = 0

   if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_ORCS) then
      res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_ORC))
   end

   if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_GOBLINS) then
      res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_GOBLINOID))
   end

   if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_GIANTS) then
      res = bor(res, lshift(1, RACIAL_TYPE_GIANT))
   end

   if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS) then
      res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_REPTILIAN))
   end
   return res
end

--- Determines turn resistance hit dice.
function M.Creature:GetTurnResistanceHD()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(478, 1)
   NWE.StackPopInteger()
end

--- Restores a creature's base number of attacks.
function M.Creature:RestoreBaseAttackBonus()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(756, 1)
end

--- Sets a creature's base number of attacks.
-- @param amount Amount of attacks.
function M.Creature:SetBaseAttackBonus(amount)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(amount)
   NWE.ExecuteCommand(755, 2)
end

--- Causes all creatures in a 10 meter (1 tile) radius to stop actions.
-- Improves the creature's reputation with nearby enemies for 3 minutes. Only works for NPCs.
function M.Creature:SurrenderToEnemies()
   NWE.ExecuteCommand(476, 0);
end

--- Creates debug string for combat info equips
function M.Creature:DebugCombatEquips()
   local t = {}
   local fmt = sm([[ID: %x:
                   |   Ability AB: %d, Ability Damage Bonus: %d, Base Damage: %dd%d + %d,
                   |   Base Damage Type(s): %x, Crit Range: %d, Crit Multiplier: %d,
                   |   Power: %d, Has Dev Crit: %d, Iteration: %d, AB Modifier: %d,
                   |   Transient AB Modifier: %d]])

   for i = 0, 5 do
      table.insert(t, string.format(fmt,
                                    self.ci.equips[i].id,
                                    self.ci.equips[i].ab_ability,
                                    self.ci.equips[i].dmg_ability,
                                    self.ci.equips[i].base_dmg_roll.dice,
                                    self.ci.equips[i].base_dmg_roll.sides,
                                    self.ci.equips[i].base_dmg_roll.bonus,
                                    self.ci.equips[i].base_dmg_flags,
                                    self.ci.equips[i].crit_range,
                                    self.ci.equips[i].crit_mult,
                                    self.ci.equips[i].power,
                                    self.ci.equips[i].has_dev_crit and 1 or 0,
                                    self.ci.equips[i].iter,
                                    self.ci.equips[i].ab_mod,
                                    self.ci.equips[i].transient_ab_mod))
   end

   return table.concat(t, '\n\n')
end

----------------------------------------------------------------------
-- Combat information update functions.

---
local function UpdateDamageImmunity(self)
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      self.ci.defense.immunity_base[i] = self:GetInnateDamageImmunity(i)
   end
end

---
local function UpdateDamageResistance(self)
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      self.ci.defense.resist[i] = self:GetInnateDamageResistance(i)
   end
end

local function UpdateDamageReduction(self)
   self.ci.defense.soak = self:GetInnateDamageReduction()
end

local function UpdateAttacks(self)
   self.ci.offense.attacks_on  = Rules.GetOnhandAttacks(self)
   self.ci.offense.attacks_off = Rules.GetOffhandAttacks(self)
end

--- Updates equipped weapon object IDs.
local function UpdateCombatEquips(self)
   -- Determine the ranged weapon type, this is used in the combat engine
   -- to check if we can load more ammunition
   local rng_type = RANGED_TYPE_INVALID
   local rh = self:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if rh:GetIsValid() and Rules.GetIsRangedWeapon(rh) then
      local base = rh:GetBaseType()
      if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
         rng_type = RANGED_TYPE_BOW
      elseif base == BASE_ITEM_HEAVYCROSSBOW or base == BASE_ITEM_LIGHTCROSSBOW then
         rng_type = RANGED_TYPE_CROSSBOW
      elseif base == BASE_ITEM_THROWINGAXE then
         rng_type = RANGED_TYPE_THROWAXE
      elseif base == BASE_ITEM_SLING then
         rng_type = RANGED_TYPE_SLING
      elseif base == BASE_ITEM_DART then
         rng_type = RANGED_TYPE_DART
      elseif base == BASE_ITEM_SHURIKEN then
         rng_type = RANGED_TYPE_SHURIKEN
      end
      self.ci.offense.ranged_type = rng_type
   end

   local is_double = TDA.Get2daInt("wpnprops", "Type", Rules.BaseitemToWeapon(rh)) == 7

   self.ci.equips[0].id = rh.id
   if is_double then
      self.ci.equips[1].id = rh.id
   else
      self.ci.equips[1].id = self:GetItemInSlot(INVENTORY_SLOT_LEFTHAND).id
   end
   self.ci.equips[2].id = self:GetItemInSlot(INVENTORY_SLOT_ARMS).id
   self.ci.equips[3].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_L).id
   self.ci.equips[4].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_R).id
   self.ci.equips[5].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_B).id
end

function get_equip(cre, creator)
   for i=0, EQUIP_TYPE_NUM - 1 do
      if creator == cre.ci.equips[i].id then
         return i
      end
   end
   return -1
end

local function UpdateAttackBonus(self)
   self.ci.offense.ab_base = self:GetBaseAttackBonus()

   self.ci.offense.offhand_penalty_on,
   self.ci.offense.offhand_penalty_off = Rules.GetDualWieldPenalty(self)

   local bon, pen = {}, {}

   for i = self.obj.cre_stats.cs_first_ab_eff, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ATTACK_INCREASE and
         self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ATTACK_DECREASE
      then
         break
      end

      local amount    = self.obj.obj.obj_effects[i].eff_integers[0]
      local atktype   = self.obj.obj.obj_effects[i].eff_integers[1]
      local race      = self.obj.obj.obj_effects[i].eff_integers[2]
      local lawchaos  = self.obj.obj.obj_effects[i].eff_integers[3]
      local goodevil  = self.obj.obj.obj_effects[i].eff_integers[4]

      bon[atktype] = bon[atktype] or 0
      pen[atktype] = pen[atktype] or 0

      if race == 28 and lawchaos == 0 and goodevil == 0 then
         if self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_INCREASE then
            bon[atktype] = bon[atktype] + amount
         elseif self.obj.obj.obj_effects[i].eff_type ==  EFFECT_TYPE_ATTACK_DECREASE then
            pen[atktype] = pen[atktype] + amount
         end
      end
   end

   self.ci.offense.ab_transient =
      (bon[ATTACK_TYPE_MISC] or 0) - (pen[ATTACK_TYPE_MISC] or 0)

   self.ci.equips[EQUIP_TYPE_ONHAND].transient_ab_mod =
      (bon[ATTACK_TYPE_ONHAND] or 0) - (pen[ATTACK_TYPE_ONHAND] or 0)

   self.ci.equips[EQUIP_TYPE_OFFHAND].transient_ab_mod =
      (bon[ATTACK_TYPE_OFFHAND] or 0) - (pen[ATTACK_TYPE_OFFHAND] or 0)

   self.ci.equips[EQUIP_TYPE_UNARMED].transient_ab_mod =
      (bon[ATTACK_TYPE_UNARMED] or 0) - (pen[ATTACK_TYPE_UNARMED] or 0)

   self.ci.equips[EQUIP_TYPE_CREATURE_1].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON1] or 0) - (pen[ATTACK_TYPE_CWEAPON1] or 0)

   self.ci.equips[EQUIP_TYPE_CREATURE_2].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON2] or 0) - (pen[ATTACK_TYPE_CWEAPON2] or 0)

   self.ci.equips[EQUIP_TYPE_CREATURE_3].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON3] or 0) - (pen[ATTACK_TYPE_CWEAPON3] or 0)
end

local function AddDamageToEquip(self, equip_num, type, dice, sides, bonus, mask)
   local len = self.ci.equips[equip_num].damage_len
   self.ci.equips[equip_num].damage[len].type = type
   self.ci.equips[equip_num].damage[len].roll.dice,
   self.ci.equips[equip_num].damage[len].roll.sides,
   self.ci.equips[equip_num].damage[len].roll.bonus = dice, sides, bonus
   self.ci.equips[equip_num].damage[len].mask = mask
   self.ci.equips[equip_num].damage_len = len + 1
end

local function UpdateImmunities(self)
   ffi.fill(self.ci.defense.immunity_misc, 4*IMMUNITY_TYPE_NUM)
   if self.obj.cre_stats.cs_first_imm_eff < 0 then return end
   for i = self.obj.cre_stats.cs_first_imm_eff, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_IMMUNITY then break end

      if self.obj.obj.obj_effects[i].eff_integers[1] == 28
         and self.obj.obj.obj_effects[i].eff_integers[2] == 0
         and self.obj.obj.obj_effects[i].eff_integers[3] == 0
      then
         local amt = self.obj.obj.obj_effects[i].eff_integers[4]
         amt = amt == 0 and 100 or amt

         self.ci.defense.immunity_misc[self.obj.obj.obj_effects[i].eff_integers[0]] =
            self.ci.defense.immunity_misc[self.obj.obj.obj_effects[i].eff_integers[0]] + amt
      end
   end
end

-- Determines creature's weapon combat info.
local function UpdateCombatWeaponInfo(self)
   local weap
   for i = 0, EQUIP_TYPE_NUM - 1 do
      weap = _SOL_GET_CACHED_OBJECT(self.ci.equips[i].id)
      if weap:GetIsValid() or i == EQUIP_TYPE_UNARMED then

         self.ci.equips[i].ab_mod         = Rules.GetWeaponAttackBonus(self, weap)
         self.ci.equips[i].ab_ability     = Rules.GetWeaponAttackAbility(self, weap)
         self.ci.equips[i].dmg_ability    = Rules.GetWeaponDamageAbility(self, weap)
         self.ci.equips[i].iter           = Rules.GetWeaponIteration(self, weap)
         self.ci.equips[i].base_dmg_flags = Rules.GetWeaponBaseDamageType(weap)
         self.ci.equips[i].power          = Rules.GetWeaponPower(self, weap)
         if i == EQUIP_TYPE_UNARMED then
            self.ci.equips[i].base_dmg_roll.dice,
            self.ci.equips[i].base_dmg_roll.sides,
            self.ci.equips[i].base_dmg_roll.bonus = Rules.GetUnarmedDamageBonus(self)
         else
            self.ci.equips[i].base_dmg_roll.dice,
            self.ci.equips[i].base_dmg_roll.sides,
            self.ci.equips[i].base_dmg_roll.bonus = Rules.GetWeaponBaseDamage(weap, self)
         end

         self.ci.equips[i].crit_range     = Rules.GetWeaponCritRange(self, weap)
         self.ci.equips[i].crit_mult      = Rules.GetWeaponCritMultiplier(self, weap)
         self.ci.equips[i].damage_len     = 0
      else
         self.ci.equips[i].ab_mod = 0
         self.ci.equips[i].ab_ability = 0
         self.ci.equips[i].dmg_ability = 0
         self.ci.equips[i].base_dmg_roll.dice,
         self.ci.equips[i].base_dmg_roll.sides,
         self.ci.equips[i].base_dmg_roll.bonus = 0, 0, 0
         self.ci.equips[i].base_dmg_flags = 0
         self.ci.equips[i].crit_range = 0
         self.ci.equips[i].crit_mult = 0
         self.ci.equips[i].damage_len = 0
      end
   end
end


local function UpdateAmmoDamage(self)
   local obj
   if self.ci.offense.ranged_type == RANGED_TYPE_BOW then
      obj = self:GetItemInSlot(INVENTORY_SLOT_ARROWS)
   elseif self.ci.offense.ranged_type == RANGED_TYPE_SLING then
      obj = self:GetItemInSlot(INVENTORY_SLOT_BULLETS)
   elseif self.ci.offense.ranged_type == RANGED_TYPE_CROSSBOW then
      obj = self:GetItemInSlot(INVENTORY_SLOT_BOLTS)
   else
      return
   end

   if not obj:GetIsValid() then return end

   for _it, ip in obj:ItemProperties() do
      if ip:GetPropertyType() == ITEM_PROPERTY_DAMAGE_BONUS then
         local type = ip:GetPropertySubType()
         if type > 2 then type = type - 2 end
         local dice, sides, bonus = Rules.UnpackItempropDamageRoll(ip:GetCostTableValue())

         AddDamageToEquip(self, 0, type, dice, sides, bonus, 0)
      end
   end

end

local function UpdateDamage(self)
   self.ci.offense.damage_len = 0

   for i = self.obj.cre_stats.cs_first_dmg_eff, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_DECREASE and
         self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_INCREASE
      then
         break
      end

      local type      = C.ns_BitScanFFS(self.obj.obj.obj_effects[i].eff_integers[1])
      local race      = self.obj.obj.obj_effects[i].eff_integers[2]
      local start     = self.obj.obj.obj_effects[i].eff_integers[3]
      local stop      = self.obj.obj.obj_effects[i].eff_integers[4]
      local att_type  = self.obj.obj.obj_effects[i].eff_integers[5]
      local mask      = self.obj.obj.obj_effects[i].eff_integers[6]
      local range     = self.obj.obj.obj_effects[i].eff_integers[7] == 1

      if race == 28 then
         if att_type == ATTACK_TYPE_MISC then
            local len = self.ci.offense.damage_len

            if self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_DECREASE then
               self.ci.offense.damage[len].mask = mask == 0 and 1 or mask
            else
               self.ci.offense.damage[len].mask = mask
            end

            self.ci.offense.damage[len].type = type

            if range then
               self.ci.offense.damage[len].roll.dice,
               self.ci.offense.damage[len].roll.sides,
               self.ci.offense.damage[len].roll.bonus = 1, stop - start + 1, start - 1
            else
               self.ci.offense.damage[len].roll.dice,
               self.ci.offense.damage[len].roll.sides,
               self.ci.offense.damage[len].roll.bonus = Rules.UnpackItempropDamageRoll(self.obj.obj.obj_effects[i].eff_integers[0])
            end
            self.ci.offense.damage_len = len + 1
         else
            local e = Rules.AttackTypeToEquipType(att_type)
            local d, s, b = 0, 0, 0
            if range then
               d, s, b = 1, stop - start + 1, start - 1
            else
               d, s, b = Rules.UnpackItempropDamageRoll(self.obj.obj.obj_effects[i].eff_integers[0])
            end

            AddDamageToEquip(self, e, type, d, s, b,
                             self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_DECREASE and 1 or 0)
         end
      end
   end
end

local function UpdateCriticalDamage(self, equip_num, item)
   if item:GetIsValid() then
      for _it, ip in item:ItemProperties() do
         if ip:GetPropertyType() == ITEM_PROPERTY_MASSIVE_CRITICALS then
            local d, s, b = Rules.UnpackItempropDamageRoll(ip:GetCostTableValue())
            AddDamageToEquip(self, equip_num,
                             DAMAGE_INDEX_BASE_WEAPON,
                             d, s, b,
                             2)
            break
         end
      end
   end

   local feat = Rules.GetWeaponFeat(MASTERWEAPON_FEAT_CRIT_OVERWHELMING, item)
   if feat ~= -1 and self:GetHasFeat(feat) then
      AddDamageToEquip(self, equip_num,
                       DAMAGE_INDEX_BASE_WEAPON,
                       self.ci.equips[equip_num].crit_mult,
                       6,
                       0,
                       2)
   end
end

--- Updates a creature's combat modifiers.
-- See ConbatMod ctype.
-- @bool all Force all combat information to be updated.
function M.Creature:UpdateCombatInfo(all)
   if not all and self.ci.update_flags == 0 then return end

   if self.ci.update_flags == -1 then
      all = true
   end

   if all then
      UpdateCombatEquips(self)
      UpdateCombatWeaponInfo(self)
      self.ci.fe_mask = self:GetFavoredEnemenyMask()
      self.ci.training_vs_mask = self:GetTrainingVsMask()
      Rules.ResolveCombatModifiers(self)
      Rules.ResolveSituationModifiers(self)
      UpdateAttacks(self)
   end

   if all or bit.band(self.ci.update_flags, COMBAT_UPDATE_DAMAGE) then
      UpdateDamage(self)
      if self.ci.offense.ranged_type > 0 then
         UpdateAmmoDamage(self)
      end
      for i = 0, EQUIP_TYPE_NUM - 1 do
         weap = _SOL_GET_CACHED_OBJECT(self.ci.equips[i].id)
         UpdateCriticalDamage(self, i, weap)
      end
   end

   if all or bit.band(self.ci.update_flags, COMBAT_UPDATE_ATTACK_BONUS) then
      UpdateAttackBonus(self)
   end

   if all or bit.band(self.ci.update_flags, COMBAT_UPDATE_DAMAGE_REDUCTION) then
      UpdateDamageReduction(self)
   end

   if all or bit.band(self.ci.update_flags, COMBAT_UPDATE_DAMAGE_RESISTANCE) then
      UpdateDamageResistance(self)
   end
   UpdateDamageImmunity(self)
   UpdateImmunities(self)

   self.ci.update_flags = 0
end
