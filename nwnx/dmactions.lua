NWNXDMActions = {}

NWNXDMActions.DM_ACTION_MESSAGE_TYPE           =  1
NWNXDMActions.DM_ACTION_GIVE_XP                =  2
NWNXDMActions.DM_ACTION_GIVE_LEVEL             =  3
NWNXDMActions.DM_ACTION_GIVE_GOLD              =  4
NWNXDMActions.DM_ACTION_CREATE_ITEM_ON_OBJECT  =  5
NWNXDMActions.DM_ACTION_CREATE_ITEM_ON_AREA    =  6
NWNXDMActions.DM_ACTION_HEAL_CREATURE          =  7
NWNXDMActions.DM_ACTION_REST_CREATURE          =  8
NWNXDMActions.DM_ACTION_RUNSCRIPT              =  9
NWNXDMActions.DM_ACTION_CREATE_PLACEABLE       = 10
NWNXDMActions.DM_ACTION_SPAWN_CREATURE         = 11
NWNXDMActions.DM_ACTION_TOGGLE_INVULNERABILITY = 12
NWNXDMActions.DM_ACTION_TOGGLE_IMMORTALITY     = 13

local mod

local function get_int(dm, str, spacer)
   dm:SetLocalString(str, spacer)
   local ret = dm:GetLocalString(str)
   dm:DeleteLocalString(str)
   return tonumber(ret)
end

function NWNXDMActions.SetScript(nAction, sScript)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT", nAction .. ":" .. sScript)
   mod:DeleteLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT")
end

function NWNXDMActions.GetID(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETACTIONID", "                ")
end

function NWNXDMActions.Prevent(dm)
   dm:SetLocalString("NWNX!DMACTIONS!PREVENT", "1")
   dm:DeleteLocalString("NWNX!DMACTIONS!PREVENT")
end

function NWNXDMActions.nGetDMAction_Param(dm, second)
   local nth = second and "2" or "1"
   return get_int(dm, "NWNX!DMACTIONS!GETPARAM_" .. nth, "                ")
end

function NWNXDMActions.GetDMAction_Param(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETSTRPARAM1", "                                ")
end

function NWNXDMActions.GetTarget(dm, second)
   local nth = second and "2" or "1"
   return dm:GetLocalObject("NWNX!DMACTIONS!TARGET_" .. nth)
end

function NWNXDMActions.GetPosition(dm)
   dm:SetLocalString("NWNX!DMACTIONS!GETPOS", "                                              ")
   local vector = dm:GetLocalString("NWNX!DMACTIONS!GETPOS")
   dm:DeleteLocalString("NWNX!DMACTIONS!GETPOS")
   local x, y, z = string.match(vector, "(%d)¬(%d)¬(%d)")

   return vector_t(x, y, z)
end

function NWNXDMActions.GetTargetsCount(dm) 
   return get_int(dm, "NWNX!DMACTIONS!GETTARGETSCOUNT", "                ") 
end

function NWNXDMActions.GetTargetsCurrent(dm)
   return get_int(dm, "NWNX!DMACTIONS!GETTARGETSCURRENT", "                ") 
end

-- NWNX functions cannot be JITed.
for name, func in pairs(NWNXDMActions) do
   if type(func) == "function" then
      jit.off(func)
   end
end