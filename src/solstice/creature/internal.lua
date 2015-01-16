--- Creature module
-- @module creature

local M = require 'solstice.creature.init'
local Creature = M.Creature

--- Internal
-- @section internal

-- The following are all functions that you can use on PCs that are
-- normally used only for NPCs

--- Get PC Body Bag field
function Creature:GetPCBodyBag()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_bodybag
end

--- Get PC Body Bag ID field
function Creature:GetPCBodyBagID()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_bodybag_id
end

--- Set PC Body Bag field
-- @param bodybag Any integer.
function Creature:SetPCBodyBag(bodybag)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_bodybag = bodybag
   return self.obj.cre_bodybag
end

--- Set PC Body Bag ID field
-- @param bodybagid Any integer.
function Creature:SetPCBodyBagID(bodybagid)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_bodybag_id = bodybagid
   return self.obj.cre_bodybag_id
end

--- Set PC Lootable field
-- @param lootable Any integer.
function Creature:SetPCLootable(lootable)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_lootable = lootable
   return self.obj.cre_lootable
end
