--- NWNX Chat
-- @module nwnx.chat

local ffi = require 'ffi'
local C = ffi.C

local CHAT_HANDLER
local CC_HANDLER

local M = {}

--- TODO
function M.SetChatHandler(func)
   CHAT_HANDLER = func
end

--- TODO
function M.SetCombatMessageHandler(func)
   CC_HANDLER = func
end

function __HandleChatMessage()
   if not CHAT_HANDLER then return false end

   local msg = C.Local_GetLastChatMessage()
   if msg == nil then
      error "__HandleChatMessage : NULL msg!"
   end

   local to = OBJECT_INVALID
   if msg.to ~= 0xffffffff then
      local pl = C.nwn_GetPlayerByPlayerID(msg.to)
      if pl ~= nil then
         to = Game.GetObjectByID(pl.obj_id)
      end
   end

   msg.suppress = CHAT_HANDLER(msg.channel,
			       Game.GetObjectByID(msg.from),
			       ffi.string(msg.msg),
			       to)
   return msg.suppress
end

function __HandleCombatMessage()
   if not CC_HANDLER then return false end

   local msg = C.Local_GetLastCombatMessage()
   if msg == nil then
      error "__HandleCombatMessage : NULL msg!"
   end

   msg.suppress = CC_HANDLER(msg)

   return msg.suppress
end

return M
