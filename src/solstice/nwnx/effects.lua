----
-- Defines the interface to the nwnx_effects plugin.
--

require 'solstice.nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C
local Eff = require 'solstice.effect'
local GetObjectByID = Game.GetObjectByID
local M = {}

local EVENT_EFFECTS_CUSTOM_APPLY = "Effects/Custom/Apply"
local EVENT_EFFECTS_CUSTOM_REMOVE = "Effects/Custom/Remove"
local EVENT_EFFECTS_IP_APPLY = "Effects/IP/Apply"
local EVENT_EFFECTS_IP_REMOVE = "Effects/IP/Remove"

ffi.cdef[[
struct EffectsCustomEvent {
   /* The object on which the effect is applied/removed. */
   CNWSObject  *object;
   /* The effect itself. */
   CGameEffect *effect;
   /* Return true here if the effect cant be applied; this deletes it. */
   bool         failed;
};

struct EffectsItempropEvent {
    CNWSCreature    *obj;
    CNWSItem        *item;
    CNWItemProperty *ip;
    uint32_t         slot;
    bool             suppress;
    bool             remove;
};
]]


local EFF_HANDLERS = {}

--- Checks if a handler is present..
-- @param eff_type custom effect constants.
function M.GetIsEffectHandlerRegistered(eff_type)
   return not not EFF_HANDLERS[eff_type]
end

--- Register an effect handler.
-- @param handler Function to call on object when effect is applied or removed.
-- @param ... List of custom effect constants.
function M.RegisterEffectHandler(handler, ...)
   local types = table.pack(...)
   if types.n == 0 then
      print("Error: No effects were specified!\n" .. debug.traceback())
   end
   for i=1, types.n do
      EFF_HANDLERS[types[i]] = handler
   end
end

function M.LogEffects(obj)
    obj:SetLocalString("NWNX!EFFECTS!LOG", "1");
end

function M.SetNativeEffectCallsUs(truetype)
  local mod = Game.GetModule()
  mod:SetLocalString("NWNX!EFFECTS!SETEFFECTNATIVEHANDLED",
                     tostring(truetype));
end

function M.GetCustomEffectTickRate(eff)
  return eff:GetInt(20)
end

function M.SetCustomEffectTickRate(eff, value)
    eff:SetInt(20, value)
end

function M.EffectCustom(truetype)
  if truetype >= 96 then
    local Eff = require 'solstice.effect'
    -- We're using effectModifyAttacks as a template because it only uses
    -- one int param.
    local ret = Eff.ModifyAttacks(0)
    -- We immediately set a custom truetype, so it never registers as such
    -- with nwserver. You're free to use all local CGameEffect
    -- ints/floats/object/strings for your own nefarious purposes.
    ret:SetType(truetype)
    return ret
  end
end

local IP_HANDLERS = {}

--- Checks if a handler is present..
-- @param eff_type custom effect constants.
function M.GetIsItempropHandlerRegistered(type)
   return not not IP_HANDLERS[type]
end

--- Register an item propert handler.
-- @param f A function taking up to four parameters: An item, the object
-- equipping the item, the item property, the slot the item is being
-- equipped to, and a boolean indicating whether the item property is being removed.
-- The item property is a C struct `CNWItemProperty` as
-- defined in solstice/nwn/ctypes/itemprop.lua, it is not an ItemProp
-- class instance.
-- @param ... An item property constant.
function M.RegisterItempropHandler(handler, ...)
   local t = table.pack(...)
   for i=1, t.n do
      IP_HANDLERS[t[i]] = handler
   end
end

function M.BypassNativeItemProperty()
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!IPBYPASS", "1");
end

local NWNXCore = require 'solstice.nwnx.core'

local function handle_effect(event, remove)
   local ev = ffi.cast("struct EffectsCustomEvent*", event)
   if ev == nil then return 0 end

   local obj = GetObjectByID(ev.object.obj_id)

   local h = EFF_HANDLERS[ev.effect.eff_type]
   if not h then return 0 end

   local del = h(Eff.effect_t(ev.effect, true), obj, remove)
   ev.failed = del and 1 or 0

   return 1
end

local function __NWNXEffectsHandleRemoveEvent(event)
  local ok, ret = pcall(handle_effect, event, true)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return 0
  end
  return ret
end
if not NWNXCore.HookEvent(EVENT_EFFECTS_CUSTOM_REMOVE, __NWNXEffectsHandleRemoveEvent) then
   print(EVENT_EFFECTS_CUSTOM_REMOVE)
end

local function __NWNXEffectsHandleApplyEvent(event)
  local ok, ret = pcall(handle_effect, event, true)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return 0
  end
  return ret
end
if not NWNXCore.HookEvent(EVENT_EFFECTS_CUSTOM_APPLY, __NWNXEffectsHandleApplyEvent) then
   print(EVENT_EFFECTS_CUSTOM_APPLY)
end

local function handle_itemprop(event, remove)
   local ev = ffi.cast("struct EffectsItempropEvent*", event)
   if ev == nil then return 0 end

   local f = IP_HANDLERS[ev.ip.ip_type]
   if not f then return 0 end

   local cre  = GetObjectByID(ev.obj.obj.obj_id)
   local item = GetObjectByID(ev.item.obj.obj_id)
   f(item, cre, ev.ip, ffi.C.ns_BitScanFFS(ev.slot), remove)

   return 1
end

local function __NWNXEffectsHandleItemPropEventApply(event)
  local ok, ret = pcall(handle_itemprop, event, false)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return 0
  end
  return ret
end

if not NWNXCore.HookEvent(EVENT_EFFECTS_IP_APPLY, __NWNXEffectsHandleItemPropEventApply) then
   print(EVENT_EFFECTS_IP_APPLY)
end

local function __NWNXEffectsHandleItemPropEventRemove(event)
  local ok, ret = pcall(handle_itemprop, event, true)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return 0
  end
  return ret
end
if not NWNXCore.HookEvent(EVENT_EFFECTS_IP_REMOVE, __NWNXEffectsHandleItemPropEventRemove) then
   print(EVENT_EFFECTS_IP_REMOVE)
end
return M
