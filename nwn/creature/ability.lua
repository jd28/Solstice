require 'nwn.effects'

local ffi = require "ffi"
local C = ffi.C

-- Accumulator functions
local bonus = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local penalty = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local abil_amount = nwn.CreateEffectAmountFunc(1)
local abil_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_ABILITY_DECREASE,
					      nwn.EFFECT_TRUETYPE_ABILITY_INCREASE)


function Creature:DebugAbilityScores()
   local fmt_table = {}
   local fmt = "Str: %d, Dex: %d, Con: %d, Wis: %d, Cha: %d\n"

   table.insert(fmt_table, "Base: ")
   table.insert(fmt_table, string.format(fmt,
					 self:GetAbilityScore(nwn.ABILITY_STRENGTH, true),
					 self:GetAbilityScore(nwn.ABILITY_DEXTERITY, true),
					 self:GetAbilityScore(nwn.ABILITY_CONSTITUTION, true),
					 self:GetAbilityScore(nwn.ABILITY_WISDOM, true),
					 self:GetAbilityScore(nwn.ABILITY_CHARISMA, true)))

   table.insert(fmt_table, "Effects: ")
   table.insert(fmt_table, string.format(fmt,
					 self:GetTotalEffectAbilityMod(nwn.ABILITY_STRENGTH),
					 self:GetTotalEffectAbilityMod(nwn.ABILITY_DEXTERITY),
					 self:GetTotalEffectAbilityMod(nwn.ABILITY_CONSTITUTION),
					 self:GetTotalEffectAbilityMod(nwn.ABILITY_WISDOM),
					 self:GetTotalEffectAbilityMod(nwn.ABILITY_CHARISMA)))

   return table.concat(fmt_table)
end

--- Gets ability score that was raised at a particular level.
-- @return nwn_ABILITY_* or -1 on error.
function Creature:GetAbilityIncreaseByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_ability
end

--- Get the ability score of a specific type for a creature. 
-- NWScript: GetAbilityModifier
-- @param ability nwn.ABILITY_*.
-- @param base If set to true will return the base ability score
--      without bonuses (e.g. ability bonuses granted from equipped
--      items). If nothing entered, defaults to false.
-- @return Returns the ability score of type <em>ability<em> for self
--      (otherwise -1). 
function Creature:GetAbilityModifier(ability, base)
    local result = -1

    if base then 
        result = (self:GetAbilityScore(ability, base) - 10) / 2
    else
       if ability == nwn.ABILITY_STRENGTH then
          result = self.stats.cs_str_mod
       elseif ability == nwn.ABILITY_DEXTERITY then
          -- Dex may need to change.
          result = self.stats.cs_dex_mod
       elseif ability == nwn.ABILITY_CONSTITUTION then
          result = self.stats.cs_con_mod
       elseif ability == nwn.ABILITY_INTELLIGENCE then
          result = self.stats.cs_int_mod
       elseif ability == nwn.ABILITY_WISDOM then
          result = self.stats.cs_wis_mod
       elseif ability == nwn.ABILITY_CHARISMA then
          result = self.stats.cs_cha_mod
       end
    end

    return result
end

--- Get the ability score of a specific type for a creature. 
-- NWScript: GetAbilityScore
-- @param ability nwn.ABILITY_*.
-- @param base If set to TRUE will return the base ability score
--      without bonuses (e.g. ability bonuses granted from equipped
--      items). If nothing entered, defaults to false.
-- @return Returns the ability score of type ability for self
--      (otherwise -1). 
function Creature:GetAbilityScore(ability, base)
   local result = -1

   if not base then
      nwn.engine.StackPushBoolean(base)
      nwn.engine.StackPushInteger(ability)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(139, 3)
      result = nwn.engine.StackPopInteger() 
   else
      if ability == nwn.ABILITY_STRENGTH then
         result = self.stats.cs_str
      elseif ability == nwn.ABILITY_DEXTERITY then
         -- Dex may need to change.
         result = self.stats.cs_dex
      elseif ability == nwn.ABILITY_CONSTITUTION then
         result = self.stats.cs_con
      elseif ability == nwn.ABILITY_INTELLIGENCE then
         result = self.stats.cs_int
      elseif ability == nwn.ABILITY_WISDOM then
         result = self.stats.cs_wis
      elseif ability == nwn.ABILITY_CHARISMA then
         result = self.stats.cs_cha
      end
   end
   return result
end

--- Gets a creatures dexterity modifier.
-- @param armor_check If true uses armor check penalty (Default: false)
function Creature:GetDexMod(armor_check)
   return C.nwn_GetDexMod(self.stats, armor_check)
end

--- Gets a creatures max ability modifier from gear/effects.
-- @param abil nwn.ABILITY_*
function Creature:GetMaxAbilityMod(abil)
   return 12
end

--- Gets a creatures minimum ability modifier from gear/effects.
-- @param abil nwn.ABILITY_*
function Creature:GetMinAbilityMod(abil)
   return -12
end

--- Modifies the ability score of a specific type for a creature. 
-- NWScript: nwnx_funcs by Acaos.
-- @param ability nwn.ABILITY_*.
-- @param value Amount to modify ability score
-- @return Returns the ability score of type ability for self
--      (otherwise -1). 
function Creature:ModifyAbilityScore(ability, value)
    local abil = self:GetAbilityScore(ability, true) + value
    
    return self:SetAbilityScore(ability, abil)
end

--- Recalculates a creatures dexterity modifier.
function Creature:RecalculateDexModifier()
   if not self:GetIsValid() then return -1 end

   return C.nwn_RecalculateDexModifier(self.stats)
end

--- Sets the ability score of a specific type for a creature. 
-- NWScript: nwnx_funcs by Acaos.
-- @param ability nwn.ABILITY_*.
-- @param value Amount to modify ability score
-- @return Returns the ability score of type ability for self
--      (otherwise -1). 
function Creature:SetAbilityScore(ability, value)
   value = math.clamp(value, 3, 255)
   return C.nwn_SetAbilityScore(self, ability, value)
end

--- Get total ability modifier from effects/gear.
-- @param vs Versus another creature.
-- @param abil nwn.ABILITY_*
function Creature:GetTotalEffectAbilityMod(abil)
   local function valid(eff)
      return abil == eff:GetInt(0)
   end

   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						 penalty,
						 nil,
						 ABILITY_EFF_INFO,
						 abil_range,
						 valid,
						 abil_amount,
						 math.max,
						 self.stats.cs_first_ability_eff)
   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_idx - 1 do
      if ABILITY_EFF_INFO.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = math.max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_idx - 1 do
      if ABILITY_EFF_INFO.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = math.max(pen_total, penalty[i])
      end
   end

   return math.clamp(bon_total - pen_total, 
		     self:GetMinAbilityMod(abil), 
		     self:GetMaxAbilityMod(abil))
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Get total ability bonus from effects/gear.
-- @param cre Creature
-- @param abil nwn.ABILITY_*
function NSGetTotalEffectAbilityMod(cre, abil)
   cre = _NL_GET_CACHED_OBJECT(cre)

   return cre:GetTotalEffectAbilityMod(abil)
end
