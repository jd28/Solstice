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

function M.GetIsEffectHandlerRegistered(eff_type)
   local h = EFF_HANDLERS[eff_type]
   if not h then
      return false
   end
   return true
end

--- Register an effect handler.
-- @param effect_type solstice.effect constant or some other custom event type.
-- @param handler Function to call on object when effect is applied or removed.
-- It will be called with three parameters: an effect, an object, and boolean value
-- indicating whether the effect is being applied (false) or removed (true).
-- If the effect cannot applied, say the target is dead, then the function should
-- return true to delete the effect, returning false explicitly is not necessary.
function M.RegisterEffectHandler(handler, ...)
   local types = {...}
   if #types == 0 then
      print(debug.traceback())
   end
   for _, v in ipairs(types) do
      EFF_HANDLERS[v] = handler
   end
end

---
function NWNXEffects_HandleEffectEvent()
   local ev = C.Local_GetLastEffectEvent()
   if ev == nil then return 0 end

   obj = _SOL_GET_CACHED_OBJECT(ev.obj.obj_id)

   -- The effect should be treated as a direct effect.  So Lua doesn't delete it.
   local eff = Eff.effect_t(ev.eff, true)
   local eff_type = eff:GetType()

   local h = EFF_HANDLERS[eff_type]
   if not h then return 0 end

   ev.suppress = true
   ev.delete_eff = h(eff, obj, ev.is_remove, ev.preapply) or false

   return 1
end

return M
