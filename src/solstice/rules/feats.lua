--- Rules module
-- @module rules

--- Feats
-- @section

local M = require 'solstice.rules.init'
local C = require('ffi').C

local TDA = require 'solstice.2da'
local TLK = require 'solstice.tlk'

local _FEAT_TABLE
local FEAT_USES = {}

function M.GetFeatTable()
   if not _FEAT_TABLE then
      _FEAT_TABLE = {}
      _FEAT_TABLE.master = {}

      local twoda = TDA.GetCached2da("feat")
      local size = TDA.Get2daRowCount(twoda) - 1
      for i = 0, size do
         local const = TDA.Get2daString(twoda, "FEAT", i)
         local master = TDA.Get2daString(twoda, "MASTERFEAT", i)

         if #const > 0 and const ~= "****" then
            local str = TLK.GetString(tonumber(const))
            local insert

            if #master > 0 and master ~= "****" then
               local m = tonumber(master)
               if not _FEAT_TABLE.master[m] then
                  _FEAT_TABLE.master[m] = {}
                  -- Only insert the master feat into the feat table once.
                  insert = { TLK.GetString(m).."...", m, master = true }
               end
               table.insert(_FEAT_TABLE.master[m], { str, i })
            else
               insert = { str, i }
            end

            if insert then table.insert(_FEAT_TABLE, insert) end
         end
      end

      -- Sort everything alphabetically.
      table.sort(_FEAT_TABLE, function(a, b) return a[1] < b[1] end)
      for _, v in pairs(_FEAT_TABLE.master) do
         table.sort(v, function(a, b) return a[1] < b[1] end)
      end
   end

   return iter(_FEAT_TABLE)
end

function M.GetMasterFeatTable(master)
   return iter(_FEAT_TABLE.master[master])
end

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
