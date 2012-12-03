--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ffi = require 'ffi'

--- Changes objects faction
-- 
function Object:ChangeFaction(oMemberOfFactionToJoin)
   nwn.engine.StackPushObject(oMemberOfFactionToJoin)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(173, 2)
end

--- Gets an objects faction ID
function Object:GetFactionId()
   if not self:GetIsValid() then return -1 end

   return ffi.C.nl_Object_GetFactionId(self.id)
end

--- Sets an objects faction ID
function Object:SetFactionId(faction)
   if not self:GetIsValid() or not faction then return -1 end

   return ffi.C.nl_Object_SetFactionId(self.id, faction)
end