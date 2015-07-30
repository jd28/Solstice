--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature
local NWE = require 'solstice.nwn.engine'

--- Faction
-- @section faction

--- Add PC to party
-- @param leader Faction leader
function Creature:AddToParty(leader)
   NWE.StackPushObject(leader)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(572, 2)
end

--- Adjust reputation
-- @param target Target
-- @param amount Amount to adjust
function Creature:AdjustReputation(target, amount)
   NWE.StackPushInteger(amount)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(209, 3)
end

--- Changes creature to standard faction
function Creature:ChangeToStandardFaction()
   NWE.StackPushInteger(faction)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(412, 2)
end

--- Clears personal repuation
-- @param target Target
function Creature:ClearPersonalReputation(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(389, 2)
end

--- Get if factions are equal.
-- @param target Target
function Creature:GetFactionEqual(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(172, 2)
   return NWE.StackPopBoolean()
end

--- Determine if target is an enemy
-- @param target Target
function Creature:GetIsEnemy(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(235, 2)
   return NWE.StackPopBoolean()
end

--- Determine if target is a friend
-- @param target Target
function Creature:GetIsFriend(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(236, 2)
   return NWE.StackPopBoolean()
end

--- Determine if target is a neutral
-- @param target Target
function Creature:GetIsNeutral(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(237, 2)
   return NWE.StackPopBoolean()
end

--- Determine reaction type if friendly
-- @param target Target
function Creature:GetIsReactionTypeFriendly(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(469, 2)
   return NWE.StackPopBoolean()
end

--- Determine reaction type if hostile
-- @param target Target
function Creature:GetIsReactionTypeHostile(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(471, 2)
   return NWE.StackPopBoolean()
end

--- Determine reaction type if neutral
-- @param target Target
function Creature:GetIsReactionTypeNeutral(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(470, 2)
   return NWE.StackPopBoolean()
end

--- Gets reputation of creature.
-- @param target Target
function Creature:GetReputation(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(208, 2);
   return NWE.StackPopInteger()
end

--- Get standard faction reputation
-- @param faction Faction to check
function Creature:GetStandardFactionReputation(faction)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(faction)
   NWE.ExecuteCommand(524, 2)
   return NWE.StackPopInteger()
end

--- Remove PC from party.
function Creature:RemoveFromParty()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(573, 1)
end

--- Set creature as a temporary enemy
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryEnemy(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushBoolean(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(391, 4)
end

--- Set creature as a temporary friend
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryFriend(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushBoolean(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(390, 4)
end

--- Set creature as a temporary neutral
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryNeutral(target, decays, duration)
   duration = duration or 180.0

   NWE.StackPushFloat(duration)
   NWE.StackPushInteger(decays)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(392, 4)
end

--- Set standard faction reputation
-- @param faction Faction
-- @param rep Reputaion
function Creature:SetStandardFactionReputation(faction, rep)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(rep)
   NWE.StackPushInteger(faction)
   NWE.ExecuteCommand(523, 3)
end

--- Faction Member First Iterator
--    Prefer the iterator.
-- @param[opt=true] pc_only if true NPCs will be ignored
function Creature:GetFirstFactionMember(pc_only)
   if pc_only == nil then pc_only = true end

   NWE.StackPushBoolean(pc_only)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(380, 2)

   return NWE.StackPopObject()
end

--- Faction Member Next Iterator
--    Prefer the iterator.
-- @param[opt=true] pc_only if true NPCs will be ignored
function Creature:GetNextFactionMember(pc_only)
   if pc_only == nil then pc_only = true end

   NWE.StackPushBoolean(pc_only)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(381, 2)
   return NWE.StackPopObject()
end

--- Faction Member Iterator
-- @param[opt=true] pc_only if true NPCs will be ignored
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
