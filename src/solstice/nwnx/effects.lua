--- NWNX Effects
-- @module nwnx.effects

require 'solstice.nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C
local Eff = require 'solstice.effect'

local M = {}

local EFF_HANDLERS = {}

function M.SendEffects(obj)
   obj:SetLocalString("NWNX!EFFECTS!SENDEFFECTS", " ")
end

function M.Log(obj)
   obj:SetLocalString("NWNX!EFFECTS!LOGEFFECTS", " ")
end

function M.GetIsEffectHandlerRegistered(eff_type)
   local h = EFF_HANDLERS[eff_type]
   if not h then
      return false
   end
   return true
end

--- Register an effect handler.
-- @param handler Function to call on object when effect is applied or removed.
-- It will be called with three parameters: a RAW effect, an object, and boolean value
-- indicating whether the effect is being applied (false) or removed (true).
-- If the effect cannot applied, say the target is dead, then the function should
-- return true to delete the effect, returning false explicitly is not necessary.
-- @param ... List of CUSTOM\_EFFECT\_TYPE\_*.
function M.RegisterEffectHandler(handler, ...)
   local types = {...}
   if #types == 0 then
      print(debug.traceback())
   end
   for _, v in ipairs(types) do
      EFF_HANDLERS[v] = handler
   end
end

function NWNXEffects_HandleEffectEvent()
   local ev = C.Local_GetLastEffectEvent()
   if ev == nil then return 0 end

   obj = _SOL_GET_CACHED_OBJECT(ev.obj.obj_id)

   local h = EFF_HANDLERS[ev.eff.eff_integers[1]]
   if not h then return 0 end

   local del = h(ev.eff, obj, ev.is_remove)
   ev.delete_eff = del and 1 or 0

   return 1
end

return M
