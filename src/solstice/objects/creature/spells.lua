----
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature

--- Spells
-- @section spells

local ne = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C

function Creature:AddKnownSpell(sp_class, sp_id, sp_level)
   return C.nwn_AddKnownSpell(self.obj, sp_class, sp_id, sp_level)
end

function Creature:DecrementRemainingSpellUses(spell)
   ne.StackPushInteger(spell)
   ne.StackPushObject(self)
   ne.ExecuteCommand(581, 2)
end

function Creature:GetBonusSpellSlots(sp_class, sp_level)
   return C.nwn_GetBonusSpellSlots(self.obj, sp_class, sp_level)
end

function Creature:GetHasSpell(spell)
   ne.StackPushObject(self)
   ne.StackPushInteger(spell)
   ne.ExecuteCommand(377, 2)
   return ne.StackPopBoolean()
end

function Creature:GetKnownSpell(sp_class, sp_level, sp_idx)
   return C.nwn_GetKnownSpell(self.obj, sp_class, sp_level, sp_idx)
end

function Creature:GetKnowsSpell(sp_class, sp_id)
   return C.nwn_GetKnowsSpell(self.obj, sp_class, sp_id)
end

function Creature:GetMaxSpellSlots(sp_class, sp_level)
   return C.nwn_GetMaxSpellSlots(self.obj, sp_class, sp_level)
end

function Creature:GetMemorizedSpell(sp_class, sp_level, sp_idx)
   return C.nwn_GetMemorizedSpell(self.obj, sp_class, sp_level, sp_idx)
end

function Creature:GetRemainingSpellSlots(sp_class, sp_level)
   return C.nwn_GetRemainingSpellSlots(self.obj, sp_class, sp_level)
end

function Creature:GetTotalKnownSpells(sp_class, sp_level)
   return C.nwn_GetTotalKnownSpells (self.obj, sp_class, sp_level)
end

function Creature:RemoveKnownSpell(sp_class, sp_level, sp_id)
   return C.nwn_RemoveKnownSpell (self.obj, sp_class, sp_level, sp_id)
end

function Creature:ReplaceKnownSpell(sp_class, sp_id, sp_new)
   return C.nwn_ReplaceKnownSpell(self.obj, sp_class, sp_id, sp_new)
end

function Creature:SetKnownSpell(sp_class, sp_level, sp_idx, sp_id)
   return C.nwn_SetKnownSpell (self.obj, sp_class, sp_level, sp_idx, sp_id)
end

function Creature:SetMemorizedSpell(sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)
   return C.nwn_SetMemorizedSpell(self.obj, sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)
end

function Creature:SetRemainingSpellSlots(sp_class, sp_level, sp_slots)
   return C.nwn_SetRemainingSpellSlots (self.obj, sp_class, sp_level, sp_slots)
end
