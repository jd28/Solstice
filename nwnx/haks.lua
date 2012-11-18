local mod

NWNXHaks = {}

function NWNXHaks.DumpHakList()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPMESSAGE", "nothing")
end

function NWNXHaks.DumpHiddenHakList()
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPHIDDENHAKS", "nothing")
end

function NWNXHaks.SetHakHidden(sHak, nLevel)
   if not mod then mod = nwn.GetModule() end
   nLevel = nLevel or 1
   
   if nLevel <= 0 then return -1 end
   
   mod:SetLocalString("NWNX!HAKS!SETHAKHIDDEN", sHak .. "¬" .. nLevel)
   return mod:tonumber(mod:GetLocalString("NWNX!HAKS!SETHAKHIDDEN"))
end

function NWNXHaks.SetFallBackTLK(sTLK)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!HAKS!SETFALLBACKTLK", sTLK)
   return tonumber(mod:GetLocalString("NWNX!HAKS!SETFALLBACKTLK"))
end

-- NWNX functions cannot be JITed.
for name, func in pairs(NWNXHaks) do
   if type(func) == "function" then
      jit.off(func)
   end
end