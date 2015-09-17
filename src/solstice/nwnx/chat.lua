--- NWNX Chat
-- @module nwnx.chat

local ffi = require 'ffi'
local C = ffi.C

local CHAT_HANDLER
local CC_HANDLER

local M = {}

local EVENT_CHAT_MESSAGE = "Chat/Message";
local EVENT_CHAT_CCMESSAGE = "Chat/CCMessage";

ffi.cdef[[
/**
 * Event: Chat/Message
 * Provider: nwnx_chat
 *
 * Called whenever a qualifying chat message is sent, dependent on nwnx_chat settings.
 */
typedef struct {
    /* Chat message being sent. */
    const char* msg;
    /* Object receiving the message. */
    unsigned int to;
    /* Object sending the message. */
    unsigned int from;
    /* Channel the message was sent on. */
    unsigned char channel;
    /* Set to true to suppress the chat message. */
    bool suppress;
}
ChatMessageEvent;

/**
 * Event: Chat/CCMessage
 * Provider: nwnx_chat
 *
 * Called whenever a CNWCCMessage is sent.
 */
typedef struct {
    /* CNWCCMessageData type. */
    int type;
    /* CNWCCMessageData subtype. */
    int subtype;
    /* Object being sent the message. */
    unsigned int to;
    /* CNWCCMessageData instance. */
    void *msg_data;
    /* Set to true to suppress the CNWCCMessageData message. */
    bool suppress;
}
ChatCCMessageEvent;
]]

--- TODO
function M.SetChatHandler(func)
   CHAT_HANDLER = func
end

--- TODO
function M.SetCombatMessageHandler(func)
   CC_HANDLER = func
end

function __HandleChatMessage(event)
   if not CHAT_HANDLER then return 0 end

   local msg = ffi.cast("ChatMessageEvent*", event)
   if msg == nil then
      return 0
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

   return msg.suppress and 1 or 0
end

function __HandleCombatMessage(event)
   if not CC_HANDLER then return 0 end

   local msg = ffi.cast("ChatCCMessageEvent*", event)
   if msg == nil then
      return 0
   end

   msg.suppress = CC_HANDLER(msg)

   return msg.suppress and 1 or 0
end

local Log = System.GetLogger()
local NWNXCore = require 'solstice.nwnx.core'
if not NWNXCore.HookEvent(EVENT_CHAT_MESSAGE, __HandleChatMessage) then
  Log:error("Unable to hook EVENT_CHAT_MESSAGE!")
end
if not NWNXCore.HookEvent(EVENT_CHAT_CCMESSAGE, __HandleCombatMessage) then
  Log:error("Unable to hook EVENT_CHAT_CCMESSAGE!")
end

return M
