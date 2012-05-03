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

--- Gets nearest creature by criteria types and values
function Object:GetNearestCreature(type1, value2, nth, ...)
   nth = nth or 1
   type2, value2, type3, value3 = ...
   type2  = type2  or -1
   value2 = value2 or -1
   type3  = type3  or -1
   value3 = value3 or -1

   nwn.engine.StackPushInteger(value3)
   nwn.engine.StackPushInteger(type3)
   nwn.engine.StackPushInteger(value2)
   nwn.engine.StackPushInteger(type2)
   nwn.engine.StackPushInteger(nth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(value1)
   nwn.engine.StackPushInteger(type1)
   nwn.engine.ExecuteCommand(38, 8)
   nwn.engine.StackPopObject()
end

--- Get nearest object
-- @param obj_type nwn.OBJEC_TYPE_* (Default: nwn.OBJECT_TYPE_ALL)
-- @param nth Which object to return (Default: 1)
function Object:GetNearestObject(obj_type, nth)
   obj_type = obj_type or nwn.OBJECT_TYPE_ALL
   nth = nth or 1
   
   nwn.engine.StackPushInteger(nth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(obj_type)
   nwn.engine.ExecuteCommand(227, 3)
   return nwn.engine.StackPopObject()
end

--- Get nearest object by tag.
-- @param tag Tag of object
-- @param nth Which object to return
function Object:GetNearestObjectByTag(tag, nth)
   nth = nth or 1

   nwn.engine.StackPushInteger(nth)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushString(tag)
   nwn.engine.ExecuteCommand(229, 3)
   return nwn.engine.StackPopObject()
end

--- Get nearest trap.
-- @param is_detected If true return only detected traps. (Default: false)
function Object:GetNearestTrap(is_detected)
   nwn.engine.StackPushBoolean(is_detected)
   nwn.engine.StackPushObject(oTarget)
   nwn.engine.ExecuteCommand(488, 2)
   return nwn.engine.StackPopObject()
end

