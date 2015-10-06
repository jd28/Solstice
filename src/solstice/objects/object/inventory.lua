--- Object
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Inventory
-- @section inventory

function Object:GetFirstItemInInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(339, 1)

   return NWE.StackPopObject()
end

function Object:GetHasInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(570, 1)
   NWE.StackPopBoolean()
end

function Object:HasItem(tag)
   local item = self:GetItemPossessedBy(tag)
   return item:GetIsValid()
end

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
   return OBJECT_INVALID
end

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

function Object:GetNextItemInInventory()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(340, 1)
   return NWE.StackPopObject()
end

function Object:GiveItem(resref, stack_size, new_tag, only_once)
   if only_once then
      local item = self:GetItemPossessedBy(resref, true)
      if item:GetIsValid() then return item end
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

function Object:OpenInventory(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(701, 2)
end

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
