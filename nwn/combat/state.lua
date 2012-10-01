local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSCheckTargetState(cre, state)
   return bit.band(cre.ci.target_state_mask, state) ~= 0
end

function NSClearTargetState(cre)
   cre.ci.target_state_mask = 0
end

function NSSetTargetState(cre, state)
   cre.ci.target_state_mask = bit.bor(cre.ci.target_state_mask, state)
   return cre.ci.target_state_mask
end

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