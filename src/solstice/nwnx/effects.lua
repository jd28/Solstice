--- NWNX Effects
-- @module nwnx.effects

require 'solstice.nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C
local Eff = require 'solstice.effect'

local M = {}

local IP_HANDLERS = {}
local EFF_HANDLERS = {}

function M.SendEffects(obj)
   obj:SetLocalString("NWNX!EFFECTS!SENDEFFECTS", " ")
end

function M.GetItempropInfo()
   local e = C.Local_GetLastNWNXEventItemprop()
   if e == nil then return end

   return { type = e.ip.ip_type,
            object = _SOL_GET_CACHED_OBJECT(e.obj.obj.obj_id),
            item = _SOL_GET_CACHED_OBJECT(e.item.obj.obj_id),
          }
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
--    It will be called with three parameters: an effect, an object, and boolean value
--    indicating whether the effect is being applied (false) or removed (true)
function M.RegisterEffectHandler(handler, ...)
   local types = {...}
   if #types == 0 then
      print(debug.traceback())
   end
   for _, v in ipairs(types) do
      EFF_HANDLERS[v] = handler
   end
end

--- Register NWNXEvent event handler.
-- @param ip_type
-- @param f A function
function M.RegisterItempropHandler(ip_type, f)
   IP_HANDLERS[ip_type] = f
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

-- Bridge function to hand NWNXEvent events
function NWNXEffects_HandleItemPropEvent(ip_type)
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = IP_HANDLERS[ip_type]
   if not f then return 0 end

   local info = solstice.nwnx.GetItemproptInfo()
   if not info then return 0 end

   f(info)

   return 1
end

return M
