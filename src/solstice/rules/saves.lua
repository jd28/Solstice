-----
-- @module rules

--- Saves
-- @section saves

--- Get save effect limits.
-- @param cre Creature.
-- @param save SAVING_THROW_*
-- @param save_vs SAVING_THROW_VS_*
-- @return -20
-- @return 20
local function GetSaveEffectLimits(cre, save, save_vs)
   return -20, 20
end

--- Get save effect bonus unclamped.
-- @param cre Creature.
-- @param save SAVING_THROW_*
-- @param save_vs SAVING_THROW_VS_*
local function GetSaveEffectBonus(cre, save, save_vs)
   local res = 0
   for i = cre.obj.cre_stats.cs_first_save_eff, cre.obj.obj.obj_effects_len - 1 do
      local type = cre.obj.obj.obj_effects[i].eff_type
      if type ~= EFFECT_TYPE_SAVING_THROW_INCREASE
         and type ~= EFFECT_TYPE_SAVING_THROW_DECREASE
      then
         break
      end
      local amt = cre.obj.obj.obj_effects[i].eff_integers[0]
      local sv = cre.obj.obj.obj_effects[i].eff_integers[1]
      local vs = cre.obj.obj.obj_effects[i].eff_integers[2]
      if cre.obj.obj.obj_effects[i].eff_integers[3] == 28
         and cre.obj.obj.obj_effects[i].eff_integers[4] == 0
         and cre.obj.obj.obj_effects[i].eff_integers[5] == 0
         and (sv == 0 or sv == save)
         and (save_vs == 0 or save_vs == vs)
      then
         if type == EFFECT_TYPE_SAVING_THROW_INCREASE then
            res = res + amt
         else
            res = res - amt
         end
      end
   end
   return res
end

local M = require 'solstice.rules.init'
M.GetSaveEffectLimits = GetSaveEffectLimits
M.GetSaveEffectBonus  = GetSaveEffectBonus
