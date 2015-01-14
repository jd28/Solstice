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

function NWNXEffects_HandleEffectEvent()
   local ev = C.Local_GetLastEffectEvent()
   if ev == nil then return 0 end

   local obj = _SOL_GET_CACHED_OBJECT(ev.obj.obj_id)

   local h = EFF_HANDLERS[ev.eff.eff_integers[0]]
   if not h then return 0 end

   local del = h(Eff.effect_t(ev.eff, true), obj, ev.is_remove)
   ev.delete_eff = del and 1 or 0

   return 1
end

return M
