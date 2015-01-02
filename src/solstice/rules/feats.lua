--- Rules module
-- @module rules

--- Feats
-- @section

local M = require 'solstice.rules.init'
local C = require('ffi').C

local TDA = require 'solstice.2da'
local TLK = require 'solstice.tlk'

local FEAT_USES = {}

--- Determines a creatures maximum feat uses.
-- @param feat
-- @param[opt] cre Creature instance.
function M.GetMaximumFeatUses(feat, cre)
   local f = FEAT_USES[feat]
   local res = f and f(feat, cre)
   if res then return res end

   local tda = TDA.Get2daString("feat", "USESPERDAY", feat)
   if #tda == 0 then return 100 end
   return tonumber(tda) or 100
end

--- Register a function to determine maximum feat uses.
-- @param func A function taking two argument, a Creature instance and
-- and a FEAT\_* constant.
-- @param ... Vararg list FEAT\_* constants.
function M.RegisterFeatUses(func, ...)
   local t = {...}
   assert(#t > 0)
   for _, feat in ipairs(t) do
      FEAT_USES[feat] = func
   end
end

--- Get array of feats successors.
-- @param feat FEAT\_*
-- @return empty array if no successors.
function M.GetFeatSuccessors(feat)
   local res = {}
   local f = C.nwn_GetFeat(feat)
   while f ~= nil and f.feat_successor > 0 do
      table.insert(res, f.feat_successor)
      f = C.nwn_GetFeat(f.feat_successor)
   end
   return res
end

function NWNXSolstice_GetMaximumFeatUses(feat, cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   return M.GetMaximumFeatUses(feat, cre)
end
