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
function Object:GetColor(channel)
   nwn.engine.StackPushInteger(channel)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(843, 2)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetDescription(bOriginalDescription, bIdentifiedDescription)
   bOriginalDescription = bOriginalDescription and 0 or 1
   bIdentifiedDescription = bIdentifiedDescription and 1 or 0
   
   nwn.engine.StackPushInteger(bIdentifiedDescription)
   nwn.engine.StackPushInteger(bOriginalDescription)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(836, 3)
   return nwn.engine.StackPopString()
end

---
function Object:GetGold()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(418, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetMaxHitPoints()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(50, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetName(original)
   nwn.engine.StackPushBoolean(original)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(253, 2)
   return nwn.engine.StackPopString()
end

---
function Object:GetType()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(106, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetPlotFlag()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(455, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Object:GetPortraitId()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(831, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetPortraitResRef()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(833, 1)
   return nwn.engine.StackPopString()
end

---
function Object:GetResRef()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(582, 1)
   return nwn.engine.StackPopString()
end

---
function Object:GetTag()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(168, 1)
   return nwn.engine.StackPopString()
end

---
function Object:SetColor(channel, value)
   nwn.engine.StackPushInteger(value)
   nwn.engine.StackPushInteger(channel)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(844, 3)
end

---
function Object:SetDescription(description, identified)
   description = description or ""
   if identified == nil then identified = true end
   
   nwn.engine.StackPushBoolean(identified)
   nwn.engine.StackPushString(description)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(837, 3)
end

---
function Object:SetIsDestroyable(bDestroyable, bRaiseable, bSelectableWhenDead)
   bDestroyable = bDestroyable and 1 or 0
   bRaiseable = bRaiseable and 1 or 0
   bSelectableWhenDead = bSelectableWhenDead and 0 or 1
   
   nwn.engine.StackPushInteger(bSelectableWhenDead)
   nwn.engine.StackPushInteger(bRaiseable)
   nwn.engine.StackPushInteger(bDestroyable)
   nwn.engine.ExecuteCommand(323, 3)
end

---
function Object:SetName(name)
   name = name or ""
   
   nwn.engine.StackPushString(name)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(830, 2)
end

---
function Object:SetPlotFlag(bPlotFlag)
   bPlotFlag = bPlotFlag and 1 or 0

   nwn.engine.StackPushInteger(bPlotFlag)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(456, 2)
end

---
function Object:SetPortraitId(nPortraitId)
   nwn.engine.StackPushInteger(nPortraitId)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(832, 2)
end

---
function Object:SetPortraitResRef(sPortraitResRef)
   nwn.engine.StackPushString(sPortraitResRef)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(834, 2)
end

