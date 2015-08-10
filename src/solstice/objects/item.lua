-----------------------------------------------
-- Defines the Item class.
-- @module item
-- @alias M

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Eff = require 'solstice.effect'
local IP  = require 'solstice.itemprop'

local M = require 'solstice.objects.init'
local Item = inheritsFrom({}, M.Object)
M.Item = Item

function Item.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_ITEM
      },
      { __index = Item })
end

--- Armor Class
-- @section

--- Get the armor classof an item.
function Item:GetACValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(401, 1)

   return NWE.StackPopInteger()
end

--- Compute armor class.
function Item:ComputeArmorClass()
   if not self:GetIsValid() then return 0 end
   return ffi.C.nwn_ComputeArmorClass(self.obj)
end

--- Gets Armor's Base AC bonus.
-- Note this is currently hardcoded to the typical vanilla NWN values.
-- @return -1 if item is not armor.
function Item:GetBaseArmorACBonus()
   if not self:GetIsValid()
      or self:GetBaseType() ~= BASE_ITEM_ARMOR
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

--- Copying
-- @section item

--- Duplicates an item.
-- @param[opt=OBJECT_INVALID] target Create the item within this object's
-- inventory
-- @param[opt=false] copy_vars If true, local variables on item are copied.
function Item:Copy(target, copy_vars)
   NWE.StackPushBoolean(copy_vars)
   NWE.StackPushObject(target or OBJECT_INVALID)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(584, 3)

   return NWE.StackPopObject()
end

--- Copies an item, making a single modification to it
-- @param modtype Type of modification to make.
-- @param index Index of the modification to make.
-- @param value New value of the modified index
-- @param[opt=false] copy_vars If true, local variables on item are copied.
function Item:CopyAndModify(modtype, index, value, copy_vars)
   NWE.StackPushBoolean(copy_vars)
   NWE.StackPushInteger(value)
   NWE.StackPushInteger(index)
   NWE.StackPushInteger(modtype)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(731, 5)

   return NWE.StackPopObject()
end

--- Type
-- @section

--- Get the base item type.
-- @return BASE_ITEM_INVALID if invalid item.
function Item:GetBaseType()
   if not self:GetIsValid() then return BASE_ITEM_INVALID end
   return self.obj.it_baseitem
end

--- Sets an items base type
-- Source: nwnx_funcs by Acaos
function Item:SetBaseType(value)
   if not self:GetIsValid() then return -1 end
   self.obj.it_baseitem = value
end

--- Appearance
-- @section

--- Encodes an items appearance
-- Source: nwnx_funcs by Acaos
-- @return A string encoding the appearance
function Item:GetEntireAppearance()
   if not self:GetIsValid() then return "" end
   local app = {}
   for i = 0, 5 do
      table.insert(app, string.format("%02X", self.obj.it_color[i]))
   end

   for i = 0, 21 do
      table.insert(app, string.format("%02X", self.obj.it_model[i]))
   end

   return table.concat(app)
end

--- Returns the appearance of an item
-- @param appearance_type ITEM_APPR_TYPE_*
-- @param index ITEM_APPR_WEAPON_* or ITEM_APPR_ARMOR_*
function Item:GetItemAppearance(appearance_type, index)
   NWE.StackPushInteger(index)
   NWE.StackPushInteger(appearance_type)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(732, 3)

   return NWE.StackPopInteger()
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

--- Set item appearance
-- @param index
-- @param value
function Item:SetAppearance(index, value)
   if not self:GetIsValid()
      or index < ITEM_APPR_COLOR_LEATHER_1
      or index > ITEM_APPR_ARMOR_MODEL_ROBE
      or value < 0 or value > 255
   then
      return -1
   end

   if index < ITEM_APPR_MODEL_PART_1 then
      self.obj.it_color[index + 9] = value
   else
      self.obj.it_model[index + 3] = value
   end

   return value
end

--- Set item color
-- @param index
-- @param value
function Item:SetColor(index, value)
   if not self:GetIsValid() or index < 0 or index > 5
      or value < 0 or value > 255
   then
      return -1
   end

   self.obj.it_color[index] = value
   return self.obj.it_color[index]
end

--- Info
-- @section

--- Determines the value of an item in gold pieces.
function Item:GetGoldValue()
   if not self:GetIsValid() then return -1 end
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(311, 1)

   return NWE.StackPopInteger()
end

--- Sets an items gold piece value when IDed
-- Source: nwnx_funcs by Acaos
-- @param value New gold value.
function Item:SetGoldValue(value)
   if not self:GetIsValid() then return -1 end

   self.obj.it_cost_ided = value
   return self.obj.it_cost_ided
end

--- Get item's stack size.
function Item:GetStackSize()
   if not self:GetIsValid() then return 0 end
   return self.obj.it_stacksize
end

--- Set item's stack size.
-- @param value New stack size.
function Item:SetStackSize(value)
   if not self:GetIsValid() then return end
   if value <= 0 then return end
   self.obj.it_stacksize = value
end

--- Get item possessor.
function Item:GetPossesor()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return Game.GetObjectByID(self.obj.it_possessor)
end

--- Properties
-- @section

--- Add an itemproperty to an item
-- @param dur_type DURATION_TYPE_*
-- @param ip Itemproperty to add.
-- @param[opt=0.0] duration Duration Duration in seconds in added temporarily.
function Item:AddItemProperty(dur_type, ip, duration)
   NWE.StackPushFloat(duration or 0.0)
   NWE.StackPushObject(self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_ITEMPROPERTY, ip)
   NWE.StackPushInteger(dur_type)
   NWE.ExecuteCommand(609, 4)
end

--- Check whether an item has a given property.
-- @param ip_type ITEM_PROPERTY_*
function Item:GetHasItemProperty(ip_type)
   return C.nwn_HasPropertyType(self.obj, ip_type) ~= 0
end

local function ignore_ip(ip)
   return (ip.eff_is_exposed == 0 or
           ip.eff_type == EFFECT_TYPE_ICON or
           (bit.band(ip.eff_dursubtype, 0x7) ~= 1 and
            bit.band(ip.eff_dursubtype, 0x7) ~= 2))
end

local function get_next(self)
   local n = self.obj.obj.obj_effect_index
   while n < self.obj.obj.obj_effects_len do
      if not ignore_ip(self.obj.obj.obj_effects[n]) then
         local ip = IP.itemprop_t(self.obj.obj.obj_effects[n], true)
         n = n + 1
         self.obj.obj.obj_effect_index = n
         return ip
      end
      n = n + 1
      self.obj.obj.obj_effect_index = n
   end
end

--- Iterates over items properties
function Item:ItemProperties()
   self.obj.obj.obj_effect_index = 0
   return function()
      return get_next(self)
   end
end

--- Removes an item property
-- @param ip Item property to remove.
function Item:RemoveItemProperty(ip)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_ITEMPROPERTY, ip)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(610, 2)
end

--- Flags
-- @section

--- Determines if an item can be dropped.
function Item:GetDroppable()
   if not self:GetIsValid() then return -1 end
   return self.obj.it_droppable == 1
end

--- Set droppable flag.
-- @bool flag New value.
function Item:SetDroppable(flag)
   if not self:GetIsValid() then return end
   self.obj.it_droppable = flag
end

--- Determines whether an object has been identified.
function Item:GetIdentified()
   if not self:GetIsValid() then return false end
   return self.obj.it_identified == 1
end

--- Gets if there is an infinite quantity of any item in a store.
function Item:GetInfiniteFlag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(827, 1)
   return NWE.StackPopBoolean()
end

--- Sets an item identified
-- @param[opt=false] is_ided true or false.
function Item:SetIdentified(is_ided)
   if not self:GetIsValid() then return end
   NWE.StackPushBoolean(is_ided)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(333, 2)
end

--- Sets and items infinite quantity flag.
-- @param[opt=false] infinite true or false
function Item:SetInfiniteFlag(infinite)
   NWE.StackPushBoolean(infinite)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(828, 2)
end

--- Get item cursed flag.
function Item:GetCursedFlag()
   if not self:GetIsValid() then return false end
   return self.obj.it_cursed == 1
end

--- Set item cursed flag.
-- @bool flag New flag.
function Item:SetCursedFlag(flag)
   if not self:GetIsValid() then return end
   self.obj.it_cursed = flag
end

--- Weight
-- @section

--- Gets item weight.
function Item:GetWeight()
   if not self:GetIsValid() then return 0 end
   return self.obj.it_weight
end

--- Sets item's weight.
-- @param weight New weight.
function Item:SetWeight(weight)
   if not self:GetIsValid() then return end
   self.obj.it_weight = weight
end
