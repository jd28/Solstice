--- NWN Engine
-- @module nwn

require 'solstice.nwn.funcs'

local ffi = require "ffi"
local C = ffi.C
local sm = string.strip_margin

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
]]

local jit = require 'jit'

local M = {
   NUM_STRUCTURES           = 5,
   STRUCTURE_EFFECT         = 0,
   STRUCTURE_EVENT          = 1,
   STRUCTURE_LOCATION       = 2,
   STRUCTURE_TALENT         = 3,
   STRUCTURE_ITEMPROPERTY   = 4,
}

local Vec
local Loc

--- Gets NWN stack command object
function M.GetCommandObject()
   return _SOL_GET_CACHED_OBJECT(C.nwn_GetCommandObjectId())
end

--- Sets NWN stack command object
function M.SetCommandObject(object)
   return C.nwn_SetCommandObjectId(object.id)
end

--- Executes and NWN Script command.
function M.ExecuteCommand(cmd, args)
   C.nwn_ExecuteCommand(cmd, args)
end

-- This must absolutely be set, if the call here is JITed
-- the plugin will crash constantly.
jit.off(M.ExecuteCommand)

--- Pops a boolean value from the NWNW stack.
function M.StackPopBoolean()
   return C.nwn_StackPopBoolean()
end

--- Pop Engine Structure from NWN Stack
-- Probably should do any casting on this side...
-- @param es_type The type of the Engine Structure being popped.
function M.StackPopEngineStructure(es_type)
   if not es_type then
      error(solstice.nwn.Log(solstice.nwn.LOGLEVEL_ERROR,
		    sm[[Nil value passed to StackPopEngineStructure
                        |%s]], debug.traceback()))
   end

   local es = C.nwn_StackPopEngineStructure(es_type)
   if es == nil then return end

   if es_type == M.STRUCTURE_EFFECT then
      return effect_t(es, false)
   elseif es_type == M.STRUCTURE_EVENT then
      es = es
   elseif es_type == M.STRUCTURE_LOCATION then
      if not Loc then Loc = require 'solstice.location' end
      es = ffi.cast("CScriptLocation*", es)
      local temp = Loc.location_t(es.position, es.orientation, es.area)
      ffi.C.free(es)
      return temp
   elseif es_type == M.STRUCTURE_TALENT then
      es = es
   elseif es_type == M.STRUCTURE_ITEMPROPERTY then
      return itemprop_t(es, false)
   end

   es = ffi.gc(es, ffi.C.free)
   return es
end

--- Pops a float off the NWN stack as a Lua number
function M.StackPopFloat()
   return C.nwn_StackPopFloat()
end

--- Pops a integer off the NWN stack as a Lua number
function M.StackPopInteger()
   return C.nwn_StackPopInteger()
end

--- Pop object from NWScript stack
function M.StackPopObject()
   return _SOL_GET_CACHED_OBJECT(C.nwn_StackPopObject())
end

--- Pops a string off the NWN stack as a Lua string
function M.StackPopString()
   local s = C.nwn_StackPopString()
   local tx = s == nil
   if tx then return "" end

   local t = ffi.string(s)
   C.free(s)
   return t
end

--- Pop vector from NWScript stack
function M.StackPopVector()
   if not Vec then Vec = require 'solstice.vector' end
   local v = C.nwn_StackPopVector()
   local temp = Vec.vector_t(v.x, v.y, v.z)
   C.free(v)
   return temp
end

--- Pushes boolean on the NWScript stack.
-- This is a wrapper for StackPushInteger to make converting between boolean and integer values
-- easier for Lua.
-- @param value Boolean value
function M.StackPushBoolean(value)
   if value and type(value) ~= "boolean" then
      error(debug.traceback())
   end
   C.nwn_StackPushInteger(value and 1 or 0)
end

--- Pushes float onto NWScript stack
-- @param value Float value
function M.StackPushFloat(value)
   if type(value) ~= "number" then
      error(debug.traceback())
   end
   C.nwn_StackPushFloat(value)
end

--- Pushes integer onto NWScript stack
-- @param value Integer value
function M.StackPushInteger(value)
   if type(value) ~= "number" then
      error(debug.traceback())
   end
   C.nwn_StackPushInteger(value)
end

--- Pushes engine structure onto NWScript stack
-- @param es_type
-- @param value Engine structure
function M.StackPushEngineStructure(es_type, value)
   if not es_type or not value then
      error(debug.traceback())
   end

   if es_type == M.STRUCTURE_EFFECT 
      or es_type == M.STRUCTURE_ITEMPROPERTY
   then
      C.nwn_StackPushEngineStructure(es_type, value.eff)
   else
      C.nwn_StackPushEngineStructure(es_type, value)
   end
end

--- Pushes object onto NWscript stack
-- @param object Object to push.
function M.StackPushObject(object)
   if not object then
      error(debug.traceback())
   end

   C.nwn_StackPushObject(object.id)
end

--- Pushes string onto NWScript stack
-- @param value String value
function M.StackPushString(value)
   if type(value) ~= "string" then
      error(debug.traceback())
   end
   C.nwn_StackPushString(value)
end

--- Pushes vector onto NWScript stack
-- @param value Vector value.
function M.StackPushVector(value)
   if not value then
      error(debug.traceback())
   end
   C.nwn_StackPushVector(value)
end

return M