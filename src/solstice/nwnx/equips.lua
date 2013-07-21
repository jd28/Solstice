--- NWNX Equips
-- @module nwnx.equips

local ffi = require 'ffi'
local C = ffi.C

local M = {}
local EVENT_HANDLERS = {}

M.EVENT_ALL                = 0
M.EVENT_CAN_EQUIP          = 1
M.EQUIPS_EVENT_CAN_UNEQUIP = 2
M.EVENT_MIN_LEVEL          = 3
M.EVENT_CAN_USE            = 4
M.EVENT_CALC_BASE_COST     = 5
M.EVENT_COMPUTE_WEIGHT     = 6
M.EVENT_NUM                = 7

local current_event

function M.RegisterEquipEventHandler(ev_type, f)
   if ev_type < 0 or ev_type > M.EVENT_NUM then
      error(string.format("Invalid NWNEquips event type: %d\n", ev_type))
   end

   EVENT_HANDLERS[ev_type] = f
end

function NWNXEquips_HandleEquipEvent()
   local ev = C.Local_GetLastEquipEvent()
   if ev == nil then 
      error("NWNXEquips : Local_GetLastEquipEvent is nil!")
      return false
   end

   local f = EVENT_HANDLERS[ev.type] or EVENT_HANDLERS[M.EVENT_ALL]
   if not f then return false end

   current_event = ev
   local cre  = _SOL_GET_CACHED_OBJECT(ev.object)
   local item = _SOL_GET_CACHED_OBJECT(ev.item)

   f(item, cre, event_type)

   current_event = nil
   return true
end

function M.GetDefaultILR(item)
    item:SetLocalString("NWNX!EQUIPS!GET_DEFAULT_ILR", "        ");
    return tonumber(item:GetLocalString("NWNX!EQUIPS!GET_DEFAULT_ILR"));
end
jit.off(M.GetDefaultILR)

function M.SetHelmetHidden(pc, val)
   pc:SetLocalBoolean("NWNX_HELM_HIDDEN", val)
end

function M.SetResult(result)
   current_event.use_result = true
   current_event.result = result
end

return M