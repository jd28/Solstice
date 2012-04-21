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
function Object:FortitudeSave(nDC, nSaveType, oSaveVersus)
   nwn.engine.StackPushObject(oSaveVersus)
   nwn.engine.StackPushInteger(nSaveType)
   nwn.engine.StackPushInteger(nDC)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(108, 4)
   return nwn.engine.StackPopBoolean()
end

---
function Object:GetFortitudeSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(491, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetReflexSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(493, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetWillSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(492, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:ReflexSave(nDC, nSaveType, oSaveVersus)
   nwn.engine.StackPushObject(oSaveVersus)
   nwn.engine.StackPushInteger(nSaveType)
   nwn.engine.StackPushInteger(nDC)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(109, 4)
   return nwn.engine.StackPopBoolean()
end

---
function Object:SetFortitudeSavingThrow(nFortitudeSave)
   nwn.engine.StackPushInteger(nFortitudeSave)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(813, 2)
end

---
function Object:SetReflexSavingThrow(nReflexSave)
   nwn.engine.StackPushInteger(nReflexSave)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(812, 2)
end

---
function Object:SetWillSavingThrow(nWillSave)
   nwn.engine.StackPushInteger(nWillSave)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(811, 2)
end

---
function Object:WillSave(nDC, nSaveType, oSaveVersus)
   nwn.engine.StackPushObject(oSaveVersus)
   nwn.engine.StackPushInteger(nSaveType)
   nwn.engine.StackPushInteger(nDC)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(110, 4)
   return nwn.engine.StackPopBoolean()
end
