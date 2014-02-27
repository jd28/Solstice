--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

--- Internal
-- @section internal

-- The following are all functions that you can use on PCs that are 
-- normally used only for NPCs

--- Get PC Body Bag field
function M.Creature:GetPCBodyBag()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_bodybag
end

--- Get PC Body Bag ID field
function M.Creature:GetPCBodyBagID()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_bodybag_id
end

--- Set PC Body Bag field
-- @param bodybag Any integer.
function M.Creature:SetPCBodyBag(bodybag)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_bodybag = bodybag
   return self.obj.cre_bodybag
end

--- Set PC Body Bag ID field
-- @param bodybagid Any integer.
function M.Creature:SetPCBodyBagID(bodybagid)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_bodybag_id = bodybagid
   return self.obj.cre_bodybag_id
end

--- Set PC Lootable field
-- @param lootable Any integer.
function M.Creature:SetPCLootable(lootable)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_lootable = lootable
   return self.obj.cre_lootable
end
