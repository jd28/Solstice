------
-- Please note this is very advanced module.  Using it incorrectly will result in segfaults.
-- This is a very thin wrapper around the Acaos' NWNX `nx_hook_function` any documentation
-- can probably (not) be found in the NWNX repository.
--
-- It allows you to hook nwserver functions and replace them with Lua functions directly.
-- Note that the lua function and the original function returned by `hook` must be castable
-- to the function pointer type passed in `HookDesc.type`, which means that the types
-- of the parameters must be defined.  Currently not all types are defined, see
-- src/solstice/nwn/ctypes for those that are.
--
-- @module hooks

local ffi = require 'ffi'
local bit = require 'bit'

ffi.cdef[[
void *nx_hook_function (void *addr, void *func, size_t len, uint32_t flags);
]]

--- HookDesc
-- All fields are required.
-- @table HookDesc
-- @field address Address of function to hook
-- @field type Function pointer type.
-- @field func Function to be called by hook.
-- @field length Length of the hook.
-- @field flags See HOOK_DIRECT and HOOK_RETCODE

--- Constants
-- @section constants

--- See NWNX docs.
local HOOK_DIRECT = 0x1

--- See NWNX docs.
local HOOK_RETCODE = 0x2

--- Functions
-- @section functions

--- Hooks a function.
-- @param info HookDesc table
-- @see HookDesc
local function hook(info)
   jit.off(info.func)
   local res = ffi.C.nx_hook_function(ffi.cast('void*', info.address),
                                      ffi.cast(info.type, info.func),
                                      info.length,
                                      info.flags)
   return ffi.cast(info.type, res)
end

local M = {
   HOOK_DIRECT = HOOK_DIRECT,
   HOOK_RETCODE = HOOK_RETCODE,
   hook = hook
}

return M
