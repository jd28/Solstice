--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local ffi = require 'ffi'
local C = ffi.C
local jit = require 'jit'

local M = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'
local Mode = require 'solstice.modes'

--- Modes
-- @section level

function M.Creature:GetDetectMode()
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(575, 1);
   return NWE.StackPopInteger();
end

--- Notifies creature's associats of combat mode change
-- @param mode solstice.modes type constant.
function M.Creature:NotifyAssociateActionToggle(mode)
   C.nwn_NotifyAssociateActionToggle(self.obj, mode)
end

--- Sets a creature's activity
-- @param act
-- @param on
function M.Creature:SetActivity(act, on)
   C.nwn_SetActivity(self.obj, act, on)
end

jit.off(M.Creature.SetActivity)

--- Sets creature's combat mode
-- @param mode solstice.modes type constant.
-- @param change If false the combat mode is already active.
function M.Creature:SetCombatMode(mode, change)
   local current_mode = self.obj.cre_mode_combat
   local off = mode == Mode.INVALID
   if change and self.obj.cre_mode_combat > 11 then
      local f = Mode.Get(self.obj.cre_mode_combat)
      if f then
         f(self, mode, true)
         self.obj.cre_mode_combat = 0
         -- TODO: Remove all mode effects.
      end
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
      local f = Mode.Get(mode)
      if f and not f(self, mode, off) then
         return
      end

      set_activity()
   else
      self.obj.cre_mode_desired = mode
   end
end

jit.off(M.Creature.SetCombatMode)

--- Sets creature's combat mode
-- @param cre Creature in question.
-- @param mode solstice.modes type constant.
-- @param change If false the combat mode is already active.
function NSSetCombatMode(cre, mode, change)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   cre:SetCombatMode(mode, change)
end
