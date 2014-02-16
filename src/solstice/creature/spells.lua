--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

--- Spells
-- @section spells

local ne = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C

--- Add known spell to creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_id SPELL\_*
-- @param sp_level Spell level.
function M.Creature:AddKnownSpell(sp_class, sp_id, sp_level)
   return C.nwn_AddKnownSpell(self.obj, sp_class, sp_id, sp_level)
end

--- Decrements the remaining uses of a spell.
-- @param spell SPELL\_*
function M.Creature:DecrementRemainingSpellUses(spell)
   ne.StackPushInteger(spell)
   ne.StackPushObject(self)
   ne.ExecuteCommand(581, 2)
end

--- Get bonus spell slots
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_id SPELL\_*
-- @param sp_level Spell level.
function M.Creature:GetBonusSpellSlots(sp_class, sp_id, sp_level)
   return C.nwn_GetBonusSpellSlots(self.obj, sp_class, sp_level)
end

--- Determines whether a creature has a spell available.
-- @param spell SPELL\_*
function M.Creature:GetHasSpell(spell)
   ne.StackPushObject(self)
   ne.StackPushInteger(spell)
   ne.ExecuteCommand(377, 2)
   return ne.StackPopBoolean()
end

--- Determines whether a creature has a spell available.
-- @param spell SPELL\_*
function M.Creature:GetHasSpell(spell)
   ne.StackPushObject(self)
   ne.StackPushInteger(spell)
   ne.ExecuteCommand(377, 2)
   return ne.StackPopBoolean()
end

--- Gets known spell
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_idx Index of the spell.
-- @return SPELL\_* or -1 on error.
function M.Creature:GetKnownSpell(sp_class, sp_level, sp_idx)
   return C.nwn_GetKnownSpell(self.obj, sp_class, sp_level, sp_idx)
end

--- Determines if creature knows a spell.
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_id SPELL\_*
function M.Creature:GetKnowsSpell(sp_class, sp_id)
   return C.nwn_GetKnowsSpell(self.obj, sp_class, sp_id)
end

--- Gets max spell slots
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
function M.Creature:GetMaxSpellSlots(sp_class, sp_level)
   return C.nwn_GetMaxSpellSlots(self.obj, sp_class, sp_level)
end

--- Determines if a spell is memorized
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_idx Index of the spell.
function M.Creature:GetMemorizedSpell(sp_class, sp_level, sp_idx)
   return C.nwn_GetMemorizedSpell(self.obj, sp_class, sp_level, sp_idx)
end

--- Determines remaining spell slots at level.
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
function M.Creature:GetRemainingSpellSlots(sp_class, sp_level)
   return C.nwn_GetRemainingSpellSlots(self.obj, sp_class, sp_level)
end

--- Determines total known spells at level.
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
function M.Creature:GetTotalKnownSpells(sp_class, sp_level)
   return C.nwn_GetTotalKnownSpells (self.obj, sp_class, sp_level)
end

--- Remove known spell from creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_id SPELL\_*
function M.Creature:RemoveKnownSpell(sp_class, sp_level, sp_id)
   return C.nwn_RemoveKnownSpell (self.obj, sp_class, sp_level, sp_id)
end

--- Remove known spell from creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_id SPELL\_*
-- @param sp_new SPELL\_*
function M.Creature:ReplaceKnownSpell(sp_class, sp_id, sp_new)
   return C.nwn_ReplaceKnownSpell(self.obj, sp_class, sp_id, sp_new)
end

--- Sets a known spell on creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_idx Index of the spell to change.
-- @param sp_id SPELL\_*
function M.Creature:SetKnownSpell(sp_class, sp_level, sp_idx, sp_id)
   return C.nwn_SetKnownSpell (self.obj, sp_class, sp_level, sp_idx, sp_id)
end

--- Sets a memorized spell on creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_idx Index of the spell to change.
-- @param sp_spell SPELL\_*
-- @param sp_meta METAMAGIC_*
-- @param sp_flags Spell flags.
function M.Creature:SetMemorizedSpell(sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)
   return C.nwn_SetMemorizedSpell(self.obj, sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)
end

--- Sets a remaing spell slots on creature
-- @param sp_class CLASS\_TYPE\_*.
-- @param sp_level Spell level.
-- @param sp_slots Number of slots.
function M.Creature:SetRemainingSpellSlots(sp_class, sp_level, sp_slots)
   return C.nwn_SetRemainingSpellSlots (self.obj, sp_class, sp_level, sp_slots)
end
