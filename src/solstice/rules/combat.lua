----
-- @module rules

local ffi = require 'ffi'
local _COMBAT_ENGINE

--- Combat Engine
-- @section combat_engine

--- CombatEngine
-- @table CombatEngine
-- @field DoPreAttack Function to do pre-attack initialization, taking
-- attacker and target object instances.  Note that since DoMeleeAttack,
-- and DoRangedAttack have no parameters, the very least you need to do
-- is store those in local variables for later use.
-- @field DoMeleeAttack Function to do a melee attack.
-- @field DoRangedAttack Function to do a ranged attack.
-- @field UpdateCombatInformation Update combat information function,
-- taking a Creature object instance.  This is optional can be used to do
-- any other book keeping you might need.

--- Register a combat engine.
-- @param engine CombatEngine table.
local function RegisterCombatEngine(engine)
   assert(engine.DoMeleeAttack, "ERROR: Missing DoMeleeAttack!")
   assert(engine.DoPreAttack, "ERROR: Missing DoPreAttack!")
   assert(engine.DoRangedAttack, "ERROR: Missing DoRangedAttack!")
   _COMBAT_ENGINE = engine
   ffi.C.Local_SetCombatEngineActive(true)
end

--- Get current combat engine.
local function GetCombatEngine()
   return _COMBAT_ENGINE
end

--- Set combat engine active.
-- Note this is implicitly called by RegisterCombatEngine.
-- @bool active Turn combat engine on or off.
local function SetCombatEngineActive(active)
   ffi.C.Local_SetCombatEngineActive(active)
end

local M = require 'solstice.rules.init'
M.RegisterCombatEngine = RegisterCombatEngine
M.GetCombatEngine      = GetCombatEngine
