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
   return self.obj.cre_bodybag
end

---
--
function Creature:GetPCBodyBagID()
   return self.obj.cre_bodybag_id
end

---
--
function Creature:SetPCBodyBag(bodybag)
   self.obj.cre_bodybag = bodybag
end

---
--
function Creature:SetPCBodyBagID(bodybagid)
   self.obj.cre_bodybag_id = bodybagid
end

---
--
function Creature:SetPCLootable(lootable)
   self.obj.cre_lootable = lootable
end
