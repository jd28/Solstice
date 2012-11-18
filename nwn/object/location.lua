--- Get area object is in.
function Object:GetArea()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(24, 1)
   return nwn.engine.StackPopObject()
end

-- Get distance between two objects
function Object:GetDistanceToObject(obj)
   local loc1 = self:GetLocation()
   local loc2 = self:GetLocation()

   return loc1:GetDistanceBetween(loc2)
end

--- Get direction object is facing
function Object:GetFacing()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(28, 1)
   return nwn.engine.StackPopFloat()
end

--- Get object's location
function Object:GetLocation()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(213, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION)
end

--- Get object's position
function Object:GetPosition()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(27, 1)
   return nwn.engine.StackPopVector()
end

--- Get is target in line of sight
-- @param target Target to check.
function Object:LineOfSight(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(752, 2)
   return nwn.engine.StackPopBoolean()
end

--- Set direction object is facing in.
function Object:SetFacing(direction)
   nwn.engine.StackPushFloat(direction)
   nwn.engine.ExecuteCommand(10, 1)
end

--- Set the poin the object is facing.
-- @param target Vector position.
function Object:SetFacingPoint(target)
   nwn.engine.StackPushVector(target)
   nwn.engine.ExecuteCommand(143, 1)
end
