--- Server
-- @module server

local M = {}

local ADMIN = {}
local DM = {}

--- Register an Admin.
-- NOTE: Admins are implicity DMs.
-- @param cdkey Public CDKEY.
-- @param[opt] name Optional name of Admin.
function M.RegisterAdmin(cdkey, name)
   ADMIN[cdkey] = name or true   
end

--- Register a DM
-- @param cdkey Public CDKEY.
-- @param[opt] name Optional name of DM.
function M.RegisterDM(cdkey, name)
   DM[cdkey] = name or true
end

--- Verify Admin
-- @param obj Object to test for admin privileges.
function M.VerifyAdmin(obj)
   if not isinstance(obj, Creature) then
      return false
   end
   local cdkey = obj:GetPCPublicCDKey()
   return ADMIN[obj:GetPCPublicCDKey()] and true or false
end

--- Verify DM
-- @param obj Object to test for DM privileges.
function M.VerifyDM(obj)
   if not isinstance(obj, Creature) then
      return false
   end

   local cdkey = obj:GetPCPublicCDKey()
   local res = ADMIN[cdkey] or DM[cdkey]
   return res and true or false
end

return M
