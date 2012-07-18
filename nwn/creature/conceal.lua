require 'nwn.creature.effects'

--- Get creatures concealment
-- @param vs Creatures attacker, if any.
-- @param attack CNWSCombatAttackData ctype (Default: nil).  This parameter
--    should only ever be passed from the combat engine.
function Creature:GetConcealment(vs, attack)
   local race, lawchaos, goodevil, subrace, deity, target
   local amount

   local total = 0
   local eff_type

   -- Self-Conceal Feats
   local feat = self:GetHighestFeatInRange(nwn.FEAT_EPIC_SELF_CONCEALMENT_10,
                                           nwn.FEAT_EPIC_SELF_CONCEALMENT_50)

   if feat ~= -1 then
      total = (feat - nwn.FEAT_EPIC_SELF_CONCEALMENT_10 + 1) * 10
   end
   
   local vs_info
   if vs:GetIsValid() and vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      vs_info = versus_info_t(vs:GetRacialType(),
                              vs:GetGoodEvilValue(),
                              vs:GetLawChaosValue(),
                              vs:GetDeityId(),
                              vs:GetSubraceId(),
                              vs.id)
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
      target    = self.obj.obj.obj_effects[i].eff_integers[7]
      valid     = false
      pass      = false
            
      if miss_type == nwn.MISS_CHANCE_TYPE_NORMAL
         or (miss_type == nwn.MISS_CHANCE_TYPE_VS_RANGED and attack and attack.cad_ranged_attack ~= 0)
         or (miss_type == nwn.MISS_CHANCE_TYPE_VS_MELEE and attack and attack.cad_ranged_attack == 0)
      then
         valid = true
      end

      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
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

--- Get creatures miss chance
-- @param attack CNWSCombatAttackData ctype (Default: nil).  This parameter
--    should only ever be passed from the combat engine.
function Creature:GetMissChance(attack)
   local total = 0
   local eff_type, amount, miss_type

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