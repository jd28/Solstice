---
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature

local USE_VERSUS = OPT.USE_VERSUS
local random = math.random

--- Effects
-- @section effects

local ffi = require 'ffi'
local C = ffi.C

function Creature:CreateEffectDebugString()
   local t = {}
   for eff in self:Effects(true) do
      table.insert(t, eff:ToString())
   end

   return table.concat(t, "\n")
end

--- Determine if creature has an immunity.
-- @param imm_type IMMUNITY_TYPE_*
-- @param[opt] vs Creature's attacker.
function Creature:GetEffectImmunity(imm_type, vs)
   return Rules.GetEffectImmunity(self, imm_type, vs)
end

--- Determins if creature has a feat effect.
-- @param feat FEAT_*
function Creature:GetHasFeatEffect(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then return false end
   return self:GetHasSpellEffect(f.feat_spell_id)
end

--- Determins if target is invisible.
-- @param vs Creature to test again.
function Creature:GetIsInvisible(vs)
   if vs.type == OBJECT_TRUETYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, vs.obj.obj)
   end

   return false
end

--- Get if creature has immunity.
-- @param immunity IMMUNITY_TYPE_*
-- @param[opt] versus Versus object.
function Creature:GetIsImmune(immunity, versus)
   if self:GetIsInvulnerable() then return true end
   local imm = self:GetEffectImmunity(immunity, versus)
   if imm <= 0 then return false
   elseif imm >= 100 then return true
   end

   return random(100) <= imm
end
