--[[------------------------------------------------------------------------
    Copyright (C) 2011 jmd ( jmd2028 at gmail dot com )

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
----------------------------------------------------------------------------]]

local mod

function nwnx.DumpSpells(oCreature)
   oCreature:SetLocalString("NWNX!LEVELS!DUMPSPELLS", "none")
end

function nwnx.GetMaxLevelLimit()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT", "none")
   return tonumber(mod:GetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT"))
end

function nwnx.SetMaxLevelLimit (nLevel)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT", tostring(nLevel))
   return tonumber(mod:GetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT"))
end

function nwnx.LevelDown(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELDOWN", "1");
    return tonumber(oPC:GetLocalString("NWNX!LEVELS!LEVELDOWN"))
end

function nwnx.LevelUp(oPC)
    oPC:SetLocalString("NWNX!LEVELS!LEVELUP", "  ")
    return tonumber(GetLocalString(oPC, "NWNX!LEVELS!LEVELUP"))
end
