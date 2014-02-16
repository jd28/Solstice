--- NWNX Areas
-- Area instancing plugin
-- (c) by virusman, 2006-2010
-- @module nwnx.areas
-- @alias M

local mod
local M = {}

function M.CreateArea(sResRef)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!AREAS!CREATE_AREA", sResRef)
   return mod:GetLocalObject("NWNX!AREAS!GET_LAST_AREA_ID")
end

function M.DestroyArea(oArea)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!AREAS!DESTROY_AREA", oArea:ToString())
end

function M.SetAreaName(oArea, sName)
   oArea:SetLocalString("NWNX!AREAS!SET_AREA_NAME", sName)
end

-- NWNX functions cannot be JITed.
for name, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M
