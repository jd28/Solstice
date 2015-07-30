--- Object
-- @module object

local M = require 'solstice.objects.init'
local Object = M.Object
local ffi = require 'ffi'
local C = ffi.C

local NWE = require 'solstice.nwn.engine'

--- Class Object: Faction
-- @section faction

--- Changes objects faction
-- @param faction
function Object:ChangeFaction(faction)
   NWE.StackPushObject(faction)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(173, 2)
end

--- Gets an objects faction ID
function Object:GetFactionId()
   if not self:GetIsValid() then return -1 end

   return C.nl_Object_GetFactionId(self.id)
end

--- Sets an objects faction ID
-- @param faction New faction ID.
function Object:SetFactionId(faction)
   if not self:GetIsValid() or not faction then return -1 end

   return C.nl_Object_SetFactionId(self.id, faction)
end
