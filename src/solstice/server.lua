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
-- @param cdkey Public CDKEY.
function M.VerifyAdmin(cdkey)
   return ADMIN[cdkey] and true or false
end

--- Verify DM
-- @param cdkey Public CDKEY.
function M.VerifyDM(cdkey)
   local res = ADMIN[cdkey] or DM[cdkey]
   return res and true or false
end

return M
