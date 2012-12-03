--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Get is object commandable
function Object:GetCommandable()
   nwn.engine.StackPushObject(self);
   nwn.engine.ExecuteCommand(163, 1);
   return nwn.engine.StackPopBoolean();
end

--- Determines if a creature is dead or dying.
function Object:GetIsDead()
   if not self:GetIsValid() then
      return true
   end

   local hp = self:GetCurrentHitPoints()
   if self.type == nwn.GAME_OBJECT_TYPE_CREATURE 
      and (self:GetIsPC() or self:GetIsPossessedFamiliar())
   then
      if hp <= NS_OPT_HP_LIMIT then
         return true
      end
   else
      if hp <= 0 then
         return true
      end
   end

   return false
end

--- Determines if a creature is dead or dying.
function Object:GetIsPCDying()
   if not self:GetIsValid() 
      or self.type ~= nwn.GAME_OBJECT_TYPE_CREATURE 
      or not self:GetIsPC()
      or not self:GetIsPossessedFamiliar()
   then
      return false
   end

   local hp = self:GetCurrentHitPoints()
   if hp <= 0 and hp > NS_OPT_HP_LIMIT then
      return true
   end

   return false
end

--- Set is object commandable
-- @param commandable (Default: false)
function Object:SetCommandable(commandable)
   nwn.engine.StackPushObject(self);
   nwn.engine.StackPushBoolean(commandable);
   nwn.engine.ExecuteCommand(162, 2);
end

--------------------------------------------------------------------------------
-- Bridge functions to nwnx_solstice

function NSGetIsDead(obj)
   obj = _NL_GET_CACHED_OBJECT(obj)
   return obj:GetIsDead()
end

function NSGetIsPCDying(obj)
   obj = _NL_GET_CACHED_OBJECT(obj)
   return obj:GetIsPCDying()
end