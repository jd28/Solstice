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

--- TODO: finish, test nwn funcs
function NSResolveTargetState(attacker, target, attack_info)
   attacker.ci.target_state_mask = 0
   local mask = 0

   if target:GetIsBlind() then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_BLIND)
   end

   if attacker:GetIsInvisible(target) then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
   end

   if target:GetIsInvisible(attacker) then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_INVIS)
   end

   if not target:GetIsVisibile(attacker) then
      print("COMBAT_TARGET_STATE_ATTACKER_UNSEEN")
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
   end

   if not attacker:GetIsVisibile(target) then
      print("COMBAT_TARGET_STATE_UNSEEN")
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_UNSEEN)
   end

   if target.obj.obj.obj_anim == 4
      or target.obj.obj.obj_anim == 87
      or target.obj.obj.obj_anim == 86
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_MOVING)
   end

   if target.obj.obj.obj_anim == 36       
      or target.obj.obj.obj_anim == 33
      or target.obj.obj.obj_anim == 32
      or target.obj.obj.obj_anim == 7
      or target.obj.obj.obj_anim == 5
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_PRONE)
   end

   if target.obj.cre_state == 6 then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_STUNNED)
   end

   if target:GetIsFlanked(attacker) then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_FLANKED)
   end

   if target:GetIsFlatfooted() then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED)
   end

   if target.obj.cre_state == 9 or target.obj.cre_state == 8 then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ASLEEP)
   end

   attacker.ci.target_state_mask = mask
   attack_info.target_state = mask
end