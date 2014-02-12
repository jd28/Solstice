--- Chat
-- @module chat

local ffi = require 'ffi'
local C = ffi.C
local M = {}

--- Sends a chat message
-- @param channel Channel the message to send message on.
-- @param from Sender.
-- @param message Text to send.
-- @param to Receiver.
function M.SendChatMessage(channel, from, message, to)
   C.nwn_SendMessage(channel, from.id, message, to.id)
end

--- Simple wrapper around solstice.chat.SendChatMessage
-- that sends a server message to a player.
-- @param message Text to send.
-- @param recipient Receiver.
function M.SendServerMessage(message, recipient)
   if not recipient:GetIsValid() then return end
   M.SendChatMessage(5, recipient, message, recipient)
end

return M
