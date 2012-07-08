require 'nwn.creature.effects'
require 'nwn.effects'

local ffi = require 'ffi'

-- Effect accumulator locals
local bonus = ffi.new("uint32_t[?]", 10)
local penalty = ffi.new("uint32_t[?]", 10)
local ab_amount = nwn.CreateEffectAmountFunc(0)
local ab_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_ATTACK_DECREASE,
					   nwn.EFFECT_TRUETYPE_ATTACK_INCREASE)

--- Create a debug string for attack bonus.
-- @param vs Attack target.  (Default: nwn.OBJECT_INVALID)
function Creature:CreateAttackBonusDebugString(vs)
   vs = vs or nwn.OBJECT_INVALID

   -- Make sure all info is current/
   self:UpdateCombatInfo()

   local fmt_table = {}
   local fmt = "BAB: %d, Area: %d, Class: %d, Feat: %d, Mode: %d, Race: %d, Size: %d, Skill: %d \n\n"
   local wfmt = "Weapon: %s, Ability Mod: %d (%s), Weapon AB Mod: %d, Effects: %d\n"

   local vs_name = vs:GetIsValid() and vs:GetName() or "Invalid Object"

   table.insert(fmt_table, string.format("Versus: %s\n", vs_name))
   table.insert(fmt_table, string.format(fmt, self.ci.bab, 
					 self.ci.area.ab,
					 self.ci.class.ab,
					 self.ci.feat.ab,
					 self.ci.mode.ab,
					 self.ci.race.ab,
					 self.ci.size.ab,
					 self.ci.skill.ab))

   for i = 0, 5 do
      local weap
      if self.ci.equips[i].id ~= nwn.OBJECT_INVALID.id then
	 weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)
	 table.insert(fmt_table, string.format(wfmt,
					       weap:GetName(),
					       self:GetAbilityModifier(self.ci.equips[i].ab_ability),
					       nwn.GetAbilityName(self.ci.equips[i].ab_ability),
					       self.ci.equips[i].ab_mod,
					       self:GetEffectAttackBonus(vs,
									 nwn.GetAttackTypeFromEquipNum(i))))
      end
   end

   return table.concat(fmt_table)
end

--- Determine creature's BAB.
function Creature:GetBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(699, 1)
   return nwn.engine.StackPopInteger()
end

--- Get creatures attack bonus from effects/weapons.
-- @param vs Creatures target
-- @param attack_type Current attack type.  See nwn.ATTACK_TYPE_*
function Creature:GetEffectAttackBonus(vs, attack_type)
   local function valid(eff, vs_info)
      local type = eff:GetInt(1)
      if not (type == nwn.ATTACK_TYPE_MISC or attack_type == type) then
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

   return math.clamp(bon_total - pen_total, self:GetMinAttackBonusMod(), self:GetMaxAttackBonusMod())
end

--- Determines maximum attack bonus modifier.
function Creature:GetMaxAttackBonusMod()
   return 20
end

--- Determines minimum attack bonus modifier.
function Creature:GetMinAttackBonusMod()
   return -20
end