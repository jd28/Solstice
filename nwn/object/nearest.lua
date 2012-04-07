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
function Object:GetNearestCreature(nFirstCriteriaType, nFirstCriteriaValue, nNth, ...)
   nNth = nNth or 1
   nSecondCriteriaType, nSecondCriteriaValue, nThirdCriteriaType, nThirdCriteriaValue = ...
   nSecondCriteriaType  = nSecondCriteriaType  or -1
   nSecondCriteriaValue = nSecondCriteriaValue or -1
   nThirdCriteriaType   = nThirdCriteriaType   or -1
   nThirdCriteriaValue  = nThirdCriteriaValue  or -1

   nwn.engine.StackPushInteger(nThirdCriteriaValue)
   nwn.engine.StackPushInteger(nThirdCriteriaType)
   nwn.engine.StackPushInteger(nSecondCriteriaValue)
   nwn.engine.StackPushInteger(nSecondCriteriaType)
   nwn.engine.StackPushInteger(nNth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nFirstCriteriaValue)
   nwn.engine.StackPushInteger(nFirstCriteriaType)
   nwn.engine.ExecuteCommand(38, 8)
   nwn.engine.StackPopObject()
end

---
--
function Object:GetNearestObject(nObjectType, nNth)
   nObjectType = nObjectType or OBJECT_TYPE_ALL
   nNth = nNth or 1
   
   nwn.engine.StackPushInteger(nNth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nObjectType)
   nwn.engine.ExecuteCommand(227, 3)
   return nwn.engine.StackPopObject()
end

---
--
function Object:GetNearestObjectByTag(sTag, nNth)
   nNth = nNth or 1

   nwn.engine.StackPushInteger(nNth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushString(sTag)
   nwn.engine.ExecuteCommand(229, 3)
   return nwn.engine.StackPopObject()
end

---
function Object:GetNearestTrap(is_detected)
   nwn.engine.StackPushBoolean(is_detected)
   nwn.engine.StackPushObject(oTarget)
   nwn.engine.ExecuteCommand(488, 2)
   return nwn.engine.StackPopObject()
end

