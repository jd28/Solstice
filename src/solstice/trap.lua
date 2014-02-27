--- Trap
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module trap

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

local M = {}

M.Trap = {}

--- Internal ctype
M.trap_t = ffi.metatype("Trap", { __index = M.Trap })

local function trap_get_obj(trap)
   local ob = _SOL_GET_CACHED_OBJECT(trap.id)
   if not anyinstance(trap, Door, Placeable, Trigger) then
      error "Invalid type!"
   end
   return ob
end

--- Gets traps base type.
function M.Trap:GetBaseType()
   local o = trap_get_obj(self)
   return o.trap_basetype
end

--- Get traps creator
function M.Trap:GetCreator()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(533, 1)
   return NWE.StackPopObject()
end

--- Get if trap was detected by creature
function M.Trap:GetDetectedBy(creature)
   NWE.StackPushObject(creature)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(529, 2)
   return NWE.StackPopBoolean()
end

--- Get trap's key tag
function M.Trap:GetKeyTag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(534, 1)
   return NWE.StackPopString()
end

--- Get if trap is detectable.
function M.Trap:GetDetectable()
   local o = trap_get_obj(self)
   return o.trap_detectable == 1
end

--- Get the DC required to detect trap.
function M.Trap:GetDetectDC()
   local o = trap_get_obj(self)
   return o.trap_detect_dc
end

--- Get if trap is disarmable
function M.Trap:GetDisarmable()
   local o = trap_get_obj(self)
   return o.trap_disarmable == 1
end

--- Get DC required to disarm trap
function M.Trap:GetDisarmDC()
   local o = trap_get_obj(self)
   return o.trap_disarm_dc
end

--- Get if trap is flagged
function M.Trap:GetFlagged()
   local o = trap_get_obj(self)
   return o.trap_flagged == 1
end

--- Get if trap is oneshot
function M.Trap:GetOneShot()
   local o = trap_get_obj(self)
   return o.trap_oneshot == 1
end

--- Set whether an object has detected the trap
-- @param object the detector
-- @param is_detected (Default: false)
function M.Trap:SetDetectedBy(object, is_detected)
   NWE.StackPushInteger(is_detected)
   NWE.StackPushObject(object)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(550, 3)
   return NWE.StackPopBoolean()
end

--- Set the trap's key tag
function M.Trap:SetKeyTag(tag)
   NWE.StackPushString(tag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(806, 2)
end

return M
