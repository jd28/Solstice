--- Get current conversation node type.
local function GetCurrentNodeType()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TYPE", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_TYPE"))
end

--- Get current conversation node ID.
local function GetCurrentNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_NODE_ID"))
end

--- Get current conversation absolute node ID.
local function GetCurrentAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_ABSOLUTE_NODE_ID"))
end

--- Get selected conversation node ID.
local function GetSelectedNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_ID"))
end

--- Get current conversation absolute node ID.
local function GetSelectedAbsoluteNodeID()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID", "      ")
   return tonumber(mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_ABSOLUTE_NODE_ID"))
end

--- Get conversation selected node text.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
local function GetSelectedNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_SELECTED_NODE_TEXT")
end

--- Get conversation current node text.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
local function GetCurrentNodeText(nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!GET_NODE_TEXT", tostring(nLangID*2 + nGender))
   return mod:GetLocalString("NWNX!EVENTS!GET_NODE_TEXT")
end

--- Set conversation current node text.
-- @string sText New text value.
-- @param nLangID LANGUAGE_*
-- @param nGender GENDER_*
local function SetCurrentNodeText(sText, nLangID, nGender)
   if not mod then mod = Game.GetModule() end
   if nGender ~= GENDER_FEMALE then nGender = GENDER_MALE end
   mod:SetLocalString("NWNX!EVENTS!SET_NODE_TEXT", tostring(nLangID*2 + nGender) .. "\xAC" ..sText)
end

local M = require 'solstice.game.init'
M.GetCurrentNodeType = GetCurrentNodeType
M.GetCurrentNodeID = GetCurrentNodeID
M.GetCurrentAbsoluteNodeID = GetCurrentAbsoluteNodeID
M.GetSelectedNodeID = GetSelectedNodeID
M.GetSelectedAbsoluteNodeID = GetSelectedAbsoluteNodeID
M.GetSelectedNodeText = GetSelectedNodeText
M.GetCurrentNodeText = GetCurrentNodeText
M.SetCurrentNodeText = SetCurrentNodeText