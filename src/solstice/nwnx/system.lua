--- NWNX System
-- Some aspects of this plugin are unsupported.
-- @module nwnx.system

--/* interface functions for nwnx_system plugin */


--[[
struct CPUUsage {
    float user, sys;
};


/* Get the CPU usage values for the current process. */
struct CPUUsage GetProcessCPUUsage ();

/* Get an estimate of memory used by the current process in bytes. */
int GetProcessMemoryUsage ();

/* Get the current process TMI limit. The nwserver default is 131071. */
int GetTMILimit ();

/* Set the current process TMI limit, with a minimum of 16k and a maximum of 8M. */
void SetTMILimit (int nLimit);

/* Shut down the current process. If nForce is specified, the process will be
 * force-killed in that number of seconds, in case it hangs during shutdown. */
void ShutdownServer (int nForce=0);

struct CPUUsage GetProcessCPUUsage () {
    struct CPUUsage ret;

    SetLocalString(GetModule(), "NWNX!SYSTEM!GETPROCESSCPUUSAGE", "                                ");
    string sUsage = GetLocalString(GetModule(), "NWNX!SYSTEM!GETPROCESSCPUUSAGE");

    ret.user = StringToFloat(sUsage);
    ret.sys  = StringToFloat(GetSubString(sUsage, FindSubString(sUsage, " ") + 1, 100));

    return ret;
}

int GetProcessMemoryUsage () {
    SetLocalString(GetModule(), "NWNX!SYSTEM!GETPROCESSMEMORYUSAGE", "            ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!SYSTEM!GETPROCESSMEMORYUSAGE"));
}

--]]

local mod

local M = {}

--- TODO
function M.GetTMILimit ()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!SYSTEM!GETTMILIMIT", "          ")
   return tonumber(mod:GetLocalString("NWNX!SYSTEM!GETTMILIMIT"))
end

--- TODO
function M.SetTMILimit (nLimit)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!SYSTEM!SETTMILIMIT", tostring(nLimit))
end

--- TODO
function M.ShutdownServer (nForce)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!SYSTEM!SHUTDOWNSERVER", tostring(nForce))
end

-- NWNX functions cannot be JITed.
for _, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M
