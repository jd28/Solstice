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

function nwnx.GetEventType()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_EVENT_ID", "          ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_EVENT_ID"))
end

function nwnx.GetEventSubType()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_EVENT_SUBID", "          ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_EVENT_SUBID"))
end

function nwnx.GetEventTarget()
   if not mod then mod = nwn.GetModule() end
   return mod:GetLocalObject("NWNX!EVENTS!TARGET")
end

function nwnx.GetEventItem()
   if not mod then mod = nwn.GetModule() end
   return mod:GetLocalObject("NWNX!EVENTS!ITEM")
end

function nwnx.GetEventPosition()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_EVENT_POSITION", "                                              ")
   local vector = mod:GetLocalString("NWNX!EVENTS!GET_EVENT_POSITION")
   local x, y, z = string.match(vector, "(%d)¬(%d)¬(%d)")

   return vector_t(x, y, z)
end

function nwnx.BypassEvent()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!BYPASS", "1")
end

function nwnx.SetGlobalEventHandler(nEventID, sHandler)
   if not mod then mod = nwn.GetModule() end
   if sHandler == "" then
      sHandler = "-"
   end

   local sKey = "NWNX!EVENTS!SET_EVENT_HANDLER_" + tostring(nEventID)
   mod:SetLocalString(sKey, sHandler)
   mod:DeleteLocalString(sKey)
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

