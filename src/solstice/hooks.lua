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

--- Constants
-- @section constants

--- See NWNX docs.
local HOOK_DIRECT = 0x1

--- See NWNX docs.
local HOOK_RETCODE = 0x2

--- Functions
-- @section functions

local HOOKS = {

}

local function helper(name)
  return function(...)
    if HOOKS[name].func then
      local ok, ret = pcall(HOOKS[name].func, ...)
      if not ok then
        local Log = System.GetLogger()
        Log:error("Error calling hook '%s': %s", name, ret)
      else
        return ret
      end
    end
    -- If we get here something bad happened, return the original function.
    return HOOKS[name].orig(...)
  end
end

--- Hooks a function.
-- @param info HookDesc table
-- @see HookDesc
local function hook(info)
  if not info.name and type(info.name) ~= 'string' then
    error("A hook name must be specified!", 2)
  end

  if HOOKS[info.name] then
    local Log = System.GetLogger()
    jit.off(info.func)
    HOOKS[info.name].func = info.func
    Log:notice("Overriding hook '%s'", info.name)
  else
    local func = helper(info.name)
    local res = ffi.C.nx_hook_function(ffi.cast('void*', info.address),
                                       ffi.cast(info.type, func),
                                       info.length,
                                       bit.bor(HOOK_DIRECT, HOOK_RETCODE))
    HOOKS[info.name] = {
      orig = ffi.cast(info.type, res),
      func = info.func
    }
  end
  return HOOKS[info.name].orig
end

local M = {
   hook = hook
}

return M
