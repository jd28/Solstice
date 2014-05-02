local M = require 'solstice.creature.init'
local Creature = M.Creature

local NWNXDb = require 'solstice.nwnx.database'

function Creature:GetPlayerInt(var, global, dbtable)
   local ret = self:GetLocalInt(var)
   if ret ~= 0 then return ret end
   ret = NWNXDb.GetInt(self, var, global, dbtable)
   self:SetLocalInt(var, ret)
   return ret
end

function Creature:SetPlayerInt(var, value, global, dbtable)
   assert(value and type(value) == 'number')
   self:SetLocalInt(var, value)
   NWNXDb.SetInt(self, var, value, 0, global, dbtable)
end

function Creature:GetPlayerString(var, global, dbtable)
   local ret = self:GetLocalString(var)
   if ret ~= 0 then return ret end
   ret = NWNXDb.GetString(self, var, global, dbtable)
   self:SetLocalString(var, ret)
   return ret
end

function Creature:SetPlayerString(var, value, global, dbtable)
   assert(value and type(value) == 'string')
   self:SetLocalString(var, value)
   NWNXDb.SetString(self, var, value, 0, global, dbtable)
end
