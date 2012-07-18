function pl_test_lua(oPC)
   local pc = nwn.GetFirstPC()
   pc:SendMessage(pc:DebugAttackBonus())
end

function pl_check_lua(oSelf)
    return 1
end
