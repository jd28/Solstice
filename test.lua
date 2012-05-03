local chat = require 'nwn.chat'

function pl_test_lua(oPC)
   local pc = nwn.GetFirstPC()
   chat.SendChatMessage(5, pc, "Hello", pc)
end

function pl_check_lua(oSelf)
    return 1
end
