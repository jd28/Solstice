require 'nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C

NWNXEffects = {}

local IP_HANDLERS = {}
local EFF_HANDLERS = {}

function NWNXEffects.SendEffects(obj)
   obj:SetLocalString("NWNX!EFFECTS!SENDEFFECTS", " ")
end

function NWNXEffects.GetItempropInfo()
   local e = C.Local_GetLastNWNXEventItemprop()
   if e == nil then return end

   return { type = e.ip.ip_type,
            object = _NL_GET_CACHED_OBJECT(e.obj.obj.obj_id),
            item = _NL_GET_CACHED_OBJECT(e.item.obj.obj_id),
          }
end

function NWNXEffects.GetIsEffectHandlerRegistered(eff_type)
   local h = EFF_HANDLERS[eff_type]
   if not h then
      return false
   end
   return true
end

--- Register an effect handler.
-- @param effect_type EFFECT_TRUETYPE_* or some other custom event type.
-- @param handler Function to call on object when effect is applied or removed.
--    It will be called with three parameters: an effect, an object, and boolean value
--    indicating whether the effect is being applied (false) or removed (true)
function NWNXEffects.RegisterEffectHandler(effect_type, handler)
   if not effect_type then
      print(debug.traceback())
   end
   EFF_HANDLERS[effect_type] = handler
end

--- Register NWNXEvent event handler.
-- @param ip_type
-- @param f A function
function NWNXEffects.RegisterItempropHandler(ip_type, f)
   IP_HANDLERS[ip_type] = f
end

---
function NWNXEffects_HandleEffectEvent()
   local ev = C.Local_GetLastEffectEvent()
   if ev == nil then return 0 end

   obj = _NL_GET_CACHED_OBJECT(ev.obj.obj_id)

   -- The effect should be treated as a direct effect.  So Lua doesn't delete it.
   local eff = effect_t(ev.eff, true)
   local eff_type = eff:GetTrueType()

   local h = EFF_HANDLERS[eff_type]
   if not h then return 0 end

   ev.suppress = true
   ev.delete_eff = h(eff, obj, ev.is_remove) or false

   return 1
end

--- Bridge function to hand NWNXEvent events
function NWNXEffects_HandleItemPropEvent(ip_type)
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = IP_HANDLERS[ip_type]
   if not f then return 0 end
   
   local info = nwnx.GetItemproptInfo()
   if not info then return 0 end

   f(info)
   
   return 1
end