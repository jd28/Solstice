--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'

local ffi = require 'ffi'
local C = ffi.C

local NWE = require 'solstice.nwn.engine'

--- Class Object: Faction
-- @section faction

--- Changes objects faction
-- @param faction 
function M.Object:ChangeFaction(faction)
   NWE.StackPushObject(faction)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(173, 2)
end

--- Gets an objects faction ID
function M.Object:GetFactionId()
   if not self:GetIsValid() then return -1 end

   return C.nl_Object_GetFactionId(self.id)
end

--- Sets an objects faction ID
-- @param faction New faction ID.
function M.Object:SetFactionId(faction)
   if not self:GetIsValid() or not faction then return -1 end

   return C.nl_Object_SetFactionId(self.id, faction)
end