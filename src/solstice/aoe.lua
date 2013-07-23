--- Area of Effects
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module aoe

local M = require 'solstice.aoe.init'
M.const = require 'solstice.aoe.constant'
setmetatable(M, { __index = M.const })

local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

M.AoE = inheritsFrom(Obj.Object, 'solstice.aoe.AoE')

--- Class AoE
-- @section

--- An iterator over all objects in an AoE
-- @param[opt=solstice.object.CREATURE] object_mask solstice.object type constant
-- @return All objects satisfying the object mask.
function M.AoE:ObjectsInEffect(object_mask)
   object_mask = object_mask or solstice.object.CREATURE

   return function ()
      local obj, _obj = self:GetFirstInPersistentObject(object_mask)
      while obj:GetIsValid() do
         _obj, obj = obj, self:GetNextInPersistentObject(object_mask)
         return _obj
      end
   end
end

--- Gets the first object in an AoE
--    Perfer the solstice.aoe.AoE:ObjectsInEffect iterator.
-- @param[opt=solstice.object.CREATURE] object_mask solstice.object type constant
-- @return First object in AoE or solstice.object.INVALID if none.
function M.AoE:GetFirstInPersistentObject(object_mask)
   object_mask = object_mask or solstice.object.CREATURE
   
   NWE.StackPushInteger(0)
   NWE.StackPushInteger(object_mask)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(262, 3)
   return NWE.StackPopObject()
end

--- Gets the next object in an AoE
--    Perfer the solstice.aoe.AoE:ObjectsInEffect iterator.
-- @param[opt=solstice.object.CREATURE] object_mask solstice.object. type constant.
-- @return Next object in AoE and finally solstice.object.INVALID
function M.AoE:GetNextInPersistentObject(object_mask)
   object_mask = object_mask or solstice.object.CREATURE
   
   NWE.StackPushInteger(0)
   NWE.StackPushInteger(object_mask)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(263, 3)
   return NWE.StackPopObject()
end

--- Get's the creator of the AoE
-- @return The creator or solstice.object.INVALID.
function M.AoE:GetCreator()
   if not self:GetIsValid() then
      return Obj.INVALID
   end
   return _SOL_GET_CACHED_OBJECT(self.obj.aoe_creator)
end

---
function M.AoE:SetSpellDC(dc)
   if not self:GetIsValid() then return -1 end
   
   self.obj.aoe_spell_dc = dc
   return self.obj.aoe_spell_dc
end

---
function M.AoE:SetSpellLevel(level)
   if not self:GetIsValid() then return -1 end
   
   self.obj.aoe_spell_level = level
   return self.obj.aoe_spell_level
end

return M