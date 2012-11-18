-- NWNX Areas
-- Area instancing plugin
-- (c) by virusman, 2006-2010

local mod
NWNXAreas = {}

function NWNXAreas.CreateArea(sResRef)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!AREAS!CREATE_AREA", sResRef)
   return mod:GetLocalObject("NWNX!AREAS!GET_LAST_AREA_ID")
end

function NWNXAreas.DestroyArea(oArea)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!AREAS!DESTROY_AREA", oArea:ToString())
end

function NWNXAreas.SetAreaName(oArea, sName)
   oArea:SetLocalString("NWNX!AREAS!SET_AREA_NAME", sName)
end

-- NWNX functions cannot be JITed.
for name, func in pairs(NWNXAreas) do
   if type(func) == "function" then
      jit.off(func)
   end
end