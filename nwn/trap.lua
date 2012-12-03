--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ffi = require 'ffi'

ffi.cdef [[
typedef struct Trap {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Trap;
]]

local trap_mt = { __index = Trap }
trap_t = ffi.metatype("Trap", trap_mt)

local function trap_get_obj(trap)
   if not nli.CheckGameObjectType(trap, GAME_OBJECT_TYPE_DOOR, GAME_OBJECT_TYPE_PLACEABLE,
                                  GAME_OBJECT_TYPE_TRIGGER)
   then
      error("Invalid GAME_OBJECT_TYPE_* : " .. trap.type)
      return nil
   end
   return _NL_GET_CACHED_OBJECT(trap.id)
end

--- Gets traps base type.
function Trap:GetBaseType()
   local o = trap_get_obj(self)
   return o.trap_basetype
end

--- Get traps creator
function Trap:GetCreator()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(533, 1)
   return nwn.engine.StackPopObject()
end

--- Get if trap was detected by creature
function Trap:GetDetectedBy(creature)
   nwn.engine.StackPushObject(creature)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(529, 2)
   return nwn.engine.StackPopBoolean()
end

--- Get trap's key tag
function Trap:GetKeyTag()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(534, 1)
   return nwn.engine.StackPopString()
end

--- Get if trap is detectable.
function Trap:GetDetectable()
   local o = trap_get_obj(self)
   return o.trap_detectable == 1
end

--- Get the DC required to detect trap.
function Trap:GetDetectDC()
   local o = trap_get_obj(self)
   return o.trap_detect_dc
end

--- Get if trap is disarmable
function Trap:GetDisarmable()
   local o = trap_get_obj(self)
   return o.trap_disarmable == 1
end

--- Get DC required to disarm trap
function Trap:GetDisarmDC()
   local o = trap_get_obj(self)
   return o.trap_disarm_dc
end

--- Get if trap is flagged
function Trap:GetFlagged()
   local o = trap_get_obj(self)
   return o.trap_flagged == 1
end

--- Get if trap is oneshot
function Trap:GetOneShot()
   local o = trap_get_obj(self)
   return o.trap_oneshot == 1
end

--- Set whether an object has detected the trap
-- @param object the detector
-- @param is_detected (Default: false)
function Trap:SetDetectedBy(object, is_detected)
   nwn.engine.StackPushInteger(is_detected)
   nwn.engine.StackPushObject(object)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(550, 3)
   return nwn.engine.StackPopBoolean()
end

--- Set the trap's key tag
function Trap:SetKeyTag(tag)
   nwn.engine.StackPushString(tag)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(806, 2)
end
