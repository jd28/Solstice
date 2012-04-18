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

