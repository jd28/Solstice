local ffi = require 'ffi'
local C = ffi.C

---
function Creature:GetHasFeatEffect(nFeat)
   nwn.engine.StackPushObject(self.id)
   nwn.engine.StackPushInteger(nFeat)
   nwn.engine.ExecuteCommand(543, 2)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetIsInvisible(target)
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, target.obj.obj)
   end

   return false
end

---
function Creature:GetIsImmune(immunity, versus)
   nwn.engine.StackPushObject(versus)
   nwn.engine.StackPushInteger(immunity)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(274, 3)
   return StackPopBoolean()
end
