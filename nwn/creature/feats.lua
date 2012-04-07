--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

require 'nwn.funcs'
local ffi = require 'ffi'
local C = ffi.C

---
-- @param feat
-- @param level
function Creature:AddKnownFeat(feat, level)
   if not self:GetIsValid() then return -1 end

   level = level or 0
   return C.nwn_AddKnownFeat(self, feat, level)
end

---
-- @param feat
function Creature:DecrementRemainingFeatUses(feat)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(580, 2)
end

---
-- @param feat
function Creature:GetHasFeat(feat)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.ExecuteCommand(285, 2)
   return nwn.engine.StackPopBoolean()
end

---
-- @param low_feat
-- @param high_feat
function Creature:GetHighestFeatInRange(low_feat, high_feat)
   while high_feat >= low_feat do
      if self:GetHasFeat(high_feat) then
         return high_feat
      end
      high_feat = high_feat - 1
   end
end

---
-- @param index
function Creature:GetKnownFeat(index)
   if not self:GetIsValid() or index < 0 or index > self.stats.cs_feats.len then
      return -1
   end

   return self.stats.cs_feats.data[idx];
end

---
-- @param level
-- @param idx
function Creature:GetKnownFeatByLevel(level, idx)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil or idx < 0 or idx > ls.ls_featlist.len then
      return -1
   end

   return ls.ls_featlist.data[idx]
end

---
-- @param feat
function Creature:GetKnowsFeat(feat)
   if not self:GetIsValid() then return false end
   
   return C.nwn_GetKnowsFeat(self.stats, feat)
end

---
-- @param feat
function Creature:GetRemainingFeatUses(feat)
   if not self:GetIsValid() then return -1 end

   return C.nwn_GetRemainingFeatUses(self.stats, feat)
end

---
-- @param feat
function Creature:GetTotalFeatUses(feat)
   if not self:GetIsValid() then return -1 end
   return C.nwn_GetTotalFeatUses(self.stats, feat)
end

---
function Creature:GetTotalKnownFeats()
   if not self:GetIsValid() then return -1 end

   return self.stats.cs_feats.len
end

---
-- @param level
function Creature:GetTotalKnownFeatsByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_featlist.len
end

---
-- @param feat
function Creature:IncrementRemainingFeatUses(feat)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(718, 2)
end

---
-- @param feat
function Creature:RemoveKnownFeat(feat)
   if not self:GetIsValid() then return end
   C.nwn_RemoveKnownFeat(self.stats, feat)
end

---
-- @param index
-- @param feat
function Creature:SetKnownFeat(index, feat)
   if not self:GetIsValid() or index < 0 or idx > self.stats.cs_feats.len then
      return -1
   end

   self.stats.cs_feats.data[idx] = feat
   return self.stats.cs_feats.data[idx];
end

---
-- @param level
-- @param index
-- @param feat
function Creature:SetKnownFeatByLevel(level, index, feat)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.stats, level)
   if ls == nil or index < 0 or index > ls.ls_featlist.len then
      return -1
   end

   ls.ls_featlist.data[index] = feat

   return ls.ls_featlist.data[index]
end