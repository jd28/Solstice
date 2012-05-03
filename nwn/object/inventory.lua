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
-- @return
function Object:GetFirstItemInInventory()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(339, 1)

   return nwn.engine.StackPopObject()
end

--- Determines if object has an inventory.
function Object:GetHasInventory()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(570, 1)
   nwn.engine.StackPopBoolean()
end

--- Determines if an object has an item by tag
function Object:HasItem(tag)
   local item = self:GetItemPossessedBy(tag)
   return item:GetIsValid()
end

--- Determine if object has an item
-- @param tag Object tag to search for
-- @param is_resref If true search by reserf rather than tag.
function Object:GetItemPossessedBy(tag, is_resref)
   if not is_resref then
      nwn.engine.StackPushString(tag)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(30, 2)
      return nwn.engine.StackPopObject()
   else
      for item in Object:Items() do
         if tag == item:GetResref() then
            return item
         end
      end
   end
end

--- Iterator over items in an object's inventory
function Object:Items()
   local obj = self:GetFirstItemInInventory()
   local prev_obj 
   return function()
      while obj do
         prev_obj = obj
         obj = self:GetNextItemInInventory()
         return prev_obj
      end
   end
end

---
-- @return
function Object:GetNextItemInInventory()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(340, 1)
   return nwn.engine.StackPopObject()
end

--- Create a specific item in an objects inventory.
-- NWScript: CreateItemOnObject
-- @param resref The blueprint ResRef string of the item to be created or tag.
-- @param stack_size The number of items to be created. (Default: 1) 
-- @param new_tag If this string is empty (""), it be set to the default tag from the template. (Default: "") 
-- @return The new item or nwn.OBJECT_INVALID on error.
function Object:GiveItem(resref, stack_size, new_tag, only_once)
   if only_once then
      local item = self:GetItemPossessedBy(resref, true)
      if item then return item end
   end
   stack_size = stack_size or 1
   new_tag = new_tag or ""

   nwn.engine.StackPushString(new_tag)
   nwn.engine.StackPushInteger(stack_size)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushString(resref)
   nwn.engine.ExecuteCommand(31, 4)
   return nwn.engine.StackPopObject()
end

---Open Inventory of specified target
-- @param target Creature to view the inventory of.
function Object:OpenInventory(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(701, 2)
end
