local bit = require 'bit'
local ffi = require 'ffi'
local C = ffi.C

--- Sends a chat message
-- @param channel Channel the message to send message on.
-- @param from Sender.
-- @param message Text to send.
-- @param to Receiver.
function nwn.SendChatMessage(channel, from, message, to)
   C.nwn_SendMessage(channel, from.id, message, to.id)
end

--- Simple wrapper around nwn.SendChatMessage
-- @param message Text to send.
-- @param recipient Receiver.
function nwn.SendServerMessage(message, recipient)
   if not recipient:GetIsValid() then return end

   nwn.SendChatMessage(5, recipient, message, recipient)
end
