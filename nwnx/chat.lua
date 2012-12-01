local ffi = require 'ffi'
local C = ffi.C

local CHAT_HANDLER
local CC_HANDLER

NWNXChat = {}

---
function NWNXChat.SetChatHandler(func)
   CHAT_HANDLER = func
end

function NWNXChat.SetCombatMessageHandler(func)
   CC_HANDLER = func
end


function NWNXChat_HandleChatMessage()
   if not CHAT_HANDLER then return false end

   local msg = C.Local_GetLastChatMessage()
   if msg == nil then 
      error "NWNXChat_HandleChatMessage : NULL msg!"
   end


   msg.suppress = CHAT_HANDLER(msg.channel, _NL_GET_CACHED_OBJECT(msg.from),
			       ffi.string(msg.msg), _NL_GET_CACHED_OBJECT(msg.to))
   return msg.suppress
end

function NWNXChat_HandleCombatMessage()
   if not CHAT_HANDLER then return false end

   local msg = C.Local_GetLastCombatMessage()
   if msg == nil then 
      error "NWNXChat_HandleCombatMessage : NULL msg!"
   end

   msg.suppress = CC_HANDLER(msg)
   
   return msg.suppress
end
