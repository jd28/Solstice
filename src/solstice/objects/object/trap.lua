local M = require 'solstice.objects.init'
local Object = M.Object

local OBJECT_TYPES = bit.bor(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE,
                             OBJECT_TYPE_TRIGGER)

--- Gets traps base type.
function Object:GetTrapBaseType()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return -1
  end
  return self.obj.trap_basetype
end

--- Get traps creator
function Object:GetTrapCreator()
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(533, 1)
  return NWE.StackPopObject()
end

--- Get if trap was detected by creature
function Object:GetTrapDetectedBy(creature)
  NWE.StackPushObject(creature)
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(529, 2)
  return NWE.StackPopBoolean()
end

--- Get trap's key tag
function Object:GetTrapKeyTag()
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(534, 1)
  return NWE.StackPopString()
end

--- Get if trap is detectable.
function Object:GetTrapDetectable()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return false
  end
  return self.obj.trap_detectable == 1
end

--- Get the DC required to detect trap.
function Object:GetTrapDetectDC()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return -1
  end
  return self.obj.trap_detect_dc
end

--- Get if trap is disarmable
function Object:GetTrapDisarmable()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return false
  end
  return self.obj.trap_disarmable == 1
end

--- Get DC required to disarm trap
function Object:GetTrapDisarmDC()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return -1
  end
  return self.obj.trap_disarm_dc
end

--- Get if trap is flagged
function Object:GetTrapFlagged()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return false
  end
  return self.obj.trap_flagged == 1
end

--- Get if trap is oneshot
function Object:GetTrapOneShot()
  if not self:GetIsValid() or bit.band(self:GetType(), OBJECT_TYPES) == 0 then
    return false
  end
  return self.obj.trap_oneshot == 1
end

--- Set whether an object has detected the trap
-- @param object the detector
-- @param is_detected (Default: false)
function Object:SetTrapDetectedBy(object, is_detected)
  NWE.StackPushInteger(is_detected)
  NWE.StackPushObject(object)
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(550, 3)
  return NWE.StackPopBoolean()
end

--- Set the trap's key tag
function Object:SetTrapKeyTag(tag)
  NWE.StackPushString(tag)
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(806, 2)
end
