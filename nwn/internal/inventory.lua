--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ffi = require 'ffi'
local C = ffi.C

local inventory = {}

local can_equip_handler = function (cre, item) return true end
function inventory.SetCanEquipHandler(func)
   can_equip_handler = func
end

function NSGetWeaponFinesse(cre, item)
   cre = _NL_GET_CACHED_OBJECT(cre)
   item = _NL_GET_CACHED_OBJECT(item)

   return cre:GetIsWeaponFinessable(item)
end

function NSCanEquipItem(cre, item)
   cre  = _NL_GET_CACHED_OBJECT(cre)
   item = _NL_GET_CACHED_OBJECT(item)
   local t = can_equip_handler(cre, item)
   return t and 1 or 0
end

return inventory