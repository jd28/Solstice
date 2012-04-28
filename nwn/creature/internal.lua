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

---
--
function Creature:GetPCBodyBag()
   if not self:GetIsValid then return -1 end
   return self.obj.cre_bodybag
end

---
--
function Creature:GetPCBodyBagID()
   if not self:GetIsValid then return -1 end
   return self.obj.cre_bodybag_id
end

---
--
function Creature:SetPCBodyBag(bodybag)
   if not self:GetIsValid then return -1 end

   self.obj.cre_bodybag = bodybag
   return self.obj.cre_bodybag
end

---
--
function Creature:SetPCBodyBagID(bodybagid)
   if not self:GetIsValid then return -1 end

   self.obj.cre_bodybag_id = bodybagid
   return self.obj.cre_bodybag_id
end

---
--
function Creature:SetPCLootable(lootable)
   if not self:GetIsValid then return -1 end

   self.obj.cre_lootable = lootable
   return self.obj.cre_lootable
end
