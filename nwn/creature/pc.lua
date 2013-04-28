local ne = nwn.engine
local ffi = require 'ffi'

--- Activates a portal between servers.
-- @param ip_addr DNS name or IP address (and optional port) of new server. (Default: "") 
-- @param password Password for login to the destination server. (Default: "") 
-- @param waypoint If set, arriving PCs will jump to this waypoint after appearing at
--    the start location. (Default: "") 
-- @param seemless If true, the transition will be made 'seamless', and the PC will not
--    get a dialogue box on transfer. (Default: false) 
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

--- Add an entry to a player's Journal. (Create the entry in the Journal Editor first).
-- @param plot The tag of the Journal category (case sensitive).
-- @param state The ID of the Journal entry.
-- @param entire_party If true, the entry is added to the journal of the entire party. (Default: true) 
-- @param all_pc If true, the entry will show up in the journal of all PCs in the
--     module. (Default: false) 
-- @param allow_override If true, override restriction that nState must be > current
--    Journal Entry. (Default: false) 
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

--- Abruptly kicks a player off a multi-player server.
function Creature:BootPC()
   ne.StackPushObject(self)
   ne.ExecuteCommand(565, 1)
end

--- Changes the current Day/Night cycle for this player to night
-- @param transition_time Time it takes to become night (Default: 0) 
function Creature:DayToNight(transition_time)
   ne.StackPushFloat(transition_time or 0)
   ne.StackPushObject(self)
   ne.ExecuteCommand(750, 2)
end

--- Reveals the entire map of an area to a player.
-- @param area
-- @param explored true (explored) or false (hidden). Whether the map should
--     be completely explored or hidden. If not set, defaults to true.
function Creature:ExploreArea(area, explored)
   if explored == nil then explored = true end 
   
   ne.StackPushBoolean(explored)
   ne.StackPushObject(self)
   ne.StackPushObject(area)
   ne.ExecuteCommand(403, 3)
end

---
function Creature:GetIsPC()
   if not self:GetIsValid() then return false end
   return not (ffi.C.nwn_GetPlayerByID(self.id) == nil)
end

--- Removes a journal quest entry from a PCs journal.
-- @param plot The tag for the quest as used in the toolset's Journal Editor.
-- @param entire_party If this is true, the entry will be removed from the journal
--    of everyone in the party. (Default: true) 
-- @param all_pc If this is true, the entry will be removed from the journal of
--    everyone in the world. (Default: false) 
function Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)
   if entire_party == nil then entire_party = true end 
   
   ne.StackPushBoolean(all_pc)
   ne.StackPushBoolean(entire_party)
   ne.StackPushObject(self)
   ne.StackPushString(plot)

   ne.ExecuteCommand(368, 4)
end

--- Retrieves the public version of the PC's CD key.
-- @param single_player If set to true, the player's public CD key
--     will be returned when the player is playing in single player mode.
--     Otherwise returns an empty string in single player mode. (Default: false)
function Creature:GetPCPublicCDKey(single_player)
   ne.StackPushBoolean(single_player)
   ne.StackPushObject(self)
   ne.ExecuteCommand(369, 2)

   return ne.StackPopString()
end

--- Retrieves the IP address of a PC.
function Creature:GetPCIPAddress()
   ne.StackPushObject(self)
   ne.ExecuteCommand(370, 1)

   return ne.StackPopString()
end

--- Retrieves the login name of the player of a PC.
function Creature:GetPCPlayerName()
   ne.StackPushObject(self)
   ne.ExecuteCommand(371, 1)

   return ne.StackPopString()
end

--- Changes the current Day/Night cycle for this player to daylight
-- @param transition_time Time it takes for the daylight to fade in (Default: 0) 
function Creature:NightToDay(transition_time)
   transition_time = transition_time or 0
   ne.StackPushFloat(transition_time)
   ne.StackPushObject(self)
   ne.ExecuteCommand(751, 2)
end

--- Displays a customizable death panel.
-- @param respawn_enabled If this is <em>true</em>, the "Respawn" button will be enabled (Default: <em>true</em>)
-- @param wait_enabled If this is <em>true</em>, the "Wait For Help" button will be enabled (Default: <em>true</em>)
-- @param help_strref String reference to display for help. (Default: 0)
-- @param help_str String to display for help which appears in the top of the panel. (Default: "")
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

--- Displays a GUI panel to a player.
-- @param gui_panel nwn.GUI_PANEL_*
function Creature:PopUpGUIPanel(gui_panel)
   ne.StackPushInteger(gui_panel)
   ne.StackPushObject(self)
   ne.ExecuteCommand(388, 2)
end

--- Sends a message to the PC.
-- @param message Message to be sent to the PC.
function Creature:SendMessage(message)
   ne.StackPushString(message)
   ne.StackPushObject(self)
   ne.ExecuteCommand(374, 2)
end

--- Sends a message to the PC by StrRef.
-- @param strref StrRef of the message to send
function Creature:SendMessageByStrRef(strref)
   ne.StackPushInteger(strref)
   ne.StackPushObject(self)
   ne.ExecuteCommand(717, 2)
end

--- Causes a creature to like a PC.
-- @param target Target to alter the feelings of.
function Creature:SetPCLike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(372, 2)
end

--- Sets that a player dislikes a creature (or object).
-- @param target The creature that dislikes the PC (and the PC dislike it).
function Creature:SetPCDislike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(373, 2)
end

--- Make a panel button in the player's client start or stop flashing.
-- button nwn.PANEL_BUTTON_*
-- enable_flash true to flash, false to stop flashing
function Creature:SetPanelButtonFlash(button, enable_flash)
   ne.StackPushInteger(enable_flash);
   ne.StackPushInteger(button);
   ne.StackPushObject(self);
   ne.ExecuteCommand(521, 3);
end
