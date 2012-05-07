nwnx.EVENT_TYPE_ALL               = 0
nwnx.EVENT_TYPE_SAVE_CHAR         = 1
nwnx.EVENT_TYPE_PICKPOCKET        = 2
nwnx.EVENT_TYPE_ATTACK            = 3
nwnx.EVENT_TYPE_USE_ITEM          = 4
nwnx.EVENT_TYPE_QUICKCHAT         = 5
nwnx.EVENT_TYPE_EXAMINE           = 6
nwnx.EVENT_TYPE_USE_SKILL         = 7
nwnx.EVENT_TYPE_USE_FEAT          = 8
nwnx.EVENT_TYPE_TOGGLE_MODE       = 9
nwnx.EVENT_TYPE_CAST_SPELL        = 10
nwnx.EVENT_TYPE_TOGGLE_PAUSE      = 11
nwnx.EVENT_TYPE_POSSESS_FAMILIAR  = 12

nwnx.NODE_TYPE_STARTING_NODE      = 0
nwnx.NODE_TYPE_ENTRY_NODE         = 1
nwnx.NODE_TYPE_REPLY_NODE         = 2

nwnx.LANGUAGE_ENGLISH             = 0
nwnx.LANGUAGE_FRENCH              = 1
nwnx.LANGUAGE_GERMAN              = 2
nwnx.LANGUAGE_ITALIAN             = 3
nwnx.LANGUAGE_SPANISH             = 4
nwnx.LANGUAGE_POLISH              = 5
nwnx.LANGUAGE_KOREAN              = 128
nwnx.LANGUAGE_CHINESE_TRADITIONAL = 129
nwnx.LANGUAGE_CHINESE_SIMPLIFIED  = 130
nwnx.LANGUAGE_JAPANESE            = 131

local mod
local EVENT_HANDLERS = {}
local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
typedef struct {
    int      type;
    int      subtype;
    uint32_t object;
    uint32_t target;
    uint32_t item;
    Vector   loc;
    bool     bypass;
    bool     use_result;
    int32_t  result;
} Event;

Event *Local_GetLastNWNXEvent();
]]

--- Event Info Table
-- @class table NWNXEventInfo
-- @field type Event type
-- @field type Event subtype
-- @field type Event target or nwn.OBJECT_INVALID
-- @field item Event item or nwn.OBJECT_INVALID
-- @field pos Event location vector

--- Gets information about the current event.
-- @return see Table type NWNXEventInfo
function nwnx.GetEventInfo()
   local e = C.Local_GetLastNWNXEvent()
   if e == nil then return end

   return { type = e.type,
            subtype = e.subtype,
            object = _NL_GET_CACHED_OBJECT(e.object),
            target = _NL_GET_CACHED_OBJECT(e.target),
            item = _NL_GET_CACHED_OBJECT(e.item),
            pos = vector_t(e.loc.x, e.loc.y, e.loc.z)
          }
end

--- Bypass current event.
-- @param use_return_val If true this tells the plugin to use a value 
--    passed via nwnx.SetEventReturnValue. (Default: false)
function nwnx.BypassEvent(use_return_val)
   if not mod then mod = nwn.GetModule() end

   if not use_return_val then
      mod:SetLocalString("NWNX!EVENTS!BYPASS", "1")
   else
      mod:SetLocalString("NWNX!EVENTS!BYPASS", "1¬1")
   end
end

--- Register NWNXEvent event handler.
-- @param event_type nwnx.EVENT_TYPE_*
-- @param f A function to handle the event.  When the event fires the function will
--    be called with one paramenter a NWNXEventInfo table.
function nwnx.RegisterEventHandler(event_type, f)
   EVENT_HANDLERS[event_type] = f
end

--- Sets a value for NWNX Events to return from a hook.
-- @param val Must be an integer value.
function nwnx.SetEventReturnValue(val)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!RETURN", tostring(val));
end

function nwnx.GetCurrentNodeType()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TYPE", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_TYPE"))
end

function nwnx.GetCurrentNodeID()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_ID"))
end

function nwnx.GetCurrentAbsoluteNodeID()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID"))
end

function nwnx.GetSelectedNodeID()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID"))
end

function nwnx.GetSelectedAbsoluteNodeID()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID"))
end

function nwnx.GetSelectedNodeText(nLangID, nGender)
   if not mod then mod = nwn.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT")
end

function nwnx.GetCurrentNodeText(nLangID, nGender)
   if not mod then mod = nwn.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_NODE_TEXT")
end

function nwnx.SetCurrentNodeText(sText, nLangID, nGender)
   if not mod then mod = nwn.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!SET_NODE_TEXT", tostring(nLangID*2 + nGender) .. "¬" ..sText)
end

--- Bridge function to hand NWNXEvent events
function NSHandleNWNXEvent(event_type)
   print("Handle NWNX Event", event_type)
   
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = EVENT_HANDLERS[event_type]
   if not f then return 0 end
   
   f(nwnx.GetEventInfo())
   
   return 1
end