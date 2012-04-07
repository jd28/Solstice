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

local ffi = require 'ffi'
local C = ffi.C

---
--
function Creature:Equips(creature)
   local i, _i = 1
   local obj, _obj = pc:GetItemInSlot(i)
   local max = creature and nwn.NUM_INV_SLOTS or 15
   return function ()
      while obj and i < max do
         _i, i = i, i + 1
         _obj, obj = obj, pc:GetItemInSlot(i)
         return _obj, _i
      end
   end
end

---
--
function Creature:ForceEquip(equips)
   self:ClearAllActions(true)
   for _, equip in ipairs(equips) do
      self:ActionEquipItem(equip[2], equip[1])
   end
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

---
--
function Creature:ForceUnequip(item)
   self:ClearAllActions(true)
   self:ActionUnequipItem(item)
   self:ActionDoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

---
--
function Creature:GetIsWeaponEffective(oVersus, bOffHand)
   if bOffHand == nil then bOffHand = false end

   nwn.engine.StackPushInteger(bOffHand)
   nwn.engine.StackPushObject(oVersus)
   nwn.engine.ExecuteCommand(422, 2)
   
   return nwn.engine.StackPopBoolean()
end

function Creature:GetIsWeaponFinessable(weap)
   if self:GetIsWeaponLight(weap) then
      return true
   end

   local size = self:GetSize()   
   local rel = self:GetRelativeWeaponSize(weap)
   local baseitem = weap:GetBaseType()
   local usable = nwn.GetWeaponUsableWithFeat(nwn.FEAT_WEAPON_FINESSE, baseitem)

   if useable and size >= useable then
      return true
   end
   
   return rel <= 0
end

function Creature:GetIsWeaponLight(weap)
   if not weap:GetIsValid() or 
      weap:GetIsUnarmedWeapon()
   then
      return true
   end
   local size = self:GetSize()

   if size < nwn.CREATURE_SIZE_TINY or 
      size > nwn.CREATURE_SIZE_HUGE
   then 
      return false
   end

   local rel = self:GetRelativeWeaponSize(weap)
   
   return rel < 0
end

---
--
function Creature:GetItemInSlot(slot)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(slot)
   nwn.engine.ExecuteCommand(155, 2);
   return nwn.engine.StackPopObject();
end

function Creature:GetRelativeWeaponSize(weap)
   if not self:GetIsValid() or 
      not weap:GetIsValid()
   then
      return 0
   end
   return C.nwn_GetRelativeWeaponSize(self.obj, weap.obj)
end

---
--
function Creature:GiveGold(nAmount, is_direct)
   if not is_direct then
      nwn.engine.StackPushInteger(nAmount)
      nwn.engine.StackPushObject(self)
      nwn.engine.ExecuteCommand(322, 2)
   end
end

---
--
function Creature:ReequipItemInSlot(slot)
   local item = self:GetItemInSlot(slot)
   if not item then return end

   pc:ClearAllActions(true)
   pc:ActionUnequipItem(item)
   pc:ActionEquipItem(item, slot)
   pc:ActionDoCommand(function (self) self:SetCommandable(true) end)
   pc:SetCommandable(false)
end

---
--
function Creature:TakeGold(nAmount, bDestroy)
   if bDestroy == nil then bDestroy = true end
   
   nwn.engine.StackPushInteger(bDestroy)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nAmount)
   nwn.engine.ExecuteCommand(444, 3)
end
