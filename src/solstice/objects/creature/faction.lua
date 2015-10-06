--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature
local NWE = require 'solstice.nwn.engine'

--- Faction
-- @section faction

function Creature:AddToParty(leader)
   NWE.StackPushObject(leader)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(572, 2)
end

function Creature:AdjustReputation(target, amount)
   NWE.StackPushInteger(amount)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(209, 3)
end

function Creature:ChangeToStandardFaction()
   NWE.StackPushInteger(faction)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(412, 2)
end

function Creature:ClearPersonalReputation(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(389, 2)
end

function Creature:GetFactionEqual(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(172, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsEnemy(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(235, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsFriend(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(236, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsNeutral(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(237, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsReactionTypeFriendly(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(469, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsReactionTypeHostile(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(471, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsReactionTypeNeutral(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(470, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetReputation(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(208, 2);
   return NWE.StackPopInteger()
end

function Creature:GetStandardFactionReputation(faction)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(faction)
   NWE.ExecuteCommand(524, 2)
   return NWE.StackPopInteger()
end

function Creature:RemoveFromParty()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(573, 1)
end

function Creature:SetIsTemporaryEnemy(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushBoolean(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(391, 4)
end

function Creature:SetIsTemporaryFriend(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushBoolean(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(390, 4)
end

function Creature:SetIsTemporaryNeutral(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushInteger(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(392, 4)
end

function Creature:SetStandardFactionReputation(faction, rep)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(rep)
   NWE.StackPushInteger(faction)
   NWE.ExecuteCommand(523, 3)
end

function Creature:GetFirstFactionMember(pc_only)
   if pc_only == nil then pc_only = true end

   NWE.StackPushBoolean(pc_only)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(380, 2)

   return NWE.StackPopObject()
end

function Creature:GetNextFactionMember(pc_only)
   if pc_only == nil then pc_only = true end

   NWE.StackPushBoolean(pc_only)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(381, 2)
   return NWE.StackPopObject()
end

function Creature:FactionMembers(pc_only)
   if pc_only == nil then pc_only = true end
   local obj, _obj = self:GetFirstFactionMember(pc_only)
   return function ()
      while obj and obj:GetIsValid() do
         _obj, obj = obj, self:GetNextFactionMember(pc_only)
         return _obj
      end
   end
end
