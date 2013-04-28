require 'nwn.effects'

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
          result = self:GetDexMod()
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
