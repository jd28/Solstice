--- Modes
-- @module modes

local Obj = require 'solstice.object'
local jit = require 'jit'
local MODES = {}
local M = {}

--- Internal toggle mode function
-- @param cre Creature to toggle mode on
-- @param mode solstice.nwn.ACTION_MODE_*
function NSToggleMode(cre, mode)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return false end

   local bypass = true
   local act, on

   if cre:GetIsDead() or cre:GetIsPCDying() then
      return false
   end

   if mode == ACTION_MODE_DETECT then
      if cre:GetDetectMode() == 1 then
         act, on = 2, 0
      else
         act, on = 2, 1
      end
      cre:SetActivity(act, on)
   elseif mode == ACTION_MODE_STEALTH then
      if cre.obj.cre_attack_target ~= OBJECT_INVALID.id
         or cre.obj.cre_attempted_target ~= OBJECT_INVALID.id
      then
         cre:SendMessageByStrRef(60)
      elseif cre:CanUseSkill(SKILL_HIDE) or cre:CanUseSkill(SKILL_MOVE_SILENTLY) then
         if cre.obj.cre_mode_stealth == 1 then
            act, on = 1, 0
         else
            act, on = 1, 1
         end
         cre:SetActivity(act, on)
      end
   elseif mode == ACTION_MODE_PARRY then
      if cre.obj.cre_mode_combat == COMBAT_MODE_PARRY then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_PARRY, false)
      end
   elseif mode == ACTION_MODE_POWER_ATTACK then
      if not cre:GetHasFeat(FEAT_POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_POWER_ATTACK then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_POWER_ATTACK, false)
      end
   elseif mode == ACTION_MODE_IMPROVED_POWER_ATTACK then
      if not cre:GetHasFeat(FEAT_IMPROVED_POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_IMPROVED_POWER_ATTACK then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_IMPROVED_POWER_ATTACK, false)
      end
   elseif mode == ACTION_MODE_COUNTERSPELL then
      if cre.obj.cre_mode_combat == COMBAT_MODE_COUNTERSPELL then
         cre:SetCombatMode(COMBAT_MODE_COUNTERSPELL, false)
      else
         cre:SetCombatMode(COMBAT_MODE_COUNTERSPELL, true)
      end
   elseif mode == ACTION_MODE_FLURRY_OF_BLOWS then
      if not cre:GetHasFeat(FEAT_FLURRY_OF_BLOWS) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_FLURRY_OF_BLOWS then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_FLURRY_OF_BLOWS, false)
      end
   elseif mode == ACTION_MODE_RAPID_SHOT then
      if not cre:GetHasFeat(FEAT_RAPID_SHOT) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_RAPID_SHOT then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_RAPID_SHOT, false)
      end
   elseif mode == ACTION_MODE_EXPERTISE then
      if not cre:GetHasFeat(FEAT_EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_EXPERTISE then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_EXPERTISE, false)
      end
   elseif mode == ACTION_MODE_IMPROVED_EXPERTISE then
      if not cre:GetHasFeat(FEAT_IMPROVED_EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_IMPROVED_EXPERTISE then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_IMPROVED_EXPERTISE, true)
      end
   elseif mode == ACTION_MODE_DEFENSIVE_CAST then
      if cre.obj.cre_mode_combat == COMBAT_MODE_DEFENSIVE_CASTING then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_DEFENSIVE_CASTING, false)
      end
   elseif mode == ACTION_MODE_DIRTY_FIGHTING then
      if not cre:GetHasFeat(FEAT_DIRTY_FIGHTING) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_DIRTY_FIGHTING then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_DIRTY_FIGHTING, false)
      end
   elseif mode == ACTION_MODE_DEFENSIVE_STANCE then
      if not cre:GetHasFeat(FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE) then
         return false
      end

      if cre.obj.cre_mode_combat == COMBAT_MODE_DEFENSIVE_STANCE then
         cre:SetCombatMode(COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(COMBAT_MODE_DEFENSIVE_STANCE, false)
         cre:DecrementRemainingFeatUses(FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE)
      end
   end

   cre:NotifyAssociateActionToggle(mode)
   return true
end

jit.off(NSToggleMode)

--- Get a registered combat mode
-- @param mode
function M.Get(mode)
   return MODES[mode]
end

--- Register a combat mode.
-- See examples/modes.lua
-- @param mode
-- @param f A function taking object, mode, and a boolean indicating whether the mode is being
-- turned on or off.
function M.Register(mode, f)
   MODES[mode] = f
end

--- Convert solstice.modes constants to solstice.modes.ACTION_*
-- @param mode solstice.modes constant.
-- @return -1 on error.
function M.ToAction(mode)
   if mode == COMBAT_MODE_PARRY then
      return ACTION_MODE_PARRY
   elseif mode == COMBAT_MODE_POWER_ATTACK then
      return ACTION_MODE_POWER_ATTACK
   elseif mode == COMBAT_MODE_IMPROVED_POWER_ATTACK then
      return ACTION_MODE_IMPROVED_POWER_ATTACK
   elseif mode == COMBAT_MODE_COUNTER_SPELL then
      return ACTION_MODE_COUNTERSPELL
   elseif mode == COMBAT_MODE_FLURRY_OF_BLOWS then
      return ACTION_MODE_FLURRY_OF_BLOWS
   elseif mode == COMBAT_MODE_RAPID_SHOT then
      return ACTION_MODE_RAPID_SHOT
   elseif mode == COMBAT_MODE_EXPERTISE then
      return ACTION_MODE_EXPERTISE
   elseif mode == COMBAT_MODE_IMPROVED_EXPERTISE then
      return ACTION_MODE_IMPROVED_EXPERTISE
   elseif mode == COMBAT_MODE_DEFENSIVE_CASTING then
      return ACTION_MODE_DEFENSIVE_CAST
   elseif mode == COMBAT_MODE_DIRTY_FIGHTING then
      return ACTION_MODE_DIRTY_FIGHTING
   elseif mode == COMBAT_MODE_DEFENSIVE_STANCE then
      return ACTION_MODE_DEFENSIVE_STANCE
   end

   return -1
end

return M
