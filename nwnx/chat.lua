local chat_handler = function () return false end

function _NL_CHAT_HANDLER(channel, from, msg, to)
   return chat_handler(channel, _NL_GET_CACHED_OBJECT(from),
                       msg, _NL_GET_CACHED_OBJECT(to))
end

---
function nwnx.SetChatHandler(func)
   chat_handler = func
end