require 'nwn.effects'

local ffi = require 'ffi'
local max = math.max

-- Effect accumulator locals.
local bonus = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local penalty = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local ac_amount = nwn.CreateEffectAmountFunc(0)
local ac_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_AC_DECREASE,
					   nwn.EFFECT_TRUETYPE_AC_INCREASE)

--- Get creature's AC
-- @param touch If true it's a touch attack.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetAC(touch, log)
   return self:GetACVersus(nwn.OBJECT_INVALID, touch, nil, log)
end

--- Determines AC vs creature
-- @param att Attacking creature
-- @param touch If true it's a touch attack.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
function Creature:GetACVersus(att, touch, attack, log)
   att = att or nwn.OBJECT_INVALID
   -- 10 base AC
   local ac = 10
   local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0
   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge

   -- Armor AC
   ac = ac + self.stats.cs_ac_natural_base
   -- Natural AC
   ac = ac + self.stats.cs_ac_armour_base
   -- Shield AC
   ac = ac + self.stats.cs_ac_shield_base
   -- Size Modifier
   ac = ac + self.ci.size.ac
   -- Class: Monk, RDD, PM, ...
   ac = ac + self.ci.class.ac
   -- Attack Mode Modifier
   ac = ac + self.ci.mode.ac
   -- Feat: Armor Skin, etc
   ac = ac + self.ci.feat.ac

   nwn.LogTableAdd(log, "Base: %d", 10)
   nwn.LogTableAdd(log, "Base Armor: %d", self.stats.cs_ac_armour_base)
   nwn.LogTableAdd(log, "Base Natural: %d", self.stats.cs_ac_natural_base)
   nwn.LogTableAdd(log, "Base Shield: %d", self.stats.cs_ac_shield_base)
   nwn.LogTableAdd(log, "Class: %d", self.ci.class.ac)
   nwn.LogTableAdd(log, "Feat: %d", self.ci.feat.ac)
   nwn.LogTableAdd(log, "Mode: %d", self.ci.mode.ac)
   nwn.LogTableAdd(log, "Size: %d", self.ci.size.ac)

   if not attack then
      -- If not an attack we can include skills and dex modifier without
      -- worrying about being flatfooted, etc

      -- Dodge AC
      dodge = self.stats.cs_ac_dodge_bonus - self.stats.cs_ac_dodge_penalty

      -- Skill: Tumble...
      ac = ac + self.ci.skill.ac   
      nwn.LogTableAdd(log, "Skills: %d", self.ci.skill.ac)

      -- Dex Mod.
      val = self:GetDexMod(true)
      ac = ac + val
      nwn.LogTableAdd(log, "Dexterity Modifier: %d", val)
   else
      -- Dex Modifier
      local dex_mod = self:GetDexMod(true)
      local dexed = false

      -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
      -- then target gets no Dex mod.
      if not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
	 and not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_FLATFOOTED)
      then
	 -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
	 -- gets dex_mod and dodge AC
	 if not att:CheckTargetState(nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
	    or (self:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and attack:GetIsRangedAttack())
	 then
	    if dex_mod > 0 then
	       dexed = true
	    end 
	    -- Dodge AC
	    dodge = self.stats.cs_ac_dodge_bonus - self.stats.cs_ac_dodge_penalty

	    -- Skill: Tumble...
	    nwn.LogTableAdd(log, "Skills: %d", self.ci.skill.ac)
	    ac = ac + self.ci.skill.ac
	    
	    -- If this is an attack of opportunity and target has mobility
	    -- there is a +4 ac bonus.
	    if attack:GetSpecialAttack() == -534 
	       and self:GetHasFeat(nwn.FEAT_MOBILITY)
	    then
	       nwn.LogTableAdd(log, "AoO Mobility Bonus: %d", 4)
	       ac = ac + 4
	    end
	    
	    if self:GetHasFeat(nwn.FEAT_DODGE) then
	       if self.obj.cre_combat_round.cr_dodge_target == nwn.OBJECT_INVALID.id then
		  self.obj.cre_combat_round.cr_dodge_target = att.id
	       end
	       if self.obj.cre_combat_round.cr_dodge_target == att.id
		  and not self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
	       then
		  ac = ac + 1
		  nwn.LogTableAdd(log, "Dodge Feat: %d", 1)
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
	 and (self:GetHasFeat(nwn.FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
	 or self:GetHasFeat(nwn.FEAT_UNCANNY_DODGE_1))
      then
	 dexed = true
      end

      if dexed then
	 nwn.LogTableAdd(log, "Dexterity Modifier: %d", dex_mod)
	 ac = ac + dex_mod
      end
   end
   -- +4 Defensive Training Vs.
   if self:GetHasDefensiveTrainingVs(att) then
      nwn.LogTableAdd(log, "Defensive Training Vs: %d", 4)
      ac = ac + 4
   end

   -- Armor AC
   armor = self.stats.cs_ac_armour_bonus - self.stats.cs_ac_armour_penalty
   -- Deflect AC
   deflect = self.stats.cs_ac_deflection_bonus - self.stats.cs_ac_deflection_penalty
   -- Natural AC
   nat = self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty
   -- Shield AC
   shield = self.stats.cs_ac_shield_bonus - self.stats.cs_ac_shield_penalty


   if touch then
      nwn.LogTableAdd(log, "Touch Attack: true")
      return ac + dodge
   end

   -- Only necessary if versus target is valid.  If it's not all the 
   -- appropriate bonuses have already been determined.
   if att:GetIsValid() then
      eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge =
	 self:GetEffectArmorClassBonus(att, touch)

      nat     = max(nat, eff_nat)
      armor   = max(armor, eff_armor)
      deflect = max(deflect, eff_deflect)
      shield  = max(shield, eff_shield)

      dodge = dodge + eff_dodge
   end

   dodge = math.clamp(dodge, self:GetMinArmorClassMod(), self:GetMaxArmorClassMod())

   nwn.LogTableAdd(log, "Armor: %d", armor)
   nwn.LogTableAdd(log, "Deflection: %d", deflect)
   nwn.LogTableAdd(log, "Natural: %d", nat)
   nwn.LogTableAdd(log, "Shield: %d", shield)
   nwn.LogTableAdd(log, "Dodge: %d", dodge)
   nwn.LogTableAdd(log, "Touch Attack: false")

   ac = ac + nat + armor + shield + deflect + dodge

   nwn.LogTableAdd(log, "    Total: %d", ac)
   return ac
end

function Creature:GetArmorCheckPenalty()
   if not self:GetIsValid() then
      return 0
   end

   return self.stats.cs_acp_armor + self.stats.cs_acp_shield
end

--- Get Creatures Armor Class effect bonus / penalty
-- The algorithm here is naive...  Rather than collect all AC effects in one loop it
--    loops over AC effects for each type.
-- @param vs Attacking creature. (Default: nwn.OBJECT_INVALID)
-- @param touch True if touch attack, false if not. (Default: false)
-- @return natural, armor, shield, deflection, dodge
function Creature:GetEffectArmorClassBonus(vs, touch)
   vs = vs or nwn.OBJECT_INVALID

   local dmg_flags = 0
   local vs_info 
   if NS_OPT_USE_VERSUS_INFO then
      vs_info = nwn.GetVersusInfo(vs)
   else
      -- If we're not using versus effects than we don't need to bother calculating
      -- anything, since the non-versus effects are already stored on the creature.
      return 0, 0, 0, 0, 0      
   end

   if touch then
      return 0, 0, 0, 0, self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DODGE_BONUS, AC_DODGE_EFF_INFO)
   else
      local nat  = self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_NATURAL_BONUS, AC_NATURAL_EFF_INFO)
      local amr  = self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_ARMOUR_BONUS, AC_ARMOR_EFF_INFO)
      local shld = self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_SHIELD_BONUS, AC_SHIELD_EFF_INFO)
      local defl = self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DEFLECTION_BONUS, AC_DEFLECTION_EFF_INFO)
      local dodg = self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DODGE_BONUS, AC_DODGE_EFF_INFO)

      return nat, amr, shld, defl, dodg
   end
end

--- Get Creatures Armor Class effect bonus / penalty by AC type
-- @param vs_info
-- @param type nwn.AC_*
-- @param ac_info
function Creature:GetEffectArmorClassBonusByType(vs_info, type, ac_info)
   local function ac_valid(eff, vs_info)
      if type ~= eff:GetInt(0) then
	 return false
      end
      
      -- If using versus info is disabled globally, return true
      if not NS_OPT_USE_VERSUS_INFO then return true end

      -- Check to make sure this effect is applicable vs the
      -- damages that may be dealt.
      local damage = eff:GetInt(5)
      if damage ~= nwn.AC_VS_DAMAGE_TYPE_ALL and bit.band(vs_info.dmg_flags, damage) ~= 0 then
	 return false
      end

      local race     = eff:GetInt(2)
      local lawchaos = eff:GetInt(3)
      local goodevil = eff:GetInt(4)
      local subrace  = eff:GetInt(6)
      local deity    = eff:GetInt(7)
      local target   = eff:GetInt(8)

      -- check other VS constraints
      if (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
	 and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
	 and (goodevil == 0 or goodevil == vs_info.goodevil)
	 and (subrace == 0 or subrace == vs_info.subrace_id)
	 and (deity == 0 or deity == vs_info.deity_id)
	 and (target == 0 or target == vs_info.target)
      then
	 return true
      else
	 return false
      end
   end

   if NS_OPT_USE_VERSUS_INFO then
      vs_info = vs_info or nwn.GetVersusInfo(vs)
   else
      -- If we're not using versus effects than we don't need to bother calculating
      -- anything, since the non-versus effects are already stored on the creature.
      return 0
   end

   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						penalty,
						vs_info,
						ac_info,
						ac_range, 
						ac_valid,
						ac_amount,
						max,
						self.stats.cs_first_ac_eff)

   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_total - 1 do
      if ac_info.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_total - 1 do
      if ac_info.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = max(pen_total, penalty[i])
      end
   end

   return bon_total - pen_total
end

--- Determine maximum armor class modifier
function Creature:GetMaxArmorClassMod()
   return 20
end

--- Determine minimum armor class modifier
function Creature:GetMinArmorClassMod()
   return -20
end
