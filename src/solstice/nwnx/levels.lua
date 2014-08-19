--- NWNX Levels
-- @module nwnx.level

local mod
local M = {}

function M.DumpSpells(oCreature)
   oCreature:SetLocalString("NWNX!LEVELS!DUMPSPELLS", "none")
end

function M.GetMaxLevelLimit()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT", "none")
   return tonumber(mod:GetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT"))
end

function M.SetMaxLevelLimit (nLevel)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT", tostring(nLevel))
   return tonumber(mod:GetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT"))
end

function M.LevelDown(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELDOWN", "1");
    return tonumber(oPC:GetLocalString("NWNX!LEVELS!LEVELDOWN"))
end

function M.LevelUp(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELUP", "  ")
    return tonumber(oPC:GetLocalString(oPC, "NWNX!LEVELS!LEVELUP"))
end

-- NWNX functions cannot be JITed.
for _, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M
