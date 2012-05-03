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

--- Get game difficulty
function Module:GetGameDifficulty()
   nwn.engine.ExecuteCommand(513, 0);
   return nwn.engine.StackPopInteger();
end

--- Sets max number of henchmen
function Module:GetMaxHenchmen()
   nwn.engine.ExecuteCommand(747, 0);
   return nwn.engine.StackPopInteger();
end

--- Sets max number of henchmen
-- @param max Max henchment
function Module:SetMaxHenchmen(max)
   nwn.engine.StackPushInteger(max);
   nwn.engine.ExecuteCommand(746, 1);
end

--- Sets XP scale
-- @param scale New XP scale.
function Module:SetModuleXPScale(scale)
   nwn.engine.StackPushInteger(scale);
   nwn.engine.ExecuteCommand(818, 1);
end

