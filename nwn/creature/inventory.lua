--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ffi = require 'ffi'
local C = ffi.C
local sm = string.strip_margin

---
-- TODO fill in.
function Creature:GetAmmunitionAvailable(attack_count)
   return attack_count
end

--- Iterator of a creature's equipped items.
-- @param creature If true include creature items.
function Creature:Equips(creature)
   local i, _i = 0
   local obj, _obj = pc:GetItemInSlot(i)
   local max = creature and nwn.NUM_INVENTORY_SLOTS or 14
   return function ()
      while obj and i < max do
         _i, i = i, i + 1
         _obj, obj = obj, pc:GetItemInSlot(i)
         return _obj, _i
      end
   end
end

--- Forces creature to equip items
-- @param equips A list of items to equip
function Creature:ForceEquip(equips)
   self:ClearAllActions(true)
   for _, equip in ipairs(equips) do
      self:ActionEquipItem(equip[2], equip[1])
   end
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

--- Forces creature to unequip an item
-- @param item The item in question.
function Creature:ForceUnequip(item)
   self:ClearAllActions(true)
   self:ActionUnequipItem(item)
   self:ActionDoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:GetEquipNumFromEquips(is_offhand)
   local weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   if not is_offhand and weap:GetIsValid() then
      return 0
   end
   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   if weap:GetIsValid() then return 1 end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
   if weap:GetIsValid() and weap:GetBaseType() == nwn.BASE_ITEM_GLOVES then 
      return 2
   end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_L)
   if weap:GetIsValid() then return 3 end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_R)
   if weap:GetIsValid() then return 4 end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_B)
   if weap:GetIsValid() then return 5 end

   -- Default to unarmed.
   return 3
end

--- Determines if weapon is effect versus a target.
-- @param vs Attack target.
-- @param is_offhand true if the attack is an offhand attack.
function Creature:GetIsWeaponEffective(vs, is_offhand)
   nwn.engine.StackPushBoolean(is_offhand)
   nwn.engine.StackPushObject(vs)
   nwn.engine.ExecuteCommand(422, 2)
   
   return nwn.engine.StackPopBoolean()
end

--- Determines if a creature can finesse a weapon.
-- @param weap The weapon in question.
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

--- Determines if a weapon is light for a creature.
-- @param weap The weapon in question.
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

--- Gets an equipped item in creature's inventory.
-- @param slot nwn.INVENTORY_SLOT_*
function Creature:GetItemInSlot(slot)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(slot)
   nwn.engine.ExecuteCommand(155, 2);
   return nwn.engine.StackPopObject();
end

--- Determines a weapons weapon size relative to a creature.
-- @param weap The weapon in question.
function Creature:GetRelativeWeaponSize(weap)
   if not self:GetIsValid() or 
      not weap:GetIsValid()
   then
      return 0
   end
   return C.nwn_GetRelativeWeaponSize(self.obj, weap.obj)
end

function Creature:GetWeaponFromEquips(is_offhand)
   -- If the attack is offhand, then there is either a weapon there
   -- or not so just return it.
   local weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   if is_offhand then return weap end

   -- If it's not an offhand attack check the right hand.
   -- if it's there we can return if not fall back to gloves,
   -- then to creature attacks.  If nothing is equipped return
   -- nwn.OBJECT_INVALID

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   if weap:GetIsValid() then return weap end

   -- We want to ignore bracers here...
   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
   if weap:GetIsValid() and weap:GetBaseType() == nwn.BASE_ITEM_GLOVES then 
      return weap
   end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_L)
   if weap:GetIsValid() then return weap end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_R)
   if weap:GetIsValid() then return weap end

   weap = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_B)
   if weap:GetIsValid() then return weap end

   -- Default to unarmed.
   return nwn.OBJECT_INVALID
end

--- Gives gold to creature
-- @param amount Amount of gold to give.
-- @param feedback Sends feedback to creature. (Default: true)
function Creature:GiveGold(amount, feedback, source)
   if feedback == nil then feedback = true end

   if not self:GetIsValid() 
      or self.obj.cre_gold >= 999999999
      or amount <= 0
   then 
      return 
   end
   self.obj.cre_gold = math.max(999999999, self.obj.cre_gold + amount)

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

--- Forces the item in an inventory slot to be reequiped.
-- @param slot nwn.INVENTORY_SLOT_*
function Creature:ReequipItemInSlot(slot)
   local item = self:GetItemInSlot(slot)
   if not item then return end

   pc:ClearAllActions(true)
   pc:ActionUnequipItem(item)
   pc:ActionEquipItem(item, slot)
   pc:ActionDoCommand(function (self) self:SetCommandable(true) end)
   pc:SetCommandable(false)
end

--- Gives gold to creature
-- @param amount Amount of gold to give.
-- @param feedback Sends feedback to creature. (Default: true)
-- @param source Source object
function Creature:TakeGold(amount, feedback, source)
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
