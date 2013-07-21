--- 2da
-- @module 2da

local ffi = require 'ffi'
local C   = ffi.C

local M = {}

-- Get a cached 2da file.
-- @param twoda 2da name (minus .2da extention)
function M.GetCached2da(twoda) 
   if type(twoda) ~= "string" then 
      error "solstice.2da.GetCached2da: parameter is not a string type!"
   end

   t = C.nwn_GetCached2da(twoda)
   if t == nil then
      error("solstice.2da.GetCached2da: invalid 2dA: " .. twoda)
   end

   return t
end

---
-- @param twoda 2da file.
function M.Get2daColumnCount(twoda) 
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)       
   end

   if twoda == nil then
      error "solstice.2da.Get2daColumnCount: Invalid TwoDA"
   end
   return C.nwn_Get2daColumnCount(twoda);
end

---
-- @param twoda 2da file.
function M.Get2daRowCount(twoda) 
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)       
   end

   if twoda == nil then
      error "solstice.2da.Get2daRowCount: Invalid TwoDA"
   end
   return C.nwn_Get2daRowCount(twoda);
end

---
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.Get2daFloat(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)       
   end

   if twoda == nil then
      error "solstice.2da.Get2daFloat: Invalid TwoDA"
   end

   if type(col) == "string" then
      return C.nwn_Get2daFloat(twoda, col, row)
   elseif type(col) == "number" then
      return C.nwn_Get2daFloatIdx(twoda, col, row)
   else
      error "solstice.2da.Get2daFloat: Invalid column type"
   end
end

---
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.Get2daInt(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)       
   end

   if twoda == nil then
      error "solstice.2da.Get2daInt: Invalid TwoDA"
   end

   if type(col) == "string" then
      return C.nwn_Get2daInt(twoda, col, row)
   elseif type(col) == "number" then
      return C.nwn_Get2daIntIdx(twoda, col, row)
   else
      error "solstice.2da.Get2daInt: Invalid column type"
   end

end

---
-- @param twoda 2da file.
-- @param col Column label or index.
-- @param row Row index.
function M.Get2daString(twoda, col, row)
   if type(twoda) == "string" then
      twoda = M.GetCached2da(twoda)       
   end

   if twoda == nil then
      error "solstice.2da.Get2daString: Invalid TwoDA"
   end

   if type(col) == "string" then
      return ffi.string(C.nwn_Get2daString(twoda, col, row))
   elseif type(col) == "number" then
      return ffi.string(C.nwn_Get2daStringIdx(twoda, col, row))
   else
      error "solstice.2da.Get2daString: Invalid column type"
   end
end

return M
