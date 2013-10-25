--- Modes
-- @module modes

local Sk = require 'solstice.skill'
local Ft = require 'solstice.feat'
local Obj = require 'solstice.object'

local MODES = {}
local M = {}

M.const = {
   -- Combat Mode Defines
   INVALID                 = 0,
   PARRY                   = 1,
   POWER_ATTACK            = 2,
   IMPROVED_POWER_ATTACK   = 3,
   COUNTER_SPELL           = 4,
   FLURRY_OF_BLOWS         = 5,
   RAPID_SHOT              = 6,
   EXPERTISE               = 7,
   IMPROVED_EXPERTISE      = 8,
   DEFENSIVE_CASTING       = 9,
   DIRTY_FIGHTING          = 10,
   DEFENSIVE_STANCE        = 11,

   ACTION_DETECT                  = 0,
   ACTION_STEALTH                 = 1,
   ACTION_PARRY                   = 2,
   ACTION_POWER_ATTACK            = 3,
   ACTION_IMPROVED_POWER_ATTACK   = 4,
   ACTION_COUNTERSPELL            = 5,
   ACTION_FLURRY_OF_BLOWS         = 6,
   ACTION_RAPID_SHOT              = 7,
   ACTION_EXPERTISE               = 8,
   ACTION_IMPROVED_EXPERTISE      = 9,
   ACTION_DEFENSIVE_CAST          = 10,
   ACTION_DIRTY_FIGHTING          = 11,
   ACTION_DEFENSIVE_STANCE        = 12,
}

setmetatable(M, { __index = M.const })

--- Internal toggle mode function
-- @param cre Creature to toggle mode on
-- @param mode solstice.nwn.ACTION_MODE_*
function NSToggleMode(cre, mode)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   local bypass = true
   local act, on

   if cre:GetIsDead() or cre:GetIsPCDying() then
      return false
   end

   if mode == M.ACTION_DETECT then
      if cre:GetDetectMode() == 1 then
         act, on = 2, 0
      else
         act, on = 2, 1
      end
      cre:SetActivity(act, on)
   elseif mode == M.ACTION_STEALTH then
      if cre.obj.cre_attack_target ~= Obj.INVALID.id
         or cre.obj.cre_attempted_target ~= Obj.INVALID.id
      then
         cre:SendMessageByStrRef(60)
      elseif cre:CanUseSkill(Sk.HIDE) or cre:CanUseSkill(Sk.SILENTLY) then
         if cre.obj.cre_mode_stealth == 1 then
            act, on = 1, 0
         else
            act, on = 1, 1
         end
         cre:SetActivity(act, on)
      end
   elseif mode == M.ACTION_PARRY then
      if cre.obj.cre_mode_combat == M.PARRY then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.PARRY, false)
      end
   elseif mode == M.ACTION_POWER_ATTACK then
      if not cre:GetHasFeat(Ft.POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == M.POWER_ATTACK then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.POWER_ATTACK, false)
      end
   elseif mode == M.ACTION_IMPROVED_POWER_ATTACK then
      if not cre:GetHasFeat(Ft.IMPROVED_POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == M.IMPROVED_POWER_ATTACK then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.IMPROVED_POWER_ATTACK, false)
      end
   elseif mode == M.ACTION_COUNTERSPELL then
      if cre.obj.cre_mode_combat == M.COUNTERSPELL then
         cre:SetCombatMode(M.COUNTERSPELL, false)
      else
         cre:SetCombatMode(M.COUNTERSPELL, true)
      end
   elseif mode == M.ACTION_FLURRY_OF_BLOWS then
      if not cre:GetHasFeat(Ft.FLURRY_OF_BLOWS) then
         return false
      end

      if cre.obj.cre_mode_combat == M.FLURRY_OF_BLOWS then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.FLURRY_OF_BLOWS, false)
      end
   elseif mode == M.ACTION_RAPID_SHOT then
      if not cre:GetHasFeat(Ft.RAPID_SHOT) then
         return false
      end

      if cre.obj.cre_mode_combat == M.RAPID_SHOT then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.RAPID_SHOT, false)
      end
   elseif mode == M.ACTION_EXPERTISE then
      if not cre:GetHasFeat(Ft.EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == M.EXPERTISE then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.EXPERTISE, false)
      end
   elseif mode == M.ACTION_IMPROVED_EXPERTISE then
      if not cre:GetHasFeat(Ft.IMPROVED_EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == M.IMPROVED_EXPERTISE then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.IMPROVED_EXPERTISE, true)
      end
   elseif mode == M.ACTION_DEFENSIVE_CAST then
      if cre.obj.cre_mode_combat == M.DEFENSIVE_CASTING then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.DEFENSIVE_CASTING, false)
      end
   elseif mode == M.ACTION_DIRTY_FIGHTING then
      if not cre:GetHasFeat(Ft.DIRTY_FIGHTING) then
         return false
      end

      if cre.obj.cre_mode_combat == M.DIRTY_FIGHTING then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.DIRTY_FIGHTING, false)
      end
   elseif mode == M.ACTION_DEFENSIVE_STANCE then
      if not cre:GetHasFeat(Ft.DWARVEN_DEFENDER_DEFENSIVE_STANCE) then
         return false
      end

      if cre.obj.cre_mode_combat == M.DEFENSIVE_STANCE then
         cre:SetCombatMode(M.INVALID, true)
      else
         cre:SetCombatMode(M.DEFENSIVE_STANCE, false)
         cre:DecrementRemainingFeatUses(Ft.DWARVEN_DEFENDER_DEFENSIVE_STANCE)
      end
   end

   cre:NotifyAssociateActionToggle(mode)
   return true
end

--- Get a registered combat mode
-- @param M.*
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
   if mode == M.PARRY then
      return M.ACTION_PARRY
   elseif mode == M.POWER_ATTACK then
      return M.ACTION_POWER_ATTACK
   elseif mode == M.IMPROVED_POWER_ATTACK then
      return M.ACTION_IMPROVED_POWER_ATTACK
   elseif mode == M.COUNTER_SPELL then
      return M.ACTION_COUNTERSPELL
   elseif mode == M.FLURRY_OF_BLOWS then
      return M.ACTION_FLURRY_OF_BLOWS
   elseif mode == M.RAPID_SHOT then
      return M.ACTION_RAPID_SHOT
   elseif mode == M.EXPERTISE then
      return M.ACTION_EXPERTISE
   elseif mode == M.IMPROVED_EXPERTISE then
      return M.ACTION_IMPROVED_EXPERTISE
   elseif mode == M.DEFENSIVE_CASTING then
      return M.ACTION_DEFENSIVE_CAST
   elseif mode == M.DIRTY_FIGHTING then
      return M.ACTION_DIRTY_FIGHTING
   elseif mode == M.DEFENSIVE_STANCE then
      return M.ACTION_DEFENSIVE_STANCE
   end

   return -1
end

return M