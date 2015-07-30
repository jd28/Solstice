--- Creature
-- @module creature

--- Persistant Variables
-- @section creature.vars

local M = require 'solstice.objects.init'
local Creature = M.Creature

local NWNXDb = require 'solstice.nwnx.database'

--- Get persistant integer.
-- @string var Variable name.
-- @bool global If true uses player login, if false player tag.
-- @string dbtable Database table.
function Creature:GetPlayerInt(var, global, dbtable)
   local ret = self:GetLocalInt(var)
   if ret ~= 0 then return ret end
   ret = NWNXDb.GetInt(self, var, global, dbtable)
   self:SetLocalInt(var, ret)
   return ret
end

--- Set persistant integer.
-- @string var Variable name.
-- @param value Variable value.
-- @bool global If true uses player login, if false player tag.
-- @string dbtable Database table.
function Creature:SetPlayerInt(var, value, global, dbtable)
   assert(value and type(value) == 'number')
   self:SetLocalInt(var, value)
   NWNXDb.SetInt(self, var, value, 0, global, dbtable)
end

--- Get persistant string.
-- @string var Variable name.
-- @bool global If true uses player login, if false player tag.
-- @string dbtable Database table.
function Creature:GetPlayerString(var, global, dbtable)
   local ret = self:GetLocalString(var)
   if ret ~= 0 then return ret end
   ret = NWNXDb.GetString(self, var, global, dbtable)
   self:SetLocalString(var, ret)
   return ret
end

--- Set persistant string.
-- @string var Variable name.
-- @param value Variable value.
-- @bool global If true uses player login, if false player tag.
-- @string dbtable Database table.
function Creature:SetPlayerString(var, value, global, dbtable)
   assert(value and type(value) == 'string')
   self:SetLocalString(var, value)
   NWNXDb.SetString(self, var, value, 0, global, dbtable)
end
