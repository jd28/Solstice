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

--- Deletes a campaign variable from the database.
-- @param campaign_name Campaign to delete the variable from (case-sensitive).
-- @param var_name Variable name to delete.
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID) 
function nwn.DeleteCampaignVariable(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID
   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(601, 3)
end

--- Destroys a campaign database.
-- @param campaign_name Campaign to delete.
function nwn.DestroyCampaignDatabase(campaign_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(594, 1)
end

--- Retrieves a float from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.GetCampaignFloat(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID
   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(595, 3)
   return nwn.engine.StackPopFloat()
end

--- Retrieves a integer from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.GetCampaignInt(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(596, 3)
   return nwn.engine.StackPopInteger()
end

--- Retrieves a location from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.GetCampaignLocation(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(598, 3)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_LOCATION)
end

--- Retrieves a string from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.GetCampaignString(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(599, 3)
   return nwn.engine.StackPopString()
end

--- Retrieves a vector from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.GetCampaignVector(campaign_name, var_name, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(597, 3)
   return nwn.engine.StackPopVector()
end


--- Retrieves an object from the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param loc Location to create the object at.
-- @param owner Owner to attempt to create the object within. (Default: nwn.OBJECT_INVALID)
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.RetrieveCampaignObject(campaign_name, var_name, loc, owner, player)
   owner = owner or nwn.OBJECT_INVALID
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushObject(owner)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(603, 5)
   return nwn.engine.StackPopObject()
end

--- Stores float in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.SetCampaignFloat(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushFloat(value)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(589, 4)
end

--- Stores integer in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.SetCampaignInt(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

	nwn.engine.StackPushObject(player)
	nwn.engine.StackPushInteger(value)
	nwn.engine.StackPushString(var_name)
	nwn.engine.StackPushString(campaign_name)
	nwn.engine.ExecuteCommand(590, 4)
end

--- Stores Location in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.SetCampaignLocation(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

	nwn.engine.StackPushObject(player)
	nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, value)
	nwn.engine.StackPushString(var_name)
	nwn.engine.StackPushString(campaign_name)
	nwn.engine.ExecuteCommand(592, 4)
end

--- Stores string in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.SetCampaignString(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

	nwn.engine.StackPushObject(player)
	nwn.engine.StackPushString(value)
	nwn.engine.StackPushString(var_name)
	nwn.engine.StackPushString(campaign_name)
	nwn.engine.ExecuteCommand(593, 4)
end

--- Stores vector in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.SetCampaignVector(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

	nwn.engine.StackPushObject(player)
	nwn.engine.StackPushVector(value)
	nwn.engine.StackPushString(var_name)
	nwn.engine.StackPushString(campaign_name)
	nwn.engine.ExecuteCommand(591, 4)
end

--- Stores object in the campaign database.
-- @param campaign_name Campaign to get the variable from (case-sensitive).
-- @param var_name Variable name 
-- @param value Value to store
-- @param player Player associated with a variable. (Default: nwn.OBJECT_INVALID)
function nwn.StoreCampaignObject(campaign_name, var_name, value, player)
   player = player or nwn.OBJECT_INVALID

   nwn.engine.StackPushObject(player)
   nwn.engine.StackPushObject(value)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushString(campaign_name)
   nwn.engine.ExecuteCommand(602, 4)
   return nwn.engine.StackPopInteger()
end