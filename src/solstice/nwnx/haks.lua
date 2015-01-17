--- NWNX Haks
-- nwnx_haks allows a server to control the visibility of HAKs and
-- custom TLK on player login.  You can do so at various levels.
--
-- The main impetus was to allow a new player to login to a safe loading area
-- without having to download a massive amount of haks before deciding
-- if they feel the server was right for them.
--
-- It's also useful if you've built a world with default/CEP/Q resources
-- and then chose later to add tilesets or your own top hak.
--
-- Example: Imagine you have a CEP world with many areas and you add
-- some of the great tilesets greated by the community.
--    SetFallBackTLK('cep_tlk_v26')
--    SetHakHidden('mytophak', 1)
--    SetHakHidden('mytileset', 2)
--    ...
--
-- When a new player enters, the server will only require CEP 2.6 to
-- login.  You can then flag players based on which HAKs the have via
-- some dialog and store in your DB.  They will have to relog/ActivatePortal
-- in order to have their client load the HAKs, from then on they can
-- enter as normal.
--
-- Note: If you hide tilesets, you need to control who can enter
-- areas that use those tilesets or it will cause the client to crash.
--
-- @module nwnx.haks

local M = {}
local mod

--- Log HAK list
function M.DumpHakList()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPMESSAGE", "nothing")
end

--- Log Hidden HAKs
function M.DumpHiddenHakList()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!HAKS!DUMPHIDDENHAKS", "nothing")
end

--- Set HAK hidden.
-- @param hak HAK file name (without .hak)
-- @param[opt=1] level Ehancement level that HAK is visible.
function M.SetHakHidden(hak, level)
   if not mod then mod = Game.GetModule() end
   level = level or 1

   if nLevel <= 0 then return -1 end

   mod:SetLocalString("NWNX!HAKS!SETHAKHIDDEN", hak .. "|" .. level)
   return mod:tonumber(mod:GetLocalString("NWNX!HAKS!SETHAKHIDDEN"))
end

--- Set fallback TLK.
-- Note that if any of the hidden HAKs are flagged as visible to a player
-- they will require your custom TLK, if any.
-- @param tlk TLK file name (without .tlk)
function M.SetFallBackTLK(tlk)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!HAKS!SETFALLBACKTLK", tlk)
   return tonumber(mod:GetLocalString("NWNX!HAKS!SETFALLBACKTLK"))
end

--- Set the script to be called when a player enters.
-- @string script Your script.
function M.SetEnhanceScript(script)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!HAKS!SETENHANCESCRIPT", script)
end

--- Set player 'enhanced' level.
-- This function must be called from the script set by the
-- SetEnhanceScript function.
-- @param pc Player
-- @param enhanced This determines which HAKs are visible, all those
-- less than or equal to the level specified in SetHakHidden.
function M.SetPlayerEnhanced(pc, enhanced)
    pc:SetLocalString("NWNX!HAKS!SETPLAYERENHANCED", tostring(enhanced))
end

-- NWNX functions cannot be JITed.
for _, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M
