--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Do fortitude save
-- @param dc Difficult class
-- @param save_type nwn.SAVING_THROW_TYPE_*
-- @param vs Save versus object
function Object:FortitudeSave(dc, save_type, vs)
   nwn.engine.StackPushObject(vs)
   nwn.engine.StackPushInteger(save_type)
   nwn.engine.StackPushInteger(dc)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(108, 4)
   return nwn.engine.StackPopInteger()
end

--- Get fortitude saving throw
function Object:GetFortitudeSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(491, 1)
   return nwn.engine.StackPopInteger()
end

--- Get reflex saving throw
function Object:GetReflexSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(493, 1)
   return nwn.engine.StackPopInteger()
end

--- Get will saving throw
function Object:GetWillSavingThrow()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(492, 1)
   return nwn.engine.StackPopInteger()
end

--- Do reflex save
-- @param dc Difficult class
-- @param save_type nwn.SAVING_THROW_TYPE_*
-- @param vs Save versus object
function Object:ReflexSave(dc, save_type, vs)
   nwn.engine.StackPushObject(vs)
   nwn.engine.StackPushInteger(save_type)
   nwn.engine.StackPushInteger(dc)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(109, 4)
   return nwn.engine.StackPopInteger()
end

--- Set fortitude saving throw
-- @param val New value
function Object:SetFortitudeSavingThrow(val)
   nwn.engine.StackPushInteger(val)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(813, 2)
end

--- Set reflex saving throw
-- @param val New value
function Object:SetReflexSavingThrow(val)
   nwn.engine.StackPushInteger(val)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(812, 2)
end

--- Set will saving throw
-- @param val New value
function Object:SetWillSavingThrow(val)
   nwn.engine.StackPushInteger(val)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(811, 2)
end

--- Do will save
-- @param dc Difficult class
-- @param save_type nwn.SAVING_THROW_TYPE_*
-- @param vs Save versus object
function Object:WillSave(dc, save_type, vs)
   nwn.engine.StackPushObject(vs)
   nwn.engine.StackPushInteger(save_type)
   nwn.engine.StackPushInteger(dc)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(110, 4)
   return nwn.engine.StackPopInteger()
end
