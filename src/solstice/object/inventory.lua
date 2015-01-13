--- Object
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Inventory
-- @section inventory

---
-- @return
function Object:GetFirstItemInInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(339, 1)

   return NWE.StackPopObject()
end

--- Determines if object has an inventory.
function Object:GetHasInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(570, 1)
   NWE.StackPopBoolean()
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
      NWE.StackPushString(tag)
      NWE.StackPushObject(self)
      NWE.ExecuteCommand(30, 2)
      return NWE.StackPopObject()
   else
      for item in self:Items() do
         if tag == item:GetResRef() then
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
      while obj:GetIsValid() do
         prev_obj = obj
         obj = self:GetNextItemInInventory()
         return prev_obj
      end
   end
end

---
-- @return
function Object:GetNextItemInInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(340, 1)
   return NWE.StackPopObject()
end

--- Create a specific item in an objects inventory.
-- NWScript: CreateItemOnObject
-- @param resref The blueprint ResRef string of the item to be created or tag.
-- @param[opt=1] stack_size The number of items to be created.
-- @param[opt=""] new_tag If this string is empty (""), it be set to the default tag from the template.
-- @param[opt=false] only_once If true, function will not give item if
-- object already possess one.
-- @return The new item or solstice.object.INVALID on error.
function Object:GiveItem(resref, stack_size, new_tag, only_once)
   if only_once then
      local item = self:GetItemPossessedBy(resref, true)
      if item then return item end
   end
   stack_size = stack_size or 1
   new_tag = new_tag or ""

   NWE.StackPushString(new_tag)
   NWE.StackPushInteger(stack_size)
   NWE.StackPushObject(self)
   NWE.StackPushString(resref)
   NWE.ExecuteCommand(31, 4)
   return NWE.StackPopObject()
end

---Open Inventory of specified target
-- @param target Creature to view the inventory of.
function Object:OpenInventory(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(701, 2)
end

--- Get number of items that an object carries.
-- @param id Tag or Resref.
-- @param[opt=false] Use resref.
function Object:CountItem(id, resref)
   local count = 0
   for item in self:Items() do
      if resref then
         if id == item:GetResRef() then
            count = count + item:GetStackSize()
         end
      else
         if id == item:GetTag() then
            count = count + item:GetStackSize()
         end
      end
   end
   return count
end

--- Get number of items that an object carries.
-- @param id Tag or Resref.
-- @param[opt=1] How many of the items to take.
-- @param[opt=false] Use resref.
function Object:TakeItem(id, count, resref)
   count = count or 1
   if count > self:CountItem(id, resref) then
      return 0
   end
   local taken = 0
   for item in self:Items() do
      if count == 0 then break end
      local take = false
      if resref then
         if id == item:GetResRef() then
            take = true
         end
      else
         if id == item:GetTag() then
            take = true
         end
      end

      if take then
         local stacksize = item:GetStackSize()
         if stacksize > count then
            taken = taken + count
            item:SetStackSize(stacksize - count)
            count = 0
         else
            count = count - stacksize
            taken = taken + stacksize
            item:Destroy(0.2)
         end
      end
   end
   return taken
end
