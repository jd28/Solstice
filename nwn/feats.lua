local FEAT_USES = {}

function nwn.GetMaximumFeatUses(cre, feat)
   local f = FEAT_USES[feat]
   if not f then 
      local tda = nwn.Get2DAString("feat", "USESPERDAY", feat)
      return tonumber(tda) or 100
   end

   return f(cre, feat)
end

function nwn.RegisterFeatUses(feat, func)
   FEAT_USES[feat] = func
end

