require 'nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C

local IP_HANDLERS = {}
local CUSTOM_EFFECTS = {}

ffi.cdef[[
typedef struct {
    CNWSCreature    *obj;
    CNWSItem        *item;
    CNWItemProperty *ip;
    bool             remove;
} EventItemprop;

EventItemprop *Local_GetLastNWNXEventItemprop();
CGameEffect * nl_GetLastCustomEffect();
]]

function nwnx.GetItempropInfo()
   local e = C.Local_GetLastNWNXEventItemprop()
   if e == nil then return end

   return { type = e.ip.ip_type,
            object = _NL_GET_CACHED_OBJECT(e.obj.obj.obj_id),
            item = _NL_GET_CACHED_OBJECT(e.item.obj.obj_id),
          }
end

---
function NSCustomEffectImpact(obj, is_apply)
   -- Treat last custome effect as direct, it will be deleted
   -- by the game engine.
   local eff = effect_t(C.nl_GetLastCustomEffect(), true)
   obj = _NL_GET_CACHED_OBJECT(obj)

   local eff_type = eff:GetTrueType()
   local h = CUSTOM_EFFECTS[eff_type]
   if not h then
      return true
   end

   return h(eff, obj, is_apply)
end

function nwn.GetIsCustomEffectRegistered(eff_type)
   local h = CUSTOM_EFFECTS[eff_type]
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
function nwn.RegisterCustomEffectHandler(effect_type, handler)
   CUSTOM_EFFECTS[effect_type] = handler
end

--- Register NWNXEvent event handler.
-- @param ip_type
-- @param f A function
function nwnx.RegisterItempropHandler(ip_type, f)
   IP_HANDLERS[ip_type] = f
end

--- Bridge function to hand NWNXEvent events
function NSHandleNWNXItemPropEvent(ip_type)
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = IP_HANDLERS[ip_type]
   if not f then return 0 end
   
   local info = nwnx.GetItemproptInfo()
   if not info then return 0 end

   f(info)
   
   return 1
end