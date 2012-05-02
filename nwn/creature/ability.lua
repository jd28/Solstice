--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local ffi = require "ffi"
local C = ffi.C

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

--- Gets a creatures max ability bonus from gear/effects.
-- @param abil nwn.ABILITY_*
function Creature:GetMaxAbilityBonus(abil)
   return 12
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

--- Get total ability bonus from effects/gear.
-- @param vs Versus another creature.
-- @param abil nwn.ABILITY_*
function Creature:GetTotalEffectAbilityBonus(vs, abil)
   local function valid(eff, vs_info)
      local eabil = eff.eff_integers[0]

      if eabil == abil then
         return true
      end
      return false
   end

   local function range(type)
      if type > nwn.EFFECT_TRUETYPE_ABILITY_DECREASE
         or type < nwn.EFFECT_TRUETYPE_ABILITY_INCREASE
      then
         return false
      end
      return true
   end

   local function get_amount(eff)
      return eff.eff_integers[1]
   end

   local info = effect_info_t(self.stats.cs_first_ability_eff, 
                              nwn.EFFECT_TRUETYPE_ABILITY_DECREASE,
                              nwn.EFFECT_TRUETYPE_ABILITY_INCREASE,
                              NS_OPT_EFFECT_ABILITY_STACK,
                              NS_OPT_EFFECT_ABILITY_STACK_GEAR,
                              NS_OPT_EFFECT_ABILITY_STACK_SPELL)

   return math.clamp(self:GetTotalEffectBonus(vs, info, range, valid, get_amount),
                     0, self:GetMaxAbilityBonus(abil))
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Get total ability bonus from effects/gear.
-- @param cre Creature
-- @param vs Versus another creature.
-- @param abil nwn.ABILITY_*
function NSGetTotalAbilityBonus(cre, vs, abil)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)

   return cre:GetTotalEffectAbilityBonus(vs, abil)
end