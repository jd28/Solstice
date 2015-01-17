--- NWNX Items
-- nwnx_items allows orrividing some aspects of items:
--
-- * Whether a creature can equip, use, unequip an item.
-- * The base cost and weight of item.
-- * The items minimum level required to equip. Note: this
-- requires using the ILR setting on your server.
--
-- It also allows you to override or create new itemproperty add/
-- remove events.  E,g. if you added an item property to grant spell
-- DC increase, you could use this to directly modify some local int
-- that your spell system uses to calculate DC.  The alternative to
-- this is looping through all item properties when the item is
-- (un)equipped.
--
-- @module nwnx.items
-- @alias M

local ffi = require 'ffi'
local C = ffi.C

local M = {}
local EVENT_HANDLERS = {}
local IP_HANDLERS = {}

--- Constants
-- @section constants

M.EVENT_ALL                = 0

--- Can equip item event.  Note that using `SetResult(true)`
-- will essentially operate like if a DM was equipping the
-- item.
M.EVENT_CAN_EQUIP          = 1

--- Can unequip item event.  Note only `SetResult(false)`
-- is respected.
M.EVENT_CAN_UNEQUIP        = 2

--- Minimum level required event.  This is used to determine
-- ILR.
M.EVENT_MIN_LEVEL          = 3

--- Can use item event.  Note that using `SetResult(true)`
-- will essentially operate like if a DM was equipping the
-- item.  SetResult(false) will highlight the item in red.
-- However, you'll still need to override the EVENT_CAN_EQUIP
-- event to ensure a player cannot equip the item.
M.EVENT_CAN_USE            = 4

--- Calculate base cost event.  The value passed to `SetResult`
-- must be positive.
M.EVENT_CALC_BASE_COST     = 5

--- Calculate item weight event.  The value passed to `SetResult`
-- must be positive.
M.EVENT_COMPUTE_WEIGHT     = 6

M.EVENT_NUM                = 7

local current_event

--- Functions
-- @section functions

--- Register an event handler.
-- @param ev_type Event type, see constants.
-- @param f A function that takes three parameters: an item, a creature,
-- and the event type.
function M.RegisterItemEventHandler(ev_type, f)
   if ev_type < 0 or ev_type > M.EVENT_NUM then
      error(string.format("Invalid NWNItems event type: %d\n", ev_type))
   end

   EVENT_HANDLERS[ev_type] = f
end

--- Register an item propert handler.
-- @param ipconst An item property constant.
-- @param f A function taking up to four parameters: An item, the object
-- equipping the item, the item property, and the slot the item is being
-- equipped to.  The item property is a C struct `CNWItemProperty` as
-- defined in solstice/nwn/ctypes/itemprop.lua, it is not an ItemProp
-- class instance.
function M.RegisterItempropHandler(ipconst, f)
   IP_HANDLERS[ipconst] = f
end

--- Gets the default ILR for an item.
-- @param item An item.
function M.GetDefaultILR(item)
    item:SetLocalString("NWNX!ITEMS!GET_DEFAULT_ILR", "        ");
    return tonumber(item:GetLocalString("NWNX!ITEMS!GET_DEFAULT_ILR"));
end
jit.off(M.GetDefaultILR)

--- Sets an PC's helmet as hidden.
-- Note: Re-equipping may be required.  Also this doesn't work well for
-- polymorphing characters.
-- @param pc A player character.
-- @bool val true hides the helmet, false shows it.
function M.SetHelmetHidden(pc, val)
   pc:SetLocalBoolean("NWNX_HELM_HIDDEN", val)
end

--- Set result.
-- This function must be called to override the result of any
-- event.
-- @param result Integer value dependent on the event firing.
function M.SetResult(result)
   current_event.use_result = true
   current_event.result = result
end

function NWNXItems_HandleItemEvent()
   local ev = C.Local_GetLastItemEvent()
   if ev == nil then
      error("NWNXItems : Local_GetLastItemEvent is nil!")
      return false
   end

   local f = EVENT_HANDLERS[ev.type] or EVENT_HANDLERS[M.EVENT_ALL]
   if not f then return false end

   current_event = ev
   local cre  = _SOL_GET_CACHED_OBJECT(ev.object)
   local item = _SOL_GET_CACHED_OBJECT(ev.item)

   f(item, cre, ev.type)

   current_event = nil
   return true
end

function NWNXItems_HandleItemPropEvent()
   local ev = C.Local_GetLastItemPropEvent()
   if ev == nil then
      error("NWNXItems : Local_GetLastItemPropEvent is nil!")
      return false
   end

   local f = EVENT_HANDLERS[ev.ip.ip_type]
   if not f then return false end

   current_event = ev
   local cre  = _SOL_GET_CACHED_OBJECT(ev.obj)
   local item = _SOL_GET_CACHED_OBJECT(ev.item)
   f(item, cre, ev.ip, ev.slot)

   current_event = nil
   return true
end


return M
