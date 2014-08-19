--- Campaign Database
-- @module campaigndb

local M = {}

local NWE = require 'solstice.nwn.engine'

--- Campaign Database
-- @section

--- Deletes a campaign variable from the database.
-- @param name Campaign to delete the variable from (case-sensitive).
-- @param var Variable name to delete.
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.DeleteVariable(name, var, player)
   player = player or OBJECT_INVALID
   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(601, 3)
end

--- Destroys a campaign database.
-- @param name Campaign to delete.
function M.DestroyDatabase(name)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(594, 1)
end

--- Retrieves a float from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param player Player associated with a variable.
function M.GetFloat(name, var, player)
   player = player or OBJECT_INVALID
   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(595, 3)
   return NWE.StackPopFloat()
end

--- Retrieves a integer from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.GetInt(name, var, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(596, 3)
   return NWE.StackPopInteger()
end

--- Retrieves a location from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.GetLocation(name, var, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(598, 3)
   return NWE.StackPopEngineStructure(ENGINE_STRUCTURE_LOCATION)
end

--- Retrieves a string from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.GetString(name, var, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(599, 3)
   return NWE.StackPopString()
end

--- Retrieves a vector from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.GetVector(name, var, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(597, 3)
   return NWE.StackPopVector()
end


--- Retrieves an object from the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param loc Location to create the object at.
-- @param[opt=OBJECT_INVALID] owner Owner to attempt to create the object within.
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.RetrieveCampaignObject(name, var, loc, owner, player)
   owner = owner or OBJECT_INVALID
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushObject(owner)
   NWE.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(603, 5)
   return NWE.StackPopObject()
end

--- Stores float in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.SetCampaignFloat(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushFloat(value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(589, 4)
end

--- Stores integer in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.SetCampaignInt(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushInteger(value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(590, 4)
end

--- Stores Location in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.SetCampaignLocation(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(592, 4)
end

--- Stores string in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.SetCampaignString(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushString(value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(593, 4)
end

--- Stores vector in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.SetCampaignVector(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushVector(value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(591, 4)
end

--- Stores object in the campaign database.
-- @param name Campaign to get the variable from (case-sensitive).
-- @param var Variable name
-- @param value Value to store
-- @param[opt=OBJECT_INVALID] player Player associated with a variable.
function M.StoreCampaignObject(name, var, value, player)
   player = player or OBJECT_INVALID

   NWE.StackPushObject(player)
   NWE.StackPushObject(value)
   NWE.StackPushString(var)
   NWE.StackPushString(name)
   NWE.ExecuteCommand(602, 4)
   return NWE.StackPopInteger()
end
