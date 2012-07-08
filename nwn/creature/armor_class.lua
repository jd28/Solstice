require 'nwn.effects'

local ffi = require 'ffi'

-- Effect accumulator locals.
local bonus = ffi.new("uint32_t[?]", 10)
local penalty = ffi.new("uint32_t[?]", 10)
local ac_amount = nwn.CreateEffectAmountFunc(0)
local ac_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_AC_DECREASE,
					   nwn.EFFECT_TRUETYPE_AC_INCREASE)

--------------------------------------------------------------------------------
-- 

function Creature:DebugArmorClass(vs, touch)
   vs = vs or nwn.OBJECT_INVALID

   -- Make sure all info is current/
   self:UpdateCombatInfo()

   local fmt_table = {}
   local vs_name = vs:GetIsValid() and vs:GetName() or "Invalid Object"

   table.insert(fmt_table, string.format("Versus: %s, Touch: %d\n\n", vs_name, touch and 1 or 0))
   
   table.insert(fmt_table, string.format("Dexterity Modifier: %d\n", self:GetDexMod(true)))

   local bfmt = "Base: Natural: %d, Armor: %d, Deflection: %d, Shield: %d, Dodge: %d \n"
   table.insert(fmt_table, string.format(bfmt,
					 self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty,
					 self.stats.cs_ac_armour_bonus - self.stats.cs_ac_armour_penalty,
					 self.stats.cs_ac_deflection_bonus - self.stats.cs_ac_deflection_penalty,
					 self.stats.cs_ac_shield_bonus - self.stats.cs_ac_shield_penalty,
					 self.stats.cs_ac_dodge_bonus - self.stats.cs_ac_dodge_penalty))

   local mfmt = "Mod: Area: %d, Class: %d, Feat: %d, Mode: %d\n"
   table.insert(fmt_table, string.format(mfmt,
					 self.ci.area.ac,
					 self.ci.class.ac,
					 self.ci.feat.ac,
					 self.ci.mode.ac,
					 self.ci.skill.ac))

   local efmt = "Effects: Natural: %d, Armor: %d, Shield: %d, Deflection: %d, Dodge: %d\n"
   table.insert(fmt_table, string.format(efmt, self:GetEffectArmorClassBonus(vs, touch)))
   
   return table.concat(fmt_table)
end

--- Get Creatures total Armor Class bonus / penalty
-- @param vs Attacking creature. (Default: nwn.OBJECT_INVALID)
-- @param touch True if touch attack, false if not. (Default: false)
-- @return natural, armor, shield, deflection, dodge
function Creature:GetArmorClassBonus(vs, touch)
   vs = vs or nwn.OBJECT_INVALID

   local dmg_flags = 0

   local vs_info = nwn.GetVersusInfo(vs)

   if touch then
      local dodg = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DODGE_BONUS, AC_DODGE_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())
      return 0, 0, 0, 0, dodg
   else
      local nat  = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_NATURAL_BONUS, AC_NATURAL_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())

      local amr  = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_ARMOUR_BONUS, AC_ARMOR_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())

      local shld = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_SHIELD_BONUS, AC_SHIELD_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())

      local defl = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DEFLECTION_BONUS, AC_DEFLECTION_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())

      local dodg = math.clamp(self.stats.cs_ac_natural_bonus - self.stats.cs_ac_natural_penalty 
			      + self:GetEffectArmorClassBonusByType(vs_info, nwn.AC_DODGE_BONUS, AC_DODGE_EFF_INFO),
			      self:GetMinArmorClassMod(),
			      self:GetMaxArmorClassMod())

      return nat, amr, shld, defl, dodg
   end
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
   local vs_info = nwn.GetVersusInfo(vs)

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

   vs_info = vs_info or nwn.GetVersusInfo(vs)
   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						penalty,
						vs_info,
						ac_info,
						ac_range, 
						ac_valid,
						ac_amount,
						math.max,
						self.stats.cs_first_ac_eff)

   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_total - 1 do
      if ac_info.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = math.max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_total - 1 do
      if ac_info.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = math.max(pen_total, penalty[i])
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
