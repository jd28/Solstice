--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M   = require 'solstice.objects.init'
local ffi = require 'ffi'
local C   = ffi.C
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature
local GetObjectByID = Game.GetObjectByID

--- Inventory
-- @section

function Creature:Equips(creature)
   local i, _i = 0
   local obj, _obj = self:GetItemInSlot(i)
   local max = creature and INVENTORY_SLOT_NUM or 14
   return function ()
      while i < max do
         _i, i = i, i + 1
         _obj, obj = obj, self:GetItemInSlot(i)
         return _obj, _i
      end
   end
end

function Creature:GetInventorySlotFromItem(item)
   if not self:GetIsValid() then return -1 end
   for it, slot in self:Equips(true) do
      if it.id == item.id then
         return slot
      end
   end
   return -1
end

function Creature:ForceEquip(equips)
   self:ClearAllActions(true)
   for i = 0, INVENTORY_SLOT_NUM - 1 do
      if equips[i] then
         self:ActionEquipItem(equips[i], i)
      end
   end
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:ForceUnequip(item)
   self:ClearAllActions(true)
   self:ActionUnequipItem(item)
   self:ActionDoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:GetIsWeaponEffective(vs, is_offhand)
   NWE.StackPushBoolean(is_offhand)
   NWE.StackPushObject(vs)
   NWE.ExecuteCommand(422, 2)

   return NWE.StackPopBoolean()
end

function Creature:GetItemInSlot(slot)
   if not self:GetIsValid() or
      slot < 0              or
      slot >= INVENTORY_SLOT_NUM
   then
      return OBJECT_INVALID
   end

   return GetObjectByID(self.obj.cre_equipment.equips[slot])
end

function Creature:GetWeaponFromAttackType(atype)
   if atype == ATTACK_TYPE_ONHAND then
      return self:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   elseif atype == ATTACK_TYPE_OFFHAND then
      return self:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
   elseif atype == ATTACK_TYPE_CWEAPON1 then
      return self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_L)
   elseif atype == ATTACK_TYPE_CWEAPON2 then
      return self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_R)
   elseif atype == ATTACK_TYPE_CWEAPON3 then
      return self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)
   elseif atype == ATTACK_TYPE_UNARMED then
      return self:GetItemInSlot(INVENTORY_SLOT_ARMS)
   end

   return OBJECT_INVALID
end

function Creature:GetRelativeWeaponSize(weap)
   if not self:GetIsValid() or not weap:GetIsValid() then
      return 0
   end
   return C.nwn_GetRelativeWeaponSize(self.obj, weap.obj)
end

function Creature:TakeGold(amount, feedback, source)
   if feedback == nil then feedback = true end

   if not self:GetIsValid()
      or self.obj.cre_gold >= 999999999
      or amount <= 0
   then
      return
   end
   self.obj.cre_gold = math.min(999999999, self.obj.cre_gold + amount)

   if feedback then
      local str
      if source then
         str = string.format("Lost %dGP to %s", amount, source:GetName())
      else
         str = string.format("Lost %dGP", amount)
      end
      self:SendMessage(str)
   end
end

function Creature:ReequipItemInSlot(slot)
   local item = self:GetItemInSlot(slot)
   if not item then return end

   self:ClearAllActions(true)
   self:ActionUnequipItem(item)
   self:ActionEquipItem(item, slot)
   self:ActionDoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:GiveGold(amount, feedback, source)
   if feedback == nil then feedback = true end

   if not self:GetIsValid()
      or self.obj.cre_gold == 0
      or amount <= 0
   then
      return
   end
   self.obj.cre_gold = math.max(0, self.obj.cre_gold - amount)

   if feedback then
      local str
      if source then
         str = string.format("Acquired %dGP from %s", amount, source:GetName())
      else
         str = string.format("Acquired %dGP", amount)
      end
      self:SendMessage(str)
   end
end
