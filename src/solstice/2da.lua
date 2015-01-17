---
-- Functions for getting values from cached 2da files.  Note: this does no
-- parsing and is only useable on a running server.
--
-- @module 2da
-- @alias M

local ffi = require 'ffi'
local C   = ffi.C
require 'solstice.nwn.ctypes.2da'

local M = {}

-- Get a cached 2da file.
-- Note: You do not want to store the return of this variable
-- as it can be deleted from the NWN 2da cache.
-- @param twoda 2da name (minus .2da extention)
-- @return A cached 2da or nil.
function M.GetCached2da(twoda)
   if type(twoda) ~= "string" then
      error "solstice.2da.GetCached2da: parameter is not a string type!"
   end

   local t = C.nwn_GetCached2da(twoda)
   if t == nil then
      error("solstice.2da.GetCached2da: invalid 2dA: " .. twoda)
   end

   return t
end

--- Get number of columns in 2da.
-- @param twoda 2da file.
function M.GetColumnCount(twoda)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)
   end

   if twoda == nil then
      error "solstice.2da.GetColumnCount: Invalid TwoDA"
   end
   return C.nwn_Get2daColumnCount(twoda);
end

--- Get number of rows in 2da.
-- @param twoda 2da file.
function M.GetRowCount(twoda)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)
   end

   if twoda == nil then
      error "solstice.2da.GetRowCount: Invalid TwoDA"
   end
   return C.nwn_Get2daRowCount(twoda);
end

--- Get float value.
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.GetFloat(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)
   end

   if twoda == nil then
      error "solstice.2da.GetFloat: Invalid TwoDA"
   end

   if type(col) == "string" then
      return C.nwn_Get2daFloat(twoda, col, row)
   elseif type(col) == "number" then
      return C.nwn_Get2daFloatIdx(twoda, col, row)
   else
      error "solstice.2da.GetFloat: Invalid column type"
   end
end

--- Get int value.
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.GetInt(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)
   end

   if twoda == nil then
      error "solstice.2da.GetInt: Invalid TwoDA"
   end

   if type(col) == "string" then
      return C.nwn_Get2daInt(twoda, col, row)
   elseif type(col) == "number" then
      return C.nwn_Get2daIntIdx(twoda, col, row)
   else
      error "solstice.2da.GetInt: Invalid column type"
   end

end

--- Get string value.
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.GetString(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)
   end

   if twoda == nil then
      error "solstice.2da.GetString: Invalid TwoDA"
   end

   if type(col) == "string" then
      return ffi.string(C.nwn_Get2daString(twoda, col, row))
   elseif type(col) == "number" then
      return ffi.string(C.nwn_Get2daStringIdx(twoda, col, row))
   else
      error "solstice.2da.GetString: Invalid column type"
   end
end

return M
