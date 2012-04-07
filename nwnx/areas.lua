-- NWNX Areas
-- Area instancing plugin
-- (c) by virusman, 2006-2010

local mod

function nwnx.CreateArea(sResRef)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!AREAS!CREATE_AREA", sResRef)
   return mod:GetLocalObject("NWNX!AREAS!GET_LAST_AREA_ID")
end

function nwnx.DestroyArea(oArea)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!AREAS!DESTROY_AREA", oArea:ToString())
end

function nwnx.SetAreaName(oArea, sName)
   oArea:SetLocalString("NWNX!AREAS!SET_AREA_NAME", sName)
end
