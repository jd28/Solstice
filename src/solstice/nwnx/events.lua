--- NWNX Events
-- @module nwnx.events
-- @alias M

local Vec = require 'solstice.vector'
local Log = System.GetLogger()
local GetObjectByID = Game.GetObjectByID
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
-- The toggle mode event is not exposed.  This already handled in the Solstice mode code.
local EVENT_TYPE_TOGGLE_MODE       = 9
M.EVENT_TYPE_CAST_SPELL        = 10
M.EVENT_TYPE_TOGGLE_PAUSE      = 11
M.EVENT_TYPE_POSSESS_FAMILIAR  = 12
M.EVENT_TYPE_DESTROY_OBJECT    = 14

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

local function GetEventInfo()
   local e = C.Local_GetLastNWNXEvent()
   if e == nil then
      Log:error("GetEventInfo GetLastNWNXEvent is null")
      return
   end

   return { type = e.type,
            subtype = e.subtype,
            object = GetObjectByID(e.object),
            target = GetObjectByID(e.target),
            item = GetObjectByID(e.item),
            pos = Vec.vector_t(e.loc.x, e.loc.y, e.loc.z)
          }
end

--- Bypass current event.
function M.BypassEvent()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!BYPASS", "1")
end

--- Register NWNXEvent event handler.
-- @param event_type M.EVENT_TYPE_*/
-- @param f A function to handle the event.  When the event fires the function will
-- be called with one paramenter a NWNXEventInfo table.
function M.RegisterEventHandler(type, f)
  if EVENT_HANDLERS[type] then
    Log:warning("Overiding event handler for event: %d", type)
  end
  EVENT_HANDLERS[type] = f
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

-- Bridge function to hand NWNXEvent events
function __NWNXEventsHandleEvent(event_type)
  if event_type == EVENT_TYPE_TOGGLE_MODE then
    M.BypassEvent()
    local e = C.Local_GetLastNWNXEvent()
    __ToggleMode(e.object, e.type)
    return
  end

  if EVENT_HANDLERS[type] then
    EVENT_HANDLERS[type](GetEventInfo())
  end
end

return M
