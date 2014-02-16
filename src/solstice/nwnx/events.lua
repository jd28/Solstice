--- NWNX Events
-- @module nwnx.events

local Vec = require 'solstice.vector'
local Log = require 'solstice.log'

local M = {}

local mod
local EVENT_HANDLERS = {}
local EXAMINE_HANDLERS = {}
local ffi = require 'ffi'
local C = ffi.C

M.EVENT_TYPE_ALL               = 0
M.EVENT_TYPE_SAVE_CHAR         = 1
M.EVENT_TYPE_PICKPOCKET        = 2
M.EVENT_TYPE_ATTACK            = 3
M.EVENT_TYPE_USE_ITEM          = 4
M.EVENT_TYPE_QUICKCHAT         = 5
M.EVENT_TYPE_EXAMINE           = 6
M.EVENT_TYPE_USE_SKILL         = 7
M.EVENT_TYPE_USE_FEAT          = 8
M.EVENT_TYPE_TOGGLE_MODE       = 9
M.EVENT_TYPE_CAST_SPELL        = 10
M.EVENT_TYPE_TOGGLE_PAUSE      = 11
M.EVENT_TYPE_POSSESS_FAMILIAR  = 12
M.EVENT_TYPE_DESTROY_OBJECT    = 14
M.EVENT_TYPE_PVP_STATE         = 15

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

--- Event Info Table
-- @class table NWNXEventInfo
-- @field type Event type
-- @field type Event subtype
-- @field type Event target or solstice.object.INVALID
-- @field item Event item or solstice.object.INVALID
-- @field pos Event location vector

--- Gets information about the current event.
-- @return see table type NWNXEventInfo
function M.GetEventInfo()
   local e = C.Local_GetLastNWNXEvent()
   if e == nil then
      Log.WriteTimestampedLogEntry("GetEventInfo GetLastNWNXEvent is null")
      return
   end

   return { type = e.type,
            subtype = e.subtype,
            object = _SOL_GET_CACHED_OBJECT(e.object),
            target = _SOL_GET_CACHED_OBJECT(e.target),
            item = _SOL_GET_CACHED_OBJECT(e.item),
            pos = Vec.vector_t(e.loc.x, e.loc.y, e.loc.z)
          }
end

--- Bypass current event.
-- @param use_return_val If true this tells the plugin to use a value
--    passed via M.SetEventReturnValue. (Default: false)
function M.BypassEvent(use_return_val)
   if not mod then mod = Game.GetModule() end

   if not use_return_val then
      mod:SetLocalString("NWNX!EVENTS!BYPASS", "1")
   else
      mod:SetLocalString("NWNX!EVENTS!BYPASS", "1¬1")
   end
end

--- Register NWNXEvent event handler.
-- @param event_type M.EVENT_TYPE_*
-- @param f A function to handle the event.  When the event fires the function will
--    be called with one paramenter a NWNXEventInfo table.
function M.RegisterEventHandler(event_type, f)
   EVENT_HANDLERS[event_type] = f
end

--- Register NWNXEvent examine event handler.
-- TODO FIX THIS
-- @param obj_type
-- @param f A function to handle the event.  When the event fires the function will
--    be called with two parameters the object and a boolean indicating whether the object
--    is identified or not..
function M.RegisterExamineEventHandler(obj_type, f)
   EXAMINE_HANDLERS[obj_type] = f
end


--- Sets a value for NWNX Events to return from a hook.
-- @param val Must be an integer value.
function M.SetEventReturnValue(val)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!RETURN", tostring(val));
end

function M.GetCurrentNodeType()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TYPE", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_TYPE"))
end

function M.GetCurrentNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_ID"))
end

function M.GetCurrentAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID"))
end

function M.GetSelectedNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID"))
end

function M.GetSelectedAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID"))
end

function M.GetSelectedNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT")
end

function M.GetCurrentNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_NODE_TEXT")
end

function M.SetCurrentNodeText(sText, nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!SET_NODE_TEXT", tostring(nLangID*2 + nGender) .. "¬" ..sText)
end

for name, func in pairs(M) do
   if type(func) == "function" then
      -- This must absolutely be set, if the call here is JITed
      -- the plugin will crash constantly.
      jit.off(func)
   end
end

-- Bridge function to hand NWNXEvent events
function NWNXEvents_HandleEvent(event_type)
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = EVENT_HANDLERS[event_type]
   if not f then return false end

   return f(M.GetEventInfo())
end

function NWNXEvents_HandleExamineEvent(obj, identified)
   obj = _SOL_GET_CACHED_OBJECT(obj)
   identified = identified or true

   if not obj:GetIsValid() then return "" end

   local f = EXAMINE_HANDLERS[obj.type]
   if not f or not identified then return obj:GetDescription() end
   return f(obj, identified)
end

return M
