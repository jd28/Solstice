--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local ne = require 'solstice.nwn.engine'
local Color = require 'solstice.color'
local fmt = string.format
local Creature = M.Creature

--- PC
-- @section

function Creature:ActivatePortal(ip, password, waypoint, seemless)
   ip = ip or ""
   password = password or ""
   waypoint = waypoint or ""

   ne.StackPushBoolean(seemless)
   ne.StackPushString(waypoint)
   ne.StackPushString(password)
   ne.StackPushString(ip)
   ne.StackPushObject(self)
   ne.ExecuteCommand(474, 5)
end

function Creature:AddJournalQuestEntry(plot, state, entire_party, all_pc, allow_override)
   if entire_party == nil then entire_party = true end

   ne.StackPushBoolean(allow_override)
   ne.StackPushBoolean(all_pc)
   ne.StackPushBoolean(entire_party)
   ne.StackPushObject(self)
   ne.StackPushInteger(state)
   ne.StackPushString(plot)
   ne.ExecuteCommand(367, 6)
end

function Creature:BootPC()
   ne.StackPushObject(self)
   ne.ExecuteCommand(565, 1)
end

function Creature:DayToNight(transition_time)
   ne.StackPushFloat(transition_time or 0)
   ne.StackPushObject(self)
   ne.ExecuteCommand(750, 2)
end

function Creature:ExploreArea(area, explored)
   if explored == nil then explored = true end

   ne.StackPushBoolean(explored)
   ne.StackPushObject(self)
   ne.StackPushObject(area)
   ne.ExecuteCommand(403, 3)
end

function Creature:GetIsPC()
   if not self:GetIsValid() then return false end
   return not (ffi.C.nwn_GetPlayerByID(self.id) == nil)
end

--- Get PC's bic file name.
function Creature:GetBICFileName()
   if not self:GetIsValid() then return "" end
   if not self:GetIsPC() then return "" end
   local c = C.nwn_GetPCFileName(self.id)
   if c == nil then return "" end
   local s = ffi.string(c)
   C.free(c)
   return s
end

function Creature:GetIsAI()
   if not self:GetIsValid() then return false end
   return (not self:GetIsPC() and not self:GetIsPossessedFamiliar() and not self:GetIsDMPossessed())
      or self:GetMaster():GetIsValid()
end

function Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)
   if entire_party == nil then entire_party = true end

   ne.StackPushBoolean(all_pc)
   ne.StackPushBoolean(entire_party)
   ne.StackPushObject(self)
   ne.StackPushString(plot)

   ne.ExecuteCommand(368, 4)
end

function Creature:GetPCPublicCDKey(single_player)
   ne.StackPushBoolean(single_player)
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(369, 2)

   return ne.StackPopString()
end

function Creature:GetPCIPAddress()
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(370, 1)

   return ne.StackPopString()
end

function Creature:GetPCPlayerName()
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(371, 1)

   return ne.StackPopString()
end

function Creature:NightToDay(transition_time)
   transition_time = transition_time or 0
   ne.StackPushFloat(transition_time)
   ne.StackPushObject(self)
   ne.ExecuteCommand(751, 2)
end

function Creature:PopUpDeathGUIPanel(respawn_enabled, wait_enabled, help_strref, help_str)
   if respawn_enabled == nil then respawn_enabled = true end
   if wait_enabled == nil then wait_enabled = true end
   help_strref = help_strref or 0
   help_str = help_str or ""

   ne.StackPushString(help_str)
   ne.StackPushInteger(help_strref)
   ne.StackPushBoolean(wait_enabled)
   ne.StackPushBoolean(respawn_enabled)
   ne.StackPushObject(self)
   ne.ExecuteCommand(554, 5)
end

function Creature:PopUpGUIPanel(gui_panel)
   ne.StackPushInteger(gui_panel)
   ne.StackPushObject(self)
   ne.ExecuteCommand(388, 2)
end

function Creature:SendMessage(message, ...)
   if select("#", ...) > 0 then
      message = string.format(message, ...)
   end
   ne.StackPushString(message)
   ne.StackPushObject(self)
   ne.ExecuteCommand(374, 2)
end

function Creature:SendMessageByStrRef(strref)
   ne.StackPushInteger(strref)
   ne.StackPushObject(self)
   ne.ExecuteCommand(717, 2)
end

function Creature:SetPCLike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(372, 2)
end

function Creature:SetPCDislike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(373, 2)
end

function Creature:SetPanelButtonFlash(button, enable_flash)
   ne.StackPushInteger(enable_flash);
   ne.StackPushInteger(button);
   ne.StackPushObject(self);
   ne.ExecuteCommand(521, 3);
end

function Creature:SendChatMessage(channel, from, message)
   if not from:GetIsValid() then return end
   if string.find(message, "\xAC") then return end
   if channel == 4 and not self:GetIsValid() then return end

   from:SetLocalString("NWNX!CHAT!SPEAK",
                       fmt("%x\xAC%x\xAC%d\xAC%s", from.id, self.id, channel, message))
end

function Creature:SendServerMessage(message, ...)
   if not self:GetIsValid() then return end
   self:SendChatMessage(5, self, string.format(message, ...))
end

function Creature:ErrorMessage(message, ...)
   if select("#", ...) > 0 then
      self:SendServerMessage(Color.RED .. string.format(message, ...) .. "</c>")
   else
      self:SendServerMessage(Color.RED .. message .. "</c>")
   end
end

function Creature:SuccessMessage(message, ...)
   if select("#", ...) > 0 then
      self:SendServerMessage(Color.GREEN .. string.format(message, ...) .. "</c>")
   else
      self:SendServerMessage(Color.GREEN .. message .. "</c>")
   end
end
