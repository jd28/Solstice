--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
CGameEffect * nl_GetLastCustomEffect();
]]

local effects = {}

function _NL_CUSTOM_EFFECT(obj, is_apply)
   local eff = effect_t(C.nl_GetLastCustomEffect(), true)
   obj = _NL_GET_CACHED_OBJECT(obj)

   local eff_type = eff:GetCustomType()
   local h = effects[eff_type]
   if not h then
      return true
      --error("Invalid custom effect type.")
   end
   local t = h(eff, obj, is_apply)
   return t
end


function effects.GetIsRegistered(eff_type)
   local h = effects[eff_type]
   if not h then
      return false
   end
   return true
end

--- Adds a custom effect.
-- @param effect_type The type of the effect.  Essentially any integer value can
--      be used to differentiate custom effects.  They have no overlap with EFFECT_TYPE_*.
-- @param on_apply Function to call on object when effect is applied.  Function will be
--      called with two parameters: the effect being applied and the target it is being applied to.
-- @param on_remove Function to call on object when effect is removed.  Function will be
--      called with two parameters: the effect being applied and the target it is being applied to.
function effects.RegisterCustomEffect(effect_type, handler)
   effects[effect_type] = handler
end

return effects