local ffi = require 'ffi'
local C = ffi.C
local color = require 'nwn.color'

safe_require 'nwn.ctypes.solstice'

DamageRoll = {}
DamageRoll_mt = { __index = DamageRoll }

local dmg_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE,
					    nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE)
local damage_format = color.LIGHT_BLUE.."%s" .. color.END .. 
   color.ORANGE .. " damages %s: %d (%s)" .. color.END

local immunity_format = color.ORANGE 
   .. "%s : Damage Immunity absorbs: %d (%s)" .. color.END

local resist_format = color.ORANGE 
   .. "%s : Damage Resitance absorbs: %d (%s)" .. color.END

local dr_format = color.ORANGE 
   .. "%s : Damage Reduction absorbs: %d" .. color.END

--- Creates a new damage roll
function DamageRoll.new(attacker, target, attack_type)
   local t = { attacker = attacker,
	       target = target,
	       attack_type = attack_type,
	       bonus = damage_roll_t(),
	       penalty = damage_roll_t()
   }
   setmetatable(t, DamageRoll_mt)
   return t
end

--- Adds a damage bonus to the damage roll
-- @param dmg_type
-- @param roll
function DamageRoll:AddBonus(dmg_type, roll)
   if not dmg_type then return end

   local idx = nwn.GetDamageIndexFromFlag(dmg_type)
   local n = self.bonus.idxs[idx]

   self.bonus.rolls[idx][n] = roll
   self.bonus.idxs[idx] = n + 1
end

--- Adds a damage penalty to the damage roll
-- @param dmg_type
-- @param roll
function DamageRoll:AddPenalty(dmg_type, roll)
   if not dmg_type then return end

   local idx = nwn.GetDamageIndexFromFlag(dmg_type)
   local n = self.penaly.idxs[idx]

   self.penaly.rolls[idx][n] = roll
   self.penaly.idxs[idx] = n + 1
end

--- Adds a dice roll directly to the result.
-- @param dmg_type
-- @param roll
function DamageRoll:AddToResult(dmg_type, roll)
   local idx = nwn.GetDamageIndexFromFlag(dmg_type)
   local amt = self.result.damages[idx]
   amt = amt + nwn.DoDiceRoll(roll)
   self.result.damages[idx] = amt
end

--- Compact physical damages
--     Moves all physical damages to index 12, the base weapon
--     type.
function DamageRoll:CompactPhysicalDamage()
   self.result.damages[12] = self.result.damages[12] + self.result.damages[0] + 
      self.result.damages[1] + self.result.damages[2]

   self.result.damages[0] = 0
   self.result.damages[1] = 0
   self.result.damages[2] = 0
end

function DamageRoll:GetWeightedDamageAmount(amt)
   return amt
end

--- Returns total of damage roll
function DamageRoll:GetTotal()
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + self.result.damages[i]
   end
   return total
end

--- Returns total amount of damage immunities.
function DamageRoll:GetTotalImmunityAdjustment()
   if not self.result then return 0 end

   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + self.result.immunity_adjust[i]
   end
   return total
end

--- Returns total amount of damage resistances.
function DamageRoll:GetTotalResistAdjustment()
   if not self.result then return 0 end

   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + self.result.resist_adjust[i]
   end
   return total
end

function DamageRoll:MapResult(f)
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      local amt = self.result.damages[i]
      self.result.damages[i] = f(amt, i)
   end
end

--- Resolves all damage bonus.
-- Area, feats, race, class, favored enemy, special attacks, etc.
-- @param attack Attack instance
function DamageRoll:ResolveBonusModifiers(attack)
   local attacker = self.attacker

   if nwn.GetDiceRollValid(attacker.ci.area.dmg) then
      self:AddBonus(attacker.ci.area.dmg_type, attacker.ci.area.dmg)
   end
   if nwn.GetDiceRollValid(attacker.ci.class.dmg) then
      self:AddBonus(attacker.ci.class.dmg_type, attacker.ci.class.dmg)
   end
   if nwn.GetDiceRollValid(attacker.ci.feat.dmg) then
      self:AddBonus(attacker.ci.feat.dmg_type, attacker.ci.feat.dmg)
   end   
   if nwn.GetDiceRollValid(attacker.ci.mode.dmg) then
      self:AddBonus(attacker.ci.mode.dmg_type, attacker.ci.mode.dmg)
   end
   if nwn.GetDiceRollValid(attacker.ci.race.dmg) then
      self:AddBonus(attacker.ci.race.dmg_type, attacker.ci.race.dmg)
   end
   if nwn.GetDiceRollValid(attacker.ci.size.dmg) then
      self:AddBonus(attacker.ci.size.dmg_type, attacker.ci.size.dmg)
   end
   if nwn.GetDiceRollValid(attacker.ci.skill.dmg) then
      self:AddBonus(attacker.ci.skill.dmg_type, attacker.ci.skill.dmg)
   end
   
   if attack and attack:GetIsSpecialAttack() then
      local dtype, roll = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_DAMAGE, attacker, target, attack.info)
      self:AddBonus(dtype, roll)
   end

   -- Favored Enemies
   if attacker:GetIsFavoredEnemy(self.target) 
      and nwn.GetDiceRollValid(attacker.ci.fe.dmg)
   then
      self:AddBonus(dmg_roll, attacker.ci.fe.dmg_type, attacker.ci.fe.dmg)
   end
end

--- Resolves all immunities, resitances, and soaks
-- @param attack Attack instance
function DamageRoll:ResolveDamageAdjustments(is_offhand, attack)
   local tar, att = self.target, self.attacker
   local weap = attack and attack:GetCurrentWeapon() or att:GetWeaponFromEquips(is_offhand)
   local base_dmg_type = nwn.GetWeaponBaseDamageType(weap:GetBaseType())

   -- Damage power.  TODO: The monk unarmed Ki thing.
   local damage_power = nwn.GetWeaponPower(weap, tar)

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      local amt = self.result.damages[i]
      local imm_adj, resist_adj, soak_adj, mod_adj = 0, 0, 0, 0

      -- Damage Modification
      amt, mod_adj = att:GetDamageAdjustment(tar, amt, i)
      
      -- Immunity
      amt, imm_adj = tar:GetDamageImmunityAdj(amt, i, base_dmg_type)

      -- Resist
      amt, resist_adj = tar:GetDamageResistAdj(amt, i, base_dmg_type, true)
      
      -- Damage Reduction.  Damage reduction only applies to base weapon damage at index 12.
      if i == 12 then
	 amt, soak_adj = tar:GetDamageReductionAdj(self.result.damages[12],
						   damage_power, true)
	 self.result.soak_adjust = soak_adj
      end

      amt = self:GetWeightedDamageAmount(amt)
      
      self.result.damages[i] = amt
      self.result.immunity_adjust[i] = imm_adj
      self.result.resist_adjust[i] = resist_adj
      self.result.mod_adjust[i] = mod_adj

      if attack and not NS_OPT_NO_DAMAGE_REDUCTION_FEEDBACK then
	 if soak_adj > 0 then
	    attack:AddCCMessage(nil, { tar.id }, { 64, soak_adj })
	 end
	 if imm_adj > 0 then
	    attack:AddCCMessage(nil, { tar.id }, { 62, imm_adj, bit.lshift(1, i) })
	 end
	 if resist_adj > 0 then
	    attack:AddCCMessage(nil, { tar.id }, { 63, resist_adj })
	 end
      end
   end
end

--- Rolls all damages bonuses and penalities.
-- @param mult Critical multiplier (Default: 1)
function DamageRoll:ResolveResult(mult)
   mult = mult or 1
   local roll, prev, idx
   local res = damage_result_t()

   for i = 1, mult do
      for j = 0, NS_OPT_NUM_DAMAGES - 1 do
	 for k = 0, self.bonus.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] + nwn.DoDiceRoll(self.bonus.rolls[j][k])
	 end

	 for k = 0, self.penalty.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] - nwn.DoDiceRoll(self.penalty.rolls[j][k])
	 end

	 if res.damages[j] < 0 then
	    res.damages[j] = 0
	 end
      end
   end
   
   self.result = res
end

--- Determines all applicable bonuses/penalties from damage effects
function DamageRoll:ResolveEffectModifiers()
   local att = self.attacker
   local tar = self.target

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
      -- Check to make sure this is the correct damage type and attack type
      if vs_info.type ~= nwn.GetDamageIndexFromFlag(eff:GetInt(1))
	 or self.attack_type ~= eff:GetInt(5)
      then
	 return false
      end

      -- If using versus info is globally disabled return true here.
      if not NS_OPT_USE_VERSUS_INFO then return true end

      local race      = eff:GetInt(2)
      local lawchaos  = eff:GetInt(3)
      local goodevil  = eff:GetInt(4)
      local subrace   = eff:GetInt(6)
      local deity     = eff:GetInt(7)
      --  local vs        = eff:GetInt(8)

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

   local vs_info
   if NS_OPT_USE_VERSUS_INFO then
      vs_info = nwn.GetVersusInfo(tar)
   else
      -- In this case even if using versus info is globally disabled we still need
      -- the struct to carry damage type.
      vs_info = nwn.GetVersusInfo(nwn.OBJECT_INVALID)
   end

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      vs_info.type = i
      local bon_idx, pen_idx = att:GetEffectArrays(self.bonus.rolls[i],
						   self.penalty.rolls[i],
						   vs_info,
						   DAMAGE_EFF_INFO,
						   dmg_range,
						   valid,
						   amount,
						   nwn.DetermineBestDiceRoll,
						   att.stats.cs_first_dmg_eff)

      self.bonus.idxs[i] = bon_idx
      self.penalty.idxs[i] = pen_idx
   end
end

--- Resolves damage from weapons item properties.
-- NOTE: This is only for ranged ammunition.  ALL other weapon damage is 
-- already calculated when resolving effects.
function DamageRoll:ResolveWeaponDamage(weap)
   local ip

   -- Active, might not have to bother with the active ones.
   for i = 0, weap.obj.it_active_ip_len - 1 do
      ip = weap.obj.it_active_ip[i]
      if ip.ip_type == nwn.ITEM_PROPERTY_DAMAGE_BONUS then
	 local bonus = nwn.GetDamageRollFromConstant(ip.ip_param_value)
	 self:AddBonus(ip.ip_cost_value, bonus)
      end

      if ip.ip_type == nwn.ITEM_PROPERTY_DECREASED_DAMAGE then
	 local pen = dice_roll_t(0, 0, ip.ip_cost_value)
	 self:AddPenalty(nwn.DAMAGE_TYPE_BASE_WEAPON, pen)
      end
   end

   -- Passive
   for i = 0, weap.obj.it_passive_ip_len - 1 do
      ip = weap.obj.it_passive_ip[i]
      if ip.ip_type == nwn.ITEM_PROPERTY_DAMAGE_BONUS then
	 local bonus = nwn.GetDamageRollFromConstant(ip.ip_param_value)
	 self:AddBonus(ip.ip_cost_value, bonus)
      end

      if ip.ip_type == nwn.ITEM_PROPERTY_DECREASED_DAMAGE then
	 local pen = dice_roll_t(0, 0, ip.ip_cost_value)
	 self:AddPenalty(nwn.DAMAGE_TYPE_BASE_WEAPON, pen)
      end
   end
end

function DamageRoll:DumpDice()
   local roll, prev, idx
   local res = damage_result_t()
   local out = {}
   table.insert(out, self.attacker:GetName())
   for j = 0, NS_OPT_NUM_DAMAGES - 1 do
      local dmgt = {}
      local bt = {}
      local pt = {}
      local show = false

      for k = 0, self.bonus.idxs[j] - 1 do
	 table.insert(bt, nwn.DiceRollToString(self.bonus.rolls[j][k]))
	 show = true
      end
	 
      for k = 0, self.penalty.idxs[j] - 1 do
	 table.insert(pt, nwn.DiceRollToString(self.bonus.rolls[j][k]))
	 show = true
      end

      if show then
	 table.insert(dmgt, nwn.GetDamageNameByIndex(j))
	 table.insert(dmgt, "Bonus:" .. table.concat(bt, ", "))
	 table.insert(dmgt, "Penalty:" .. table.concat(pt, ", "))
	 table.insert(out, table.concat(dmgt, "\n"))
      end
   end

   return table.concat(out, "\n")
end

function DamageRoll:ToFormattedString()
   local t = {}

   table.insert(t, self:FormatDamage())
   if self:GetTotalImmunityAdjustment() > 0 then 
      table.insert(t, self:FormatDamageImmunities())
   end
   if self:GetTotalResistAdjustment() > 0 then
      table.insert(t, self:FormatDamageResistance())
   end
   if self.result.soak_adjust > 0 then
      table.insert(t, self:FormatDamageReduction())
   end

   return table.concat(t, "\n")
end


function DamageRoll:FormatDamage()
   local out = {}

   table.insert(out, tostring(self.result.damages[12]) .. " Physical" )

   for i = 0, 11 do
      if self.result.damages[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), self.result.damages[i]))
      end
   end
   local tarname = self.target:GetIsValid() and self.target:GetName() or "Nobody"
   local str = string.format(damage_format, 
                             self.attacker:GetName(false),
                             tarname,
			     self:GetTotal(),
                             table.concat(out, " "))
   return str
end

function DamageRoll:FormatDamageImmunities()
   local out = {}

   table.insert(out, tostring(self.result.immunity_adjust[12]) .. " Physical" )

   for i = 0, 11 do
      if self.result.immunity_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), self.result.immunity_adjust[i]))
      end
   end
   local tarname = self.target:GetIsValid() and self.target:GetName() or "Nobody"
   local str = string.format(immunity_format, 
                             tarname,
                             self:GetTotalImmunityAdjustment(),
                             table.concat(out, " "))
   return str
end

function DamageRoll:FormatDamageResistance()
   local out = {}

   table.insert(out, tostring(self.result.resist_adjust[12]) .. " Physical" )

   for i = 0, 11 do
      if self.result.resist_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), self.result.resist_adjust[i]))
      end
   end
   local tarname = self.target:GetIsValid() and self.target:GetName() or "Nobody"
   local str = string.format(resist_format,
                             tarname,
                             self:GetTotalResistAdjustment(),
                             table.concat(out, " "))
   return str
end

function DamageRoll:FormatDamageReduction()
   local tarname = self.target:GetIsValid() and self.target:GetName() or "Nobody"
   local str = string.format(dr_format,
                             tarname,
                             self.result.soak_adjust)

   return str
end