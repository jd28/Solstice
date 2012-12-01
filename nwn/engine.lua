safe_require 'nwn.funcs'
safe_require 'nwn.effects'
safe_require 'nwn.logger'

local ffi = require "ffi"
local C = ffi.C
local sm = string.strip_margin

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
]]

local jit = require 'jit'

--- Gets NWN stack command object
function nwn.engine.GetCommandObject()
   return _NL_GET_CACHED_OBJECT(C.nwn_GetCommandObjectId())
end

--- Sets NWN stack command object
function nwn.engine.SetCommandObject(object)
   return C.nwn_SetCommandObjectId(object.id)
end

--- Executes and NWN Script command.
function nwn.engine.ExecuteCommand(cmd, args)
   C.nwn_ExecuteCommand(cmd, args)
end

-- This must absolutely be set, if the call here is JITed
-- the plugin will crash constantly.
jit.off(nwn.engine.ExecuteCommand)

--- Pops a boolean value from the NWNW stack.
function nwn.engine.StackPopBoolean()
   return C.nwn_StackPopBoolean()
end

--- Pop Engine Structure from NWN Stack
-- Probably should do any casting on this side...
-- @param es_type The type of the Engine Structure being popped.
function nwn.engine.StackPopEngineStructure(es_type)
   if not es_type then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Nil value passed to StackPopEngineStructure
                        |%s]], debug.traceback()))
   end

   local es = C.nwn_StackPopEngineStructure(es_type)
   if es == nil then return end

   if es_type == nwn.ENGINE_STRUCTURE_EFFECT then
      return effect_t(es, false)
   elseif es_type == nwn.ENGINE_STRUCTURE_EVENT then
      es = es
   elseif es_type == nwn.ENGINE_STRUCTURE_LOCATION then
      es = ffi.cast("CScriptLocation*", es)
      local temp = location_t(es.position, es.orientation, es.area)
      ffi.C.free(es)
      return temp
   elseif es_type == nwn.ENGINE_STRUCTURE_TALENT then
      es = es
   elseif es_type == nwn.ENGINE_STRUCTURE_ITEMPROPERTY then
      return itemprop_t(es, false)
   end

   es = ffi.gc(es, ffi.C.free)
   return es
end

--- Pops a float off the NWN stack as a Lua number
function nwn.engine.StackPopFloat()
   return C.nwn_StackPopFloat()
end

--- Pops a integer off the NWN stack as a Lua number
function nwn.engine.StackPopInteger()
   return C.nwn_StackPopInteger()
end

--- Pop object from NWScript stack
function nwn.engine.StackPopObject()
   return _NL_GET_CACHED_OBJECT(C.nwn_StackPopObject())
end

--- Pops a string off the NWN stack as a Lua string
function nwn.engine.StackPopString()
   local s = C.nwn_StackPopString()
   local tx = s == nil
   if tx then return "" end

   local t = ffi.string(s)
   ffi.C.free(s)
   return t
end

--- Pop vector from NWScript stack
function nwn.engine.StackPopVector()
   local v = C.nwn_StackPopVector()
   local temp = vector_t(v.x, v.y, v.z)
   C.free(v)
   return temp
end

--- Pushes boolean on the NWScript stack.
-- This is a wrapper for StackPushInteger to make converting between boolean and integer values
-- easier for Lua.
-- @param value Boolean value
function nwn.engine.StackPushBoolean(value)
   if type(value) ~= "boolean" then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Non-boolean value passed to StackPushBoolean
                        |%s]], debug.traceback()))
   end
   C.nwn_StackPushInteger(value and 1 or 0)
end

--- Pushes float onto NWScript stack
-- @param value Float value
function nwn.engine.StackPushFloat(value)
   if type(value) ~= "number" then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Non-number value passed to StackPushFloat
                        |%s]], debug.traceback()))
   end
   C.nwn_StackPushFloat(value)
end

--- Pushes integer onto NWScript stack
-- @param value Integer value
function nwn.engine.StackPushInteger(value)
   if type(value) ~= "number" then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Non-number value passed to StackPushInteger
                        |%s]], debug.traceback()))
   end
   C.nwn_StackPushInteger(value)
end

--- Pushes engine structure onto NWScript stack
-- @param es_type
-- @param value Engine structure
function nwn.engine.StackPushEngineStructure(es_type, value)
   if not es_type or not value then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Nil value passed to StackPushEngineStructure
                        |%s]], debug.traceback()))
   end

   if es_type == nwn.ENGINE_STRUCTURE_EFFECT 
      or es_type == nwn.ENGINE_STRUCTURE_ITEMPROPERTY
   then
      C.nwn_StackPushEngineStructure(es_type, value.eff)
   else
      C.nwn_StackPushEngineStructure(es_type, value)
   end
end

--- Pushes object onto NWscript stack
-- @param object Object to push.
function nwn.engine.StackPushObject(object)
   if not object then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Nil value passed to StackPushObject
                        |%s]], debug.traceback()))
   end

   C.nwn_StackPushObject(object.id)
end

--- Pushes string onto NWScript stack
-- @param value String value
function nwn.engine.StackPushString(value)
   if type(value) ~= "string" then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Non-string value passed to StackPushString
                        |%s]], debug.traceback()))
   end
   C.nwn_StackPushString(value)
end

--- Pushes vector onto NWScript stack
-- @param value Vector value.
function nwn.engine.StackPushVector(value)
   if not value then
      error(nwn.Log(nwn.LOGLEVEL_ERROR,
		    sm[[Nil value passed to StackPushVector
                        |%s]], debug.traceback()))
   end
   C.nwn_StackPushVector(value)
end

