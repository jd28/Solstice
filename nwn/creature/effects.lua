local ffi = require 'ffi'
local C = ffi.C

function Creature:GetConcealment(target, attack)
   local race, lawchaos, goodevil, subrace, deity, amount
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id

   local total = 0
   local eff_type

   -- Self-Conceal Feats
   local feat = self:GetHighestFeatInRange(nwn.FEAT_EPIC_SELF_CONCEALMENT_10,
                                           nwn.FEAT_EPIC_SELF_CONCEALMENT_50)

   if feat ~= -1 then
      total = (feat - nwn.FEAT_EPIC_SELF_CONCEALMENT_10 + 1) * 10
   end

   if target and target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      trace = target:GetRacialType()
      tgoodevil = target:GetGoodEvilValue()
      tlawchaos = target:GetLawChaosValue()
      tdeity_id = target:GetDeityId()
      tsubrace_id = target:GetSubraceId()
   end

   local valid = false
   local pass = false

   for i = self.stats.cs_first_conceal_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_CONCEALMENT then
         break
      end
      
      amount    = self.obj.obj.obj_effects[i].eff_integers[0]
      race      = self.obj.obj.obj_effects[i].eff_integers[1]
      lawchaos  = self.obj.obj.obj_effects[i].eff_integers[2]
      goodevil  = self.obj.obj.obj_effects[i].eff_integers[3]
      miss_type = self.obj.obj.obj_effects[i].eff_integers[3]
      subrace   = self.obj.obj.obj_effects[i].eff_integers[5]
      deity     = self.obj.obj.obj_effects[i].eff_integers[6]
      valid     = false
      pass      = false
            
      if race == nwn.RACIAL_TYPE_INVALID 
         and lawchaos == 0 
         and goodevil == 0 
         and subrace == 0 
         and deity == 0 
         and miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
      then
         valid = true
      end

      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == trace)
         and (lawchaos == 0 or lawchaos == tlawchaos)
         and (goodevil == 0 or goodevil == tgoodevil)
         and (subrace == 0 or subrace == tsubrace_id)
         and (deity == 0 or deity == tdeity_id)
      then
         if eff_type == nwn.EFFECT_TRUETYPE_MISS_CHANCE then
            if amount == 2 
               and bit.band(self.obj.cre_vision_type, 2) == 0
               and bit.band(self.obj.cre_vision_type, 4) == 0
            then
               total = 50
               pass = true
            elseif amount ~= 2
               and bit.band(self.obj.cre_vision_type, 1) == 0
               and bit.band(self.obj.cre_vision_type, 4) == 0
            then
               total = 50
               pass = true
            end
         end
         if not pass
            and eff_type == nwn.EFFECT_TRUETYPE_CONCEALMENT 
            and total > amount
         then
            if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
               or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
               or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
            then
               total = amount
            end
         end
      end
   end
   return total
end

---
function Creature:GetHasFeatEffect(nFeat)
   nwn.engine.StackPushObject(self.id)
   nwn.engine.StackPushInteger(nFeat)
   nwn.engine.ExecuteCommand(543, 2)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetIsInvisible(target)
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, target.obj.obj)
   end

   return false
end

function Creature:GetDamageImmunity(dmg_idx)
   -- RDD
   return self.ci.immunity[dmg_idx]
end

function Creature:GetInnateDamageReduction(dmg_power)
   -- Dwarved Defender
   return self.ci.soak[dmg_power]
end

function Creature:GetInnateDamageResistance(dmg_idx)
   return self.ci.resist[dmg_idx]
end
---
function Creature:GetIsImmune(immunity, versus)
   nwn.engine.StackPushObject(versus)
   nwn.engine.StackPushInteger(immunity)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(274, 3)
   return StackPopBoolean()
end

function Creature:GetMissChance(attack)
   local total = 0
   local eff_type, amount

   for i = self.stats.cs_first_misschance_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_MISS_CHANCE then
         break
      end
      
      amount    = self.obj.obj.obj_effects[i].eff_integers[0]
      miss_type = self.obj.obj.obj_effects[i].eff_integers[1]

      if eff_type == nwn.EFFECT_TRUETYPE_MISS_CHANCE
         and amount > total
      then
         if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
            or (miss_type == nwn.MISS_CHANCE_TYPE_DARKNESS and bit.band(self.obj.cre_vision_type, 2) ~= 0 )
            or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
            or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
         then
            total = amount
         end
      end
   end
   return total
end

function NSSetDamageImmunity(obj, dmg_flag, amount)
   obj = _NL_GET_CACHED_OBJECT(obj)
   local idx = nwn.GetDamageIndexFromFlag(dmg_flag)
   if obj.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      obj.ci.immunity[idx] = amount
   end
end

function Creature:UpdateDamageResistance()
   local eff_type, amount, dmg_flg, idx
   local cur_eff

   for i = 0, NS_SETTINGS.NS_OPT_NUM_DAMAGES - 1 do
      self.ci.eff_resist[i] = -1
   end

   for i = self.stats.cs_first_dresist_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_RESISTANCE then
         break
      end

      dmg_flag = self.obj.obj.obj_effects[i].eff_integers[0]
      amount = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if dmg_flag > 0 then
         idx = nwn.GetDamageIndexFromFlag(dmg_flag)
         cur_eff = self.ci.eff_resist[idx]
         if cur_eff < 0 then
            self.ci.eff_resist[idx] = i
         else
            local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[1]
            local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
            
            -- If the resist amount is higher, set the resist effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount 
               or (amount == camount and limit > climit)
            then
               self.ci.eff_resist[idx] = i
            end
         end
      end
   end
end

function Creature:UpdateDamageReduction()
   local eff_type, amount, dmg_power, dur_type, limit
   local cur_eff
   
   -- Reset the soak effect index list.
   for i = 0, 20 do
      self.ci.eff_soak[i] = -1
   end

   for i = self.stats.cs_first_dred_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      -- 
      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_REDUCTION then
         break
      end

      amount = self.obj.obj.obj_effects[i].eff_integers[0]
      dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]
      
      cur_eff = self.ci.eff_soak[dmg_power]
      if cur_eff < 0 then
         self.ci.eff_soak[dmg_power] = i
      else
         local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[0]
         local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
         
         -- If the soak amount is higher, set the soak effect list to the effect index.
         -- If they are equal prefer the one with the highest damage limit.
         if amount > camount 
            or (amount == camount and limit > climit)
         then
            self.ci.eff_soak[dmg_power] = i
         end
      end
   end
end