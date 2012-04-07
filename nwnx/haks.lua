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

function nwnx.DumpHakList()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPMESSAGE", "nothing")
end

function nwnx.DumpHiddenHakList()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPHIDDENHAKS", "nothing")
end

function nwnx.SetHakHidden(sHak, nLevel)
   if not mod then mod = nwn.GetModule() end
   nLevel = nLevel or 1
   
   if nLevel <= 0 then return -1 end
   
   mod:SetLocalString("NWNX!HAKS!SETHAKHIDDEN", sHak .. "¬" .. nLevel)
   return mod:tonumber(mod:GetLocalString("NWNX!HAKS!SETHAKHIDDEN"))
end

function nwnx.SetFallBackTLK(sTLK)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!SETFALLBACKTLK", sTLK)
   return tonumber(mod:GetLocalString("NWNX!HAKS!SETFALLBACKTLK"))
end

