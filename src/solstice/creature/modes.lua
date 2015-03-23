----
-- @module creature

local ffi = require 'ffi'
local C = ffi.C
local jit = require 'jit'

local M = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature
local GetObjectByID = Game.GetObjectByID

--- Modes
-- @section level

function Creature:GetDetectMode()
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(575, 1);
   return NWE.StackPopInteger();
end

--- Notifies creature's associats of combat mode change
-- @param mode solstice.modes type constant.
function Creature:NotifyAssociateActionToggle(mode)
   C.nwn_NotifyAssociateActionToggle(self.obj, mode)
end

--- Sets a creature's activity
-- @param act
-- @param on
function Creature:SetActivity(act, on)
   C.nwn_SetActivity(self.obj, act, on)
end

jit.off(Creature.SetActivity)

--- Sets creature's combat mode
-- @param mode solstice.modes type constant.
-- @param change If false the combat mode is already active.
function Creature:SetCombatMode(mode, change)
   local current_mode = self.obj.cre_mode_combat
   local off = mode == COMBAT_MODE_INVALID
   if change and self.obj.cre_mode_combat > 11 then
      Rules.ResolveMode(mode, self, off)
      return
   end

   local function set_activity()
      self.obj.cre_mode_combat = mode
      local act, on
      if mode == 1 or current_mode == 1 then
         on = mode == 1
         act = 0x1000
      elseif mode == 2 or current_mode == 2 then
         on = mode == 2
         act = 0x400
      elseif mode == 3 or current_mode == 3 then
         on = mode == 3
         act = 0x800
      elseif mode == 4 or current_mode == 4 then
         on = mode == 4
         act = 0x2000
      elseif mode == 5 or current_mode == 5 then
         on = mode == 5
         act = 0x4000
      elseif mode == 6 or current_mode == 6 then
         on = mode == 6
         act = 0x8000
      elseif mode == 7 or current_mode == 7 then
         on = mode == 7
         act = 0x10000
      elseif mode == 8 or current_mode == 8 then
         on = mode == 8
         act = 0x20000
      elseif mode == 9 or current_mode == 9 then
         on = mode == 9
         act = 0x40000
      elseif mode == 10 or current_mode == 10 then
         on = mode == 10
         act = 0x80000
      elseif mode == 11 or current_mode == 11 then
         on = mode == 11
         act = 0x100000
      else
         return
      end
      self:SetActivity(act, on)
   end

   if not change and mode == current_mode then
      set_activity()
   elseif change or
      self.obj.cre_combat_round == nil or
      self.obj.cre_combat_round.cr_round_started ~= 1
   then
      if off or Rules.ResolveMode(mode, self, off) then
         set_activity()
      end
      if off then
         ffi.fill(self.ci.mod_mode, ffi.sizeof("CombatMod"))
      end
   else
      self.obj.cre_mode_desired = mode
   end
end

jit.off(Creature.SetCombatMode)

-- Sets creature's combat mode
-- @param cre Creature in question.
-- @param mode solstice.modes type constant.
-- @param change If false the combat mode is already active.
function __SetCombatMode(cre, mode, change)
   cre = GetObjectByID(cre)
   cre:SetCombatMode(mode, change)
end
