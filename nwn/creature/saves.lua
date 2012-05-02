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
function Creature:GetMaxSaveBonus(save, save_vs)
   return 20
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
      local esave     = eff.eff_integers[1]
      local esave_vs  = eff.eff_integers[2]
      local race      = eff.eff_integers[3]
      local lawchaos  = eff.eff_integers[4]
      local goodevil  = eff.eff_integers[5]
      local subrace   = eff.eff_integers[6]
      local deity     = eff.eff_integers[7]
      local target    = eff.eff_integers[8]

      if (esave == 0 or esave == save)
         and (esave_type == 0 or esave_type == save_type)
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
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

   local function range(type)
      if type > nwn.EFFECT_TRUETYPE_SAVING_THROW_DECREASE
         or type < nwn.EFFECT_TRUETYPE_SAVING_THROW_INCREASE
      then
         return false
      end
      return true
   end

   local function get_amount(eff)
      return eff.eff_integers[0]
   end

   local info = effect_info_t(self.stats.cs_first_ability_eff, 
                              nwn.EFFECT_TRUETYPE_SAVING_THROW_DECREASE,
                              nwn.EFFECT_TRUETYPE_SAVING_THROW_INCREASE,
                              NS_OPT_EFFECT_SAVE_STACK,
                              NS_OPT_EFFECT_SAVE_STACK_GEAR,
                              NS_OPT_EFFECT_SAVE_STACK_SPELL)

   return math.clamp(self:GetTotalEffectBonus(vs, info, range, valid, get_amount),
                     0, self:GetMaxSaveBonus(save, save_vs))
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
