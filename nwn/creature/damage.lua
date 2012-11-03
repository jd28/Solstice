require 'nwn.combat'

local ffi = require 'ffi'
local C = ffi.C

-- Effect accumulator locals.
local bonus = damage_roll_t()
local penalty = damage_roll_t()
local dmg_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE,
					    nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE)

local function format_die_roll(r)
   return string.format("%dd%d + %d", r.dice, r.sides, r.bonus)
end

function Creature:DebugDamageRoll(roll)
   local t = {}
   local fmt = "%d : %s"
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      local u = {}
      for j = 0, roll.idxs[i] - 1 do
	 table.insert(u, format_die_roll(roll.rolls[i][j]))
      end
      if #u > 0 then
	 table.insert(t, string.format(fmt, i, table.concat(u, ", ")))
      else
	 table.insert(t, string.format(fmt, i, "None"))
      end
   end

   return table.concat(t, '\n')
end

local function zero_damage_roll(damage_roll)
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      -- Zero all indexs
      damage_roll.idxs[i] = 0
   end
end

local function format_damage(type, roll)
   local fmt = "%s : %dd%d + %d\n"
   local name = nwn.GetDamageName(type)
   
   return string.format(fmt, name, roll.dice, roll.sides, roll.bonus)
end


function Creature:DebugDamage(vs)
   self:UpdateCombatInfo()
   vs = vs or nwn.OBJECT_INVALID
   local fmt_table = {}
   local wfmt = "Weapon: %s\n"

   local vs_name
   if not vs:GetIsValid() then
      vs_name = "Invalid Object"
   else
      vs_name = vs:GetName()
   end

   table.insert(fmt_table, string.format("Versus: %s\n", vs_name))

   table.insert(fmt_table, "Area: ")
   table.insert(fmt_table, format_damage(self.ci.area.dmg_type, self.ci.size.dmg))
   table.insert(fmt_table, "feat: ")
   table.insert(fmt_table, format_damage(self.ci.feat.dmg_type, self.ci.size.dmg))
   table.insert(fmt_table, "mode: ")
   table.insert(fmt_table, format_damage(self.ci.mode.dmg_type, self.ci.size.dmg))
   table.insert(fmt_table, "size: ")
   table.insert(fmt_table, format_damage(self.ci.size.dmg_type, self.ci.size.dmg))

   table.insert(self:DebugWeaponDamage())

   return table.concat(fmt_table)
end

---
function Creature:DebugWeaponDamage()
   local t = {}
   local fmt = "Dmg Ability: %s : %d, Base Damage: %dd%d + %d, "
      .. "Base Damage Type(s): %x, Base Damage Mask: %x "
      .. "Crit Range: %d, Crit Multiplier: %d, Crit Damage: %dd%d + %d\n\n"
   
   for i = 0, 5 do
      table.insert(t, string.format(fmt,
				    self.ci.equips[i].id,
				    nwn.GetAbilityName(self.ci.equips[i].dmg_ability),
				    self:GetAbilityModifier(self.ci.equips[i].dmg_ability),
				    self.ci.equips[i].base_dmg.dice,
				    self.ci.equips[i].base_dmg.sides,
				    self.ci.equips[i].base_dmg.bonus,
				    self.ci.equips[i].base_type,
				    self.ci.equips[i].base_mask,
				    self.ci.equips[i].crit_range,
				    self.ci.equips[i].crit_mult,
				    self.ci.equips[i].crit_dmg.dice,
				    self.ci.equips[i].crit_dmg.sides,
				    self.ci.equips[i].crit_dmg.bonus))
   end

   return table.concat(t)
end

function nwn.DetermineBestDamageRoll(roll1, roll2)
   local r1 = (roll1.dice * roll1.sides) + roll1.bonus
   local r2 = (roll2.dice * roll2.sides) + roll2.bonus
   
   if r1 > r2 then
      return roll1
   else
      return roll2
   end
end

function Creature:GetEffectDamageBonus(target, attack_type)
   local function amount(eff)
      local r
      -- If Int 9 is 0 then this is damage const, if 1 then it's a damage range effect.
      if eff:GetInt(9) == 0 then
	 r = nwn.GetDamageRollFromConstant(eff:GetInt(0))
      else
	 r = nwn.GetDamageRollFromRange(eff:GetInt(0), eff:GetInt(10))
      end
      --print(format_die_roll(r))
      return r
   end

   local function valid(eff, vs_info)
      -- print(eff:GetInt(5))
      -- Check to make sure this is the correct damage type and attack type
      if vs_info.type ~= nwn.GetDamageIndexFromFlag(eff:GetInt(1))
	 or attack_type ~= eff:GetInt(5)
      then
	 return false
      end

      -- If using versus info is globally disabled return true.
      if not NS_OPT_USE_VERSUS_INFO then return true end

      local race      = eff:GetInt(2)
      local lawchaos  = eff:GetInt(3)
      local goodevil  = eff:GetInt(4)
      local subrace   = eff:GetInt(6)
      local deity     = eff:GetInt(7)
      --  local vs        = eff:GetInt(8)

      --  print(race, lawchaos, goodevil, subrace, deity, vs)

      -- check other VS constraints
      if (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
	 and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
	 and (goodevil == 0 or goodevil == vs_info.goodevil)
	 and (subrace == 0 or subrace == vs_info.subrace_id)
	 and (deity == 0 or deity == vs_info.deity_id)
      --	 and (vs == 0 or vs == vs_info.target)
      then
	 return true
      else
	 return false
      end   
   end

   zero_damage_roll(bonus)
   zero_damage_roll(penalty)

   local vs_info
   if NS_OPT_USE_VERSUS_INFO then
      vs_info = nwn.GetVersusInfo(target)
   else
      -- In this case even if using versus info is globally disabled we still need
      -- the struct to carry damage type.
      vs_info = nwn.GetVersusInfo(nwn.OBJECT_INVALID)
   end
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      vs_info.type = i
      local bon_idx, pen_idx = self:GetEffectArrays(bonus.rolls[i],
						    penalty.rolls[i],
						    vs_info,
						    DAMAGE_EFF_INFO,
						    dmg_range,
						    valid,
						    amount,
						    nwn.DetermineBestDamageRoll,
						    self.stats.cs_first_dmg_eff)

      bonus.idxs[i] = bon_idx
      penalty.idxs[i] = pen_idx
   end

   return bonus, penalty
end
