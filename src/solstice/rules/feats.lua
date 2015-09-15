--- Rules module
-- @module rules

--- Feats
-- @section

local M = require 'solstice.rules.init'
local C = require('ffi').C
local GetObjectByID = Game.GetObjectByID
local NWNXEvents = require 'solstice.nwnx.events'

local USE_FEAT = {}
local FEAT_USES = {}

local function use_feat_handler(info)
  if not USE_FEAT[info.subtype] then return end
  if USE_FEAT[info.subtype](info.subtype, info.object, info.target, info.pos) then
    NWNXEvents.ByPassEvent()
  end
end

NWNXEvents.RegisterEventHandler(8, use_feat_handler)

function M.SetUseFeatOverride(func, ...)
  local Log = System.GetLogger()
  local t = table.pack(...)
  assert(t.n > 0)
  for i=1, t.n do
    if USE_FEAT[t[i]] then
      Log:warning("Overriding feat use handler for feat %d", t[i])
    end
    USE_FEAT[t[i]] = func
  end
end

--- Determines a creatures maximum feat uses.
-- @param feat
-- @param[opt] cre Creature instance.
function M.GetMaximumFeatUses(feat, cre)
   local f = FEAT_USES[feat]
   local res = f and f(feat, cre)
   if res then return res end

   local tda = Game.Get2daString("feat", "USESPERDAY", feat)
   if #tda == 0 then return 100 end
   return tonumber(tda) or 100
end

function M.SetMaximumFeatUsesOverride(func, ...)
  local Log = System.GetLogger()
  local t = table.pack(...)
  assert(t.n > 0)
  for i=1, t.n do
    if FEAT_USES[t[i]] then
      Log:warning("Overriding feat use handler for feat %d", t[i])
    end
    FEAT_USES[t[i]] = func
  end
end

--- Get array of feats successors.
-- @param feat FEAT_*
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

--- Determine is first level feat only.
-- @param feat FEAT_*
function M.GetFeatIsFirstLevelOnly(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then return false end
   return f.feat_max_level == 1
end

--- Get feat name.
-- @param feat FEAT_*
function M.GetFeatName(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then return "" end
   return Game.GetTlkString(f.feat_name_strref)
end

--- Determine if feat is class general feat.
-- @param feat FEAT_*
-- @param class CLASS_TYPE_*
function M.GetIsClassGeneralFeat(feat, class)
   return C.nwn_GetIsClassGeneralFeat(class, feat)
end
--- Determine if feat is class bonus feat.
-- @param feat FEAT_*
-- @param class CLASS_TYPE_*
function M.GetIsClassBonusFeat(feat, class)
   return C.nwn_GetIsClassBonusFeat(class, feat)
end

--- Determine if feat is class granted feat.
-- @param feat FEAT_*
-- @param class CLASS_TYPE_*
function M.GetIsClassGrantedFeat(feat, class)
   return C.nwn_GetIsClassGrantedFeat(class, feat)
end

--- Get Master Feat Name
-- @param master master feat
function M.GetMasterFeatName(master)
   return Game.GetTlkString(Game.Get2daInt('masterfeats', 'STRREF', master))
end
