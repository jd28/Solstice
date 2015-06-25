--- Modes
-- @module rules

--- Modes
-- @section modes

local ffi = require 'ffi'
local jit = require 'jit'
local MODES = {}
local M = require 'solstice.rules.init'
GetObjectByID = Game.GetObjectByID

-- Internal toggle mode function
-- @param cre Creature to toggle mode on
-- @param mode ACTION_MODE_*
function __ToggleMode(cre, mode)
   cre = GetObjectByID(cre)
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

jit.off(__ToggleMode)

--- Register a combat mode.
-- @param mode
-- @param f A function taking a creature object returning a boolean value
-- indicating whether the mode was useable.
local function RegisterMode(mode, f)
   MODES[mode] = f
end

--- Updates combat modifer when mode changes.
-- @param mode COMBAT_MODE_*.
-- @param cre Creature object
-- @bool[opt=false] off True if the mode is being turned off.
function M.ResolveMode(mode, cre, off)
   ffi.fill(cre.ci.mod_mode, ffi.sizeof("CombatMod"))
   local f = MODES[mode]
   if not f then return end
   return f(cre, mode, off)
end

--- Convert COMBAT_MODE_\* to ACTION_MODE_\*.
-- @param mode COMBAT_MODE_\*.
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

--Defensive Cast--------------------------------------------------------
local function def_cast(cre, mode, off)
   -- Nothing to be done but return true really
   -- Concentration checks are dealt with during damage application.
   return true
end

RegisterMode(COMBAT_MODE_DEFENSIVE_CASTING, def_cast)

--Defensive Stance-------------------------------------------------------
local function def_stance(cre, mode, off)
   return true
end
RegisterMode(COMBAT_MODE_DEFENSIVE_STANCE, def_stance)

--Dirty Fighting--------------------------------------------------------
local function dirty(cre, mode, off)
   if off then return true end
   -- Really is worthless but there you go.  Attack number modifications
   -- are dealth with in Rules.InitializeNumberOfAttacks
   cre.ci.mod_mode.dmg.type = DAMAGE_INDEX_BASE_WEAPON
   cre.ci.mod_mode.dmg.roll.dice = 1
   cre.ci.mod_mode.dmg.roll.sides = 4

   return true
end

RegisterMode(COMBAT_MODE_DIRTY_FIGHTING, dirty)

--Expertise-------------------------------------------------------------

local function expertise(cre, mode, off)
   if off then return true end

   if mode == COMBAT_MODE_IMPROVED_EXPERTISE then
      cre.ci.mod_mode.ab = -10
      cre.ci.mod_mode.ac = 10
   else
      cre.ci.mod_mode.ab = -5
      cre.ci.mod_mode.ac = 5
   end

   return true
end

RegisterMode(COMBAT_MODE_EXPERTISE, expertise)
RegisterMode(COMBAT_MODE_IMPROVED_EXPERTISE, expertise)

--Flurry of Blows-------------------------------------------------------
local function flurry(cre, mode, off)
   if off then return true end

   local result = false
   local monk = cre:GetLevelByClass(CLASS_TYPE_MONK)
   local rh = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)

   if not rh:GetIsValid() then
      -- Creature is unarmed
      result = true
   elseif Rules.GetIsRangedWeapon(rh) then
      -- Right hand is valid and is a ranged weapon.
      result = false
   else
      -- If it's a monk weapon and creature has enough levels of monk to
      -- use it, then check if there is an offhand weapon.
      if Rules.GetIsMonkWeapon(rh) then
         local lh = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
         if not lh:GetIsValid() then
            -- lefthand weapon if invalid
            -- righthand weapon is a monk weapon
            result = true
         else
            result = Rules.GetIsMonkWeapon(lh)
         end
      else
         -- righthand weapon is not a monk weapon.
         result = false
      end
   end

   if result then
      -- Addition onhand attack is dealt with in NSInitializeNumberOfAttacks.
      -- So only the AB needs to be set here.
      cre.ci.mod_mode.ab = -2
   else
      cre:SendMessageByStrRef(66246)
   end

   return result
end

RegisterMode(COMBAT_MODE_FLURRY_OF_BLOWS, flurry)

--Power Attack----------------------------------------------------------
local function power_attack(cre, mode, off)
   if off then return true end

   cre.ci.mod_mode.dmg.type = DAMAGE_INDEX_BASE_WEAPON
   if mode == COMBAT_MODE_IMPROVED_POWER_ATTACK then
      cre.ci.mod_mode.ab = -10
      cre.ci.mod_mode.dmg.roll.bonus = 10
   else
      cre.ci.mod_mode.ab = -5
      cre.ci.mod_mode.dmg.roll.bonus = 5
   end

   return true
end

RegisterMode(COMBAT_MODE_POWER_ATTACK, power_attack)
RegisterMode(COMBAT_MODE_IMPROVED_POWER_ATTACK, power_attack)

--Rapid Shot------------------------------------------------------------
local function rapid_shot(cre, mode, off)
   if off then return true end

   local weap = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not Rules.GetIsRangedWeapon(weap) then
      cre:SendMessageByStrRef(66246)
      return false
   end

   -- Addition onhand attack is dealt with in Rules.InitializeNumberOfAttacks.
   -- So only the AB needs to be set here.
   cre.ci.mod_mode.ab = -2

   return true
end

RegisterMode(COMBAT_MODE_RAPID_SHOT, rapid_shot)


--Parry-----------------------------------------------------------------
local function parry(cre, mode, off)
   -- The parry ripostes are dealth with in the attack roll.
   -- Nothing to be done but return true.
   return true
end

RegisterMode(COMBAT_MODE_PARRY, parry)

-- Exports
M.RegisterMode = RegisterMode
return M
