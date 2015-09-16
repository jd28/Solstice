local ffi = require 'ffi'
local C = ffi.C
local Dice = require 'solstice.dice'
local Eff = require 'solstice.effect'
local GetObjectByID = require('solstice.game').GetObjectByID

function __GetMaximumFeatUses(feat, cre)
   _SOL_LOG_INTERNAL:debug("__GetMaximumFeatUses: Creature: 0x%x, Feat: %d", cre, feat)
   cre = GetObjectByID(cre)
   return Rules.GetMaximumFeatUses(feat, cre)
end

function __GetRemainingFeatUses(feat, cre)
   _SOL_LOG_INTERNAL:debug("__GetRemainingFeatUses: Creature: 0x%x, Feat: %d", cre, feat)
   cre = GetObjectByID(cre)
   return cre:GetRemainingFeatUses(feat)
end

function __GetMaxHitpoints(id)
  local cre = GetObjectByID(id)
  if not cre:GetIsValid() then return 0 end
  return Rules.GetMaxHitPoints(cre)
end

function __GetArmorClass(cre)
   _SOL_LOG_INTERNAL:debug("__GetArmorClass: Creature: 0x%x", cre)

   cre = Game.GetObjectByID(cre)
   if not cre:GetIsValid() or cre.type ~= OBJECT_TRUETYPE_CREATURE then
      return 0
   end
   return cre:GetACVersus(OBJECT_INVALID, false)
end

function __DoMeleeAttack()
   local ce = Rules.GetCombatEngine()
   ce.DoMeleeAttack()
end

function __DoRangedAttack()
   local ce = Rules.GetCombatEngine()
   ce.DoRangedAttack()
end

function __ResolvePreAttack(attacker_, target_)
   local ce = Rules.GetCombatEngine()
   ce.DoPreAttack(GetObjectByID(attacker_), GetObjectByID(target_))
end

function __UpdateCombatInfo(attacker)
   _SOL_LOG_INTERNAL:debug("__UpdateCombatInfo: Creature: 0x%x", attacker)

   attacker = GetObjectByID(attacker)
   if not attacker:GetIsValid() then return end

   attacker:UpdateCombatInfo(true)
   local ce = Rules.GetCombatEngine()
   if ce and ce.UpdateCombatInformation then
      ce.UpdateCombatInformation(attacker)
   end
end

local result

function __DoDamageImmunity(obj, vs, amount, flags, no_feedback)
  if not result then result = damage_result_t() end
   _SOL_LOG_INTERNAL:debug("__DoDamageImmunity")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return amount end

   local idx = C.ns_BitScanFFS(flags)
   local amt, adj = cre:DoDamageImmunity(amount, idx)

   result.damages[idx] = amt
   result.immunity[idx] = adj

   if not no_feedback and cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(
                              vs_name,
                              cre:GetName(),
                              result,
                              true))
      cre:DelayCommand(0.1,
                       function (cre)
                          if cre:GetIsValid() then
                             cre:SendMessage(s)
                          end
                       end)
   end
   return amt
end

function __DoDamageResistance(obj, vs, amount, flags, no_feedback)
  if not result then result = damage_result_t() end
   _SOL_LOG_INTERNAL:debug("__DoDamageResistance")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return amount end

   local idx = C.ns_BitScanFFS(flags)

   local start

   if cre.type == OBJECT_TRUETYPE_CREATURE then
      start = cre.obj.cre_stats.cs_first_dmgresist_eff
   end

   local eff, start = cre:GetBestDamageResistEffect(idx, start)
   local amt, adj, removed = cre:DoDamageResistance(amount, eff, idx)
   result.damages[idx] = amt
   if adj > 0 then
      result.resist[idx] = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         result.resist_remaining[idx] = eff.eff_integers[2]
      end
   end

   if removed then
      local eid = eff.eff_id
      cre:DelayCommand(0.1,
                       function (self)
                          if self:GetIsValid() then
                             self:RemoveEffectByID(eid)
                          end
                       end)
   end

   if not no_feedback and cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(vs_name,
                                                      cre:GetName(),
                                                      result,
                                                      true))
      cre:DelayCommand(0.1,
                       function (cre)
                          if cre:GetIsValid() then
                             cre:SendMessage(s)
                          end
                       end)
   end

   return amt
end

function __DoDamageReduction(obj, vs, amount, power, no_feedback)
  if not result then result = damage_result_t() end
   _SOL_LOG_INTERNAL:debug("__DoDamageReduction")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return amount end

   local idx = 12
   local start

   if cre.type == OBJECT_TRUETYPE_CREATURE then
      start = cre.obj.cre_stats.cs_first_dmgred_eff
   end

   eff = cre:GetBestDamageReductionEffect(power, start)

   amt, adj, removed = cre:DoDamageReduction(amount, eff, power)
   result.damages[idx] = amt
   if adj > 0 then
      result.reduction = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         result.reduction_remaining = eff.eff_integers[2]
      end
   end

   if removed then
      local eid = eff.eff_id
      cre:DelayCommand(0.1,
                       function (self)
                          if self:GetIsValid() then
                             self:RemoveEffectByID(eid)
                          end
                       end)
   end

   if not no_feedback and cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(vs_name,
                                                      cre:GetName(),
                                                      result,
                                                      true))
      cre:DelayCommand(0.1,
                       function (cre)
                          if cre:GetIsValid() then
                             cre:SendMessage(s)
                          end
                       end)
   end

   return amt
end

function __HandleEffect()
   local data = ffi.C.Local_GetLastEffect()
   if data == nil
      or data.obj == nil
      or data.eff == nil
   then
      return
   end

   local cre = GetObjectByID(data.obj.obj_id)
   if not cre:GetIsValid() or cre.ci == nil then
      return
   end

   _SOL_LOG_INTERNAL:debug("Handling effect of type: %d, on object: 0x%x remove: %d",
                           data.eff.eff_type, data.obj.obj_id, data.is_remove and 1 or 0)

   if data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE
      or data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
   then
      Rules.UpdateDamageImmunityEffects(cre)
   elseif data.eff.eff_type == EFFECT_TYPE_IMMUNITY then
      if data.eff.eff_integers[1] == 28
         and data.eff.eff_integers[2] == 0
         and data.eff.eff_integers[3] == 0
      then
         Rules.UpdateMiscImmunityEffects(cre)
      end
   elseif data.eff.eff_type == EFFECT_TYPE_ABILITY_INCREASE
      or data.eff.eff_type == EFFECT_TYPE_ABILITY_DECREASE
   then
      Rules.UpdateAbilityEffects(cre)
   elseif data.eff.eff_type == EFFECT_TYPE_ATTACK_INCREASE
      or data.eff.eff_type == EFFECT_TYPE_ATTACK_DECREASE
   then
      Rules.UpdateAttackBonusEffects(cre)
   end
end

function __GetEffectImmunity(obj, imm)
   _SOL_LOG_INTERNAL:debug("__GetEffectImmunity: 0x%x, %d", obj, imm)
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return false end
   return cre:GetIsImmune(imm, OBJECT_INVALID)
end

function __GetSaveEffectBonus(obj, save, save_vs)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end
   local min, max = Rules.GetSaveEffectLimits(obj, save, save_vs)
   local eff = Rules.GetSaveEffectBonus(obj, save, save_vs)
   return  math.clamp(eff, min, max)
end

function __GetAbilityEffectBonus(obj, ability)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end
   local min, max = Rules.GetAbilityEffectLimits(obj, ability)
   local eff = Rules.GetAbilityEffectModifier(obj, ability)
   eff = math.clamp(eff, min, max)

   -- Just to make sure...that the modifiers are updated.
   -- Depending on how abilities are implemented it can be
   -- an issue.
   local base = obj:GetAbilityScore(ability, true) + eff
   local mod  = math.floor((base - 10) / 2)
   if ability == ABILITY_STRENGTH then
      obj.obj.cre_stats.cs_str_mod = mod
   elseif ability == ABILITY_DEXTERITY then
      obj.obj.cre_stats.cs_dex_mod = mod
   elseif ability == ABILITY_CONSTITUTION then
      obj.obj.cre_stats.cs_con_mod = mod
   elseif ability == ABILITY_INTELLIGENCE then
      obj.obj.cre_stats.cs_int_mod = mod
   elseif ability == ABILITY_WISDOM then
      obj.obj.cre_stats.cs_wis_mod = mod
   elseif ability == ABILITY_CHARISMA then
      obj.obj.cre_stats.cs_cha_mod = mod
   end
   return eff
end

function __GetSkillEffectBonus(obj, skill)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end

   local min, max = Rules.GetSkillEffectLimits(obj, skill)
   local eff = Rules.GetSkillEffectModifier(obj, skill)
   return math.clamp(eff, min, max)
end

function __InitializeNumberOfAttacks(id)
    local cre = GetObjectByID(id)
    if not cre:GetIsValid() then return end
    Rules.InitializeNumberOfAttacks(cre)
end

function __GetWeaponFinesse(obj, it)
   local cre  = GetObjectByID(obj)
   local item = GetObjectByID(it)
   return Rules.GetIsWeaponFinessable(item, cre)
end

function __GetCriticalHitMultiplier(obj, is_offhand)
   local attacker = GetObjectByID(obj)
   if not attacker:GetIsValid() then return 0 end
   local equip = EQUIP_TYPE_UNARMED
   local it
   if is_offhand then
      it = attacker:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if not it:GetIsValid() or Rules.BaseitemToWeapon(it) == 0 then
         return 0
      end
      equip = EQUIP_TYPE_OFFHAND
   else
      it = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if it:GetIsValid() and Rules.BaseitemToWeapon(it) ~= 0 then
         equip = EQUIP_TYPE_ONHAND
      end
   end
   return attacker.ci.equips[equip].crit_mult
end

function __GetCriticalHitRoll(obj, is_offhand)
   local attacker = GetObjectByID(obj)
   if not attacker:GetIsValid() then return 0 end
   local equip = EQUIP_TYPE_UNARMED
   local it
   if is_offhand then
      it = attacker:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if not it:GetIsValid() or Rules.BaseitemToWeapon(it) == 0 then
         return 0
      end
      equip = EQUIP_TYPE_OFFHAND
   else
      it = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if it:GetIsValid() and Rules.BaseitemToWeapon(it) ~= 0 then
         equip = EQUIP_TYPE_ONHAND
      end
   end
   return 21 - attacker.ci.equips[equip].crit_range
end

function __ResolveDamageShields(cre, attacker)
   _SOL_LOG_INTERNAL:debug("__ResolveDamageShields: 0x%x, 0x%x",
                           cre, attacker)

   cre = GetObjectByID(cre)
   attacker = GetObjectByID(attacker)

   for i = cre.obj.cre_stats.cs_first_dmgshield_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_SHIELD then
         break
      end
      local ip = cre.obj.obj.obj_effects[i].eff_integers[1]
      local d, s, b = Rules.UnpackItempropDamageRoll(ip)
      b = b + cre.obj.obj.obj_effects[i].eff_integers[0]
      local dflag = cre.obj.obj.obj_effects[i].eff_integers[2]
      local chance = cre.obj.obj.obj_effects[i].eff_integers[3]

      if chance == 0 or math.random(chance) <= chance then
         local dindex = ffi.C.ns_BitScanFFS(dflag)
         local amt = Dice.Roll(d, s, b)
         -- This HAS to be in a delay command as apply damage immediately
         -- might cause the cross the Lua/C boundary multiple times.
         cre:DelayCommand(0.1,
                          function (self)
                             if attacker:GetIsValid() and self:GetIsValid() then
                                local e = Eff.Damage(amt, dindex)
                                e:SetCreator(self)
                                attacker:ApplyEffect(DURATION_TYPE_INSTANT, e)
                             end
                          end)
      end
   end
end
