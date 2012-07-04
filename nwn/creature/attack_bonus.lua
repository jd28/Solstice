require 'nwn.creature.effects'
require 'nwn.effects'

local ffi = require 'ffi'

local bonus = ffi.new("uint32_t[?]", 10)
local penalty = ffi.new("uint32_t[?]", 10)
local ab_amount = nwn.CreateEffectAmountFunc(0)
local ab_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_ATTACK_DECREASE,
					   nwn.EFFECT_TRUETYPE_ATTACK_INCREASE)

function Creature:DebugAttackBonus(vs)
   self:UpdateCombatInfo()
   vs = vs or nwn.OBJECT_INVALID
   local fmt_table = {}
   local fmt = "BAB: %d, Size: %d, Area: %d, Feat: %d, Mode: %d\n\n"
   local wfmt = "Weapon: %s, Ability: %d, Ability Mod: %d, Effects: %d\n"

   local vs_name
   if not vs:GetIsValid() then
      vs_name = "Invalid Object"
   else
      vs_name = vs:GetName()
   end

   table.insert(fmt_table, string.format("Versus: %s\n", vs_name))
   table.insert(fmt_table, string.format(fmt, self.ci.bab, 
					 self.ci.size.ab,
					 self.ci.area.ab,
					 self.ci.feat.ab,
					 self.ci.mode.ab))

   for i = 0, 5 do
      local weap
      if self.ci.equips[i].id ~= 0 then
	 weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)
	 table.insert(fmt_table, string.format(wfmt,
					       weap:GetName(),
					       self.ci.equips[i].ab_ability,
					       self:GetAbilityModifier(self.ci.equips[i].ab_ability),
					       self:GetEffectAttackBonus(vs,
									 nwn.GetAttackTypeFromEquipNum(i))))
      end
   end

   return table.concat(fmt_table)
end

--- Get creatures attack bonus from effects/weapons.
-- @param vs Creatures target
-- @param attack_type Current attack type.  See nwn.ATTACK_TYPE_*
function Creature:GetEffectAttackBonus(vs, attack_type)
   local function valid(eff, vs_info)
      if attack_type ~= eff:GetInt(1) then
	 return false
      end

      local race      = eff:GetInt(2)
      local lawchaos  = eff:GetInt(3)
      local goodevil  = eff:GetInt(4)
      local subrace   = eff:GetInt(5)
      local deity     = eff:GetInt(6)
      local vs        = eff:GetInt(7)

      if (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (vs == 0 or vs == vs_info.target)
      then
         return true
      end
      return false
   end

   local vs_info = nwn.GetVersusInfo(vs)
   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						 penalty,
						 vs_info,
						 AB_EFF_INFO,
						 ab_range,
						 valid,
						 ab_amount,
						 math.max,
						 self.stats.cs_first_ab_eff)

   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_idx - 1 do
      if AB_EFF_INFO.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = math.max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_idx - 1 do
      if AB_EFF_INFO.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = math.max(pen_total, penalty[i])
      end
   end

   return math.clamp(bon_total - pen_total, self:GetMinAttackBonus(), self:GetMaxAttackBonus())
end

function Creature:GetMaxAttackBonus()
   return 20
end

function Creature:GetMinAttackBonus()
   return -20
end