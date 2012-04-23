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
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveDevCrit(attacker, target, attack_info)
   if NS_SETTINGS.NS_OPT_DEVCRIT_DISABLE_ALL then
      return
   end

   if NS_SETTINGS.NS_OPT_DEVCRIT_DISABLE_PC and attacker:GetIsPC() then
      return
   end

   local dc = 10 + math.floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(nwn.ABILITY_STRENGTH)
   print("NSResolveDevCrit", dc)
   if target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_DEATH, attacker) == 0 then
      local eff = nwn.EffectDeath(true, true)
      eff:SetSubType(nwn.SUBTYPE_SUPERNATURAL)
      target:ApplyEffect(eff)

      attack_info.attack.cad_attack_result = 10
   end
end

function NSResolvePostMeleeDamage(attacker, target, attack_info)
   if not target:GetIsValid() then return end

   NSResolveDevCrit(attacker, target, attack_info)
end

function NSResolvePostRangedDamage(attacker, target, attack_data)
   if not target:GetIsValid() then return end

   local cr = attacker.obj.cre_combat_round
end
