--- NWNX Haks
-- @module nwnx.haks

local M = {}
local mod

--- Log HAK list
function M.DumpHakList()
   if not mod then mod = Mod.Get() end
   mod:SetLocalString("NWNX!HAKS!DUMPMESSAGE", "nothing")
end

--- Log Hidden HAKs
function M.DumpHiddenHakList()
   if not mod then mod = Mod.Get() end
   mod:SetLocalString("NWNX!HAKS!DUMPHIDDENHAKS", "nothing")
end

--- Set HAK hidden.
-- @param hak HAK file name (without .hak)
-- @param[opt=1] level Ehancement level that HAK is visible.
function M.SetHakHidden(hak, level)
   if not mod then mod = Mod.Get() end
   nLevel = level or 1
   
   if nLevel <= 0 then return -1 end
   
   mod:SetLocalString("NWNX!HAKS!SETHAKHIDDEN", hak .. "¬" .. level)
   return mod:tonumber(mod:GetLocalString("NWNX!HAKS!SETHAKHIDDEN"))
end

--- Set fallback TLK.
-- @param tlk TLK file name (without .tlk)
function M.SetFallBackTLK(tlk)
   if not mod then mod = Mod.Get() end
   mod:SetLocalString("NWNX!HAKS!SETFALLBACKTLK", tlk)
   return tonumber(mod:GetLocalString("NWNX!HAKS!SETFALLBACKTLK"))
end

-- NWNX functions cannot be JITed.
for name, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M