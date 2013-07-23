local M = require 'solstice.feat.init'
M.const = require 'solstice.feat.constant'
setmetatable(M, { __index = M.const })

local TDA = require 'solstice.2da'

local FEAT_USES = {}

--- 
-- @param feat
-- @param[opt] cre Creature instance.
function M.GetMaximumFeatUses(feat, cre)
   local f = FEAT_USES[feat]
   if not f then 
      local tda = TDA.Get2daString("feat", "USESPERDAY", feat)
      return tonumber(tda) or 100
   end

   return f(feat, cre)
end

--- Register a function to determine maximum feat uses.
-- @param func A function taking two argument, a Creature instance and
-- and a solstice.feat constant
-- @param ... Vararg list of any number of solstice.feat constant.
function M.RegisterFeatUses(func, ...)
   for _, feat in ipairs({...}) do
      FEAT_USES[feat] = func
   end
end

function NWNXSolstice_GetMaximumFeatUses(feat, cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   return M.GetMaximumFeatUses(feat, cre)
end

return M