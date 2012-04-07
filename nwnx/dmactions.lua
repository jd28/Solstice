 nwnx.DM_ACTION_MESSAGE_TYPE           =  1
 nwnx.DM_ACTION_GIVE_XP                =  2
 nwnx.DM_ACTION_GIVE_LEVEL             =  3
 nwnx.DM_ACTION_GIVE_GOLD              =  4
 nwnx.DM_ACTION_CREATE_ITEM_ON_OBJECT  =  5
 nwnx.DM_ACTION_CREATE_ITEM_ON_AREA    =  6
 nwnx.DM_ACTION_HEAL_CREATURE          =  7
 nwnx.DM_ACTION_REST_CREATURE          =  8
 nwnx.DM_ACTION_RUNSCRIPT              =  9
 nwnx.DM_ACTION_CREATE_PLACEABLE       = 10
 nwnx.DM_ACTION_SPAWN_CREATURE         = 11
 nwnx.DM_ACTION_TOGGLE_INVULNERABILITY = 12
 nwnx.DM_ACTION_TOGGLE_IMMORTALITY     = 13

--[[
// Set script name called on specified action
void SetDMActionScript(int nAction, string sScript);

// Get ID of DM Action
int nGetDMActionID();

// Get int param of DM Action
int nGetDMAction_Param(int bSecond=FALSE);

// Get string param of DM Action
string sGetDMAction_Param();

// Get target object of DM Action
object oGetDMAction_Target(int bSecond=FALSE);

// Get target position of DM Action
vector vGetDMAction_Position();

// Get total targets number in multiselection
int nGetDMAction_TargetsCount();

// Get current target number in multiselection.
int nGetDMAction_TargetsCurrent();
--]]

local mod

function nwnx.SetDMActionScript(nAction, sScript)
   if not mod then mod = nwn.GetModule() end
   mod:SetLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT", nAction .. ":" .. sScript)
   mod:DeleteLocalString("NWNX!DMACTIONS!SET_ACTION_SCRIPT")
end

function nwnx.GetDMActionID(dm)
    dm:SetLocalString("NWNX!DMACTIONS!GETACTIONID", "                ")
    local action = dm:GetLocalString("NWNX!DMACTIONS!GETACTIONID")
    dm:DeleteLocalString("NWNX!DMACTIONS!GETACTIONID")
    return tonumber(action)
end

function nwnx.PreventDMAction(dm)
    dm:SetLocalString("NWNX!DMACTIONS!PREVENT", "1")
    dm:DeleteLocalString("NWNX!DMACTIONS!PREVENT")
end

function nGetDMAction_Param(dm, second)
    local nth = second and "2" or "1"
    dm:SetLocalString("NWNX!DMACTIONS!GETPARAM_" .. nth, "                ")
    local val = dm:GetLocalString("NWNX!DMACTIONS!GETPARAM_" .. nth)
    dm:DeleteLocalString("NWNX!DMACTIONS!GETPARAM_" .. nth)
    return tonumber(val);
end

function nwnx.GetDMAction_Param(dm)
    dm:SetLocalString("NWNX!DMACTIONS!GETSTRPARAM1", "                                ")
    local sVal = dm:GetLocalString("NWNX!DMACTIONS!GETSTRPARAM1")
    dm:DeleteLocalString("NWNX!DMACTIONS!GETSTRPARAM1")
    return sVal
end

function nwnx.GetDMAction_Target(dm, second)
    local nth = second and "2" or "1"
    return dm:GetLocalObject("NWNX!DMACTIONS!TARGET_" .. nth)
end

function nwnx.GetDMAction_Position(dm)
    dm:SetLocalString("NWNX!DMACTIONS!GETPOS", "                                              ")
    local vector = dm:GetLocalString("NWNX!DMACTIONS!GETPOS")
    dm:DeleteLocalString("NWNX!DMACTIONS!GETPOS")
    local x, y, z = string.match(vector, "(%d)¬(%d)¬(%d)")

    return vector_t(x, y, z)
end

function nwnx.GetDMAction_TargetsCount(dm) 
    dm:SetLocalString("NWNX!DMACTIONS!GETTARGETSCOUNT", "                ")
    local sVal = dm:GetLocalString("NWNX!DMACTIONS!GETTARGETSCOUNT")
    dm:DeleteLocalString("NWNX!DMACTIONS!GETTARGETSCOUNT")
    return tonumber(sVal)
end

function nwnx.GetDMAction_TargetsCurrent(dm)
    dm:SetLocalString("NWNX!DMACTIONS!GETTARGETSCURRENT", "                ")
    local sVal = dm:GetLocalString("NWNX!DMACTIONS!GETTARGETSCURRENT")
    dm:DeleteLocalString("NWNX!DMACTIONS!GETTARGETSCURRENT")
    return tonumber(sVal)
end
