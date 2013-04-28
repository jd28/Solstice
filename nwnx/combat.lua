NWNXCombat = {}

function NWNXCombat.InitializeTables()
   local mod = nwn.GetModule()
   mod:SetLocalString("NWNX!COMBAT!INIT_TABLES", " ")
end

function NWNXCombat.GetMaxHitPoints(obj)
   obj:SetLocalString("NWNX!COMBAT!GETMAXHITPOINTS", " ")
end

function NWNXCombat.Log(obj)
   obj:SetLocalString("NWNX!COMBAT!DUMBCOMBATMODS", " ")
end

function NWNXCombat.SendCombatInfo(obj)
   obj:SetLocalString("NWNX!COMBAT!GETCOMBATINFO", " ")
end

function NWNXCombat.Update(obj)
   obj:SetLocalString("NWNX!COMBAT!UPDATE", " ")
end
