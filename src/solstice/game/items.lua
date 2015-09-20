local ffi = require 'ffi'
local C = ffi.C
local M = require 'solstice.game.init'

local EVENT_HANDLERS = {}

local NWNX_ITEMS_EVENT_CAN_EQUIP          = 1
local NWNX_ITEMS_EVENT_CAN_UNEQUIP        = 2
local NWNX_ITEMS_EVENT_MIN_LEVEL          = 3
local NWNX_ITEMS_EVENT_CAN_USE            = 4
local NWNX_ITEMS_EVENT_CALC_BASE_COST     = 5
local NWNX_ITEMS_EVENT_COMPUTE_WEIGHT     = 6

local function SetMinimumItemLevelOverride(func)
  EVENT_HANDLERS[NWNX_ITEMS_EVENT_MIN_LEVEL] = func
end

local function SetCanUseOverride(func)
  EVENT_HANDLERS[NWNX_ITEMS_EVENT_CAN_USE] = func
end

local function SetCanEquipOverride(func)
  EVENT_HANDLERS[NWNX_ITEMS_EVENT_CAN_EQUIP] = func
end

local function SetCanUnequipOverride(func)
  EVENT_HANDLERS[NWNX_ITEMS_EVENT_CAN_UNEQUIP] = func
end

local function SetCalculateBaseCostOverride(func)
  EVENT_HANDLERS[NWNX_ITEMS_EVENT_CALC_BASE_COST] = func
end


local EVENT_ITEMS_INFO = "Items/Info"
ffi.cdef[[
typedef struct {
    int       type;
    uint32_t  object;
    uint32_t  item;
    bool      use_result;
    uint32_t  result;
} ItemsInfoEvent;
]]

local function handle_item_event(ev)
  ev = ffi.cast("ItemsInfoEvent*", ev)
  if ev == nil then
     return false
  end

  local f = EVENT_HANDLERS[ev.type]
  if not f then return false end

  current_event = ev
  local cre  = GetObjectByID(ev.object)
  local item = GetObjectByID(ev.item)

  f(item, cre, ev.type)

  current_event = nil
  return true
end

local function __NWNXItemsHandleItemEvent(event)
    local ok, ret = pcall(handle_item_event, event)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return false
  end
  return ret
end

local NWNXCore = require 'solstice.nwnx.core'
if not NWNXCore.HookEvent(EVENT_ITEMS_INFO, __NWNXItemsHandleItemEvent) then
   print(EVENT_ITEMS_INFO)
end

--- Sets an PC's helmet as hidden.
-- Note: Re-equipping may be required.  Also this doesn't work well for
-- polymorphing characters.
-- @param pc A player character.
-- @bool val true hides the helmet, false shows it.
function M.SetHelmetHidden(pc, val)
   pc:SetLocalBoolean("NWNX_HELM_HIDDEN", val)
end

M.SetMinimumItemLevelOverride = SetMinimumItemLevelOverride
M.SetCanUseOverride = SetCanUseOverride
M.SetCanEquipOverride = SetCanEquipOverride
M.SetCanUnequipOverride = SetCanUnequipOverride
M.SetCalculateBaseCostOverride = SetCalculateBaseCostOverride


return M
