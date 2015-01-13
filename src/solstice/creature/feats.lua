----
-- @module creature

local ffi = require 'ffi'
local C   = ffi.C

local M = require 'solstice.creature.init'
local Creature = M.Creature

--- Feats
-- @section

--- Add known feat to creature
-- @param feat FEAT_*
-- @param level If level is specified feat will be add at that level. (Default: 0)
function Creature:AddKnownFeat(feat, level)
   if not self:GetIsValid() then return -1 end

   level = level or 0
   return C.nwn_AddKnownFeat(self.obj, feat, level)
end

--- Decrement remaining feat uses.
-- @param feat FEAT_*
function Creature:DecrementRemainingFeatUses(feat)
   local has, feat = self:GetHighestFeat(feat)
   if not has or self:GetRemainingFeatUses(feat, has) == 0 then
      return
   end

   for i=0, self.obj.cre_stats.cs_featuses.len - 1 do
      if self.obj.cre_stats.cs_featuses.data[i].fu_feat == feat then
         self.obj.cre_stats.cs_featuses.data[i].fu_used =
            self.obj.cre_stats.cs_featuses.data[i].fu_used + 1
      end
   end
end

--- Determine if creature has a feat
-- @param feat FEAT_*
-- @param[opt=false] has_uses Check the feat is useable.
-- @param[opt=false] check_successors Check feat successors.
function Creature:GetHasFeat(feat, has_uses, check_successors)
   if not self:GetIsValid() then return false end

   local res = false
   if check_successors then
      res, feat = self:GetHighestFeat(feat)
   end

   if not res then
      for i=0, self.obj.cre_stats.cs_feats.len - 1 do
         if feat == self.obj.cre_stats.cs_feats.data[i] then
            res = true
            break
         end
      end
   end

   if not res then
      for i=0, self.obj.cre_stats.cs_feats_bonus.len - 1 do
         if feat == self.obj.cre_stats.cs_feats_bonus.data[i] then
            res = true
            break
         end
      end
   end

   if res and has_uses then
      res = self:GetRemainingFeatUses(feat, true) > 0
   end

   return res
end

--- Determines the highest known feat.
-- This function checks all feat successors.
-- @param feat FEAT_*
-- @return true if a creature has a feat.
-- @return if creature has the feat, the highest feat is returned.
function Creature:GetHighestFeat(feat)
   local feats = Rules.GetFeatSuccessors(feat)

   if #feats > 0 then
      for i = #feats, 1, -1 do
         if self:GetHasFeat(feats[i], false, false) then
            return true, feats[i]
         end
      end
   end

   return self:GetHasFeat(feat), feat
end

--- Returns the highest feat in a range of feats.
-- @param low_feat FEAT_*
-- @param high_feat FEAT_*
-- @return FEAT_* or -1 on error.
function Creature:GetHighestFeatInRange(low_feat, high_feat)
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
function Creature:GetKnownFeat(index)
   if not self:GetIsValid() or index < 0 or index > self.obj.cre_stats.cs_feats.len then
      return -1
   end

   return self.obj.cre_stats.cs_feats.data[index];
end

--- Gets known feat by level at index
-- @param level Level in question
-- @param idx Index of feat
function Creature:GetKnownFeatByLevel(level, idx)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.obj.cre_stats, level)
   if ls == nil or idx < 0 or idx > ls.ls_featlist.len then
      return -1
   end

   return ls.ls_featlist.data[idx]
end

--- Determines if a creature knows a feat.
-- Feats acquired from gear do not count.
-- @param feat FEAT_*
function Creature:GetKnowsFeat(feat)
   if not self:GetIsValid() then return false end

   return C.nwn_GetKnowsFeat(self.obj.cre_stats, feat)
end

--- Get remaining feat uses
-- @param feat FEAT_*
-- @param[opt=false] has If true function assumes that creature
-- does have the feat in question.
function Creature:GetRemainingFeatUses(feat, has)
   if not self:GetIsValid() then return 0 end
   if not has then
      has, feat = self:GetHighestFeat(feat)
   end
   if not has then return 0 end

   local max = Rules.GetMaximumFeatUses(feat, self)
   if max == 100 or self:GetIsDM() then return 100 end

   local used
   for i=0, self.obj.cre_stats.cs_featuses.len - 1 do
      if self.obj.cre_stats.cs_featuses.data[i].fu_feat == feat then
         used = self.obj.cre_stats.cs_featuses.data[i].fu_used
         break
      end
   end

   if not used then return 100 end
   return math.clamp(max - used, 0, 100)
end

--- Get total feat uses.
-- @param feat FEAT_*
function Creature:GetTotalFeatUses(feat)
   if not self:GetIsValid() then return -1 end
   return Rules.GetMaximumFeatUses(feat, self)
end

--- Get total known feats.
-- @return -1 on error.
function Creature:GetTotalKnownFeats()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_feats.len
end

--- Get total known feats by level.
-- @param level The level to check.
-- @return -1 on error.
function Creature:GetTotalKnownFeatsByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.obj.cre_stats, level)
   if ls == nil then return -1 end

   return ls.ls_featlist.len
end

--- Increment remaining feat uses.
-- @param feat FEAT_*
function Creature:IncrementRemainingFeatUses(feat)
   local has, feat = self:GetHighestFeat(feat)
   if not has or self:GetRemainingFeatUses(feat, has) == 0 then
      return
   end

   for i=0, self.obj.cre_stats.cs_featuses.len - 1 do
      if self.obj.cre_stats.cs_featuses.data[i].fu_feat == feat then
         self.obj.cre_stats.cs_featuses.data[i].fu_used =
            math.max(self.obj.cre_stats.cs_featuses.data[i].fu_used - 1, 0)
      end
   end
end

--- Remove feat from creature.
-- @param feat FEAT_*
function Creature:RemoveKnownFeat(feat)
   if not self:GetIsValid() then return end
   C.nwn_RemoveKnownFeat(self.obj.cre_stats, feat)
end

--- Set known feat on creature
-- @param index Feat index to set
-- @param feat FEAT_*
function Creature:SetKnownFeat(index, feat)
   if not self:GetIsValid() or index < 0 or index > self.obj.cre_stats.cs_feats.len then
      return -1
   end

   self.obj.cre_stats.cs_feats.data[index] = feat
   return self.obj.cre_stats.cs_feats.data[index];
end

--- Set known feat by level
-- @param level Level to set the feat on.
-- @param index Feat index
-- @param feat FEAT_*
function Creature:SetKnownFeatByLevel(level, index, feat)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.obj.cre_stats, level)
   if ls == nil or index < 0 or index > ls.ls_featlist.len then
      return -1
   end

   ls.ls_featlist.data[index] = feat

   return ls.ls_featlist.data[index]
end

function NWNXSolstice_GetRemainingFeatUses(feat, cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   return cre:GetRemainingFeatUses(feat)
end
