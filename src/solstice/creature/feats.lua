--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local ffi = require 'ffi'
local C   = ffi.C
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.creature.init'

--- Feats
-- @section

--- Add known feat to creature
-- @param feat solstice.feat constant
-- @param level If level is specified feat will be add at that level. (Default: 0)
function M.Creature:AddKnownFeat(feat, level)
   if not self:GetIsValid() then return -1 end

   level = level or 0
   return C.nwn_AddKnownFeat(self, feat, level)
end

--- Decrement remaining feat uses.
-- @param feat solstice.feat constant
function M.Creature:DecrementRemainingFeatUses(feat)
   NWE.StackPushInteger(feat)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(580, 2)
end

--- Determine if creature has a feat
-- @param feat solstice.feat constant
function M.Creature:GetHasFeat(feat)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(feat)
   NWE.ExecuteCommand(285, 2)
   return NWE.StackPopBoolean()
end

--- Returns the highest feat in a range of feats.
-- @param low_feat solstice.feat constant
-- @param high_feat solstice.feat constant
-- @return solstice.feat constant or -1 on error.
function M.Creature:GetHighestFeatInRange(low_feat, high_feat)
   while high_feat >= low_feat do
      if self:GetHasFeat(high_feat) then
         return high_feat
      end
      high_feat = high_feat - 1
   end

   return -1
end

--- Gets known feat at index
-- @param index Index of feat
function M.Creature:GetKnownFeat(index)
   if not self:GetIsValid() or index < 0 or index > self.stats.cs_feats.len then
      return -1
   end

   return self.stats.cs_feats.data[idx];
end

--- Gets known feat by level at index
-- @param level Level in question
-- @param idx Index of feat
function M.Creature:GetKnownFeatByLevel(level, idx)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil or idx < 0 or idx > ls.ls_featlist.len then
      return -1
   end

   return ls.ls_featlist.data[idx]
end

--- Determines if a creature knows a feat.
-- Feats acquired from gear do not count.
-- @param feat solstice.feat constant
function M.Creature:GetKnowsFeat(feat)
   if not self:GetIsValid() then return false end
   
   return C.nwn_GetKnowsFeat(self.stats, feat)
end

--- Get remaining feat uses
-- @param feat solstice.feat constant
function M.Creature:GetRemainingFeatUses(feat)
   if not self:GetIsValid() then return -1 end

   return C.nwn_GetRemainingFeatUses(self.stats, feat)
end

--- Get total feat uses.
-- @param feat solstice.feat constant
function M.Creature:GetTotalFeatUses(feat)
   if not self:GetIsValid() then return -1 end
   return C.nwn_GetTotalFeatUses(self.stats, feat)
end

--- Get total known feats.
-- @return -1 on error.
function M.Creature:GetTotalKnownFeats()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_feats.len
end

--- Get total known feats by level.
-- @param level The level to check.
-- @return -1 on error.
function M.Creature:GetTotalKnownFeatsByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_featlist.len
end

--- Increment remaining feat uses.
-- @param feat solstice.feat constant
function M.Creature:IncrementRemainingFeatUses(feat)
   NWE.StackPushInteger(feat)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(718, 2)
end

--- Remove feat from creature.
-- @param feat solstice.feat constant
function M.Creature:RemoveKnownFeat(feat)
   if not self:GetIsValid() then return end
   C.nwn_RemoveKnownFeat(self.stats, feat)
end

--- Set known feat on creature
-- @param index Feat index to set
-- @param feat solstice.feat constant
function M.Creature:SetKnownFeat(index, feat)
   if not self:GetIsValid() or index < 0 or idx > self.stats.cs_feats.len then
      return -1
   end

   self.stats.cs_feats.data[idx] = feat
   return self.stats.cs_feats.data[idx];
end

--- Set known feat by level
-- @param level Level to set the feat on.
-- @param index Feat index
-- @param feat solstice.feat constant
function M.Creature:SetKnownFeatByLevel(level, index, feat)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil or index < 0 or index > ls.ls_featlist.len then
      return -1
   end

   ls.ls_featlist.data[index] = feat

   return ls.ls_featlist.data[index]
end
