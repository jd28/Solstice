require 'nwn.effects'

local ffi = require 'ffi'

-- Effect accumulator locals
local bonus = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local penalty = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local save_amount = nwn.CreateEffectAmountFunc(0)
local save_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_SAVING_THROW_DECREASE,
					     nwn.EFFECT_TRUETYPE_SAVING_THROW_INCREASE)

function Creature:DebugSaves()
   return ""
end

--- Gets creatures saving throw bonus
-- @param save nwn.SAVING_THROW_*
function Creature:GetSavingThrowBonus(save)
   if not self:GetIsValid() then return 0 end

   local bonus = 0

   if save == nwn.SAVING_THROW_FORT then
      bonus = self.stats.cs_save_fort
   elseif save == nwn.SAVING_THROW_REFLEX then
      bonus = stats.cs_save_reflex
   elseif save == nwn.SAVING_THROW_WILL then
      bonus = stats.cs_save_will
   end

   return bonus
end

--- Gets maximum saving throw bonus from gear/effects.
-- @param save nwn.SAVING_THROW_*
-- @param save_vs nwn.SAVING_THROW_TYPE_*
function Creature:GetMaxSaveMod(save, save_vs)
   return 20
end

--- Gets minimum saving throw bonus from gear/effects.
-- @param save nwn.SAVING_THROW_*
-- @param save_vs nwn.SAVING_THROW_TYPE_*
function Creature:GetMinSaveMod(save, save_vs)
   return -20
end

--- Sets creatures saving throw bonus
-- @param save nwn.SAVING_THROW_*
-- @param bonus New saving throw bonus
function Creature:SetSavingThrowBonus(save, bonus)
   if not self:GetIsValid() then return 0 end

   if save == nwn.SAVING_THROW_FORT then
      self.stats.cs_save_fort = bonus
   elseif save == nwn.SAVING_THROW_REFLEX then
      stats.cs_save_reflex = bonus
   elseif save == nwn.SAVING_THROW_WILL then
      stats.cs_save_will = bonus
   end

   return bonus
end

--- Gets total saving throw bonus from gear/effects.
-- @param vs Versus another creature.
-- @param save nwn.SAVING_THROW_*
-- @param save_vs nwn.SAVING_THROW_TYPE_*
function Creature:GetTotalEffectSaveBonus(vs, save, save_vs)
   local function valid(eff, vs_info)
      if eff:GetInt(1) ~= save 
	 or (save_vs ~= 0 and save_vs ~= eff:GetInt(2))
      then
	 return false
      end

      -- If using versus info is globally disabled return true.
      if not NS_OPT_USE_VERSUS_INFO then return true end

      local race      = eff:GetInt(3)
      local lawchaos  = eff:GetInt(4)
      local goodevil  = eff:GetInt(5)
      local subrace   = eff:GetInt(6)
      local deity     = eff:GetInt(7)
      local target    = eff:GetInt(8)

      if (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
	 and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
	 and (goodevil == 0 or goodevil == vs_info.goodevil)
	 and (subrace == 0 or subrace == vs_info.subrace_id)
	 and (deity == 0 or deity == vs_info.deity_id)
	 and (target == 0 or target == vs_info.target)
      then
	 return true
      end
      return false
   end

   local vs_info
   if NS_OPT_USE_VERSUS_INFO then
      vs_info = nwn.GetVersusInfo(vs)
   end
   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						 penalty,
						 vs_info,
						 SAVE_EFF_INFO,
						 save_range,
						 valid,
						 save_amount,
						 math.max,
						 self.stats.cs_first_save_eff)
   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_idx - 1 do
      if SAVE_EFF_INFO.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = math.max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_idx - 1 do
      if SAVE_EFF_INFO.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = math.max(pen_total, penalty[i])
      end
   end

   return math.clamp(bon_total - pen_total,
		     self:GetMinSaveMod(save, save_vs),
		     self:GetMaxSaveMod(save, save_vs))
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Gets total saving throw bonus from gear/effects.
-- @param cre Creature
-- @param vs Versus other creature.
-- @param save nwn.SAVING_THROW_*
-- @param save_vs nwn.SAVING_THROW_TYPE_*
function NSGetTotalSaveBonus(cre, vs, save, save_vs)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)

   return cre:GetTotalEffectSaveBonus(vs, save, save_vs)
end
