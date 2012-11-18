local mod

NWNXLevels = {}

function NWNXLevels.DumpSpells(oCreature)
   oCreature:SetLocalString("NWNX!LEVELS!DUMPSPELLS", "none")
end

function NWNXLevels.GetMaxLevelLimit()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT", "none")
   return tonumber(mod:GetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT"))
end

function NWNXLevels.SetMaxLevelLimit (nLevel)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT", tostring(nLevel))
   return tonumber(mod:GetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT"))
end

function NWNXLevels.LevelDown(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELDOWN", "1");
    return tonumber(oPC:GetLocalString("NWNX!LEVELS!LEVELDOWN"))
end

function NWNXLevels.LevelUp(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELUP", "  ")
    return tonumber(GetLocalString(oPC, "NWNX!LEVELS!LEVELUP"))
end

-- NWNX functions cannot be JITed.
for name, func in pairs(NWNXLevels) do
   if type(func) == "function" then
      jit.off(func)
   end
end