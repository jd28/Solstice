-----------------------------------------------
-- Item
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module item
-- @alias M

local ffi = require 'ffi'
local Obj = require 'solstice.object'
local NWE = require 'solstice.nwn.engine'
local Eff = require 'solstice.effect'
local IP  = require 'solstice.itemprop'

local M = {}
M.Item = inheritsFrom({}, Obj.Object)

--- Internal ctype.
M.item_t = ffi.metatype("Item", { __index = M.Item })

--- Class Item: Armor Class
-- @section

--- Get the armor classof an item.
function M.Item:GetACValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(401, 1)

   return NWE.StackPopInteger()
end

--- Gets Armor's Base AC bonus.
-- @return -1 if item is not armor.
function M.Item:GetBaseArmorACBonus()
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

--- Class Item: Copying
-- @section item

--- Duplicates an item.
-- @param[opt=OBJECT_INVALID] target Create the item within this object's
-- inventory
-- @param[opt=false] copy_vars If true, local variables on item are copied.
function M.Item:Copy(target, copy_vars)
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
function M.Item:CopyAndModify(modtype, index, value, copy_vars)
   NWE.StackPushBoolean(copy_vars)
   NWE.StackPushInteger(value)
   NWE.StackPushInteger(index)
   NWE.StackPushInteger(modtype)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(731, 5)

   return NWE.StackPopObject()
end

--- Class Item: Type
-- @section

--- Get the base item type.
-- @return BASE_ITEM_INVALID if invalid item.
function M.Item:GetBaseType()
   if not self:GetIsValid() then return BASE_ITEM_INVALID end
   return self.obj.it_baseitem
end

--- Sets an items base type
-- Source: nwnx_funcs by Acaos
function M.Item:SetBaseType(value)
   if not self:GetIsValid() then return -1 end
   self.obj.it_baseitem = value
end

--- Class Item: Appearance
-- @section

--- Encodes an items appearance
-- Source: nwnx_funcs by Acaos
-- @return A string encoding the appearance
function M.Item:GetEntireAppearance()
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
-- @param appearance_type ITEM\_APPR\_TYPE\_*
-- @param index ITEM\_APPR\_WEAPON\_* or ITEM\_APPR\_ARMOR\_*
function M.Item:GetItemAppearance(appearance_type, index)
   NWE.StackPushInteger(index)
   NWE.StackPushInteger(appearance_type)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(732, 3)

   return NWE.StackPopInteger()
end

--- Restores an items appearance.
-- @param appearance An encoding from Item:GetEntireAppearance
function M.Item:RestoreAppearance(appearance)
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

--- Set item
function M.Item:SetAppearance(index, value)
   if not self:GetIsValid()
      or index < ITME_APPR_COLOR_LEATHER_1
      or index > ITME_APPR_ARMOR_MODEL_ROBE
      or value < 0 or value > 255
   then
      return -1
   end

   if index < ITME_APPR_MODEL_PART_1 then
      self.obj.it_color[index + 9] = value
   else
      self.obj.it_model[index + 3] = value
   end

   return value
end

--- Set item color
-- @param index
-- @param value
function M.Item:SetColor(index, value)
   if not self:GetIsValid() or index < 0 or index > 5
      or value < 0 or value > 255
   then
      return -1
   end

   self.obj.it_color[index] = value
   return self.obj.it_color[index]
end

--- Class Item: Value
-- @section

--- Determines the value of an item in gold pieces.
function M.Item:GetGoldValue()
   if not self:GetIsValid() then return -1 end
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(311, 1)

   return NWE.StackPopInteger()
end

--- Sets an items gold piece value when IDed
-- Source: nwnx_funcs by Acaos
-- @param value New gold value.
function M.Item:SetGoldValue(value)
   if not self:GetIsValid() then return -1 end

   self.obj.it_cost_ided = value
   return self.obj.it_cost_ided
end

--- Class Item: Item Properties
-- @section

--- Add an itemproperty to an item
-- @param dur_type DURATION_TYPE_*
-- @param ip Itemproperty to add.
-- @param[opt=0.0] duration Duration Duration in seconds in added temporarily.
function M.Item:AddItemProperty(dur_type, ip, duration)
   NWE.StackPushFloat(duration or 0.0)
   NWE.StackPushObject(self)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_ITEMPROPERTY, ip)
   NWE.StackPushInteger(dur_type)
   NWE.ExecuteCommand(609, 4)
end

--- Check whether an item has a given property.
-- @param ip_type ITEM\_PROPERTY\_*
function M.Item:GetHasItemProperty(ip_type)
   return C.nwn_HasPropertyType(self.obj, ip_type) ~= 0
end

local function ignore_ip(ip)
   return not (ip.eff.eff_is_exposed == 0 or
               ip.eff.eff_type == EFFECT_TYPE_ICON or
               (bit.band(ip.eff.eff_dursubtype, 0x7) ~= 1 and
                bit.band(ip.eff.eff_dursubtype, 0x7) ~= 2))
end

local function not_nil(x) return x ~= nil end

local function get_next(self)
   local n = self.obj.obj.obj_effect_index
   if n >= self.obj.obj.obj_effects_len then return end
   self.obj.obj.obj_effect_index = n + 1
   return IP.itemprop_t(self.obj.obj.obj_effects[n], true)
end

--- Iterates over an items properties
function M.Item:ItemProperties()
   self.obj.obj.obj_effect_index = 0
   return filter(ignore_ip, take_while(not_nil, map(get_next, duplicate(self))))
end

--- Removes an item property
-- @param ip Item property to remove.
function M.Item:RemoveItemProperty(ip)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_ITEMPROPERTY, ip)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(610, 2)
end

--- Class Item: Flags
-- @section

--- Determines if an item can be dropped.
function M.Item:GetDroppable()
   if not self:GetIsValid() then return -1 end
   return self.obj.it_droppable == 1
end

--- Determines whether an object has been identified.
function M.Item:GetIdentified()
   if not self:GetIsValid() then return false end
   return self.obj.it_identified == 1
end

--- Gets if there is an infinite quantity of any item in a store.
function M.Item:GetInfiniteFlag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(827, 1)
   return NWE.StackPopBoolean
end

--- Sets an item identified
-- @param[opt=false] is_ided true or false.
function M.Item:SetIdentified(is_ided)
   if not self:GetIsValid() then return end
   self.obj.it_identified = is_ided and 1 or 0
end

--- Sets and items infinite quantity flag.
-- @param[opt=false] infinite true or false
function M.Item:SetInfiniteFlag(infinite)
   NWE.StackPushBoolean(infinite)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(828, 2)
end

--- Class Item: Weight
-- @section

--- Gets item weight.
function M.Item:GetWeight()
   if not self:GetIsValid() then return 0 end
   return self.obj.it_weight
end

--- Sets item's weight.
-- @param weight New weight.
function M.Item:SetWeight(weight)
   if not self:GetIsValid() then return end
   self.obj.it_weight = weight
end

return M
