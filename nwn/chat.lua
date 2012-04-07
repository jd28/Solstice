--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local chat_handler = function () return false end
local ignore_table = {}
local bit = require 'bit'

local ffi = require 'ffi'
local C = ffi.C

function _NL_CHAT_HANDLER(channel, from, msg, to)
   return chat_handler(channel, _NL_GET_CACHED_OBJECT(from),
                       msg, _NL_GET_CACHED_OBJECT(to))
end


function _NL_CHAT_IS_IGNORING(to, from, level)
      from = _NL_CHAT_GET_CACHED_OBJECT(from)
      to   = _NL_CHAT_GET_CACHED_OBJECT(to)
      local name = from:GetPCPlayerName()
      if bit.band(to:GetLocalInt("FKY_CHT_IGNORE"..name), level) then
         return true
      end

      return false
end

local chat = {}

---
function chat.SetHandler(func)
   chat_handler = func
end

--- 
function chat.SetIgnoring(pc, target, level)
   if not ignore_table[pc] then
      ignore_table[pc] = {}
   end

   ignore_table[pc][target] = level
end

--- Sends a chat message
-- @param channel Channel the message to send message on.
-- @param from Sender.
-- @param message Text to send.
-- @param to Receiver.
function chat.SendChatMessage(channel, from, message, to)
   C.nwn_SendMessage(channel, from, message, to)
end

---
function chat.VerifyNumber(dm, number)
   local n = tonumber(number)
   if not n then
      dm:ErrorMessage "This command must be followed by a positive number!"
   end

   return n
end

---
function chat.VerifyTarget(chat_info, type, pc_only)
   type = type or OBJECT_TYPE_CREATURE
   local dm = chat_info.speaker
   local pc = chat_info.target

   pc = pc or dm:GetLocalObject "FKY_CHAT_TARGET"
   if not pc then
      -- Check location 
      local loc = dm:GetLocalLocation "FKY_CHAT_LOCATION"
      if type == OBJECT_TYPE_AREA and loc then
         pc = loc:GetArea()
      else
         -- Requires target
         dm:ErrorMessage "This command requires a PC target!"
         dm:SetLocalInt("FKY_CHAT_TARGET_TYPE", type)
         dm:SetLocalString("FKY_CHAT_COMMAND", chat_info.original)
         
         -- Give targeter
         dm:GiveItem("fky_chat_target", 1, "", true)
      end
   else
      if pc_only and not pc:GetIsPC() then
         dm:ErrorMessage "This command requires a PC target!"
      elseif type == OBJECT_TYPE_AREA then
         pc = pc:GetArea()
      elseif not bit.band(type, pc:GetObjectType()) then
         dm:ErrorMessage "Invalid Target"
      end
      dm:DeleteLocalObject "FKY_CHAT_TARGET"
   end

   return pc
end

return chat
