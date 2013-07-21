--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local Obj = require 'solstice.object'

local M = require 'solstice.creature.init'

--- Effects
-- @section effects

local ffi = require 'ffi'
local C = ffi.C

function M.Creature:CreateEffectDebugString()
   for eff in self:EffectsDirect() do
      table.insert(t, eff:ToString())
   end

   return table.concat(t, "\n")
end

--- Determine if creature has an immunity.
-- @param vs Creature's attacker.
-- @param imm_type solstice.effect.IMMUNITY_TYPE_*
function M.Creature:GetEffectImmunity(vs, imm_type)
   error "nwnxcombat"
end

--- Determins if creature has a feat effect.
-- @param feat solstice.feat type constant
function M.Creature:GetHasFeatEffect(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then return false end
   return self:GetHasSpellEffect(f.feat_spell_id)
end

--- Determins if target is invisible.
-- @param vs Creature to test again.
function M.Creature:GetIsInvisible(vs)
   if vs.type == Obj.internal.CREATURE then
      return C.nwn_GetIsInvisible(self.obj, vs.obj.obj)
   end

   return false
end

--- Gets innate damage immunity.
-- @param dmg_idx damage type index
function M.Creature:GetDamageImmunity(dmg_idx)
   error "nwnxcombat"
end

--- Gets innate damage immunity.
function M.Creature:GetInnateDamageReduction()
   error "nwnxcombat"
end

--- Get innate/feat damage resistance.
-- @param dmg_idx
function M.Creature:GetInnateDamageResistance(dmg_idx)
   error "nwnxcombat"
end

--- Get if creature has immunity.
-- @param immunity solstice.effect.IMMUNITY_TYPE_*
-- @param[opt=solstice.object.INVALID] versus Versus object.
function M.Creature:GetIsImmune(immunity, versus)
   error "nwnxcombat"
end
