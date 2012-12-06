--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.ctypes.item'
local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
typedef struct Item {
    uint32_t        type;
    uint32_t        id;
    CNWSItem       *obj; 
} Item;

]]

local item_mt = { __index = Item }
item_t = ffi.metatype("Item", item_mt)

--- Add an itemproperty to an item
-- @param dur_type nwn.DURATION_TYPE_*
-- @param ip Itemproperty to add.
-- @param Duration (if added temporarily). (Default: 0.0) 
function Item:AddItemProperty(dur_type, ip, duration)
   nwn.engine.StackPushFloat(duration or 0.0)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY, ip)
   nwn.engine.StackPushInteger(dur_type)
   nwn.engine.ExecuteCommand(609, 4)
end

--- Duplicates an item.
-- @param target Create the item within this object's inventory
--    (Default: nwn.OBJECT_INVALID) 
-- @param copy_vars If true, local variables on item are
--    copied. (Default: false)
function Item:Copy(target, copy_vars)
   nwn.engine.StackPushBoolean(copy_vars)
   nwn.engine.StackPushObject(target or nwn.OBJECT_INVALID)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(584, 3)
   
   return nwn.engine.StackPopObject()
end

--- Copies an item, making a single modification to it
-- @param modtype Type of modification to make.
-- @param index Index of the modification to make.
-- @param value New value of the modified index
-- @param copy_vars If true, local variables on item are
--    copied. (Default: false)
function Item:CopyAndModify(modtype, index, value, copy_vars)
   nwn.engine.StackPushBoolean(copy_vars)
   nwn.engine.StackPushInteger(value)
   nwn.engine.StackPushInteger(index)
   nwn.engine.StackPushInteger(modtype)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(731, 5)

   return nwn.engine.StackPopObject()
end

--- Get the armor class (AC) of an item.
function Item:GetACValue()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(401, 1)

   return nwn.engine.StackPopInteger()
end

--- Gets Armor's Base AC bonus.
-- @return -1 if item is not armor.
function Item:GetBaseArmorACBonus()
   if not self:GetIsValid()
      or self:GetBaseType() ~= nwn.BASE_ITEM_ARMOR 
   then
      return -1
   end

   local is_ided = self:GetIdentified()
   
   local cost = self:GetGoldValue()
   if cost == 1        then return 0
   elseif cost == 5    then return 1
   elseif cost == 10   then return 2
   elseif cost == 15   then return 3
   elseif cost == 100  then return 4
   elseif cost == 150  then return 5
   elseif cost == 200  then return 6
   elseif cost == 600  then return 7
   elseif cost == 1500 then return 8
   end

   self:SetIdentified(is_ided)

   return -1
end

--- Get the base item type (nwn.BASE_ITEM_*) of item.
-- @return nwn.BASE_ITEM_INVALID if invalid item.
function Item:GetBaseType()
   if not self:GetIsValid() then return nwn.BASE_ITEM_INVALID end
   return self.obj.it_baseitem
end

--- Determines if an item can be dropped.
function Item:GetDroppable()
   if not self:GetIsValid() then return -1 end
   return self.obj.it_droppable == 1
end

--- Encodes an items appearance
-- Source: nwnx_funcs by Acaos
-- @return A string encoding the appearance
function Item:GetEntireAppearance()
   local app = {}
   for i = 0, 5 do
      table.insert(app, string.format("%02X", self.obj.it_color[i]))
   end

   for i = 0, 21 do
      table.insert(app, string.format("%02X", self.obj.it_model[i]))
   end
   
   return table.concat(app)
end

--- Determines the value of an item in gold pieces.
function Item:GetGoldValue()
   if not self:GetIsValid() then return -1 end
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(311, 1)
   
   return nwn.engine.StackPopInteger()
end

--- Check whether an item has a given property.
-- @param ip_type nwn.ITEM_PROPERTY_*
function Item:GetHasItemProperty(ip_type)
   return C.nwn_HasPropertyType(self.obj, ip_type) ~= 0
end

--- Determines whether an object has been identified.
function Item:GetIdentified()
   if not self:GetIsValid() then return false end
   return self.obj.it_identified == 1
end

--- Determine if item is monk weapon.
function Item:GetIsMonkWeapon()
   return nwn.GetIsMonkWeapon(self:GetBaseType())
end

--- Determine if item is ranged weapon.
function Item:GetIsRangedWeapon()
   if not self:GetIsValid() then return false end

   local base = self:GetBaseType()
   if base == nwn.BASE_ITEM_LONGBOW
      or base == nwn.BASE_ITEM_SHORTBOW
      or base == nwn.BASE_ITEM_THROWINGAXE
      or base == nwn.BASE_ITEM_SLING
      or base == nwn.BASE_ITEM_DART
      or base == nwn.BASE_ITEM_SHURIKEN
      or base == nwn.BASE_ITEM_HEAVYCROSSBOW
      or base == nwn.BASE_ITEM_LIGHTCROSSBOW
   then
      return true
   end
   
   return false
end

--- Determine if item is unarmed weapon.
function Item:GetIsUnarmedWeapon()
   if not self:GetIsValid() then return true end
   
   local baseitem = self:GetBaseType()
   if baseitem == nwn.BASE_ITEM_GLOVES
      or baseitem == nwn.BASE_ITEM_BRACER
      or baseitem == nwn.BASE_ITEM_CSLASHWEAPON
      or baseitem == nwn.BASE_ITEM_CPIERCWEAPON
      or baseitem == nwn.BASE_ITEM_CBLUDGWEAPON
      or baseitem == nwn.BASE_ITEM_CSLSHPRCWEAP
   then 
      return true
   end

   if NS_OPT_USING_CEP >= 23 then
      if baseitem == cep.BASE_ITEM_GLOVES_SPIKED
	 or baseitem == cep.BASE_ITEM_GLOVES_BLADED
      then
	 return true
      end
   end

   return false
end

--- Determines the first itemproperty on an item
function Item:GetFirstItemProperty()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(612, 1)

   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY)
end

--- Determines the next itemproperty on an item
function Item:GetNextItemProperty()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(613, 1)

   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY)
end

--- Iterates over an items properties
function Item:ItemProperties()
   ip, _ip = self:GetFirstItemProperty()
   return function ()
      while ip:GetIsValid() do
         _ip, ip = ip, self:GetNextItemProperty()
         return _ip
      end
   end
end

--- Gets if there is an infinite quantity of any item in a store.
function Item:GetInfiniteFlag()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(827, 1)
   return nwn.engine.StackPopBoolean
end

--- Returns the appearance of an item
-- @param appearance_type nwn.ITEM_APPR_TYPE_*
-- @param index nwn.ITEM_APPR_WEAPON_* or nwn.ITEM_APPR_ARMOE_*
function Item:GetItemAppearance(appearance_type, index)
   nwn.engine.StackPushInteger(index)
   nwn.engine.StackPushInteger(appearance_type)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(732, 3)

   return nwn.engine.StackPopInteger()
end

--- Removes an item property
-- @param ip Item property to remove.
function Item:RemoveItemProperty(ip)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_ITEMPROPERTY, ip)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(610, 2)
end

--- Restores an items appearance.
-- @param appearance An encoding from Item:GetEntireAppearance
function Item:RestoreAppearance(appearance)
   local app = {}
   string.gsub(appearance, "(%w%w)",
               function (x) 
                  table.insert(app, tonumber(x, 16))
               end)

   local j
   for i, val in ipairs(app) do
      j = i - 1

      if j < 6 then
         self.obj.it_color[j] = val
      else
         self.obj.it_model[j - 6] = val
      end
   end
end

---
function Item:SetAppearance(index, value)
   if not self:GetIsValid()
      or index < nwn.ITEM_APPR_COLOR_LEATHER_1
      or index > nwn.ITEM_APPR_ARMOR_MODEL_ROBE
      or value < 0 or value > 255
   then
      return -1
   end
   
   if index < nwn.ITEM_APPR_MODEL_PART_1 then
      self.obj.it_color[index + 9] = value
   else
      self.obj.it_model[index + 3] = value
   end

   return value
end

--- Sets an items base type
-- Source: nwnx_funcs by Acaos
function Item:SetBaseType(value)
   if not self:GetIsValid() then return -1 end
   self.obj.it_baseitem = value
end

---
function Item:SetColor(index, value)
   if not self:GetIsValid() or index < 0 or index > 5
      or value < 0 or value > 255
   then
      return -1 
   end

   self.obj.it_color[index] = value
   return self.obj.it_color[index]
end

--- Sets an items gold piece value when IDed
-- Source: nwnx_funcs by Acaos
-- @param value New gold value.
function Item:SetGoldValue(value)
   if not self:GetIsValid() then return -1 end
   
   self.obj.it_cost_ided = value
   return self.obj.it_cost_ided
end

--- Sets an item identified
-- @param is_ided true or false (Default: false)
function Item:SetIdentified(is_ided)
   if not self:GetIsValid() then return end
   self.obj.it_identified = is_ided and 1 or 0
end

--- Sets and items infinite quantity flag/
-- @param infinite true or false
function Item:SetInfiniteFlag(infinite)
   nwn.engine.StackPushBoolean(infinite)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(828, 2)
end

--- Sets and items weight.
-- @param weight New weight.
function Item:SetWeight(weight)
   if not self:GetIsValid() then return -1 end
   self.obj.it_weight = weight
end