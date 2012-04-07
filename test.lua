
function pl_test_lua(oPC)
    local pc = nwn.GetFirstPC()
    for i = 0, 5 do
       pc:SendMessage (pc:GetAbilityScore(i))
    end
end

function pl_check_lua(oSelf)
    return 1
end
