local ffi = require 'ffi'
local C = ffi.C

local CHAT_HANDLER

NWNXChat = {}

---
function NWNXChat.SetChatHandler(func)
   CHAT_HANDLER = func
end

function NWNXChat_HandleChatMessage()
   if not CHAT_HANDLER then return false end

   local msg = C.Local_GetLastChatMessage()
   msg.suppress = CHAT_HANDLER(msg.channel, _NL_GET_CACHED_OBJECT(msg.from),
			       ffi.string(msg.msg), _NL_GET_CACHED_OBJECT(msg.to))
   return true
end

function NWNXChat_HandleCombatMessage()
   local msg = C.Local_GetLastCombatMessage()
   if msg.type == 151 then
      return true
   end
   
   return false
end
