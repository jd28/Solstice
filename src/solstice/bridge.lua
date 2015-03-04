local ffi = require 'ffi'
local C = ffi.C
local Dice = require 'solstice.dice'
local Eff = require 'solstice.effect'
local GetObjectByID = require('solstice.game').GetObjectByID

function NWNXSolstice_GetMaximumFeatUses(feat, cre)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_GetMaximumFeatUses: Creature: 0x%x, Feat: %d", cre, feat)
   cre = GetObjectByID(cre)
   return Rules.GetMaximumFeatUses(feat, cre)
end

function NWNXSolstice_GetRemainingFeatUses(feat, cre)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_GetRemainingFeatUses: Creature: 0x%x, Feat: %d", cre, feat)
   cre = GetObjectByID(cre)
   return cre:GetRemainingFeatUses(feat)
end

function NWNXSolstice_GetMaxHitpoints(id)
   --_SOL_LOG_INTERNAL:debug("NWNXSolstice_GetMaxHitpoints: Creature: 0x%x", id)

   local cre = GetObjectByID(id)
   if not cre:GetIsValid() then return 0 end
   return cre:GetMaxHitPoints()
end

function NWNXSolstice_GetArmorClass(cre)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_GetArmorClass: Creature: 0x%x", cre)

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
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_GetArmorClass: Creature: 0x%x", attacker)

   attacker = GetObjectByID(attacker)
   attacker:UpdateCombatInfo(true)
   local ce = Rules.GetCombatEngine()
   if ce and ce.UpdateCombatInformation then
      ce.UpdateCombatInformation(attacker)
   end
end

local result = damage_result_t()

function NWNXSolstice_DoDamageImmunity(obj, vs, amount, flags, no_feedback)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_DoDamageImmunity")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
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
      cre:DelayCommand(0.1, function (cre) cre:SendMessage(s) end)
   end
   return amt
end

function NWNXSolstice_DoDamageResistance(obj, vs, amount, flags, no_feedback)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_DoDamageResistance")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
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
                          self:RemoveEffectByID(eid)
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
      cre:DelayCommand(0.1, function (cre) cre:SendMessage(s) end)
   end

   return amt
end

function NWNXSolstice_DoDamageReduction(obj, vs, amount, power,
                                        no_feedback)
   _SOL_LOG_INTERNAL:debug("NWNXSolstice_DoDamageReduction")
   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj)
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
                          self:RemoveEffectByID(eid)
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
      cre:DelayCommand(0.1, function (cre) cre:SendMessage(s) end)
   end

   return amt
end

function NWNXSolstice_HandleEffect()
   local data = ffi.C.Local_GetLastEffect()
   if data == nil
      or data.obj == nil
      or data.eff == nil
   then
      return
   end

   local cre = GetObjectByID(data.obj.obj_id)
   if not cre:GetIsValid() then return end

   if data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE then
      local idx = C.ns_BitScanFFS(data.eff.eff_integers[0])
      local amt = data.eff.eff_integers[1]
      if data.is_remove then amt = -amt end
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   elseif data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then
      local idx = C.ns_BitScanFFS(data.eff.eff_integers[0])
      local amt = data.eff.eff_integers[1]
      if not data.is_remove then amt = -amt end
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   elseif data.eff.eff_type == EFFECT_TYPE_IMMUNITY then
      if data.eff.eff_integers[1] == 28
         and data.eff.eff_integers[2] == 0
         and data.eff.eff_integers[3] == 0
      then
         local amt = data.eff.eff_integers[4]
         amt = amt == 0 and 100 or amt
         local idx = data.eff.eff_integers[0]
         if data.is_remove then amt = -amt end
         cre.ci.defense.immunity_misc[idx] = cre.ci.defense.immunity_misc[idx] + amt
      end
   elseif data.eff.eff_type == EFFECT_TYPE_ABILITY_INCREASE then
      local idx = data.eff.eff_integers[0]
      local amt = data.eff.eff_integers[1]
      if data.is_remove then amt = -amt end
      if idx >= 0 and idx < ABILITY_NUM then
         cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
      end
   elseif data.eff.eff_type == EFFECT_TYPE_ABILITY_DECREASE then
      local idx = data.eff.eff_integers[0]
      local amt = data.eff.eff_integers[1]
      if not data.is_remove then amt = -amt end
      if idx >= 0 and idx < ABILITY_NUM then
         cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
      end
   end
end

function NWNXSolstice_GetEffectImmunity(obj, imm)
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return false end
   return cre:GetIsImmune(imm, OBJECT_INVALID)
end

function NWNXSolstice_GetSaveEffectBonus(obj, save, save_vs)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end
   local min, max = Rules.GetSaveEffectLimits(obj, save, save_vs)
   local eff = Rules.GetSaveEffectBonus(obj, save, save_vs)
   return  math.clamp(eff, min, max)
end

function NWNXSolstice_GetAbilityEffectBonus(obj, ability)
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

function NWNXSolstice_GetSkillEffectBonus(obj, skill)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end

   local min, max = Rules.GetSkillEffectLimits(obj, skill)
   local eff = Rules.GetSkillEffectModifier(obj, skill)
   return math.clamp(eff, min, max)
end

function NWNXSolstice_InitializeNumberOfAttacks(id)
    local cre = GetObjectByID(id)
    if not cre:GetIsValid() then return end
    Rules.InitializeNumberOfAttacks(cre)
end

function NWNXSolstice_GetWeaponFinesse(obj, it)
   local cre  = GetObjectByID(obj)
   local item = GetObjectByID(it)
   return Rules.GetIsWeaponFinessable(item, cre)
end

function NWNXSolstice_GetCriticalHitMultiplier(obj, is_offhand)
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

function NWNXSolstice_GetCriticalHitRoll(obj, is_offhand)
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

function NWNXSolstice_ResolveDamageShields(cre, attacker)
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
                             if attacker:GetIsValid() then
                                local e = Eff.Damage(amt, dindex)
                                e:SetCreator(self)
                                attacker:ApplyEffect(DURATION_TYPE_INSTANT, e)
                             end
                          end)
      end
   end
end
