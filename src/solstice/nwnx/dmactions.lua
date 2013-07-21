--- NWNX DM Actions
-- @module nwnx.dmactions

local Mod = require 'solstice.module'

local M = {}

M.DM_ACTION_MESSAGE_TYPE           =  1
M.DM_ACTION_GIVE_XP                =  2
M.DM_ACTION_GIVE_LEVEL             =  3
M.DM_ACTION_GIVE_GOLD              =  4
M.DM_ACTION_CREATE_ITEM_ON_OBJECT  =  5
M.DM_ACTION_CREATE_ITEM_ON_AREA    =  6
M.DM_ACTION_HEAL_CREATURE          =  7
M.DM_ACTION_REST_CREATURE          =  8
M.DM_ACTION_RUNSCRIPT              =  9
M.DM_ACTION_CREATE_PLACEABLE       = 10
M.DM_ACTION_SPAWN_CREATURE         = 11
M.DM_ACTION_TOGGLE_INVULNERABILITY = 12
M.DM_ACTION_TOGGLE_IMMORTALITY     = 13

local function get_int(dm, str, spacer)
   dm:SetLocalString(str, spacer)
   local ret = dm:GetLocalString(str)
   dm:DeleteLocalString(str)
   return tonumber(ret)
end

function M.SetScript(nAction, sScript)
   local mod = Mod.Get()
   mod:SetLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT", nAction .. ":" .. sScript)
   mod:DeleteLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT")
end

function M.GetID(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETACTIONID", "                ")
end

function M.Prevent(dm)
   dm:SetLocalString("NWNX!DMACTIONS!PREVENT", "1")
   dm:DeleteLocalString("NWNX!DMACTIONS!PREVENT")
end

function M.nGetDMAction_Param(dm, second)
   local nth = second and "2" or "1"
   return get_int(dm, "NWNX!DMACTIONS!GETPARAM_" .. nth, "                ")
end

function M.GetDMAction_Param(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETSTRPARAM1", "                                ")
end

function M.GetTarget(dm, second)
   local nth = second and "2" or "1"
   return dm:GetLocalObject("NWNX!DMACTIONS!TARGET_" .. nth)
end

function M.GetPosition(dm)
   dm:SetLocalString("NWNX!DMACTIONS!GETPOS", "                                              ")
   local vector = dm:GetLocalString("NWNX!DMACTIONS!GETPOS")
   dm:DeleteLocalString("NWNX!DMACTIONS!GETPOS")
   local x, y, z = string.match(vector, "(%d)¬(%d)¬(%d)")

   return vector_t(x, y, z)
end

function M.GetTargetsCount(dm) 
   return get_int(dm, "NWNX!DMACTIONS!GETTARGETSCOUNT", "                ") 
end

function M.GetTargetsCurrent(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETTARGETSCURRENT", "                ") 
end

-- NWNX functions cannot be JITed.
for name, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M