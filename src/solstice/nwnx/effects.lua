----
-- Defines the interface to the nwnx_effects plugin.
--

require 'solstice.nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C
local Eff = require 'solstice.effect'
local GetObjectByID = Game.GetObjectByID
local M = {}

local EVENT_EFFECTS_CUSTOM = "Effects/Custom"
local EVENT_EFFECTS_IP = "Effects/IP"

ffi.cdef[[
typedef struct {
    /* The object on which the effect is applied/removed. */
    CNWSObject  *object;
    /* The effect itself. */
    CGameEffect *effect;
    /* Return true here if the effect cant be applied; this deletes it. */
    bool         failed;
    /* 0: Apply, 1: Remove, 2: Tick */
    int32_t      type;
} EffectsCustomEvent;

typedef struct {
    CNWSCreature    *obj;
    CNWSItem        *item;
    CNWItemProperty *ip;
    uint32_t         slot;
    bool             suppress;
    bool             remove;
} EffectsItempropEvent;
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

local function handle_effect(event)
   local ev = ffi.cast("EffectsCustomEvent*", event)
   if ev == nil then return 0 end

   local obj = GetObjectByID(ev.object.obj_id)

   local h = EFF_HANDLERS[ev.effect.eff_type]
   if not h then return 0 end

   local del = h(Eff.effect_t(ev.effect, true), obj, event.type)
   ev.failed = del and 1 or 0

   return 1
end

local function __NWNXEffectsHandleEvent(event)
  local ok, ret = pcall(handle_effect, event)
  if not ok then
    local Log = System.GetLogger()
    Log:error("__NWNXEffectsHandleEvent: %s", ret)
    return 0
  end
  return ret
end
if not NWNXCore.HookEvent(EVENT_EFFECTS_CUSTOM, __NWNXEffectsHandleEvent) then
   print(EVENT_EFFECTS_CUSTOM)
end

local function handle_itemprop(event)
   local ev = ffi.cast("EffectsItempropEvent*", event)
   if ev == nil then return 0 end

   local f = IP_HANDLERS[ev.ip.ip_type]
   if not f then return 0 end

   local cre  = GetObjectByID(ev.obj.obj.obj_id)
   local item = GetObjectByID(ev.item.obj.obj_id)
   f(item, cre, ev.ip, ffi.C.ns_BitScanFFS(ev.slot), event.remove)

   return 1
end

local function __NWNXEffectsHandleItemPropEvent(event)
  local ok, ret = pcall(handle_itemprop, event)
  if not ok then
    local Log = System.GetLogger()
    Log:error("__NWNXEffectsHandleItemPropEvent: %s", ret)
    return 0
  end
  return ret
end

if not NWNXCore.HookEvent(EVENT_EFFECTS_IP, __NWNXEffectsHandleItemPropEvent) then
   print(EVENT_EFFECTS_IP)
end

return M
