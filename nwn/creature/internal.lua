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
