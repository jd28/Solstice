----
-- Defines the interface to the nwnx_effects plugin.
--
-- nwnx_effects essentially hijacks the EFFECT_TYPE_MODIFYNUMATTACKS
-- The custom type **must** always be stored at index 0 of an effects integer
-- list.
--
-- When an effect, `eff`, of EFFECT_TYPE_MODIFYNUMATTACKS is applied.
-- An effect handler is looked up by eff:GetInt(0), if none is present
-- the effect is deleted.  If one is present the handler will be called
-- with 3 parameters: the effect, an object,
-- and boolean value indicating whether the effect is being applied
-- (false) or removed (true).
--
-- Any additional information (integers, floats, or strings) can
-- be stored at any index, except intger index 0.  See Effect:SetInt,
-- Effect:SetFloat, Effect:SetString.
-- @module nwnx.effects

require 'solstice.nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C
local Eff = require 'solstice.effect'
local GetObjectByID = Game.GetObjectByID

local M = {}

local EFF_HANDLERS = {}

--- Checks if a handler is present..
-- @param eff_type custom effect constants.
function M.GetIsEffectHandlerRegistered(eff_type)
   local h = EFF_HANDLERS[eff_type]
   if not h then
      return false
   end
   return true
end

--- Register an effect handler.
-- @param handler Function to call on object when effect is applied or removed.
-- @param ... List of custom effect constants.
function M.RegisterEffectHandler(handler, ...)
   local types = {...}
   if #types == 0 then
      print("Error: No effects were specified!\n" .. debug.traceback())
   end
   for _, v in ipairs(types) do
      EFF_HANDLERS[v] = handler
   end
end

function __NWNXEffectsHandleRemoveEvent()
   local ev = C.Local_GetLastEffectRemoveEvent()
   if ev == nil then return 0 end

   local obj = GetObjectByID(ev.object)

   local h = EFF_HANDLERS[ev.effect.eff_type]
   if not h then return 0 end

   local del = h(Eff.effect_t(ev.effect, true), obj, true)
   ev.failed = del and 1 or 0

   return 1
end

function __NWNXEffectsHandleApplyEvent()
   local ev = C.Local_GetLastEffectApplyEvent()
   if ev == nil then return 0 end

   local obj = GetObjectByID(ev.object)

   local h = EFF_HANDLERS[ev.effect.eff_type]
   if not h then return 0 end

   local del = h(Eff.effect_t(ev.effect, true), obj, false)

   return 1
end

function __NWNXEffectsHandleItemPropEvent(type, remove)
   local ev = C.Local_GetLastItemPropEvent()
   if ev == nil then
      error("NWNXItems : Local_GetLastItemPropEvent is nil!")
      return false
   end

   local f = IP_HANDLERS[ev.ip.ip_type]
   if not f then return false end

   current_event = ev
   local cre  = GetObjectByID(ev.obj.obj.obj_id)
   local item = GetObjectByID(ev.item.obj.obj_id)
   f(item, cre, ev.ip, ffi.C.ns_BitScanFFS(ev.slot), remove)

   current_event = nil
   return true
end

return M
