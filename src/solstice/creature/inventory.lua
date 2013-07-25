--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M   = require 'solstice.creature.init'
local ffi = require 'ffi'
local C   = ffi.C
local NWE = require 'solstice.nwn.engine'
local sm  = string.strip_margin

--- Inventory
-- @section

--- Iterator of a creature's equipped items.
-- @param[opt=false] creature If true include creature items.
function M.Creature:Equips(creature)
   local i, _i = 0
   local obj, _obj = pc:GetItemInSlot(i)
   local max = creature and M.INVENTORY_SLOT_NUM or 14
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
function M.Creature:ForceEquip(equips)
   self:ClearAllActions(true)
   for _, equip in ipairs(equips) do
      self:ActionEquipItem(equip[2], equip[1])
   end
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

--- Forces creature to unequip an item
-- @param item The item in question.
function M.Creature:ForceUnequip(item)
   self:ClearAllActions(true)
   self:ActionUnequipItem(item)
   self:ActionDoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

--- Determines if weapon is effect versus a target.
-- @param vs Attack target.
-- @param is_offhand true if the attack is an offhand attack.
function M.Creature:GetIsWeaponEffective(vs, is_offhand)
   NWE.StackPushBoolean(is_offhand)
   NWE.StackPushObject(vs)
   NWE.ExecuteCommand(422, 2)
   
   return NWE.StackPopBoolean()
end

--- Determines if a creature can finesse a weapon.
-- @param weap The weapon in question.
function M.Creature:GetIsWeaponFinessable(weap)
   error "nwnxcombat"
end

--- Determines if a weapon is light for a creature.
-- @param weap The weapon in question.
function M.Creature:GetIsWeaponLight(weap)
   if not weap:GetIsValid() or 
      weap:GetIsUnarmedWeapon()
   then
      return true
   end
   local size = self:GetSize()

   if size < M.SIZE_TINY or size > M.SIZE_HUGE then 
      return false
   end

   local rel = self:GetRelativeWeaponSize(weap)
   
   return rel < 0
end

--- Gets an equipped item in creature's inventory.
-- @param slot solstice.creature.INVENTORY_SLOT_*
function M.Creature:GetItemInSlot(slot)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(slot)
   NWE.ExecuteCommand(155, 2);
   return NWE.StackPopObject();
end

--- Determines a weapons weapon size relative to a creature.
-- @param weap The weapon in question.
function M.Creature:GetRelativeWeaponSize(weap)
   if not self:GetIsValid() or not weap:GetIsValid() then
      return 0
   end
   return C.nwn_GetRelativeWeaponSize(self.obj, weap.obj)
end

--- Gives gold to creature
-- @param amount Amount of gold to give.
-- @param[opt=true] feedback Sends feedback to creature.
-- @param[opt=solstice.object.INVALID] source Source object
function M.Creature:GiveGold(amount, feedback, source)
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

--- Forces the item in an inventory slot to be reequiped.
-- @param slot solstice.creature.INVENTORY_SLOT_*
function M.Creature:ReequipItemInSlot(slot)
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
-- @param[opt=true] feedback Sends feedback to creature.
-- @param[opt=solstice.object.INVALID] source Source object
function M.Creature:TakeGold(amount, feedback, source)
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