--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

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
