--- NWNX Events
-- @module nwnx.events
-- @alias M

local Vec = require 'solstice.vector'
local Signal = require 'solstice.external.signal'
local Log = System.GetLogger()
local GetObjectByID = Game.GetObjectByID
local M = {}

local EVENT_HANDLERS = {}

local mod
local ffi = require 'ffi'
local C = ffi.C

local NWNX_EVENTS_EVENT = "Events/Event"

ffi.cdef[[
struct EventsEvent {
    int type;
    int subtype;
    uint32_t object;
    uint32_t target;
    uint32_t item;
    Vector position;
    bool bypass;
    int  result;
};
]]

M.NODE_TYPE_STARTING_NODE      = 0
M.NODE_TYPE_ENTRY_NODE         = 1
M.NODE_TYPE_REPLY_NODE         = 2

M.LANGUAGE_ENGLISH             = 0
M.LANGUAGE_FRENCH              = 1
M.LANGUAGE_GERMAN              = 2
M.LANGUAGE_ITALIAN             = 3
M.LANGUAGE_SPANISH             = 4
M.LANGUAGE_POLISH              = 5
M.LANGUAGE_KOREAN              = 128
M.LANGUAGE_CHINESE_TRADITIONAL = 129
M.LANGUAGE_CHINESE_SIMPLIFIED  = 130
M.LANGUAGE_JAPANESE            = 131

-- Unexposed events.  Solstice will provide an interface for them.
local EVENT_TYPE_USE_FEAT          = 8
local EVENT_TYPE_TOGGLE_MODE       = 9
local EVENT_TYPE_USE_ITEM          = 4
local EVENT_TYPE_USE_SKILL         = 7

local EVENT_TYPE_SAVE_CHAR         = 1
local EVENT_TYPE_PICKPOCKET        = 2
local EVENT_TYPE_ATTACK            = 3
local EVENT_TYPE_QUICKCHAT         = 5
local EVENT_TYPE_EXAMINE           = 6
local EVENT_TYPE_CAST_SPELL        = 10
local EVENT_TYPE_TOGGLE_PAUSE      = 11
local EVENT_TYPE_POSSESS_FAMILIAR  = 12
local EVENT_TYPE_DESTROY_OBJECT    = 14

M.SaveCharacter = Signal.signal()
M.PickPocket = Signal.signal()
M.Attack = Signal.signal()
M.QuickChat = Signal.signal()
M.Examine = Signal.signal()
M.CastSpell = Signal.signal()
M.TogglePause = Signal.signal()
M.PossessFamiliar = Signal.signal()
M.DestroyObject = Signal.signal()

function M.__SetEventHandlerInternal(type, f)
  if EVENT_HANDLERS[type] then
    Log:warning("Overiding event handler for event: %d", type)
  end
  EVENT_HANDLERS[type] = f
end

--- Bypass current event.
function M.BypassEvent()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!BYPASS", "1")
end

--- Sets a value for NWNX Events to return from a hook.
-- @param val Must be an integer value.
function M.SetEventReturnValue(val)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!RETURN", tostring(val));
end

--- Get current conversation node type.
function M.GetCurrentNodeType()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TYPE", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_TYPE"))
end

--- Get current conversation node ID.
function M.GetCurrentNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_ID"))
end

--- Get current conversation absolute node ID.
function M.GetCurrentAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID"))
end

--- Get selected conversation node ID.
function M.GetSelectedNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID"))
end

--- Get current conversation absolute node ID.
function M.GetSelectedAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID"))
end

--- Get conversation selected node text.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
function M.GetSelectedNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT")
end

--- Get conversation current node text.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
function M.GetCurrentNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_NODE_TEXT")
end

--- Set conversation current node text.
-- @string sText New text value.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
function M.SetCurrentNodeText(sText, nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!SET_NODE_TEXT", tostring(nLangID*2 + nGender) .. "\xAC" ..sText)
end

for _, func in pairs(M) do
   if type(func) == "function" then
      -- This must absolutely be set, if the call here is JITed
      -- the plugin will crash constantly.
      jit.off(func)
   end
end

local function GetEventInfo(e)
   return { type = e.type,
            subtype = e.subtype,
            object = GetObjectByID(e.object),
            target = GetObjectByID(e.target),
            item = GetObjectByID(e.item),
            pos = Vec.vector_t(e.position.x, e.position.y, e.position.z)
          }
end

local function handle_event(event)
  local e = ffi.cast("struct EventsEvent*", event)
  if e == nil then
    Log:error("GetEventInfo GetLastNWNXEvent is null")
    return
  end
  if e.type == EVENT_TYPE_TOGGLE_MODE then
    M.BypassEvent()
    local e = C.Local_GetLastNWNXEvent()
    __ToggleMode(e.object, e.subtype)
  elseif e.type == EVENT_TYPE_SAVE_CHAR then
    M.SaveCharacter:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_PICKPOCKET then
    M.PickPocket:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_ATTACK then
    M.Attack:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_QUICKCHAT then
    M.QuickChat:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_EXAMINE then
    M.Examine:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_CAST_SPELL then
    M.CastSpell:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_TOGGLE_PAUSE then
    M.TogglePause:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_POSSESS_FAMILIAR then
    M.PossessFamiliar:notify(GetEventInfo(e))
  elseif e.type == EVENT_TYPE_DESTROY_OBJECT then
    M.DestroyObject:notify(GetEventInfo(e))
  elseif EVENT_HANDLERS[e.type] then
    EVENT_HANDLERS[e.type](GetEventInfo(e))
  end
  return e.bypass and 1 or 0
end

function __NWNXEventsHandleEvent(event)
  local ok, ret = pcall(handle_event, event)
  if not ok then
    local Log = System.GetLogger()
    Log:error("%s\nStack Trace: %s\n", ret, debug.traceback())
    return 0
  end
  return ret
end
local NWNXCore = require 'solstice.nwnx.core'
if not NWNXCore.HookEvent(NWNX_EVENTS_EVENT, __NWNXEventsHandleEvent) then
   print(NWNX_EVENTS_EVENT)
end

return M
