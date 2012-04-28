local ffi = require 'ffi'
local C = ffi.C

ffi.cdef[[
typedef struct VersusInfo {
   int32_t race;
   int32_t goodevil;
   int32_t lawchaos;
   int32_t deity_id;
   int32_t subrace_id;
   uint32_t obj_id;
} VersusInfo;

typedef struct EffectInfo {
   int32_t index;
   int32_t type_dec;
   int32_t type_inc;
   bool stack;
   bool item_stack;
   bool spell_stack;
} EffectInfo;
]]

versus_info_t = ffi.typeof("VersusInfo")
effect_info_t = ffi.typeof("EffectInfo")


function Creature:GetTotalEffectBonus(vs, eff_info, range_check, validity_check, get_amount)
   local total = 0
   local eff_type, vs_info, eff_creator, eff, amount

   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
   end

   local bonus = {}
   local pen = {}

   local spell_bonus, item_bonus, spell_pen, item_pen
   if not spell_stack then
      spell_bonus = {}
      spell_pen = {}
   end

   if not item_stack then
      item_bonus = {}
      item_pen = {}
   end

   for i = eff_info.index, self.obj.obj.obj_effects_len - 1 do
      eff = self.obj.obj.obj_effects[i]
      eff_type = eff.eff_type

      amount = get_amount(eff)

      -- If the effect is not in the effect type range then there is nothing left to do.
      if not range_check(eff_type) then break end

      -- Check if this effect is applicable versus the target.
      if validity_check(eff, vs_info) then
         if eff_type == eff_info.type_dec then
            -- If effects from items do not stack and the effect was applied by an item,
            -- find the highest applying
            if not item_stack and not C.nwn_GetItemById(eff.eff_creator) == nil then
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the bonus.
               if not item_pen[eff.eff_creator] then
                  item_pen[eff.eff_creator] = math.max(item_pen[eff.eff_creator], amount)
               else
                  item_pen[eff.eff_creator] = amount
               end
            -- If spells do not stack and the effect was applied via a spell, find the hightest
            -- applying
            elseif not spell_stack and eff.eff_spellid ~= -1 then
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the bonus.
               if not spell_pen[eff.eff_creator] then
                  spell_pen[eff.eff_spellid] = math.max(spell_pen[eff.eff_spellid], amount)
               else
                  spell_pen[eff.eff_spellid] = amount
               end
            else
               table.insert(pen, amount)
            end
         elseif eff_type == eff_info.type_inc then
            -- If effects from items do not stack and the effect was applied by an item,
            -- find the highest applying
            if not item_stack and not C.nwn_GetItemById(eff.eff_creator) == nil then 
               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if not item_bonus[eff.eff_creator] then
                  item_bonus[eff.eff_creator] = math.max(item_bonus[eff.eff_creator], amount)
               else
                  item_bonus[eff.eff_creator] = amount
               end
            -- If spells do not stack and the effect was applied via a spell, find the hightest
            -- applying
            elseif not spell_stack and eff.eff_spellid ~= -1 then
               -- If the effect was applied by a spell and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if not spell_bonus[eff.eff_creator] then
                  spell_bonus[eff.eff_spellid] = math.max(spell_bonus[eff.eff_spellid], amount)
               else
                  spell_bonus[eff.eff_spellid] = amount
               end
            else
               table.insert(bonus, amount)
            end
         end
      end
   end

   local total = 0
   local total_pen = 0

   for _, amount in ipairs(bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end
   
   for _, amount in ipairs(spell_bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end

   for _, amount in ipairs(item_bonus) do
      if eff_info.stack then
         total = total + amount
      else
         total = math.max(total, amount)
      end
   end

   for _, amount in ipairs(pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end

   for _, amount in ipairs(spell_pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end

   for _, amount in ipairs(item_pen) do
      if eff_info.stack then
         total_pen = total_pen + amount
      else
         total_pen = math.max(total_pen, amount)
      end
   end
   
   return total - total_pen
end

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
      miss_type = self.obj.obj.obj_effects[i].eff_integers[4]
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

function NSGetEffectImmunity(cre, vs, imm_type)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)
   return cre:GetEffectImmunity(vs, imm_type)
end

---
-- @param imm_type NOTE: This is NOT an nwn.IMMUNITY_TYPE_* constant.
--   it is an internal game engine constant.  Passing in nwn.IMMUNITY_TYPE_*
--   will result in weird behavior.  The internal constant is 
--   nwn.IMMUNITY_TYPE_* + 69
function Creature:GetEffectImmunity(vs, imm_type)
   local race, lawchaos, goodevil, subrace, deity, immunity, percent
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id, target

   local total = 0
   local eff_type

   if vs:GetIsValid() then
      trace = vs:GetRacialType()
      tgoodevil = vs:GetGoodEvilValue()
      tlawchaos = vs:GetLawChaosValue()
      tdeity_id = vs:GetDeityId()
      tsubrace_id = vs:GetSubraceId()
   end

   for i = self.stats.cs_first_imm_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_IMMUNITY then
         break
      end
      
      immunity  = self.obj.obj.obj_effects[i].eff_integers[0]

      race      = self.obj.obj.obj_effects[i].eff_integers[1]
      lawchaos  = self.obj.obj.obj_effects[i].eff_integers[2]
      goodevil  = self.obj.obj.obj_effects[i].eff_integers[3]

      percent   = self.obj.obj.obj_effects[i].eff_integers[4]

      subrace   = self.obj.obj.obj_effects[i].eff_integers[5]
      deity     = self.obj.obj.obj_effects[i].eff_integers[6]
      target    = self.obj.obj.obj_effects[i].eff_integers[6]
            
      if immunity == imm_type
         and (race == nwn.RACIAL_TYPE_INVALID or race == trace)
         and (lawchaos == 0 or lawchaos == tlawchaos)
         and (goodevil == 0 or goodevil == tgoodevil)
         and (subrace == 0 or subrace == tsubrace_id)
         and (deity == 0 or deity == tdeity_id)
         and (target == 0 or target == vs.id)
      then
         total = total + percent
      end
   end

   if percent >= 100 then 
      return true
   elseif percent <= 0 then
      return false
   elseif percent > math.random(100) then
      return true
   end

   return false
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

