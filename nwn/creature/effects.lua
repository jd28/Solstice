---
function Creature:GetHasFeatEffect(nFeat)
   nwn.engine.StackPushObject(self.id)
   nwn.engine.StackPushInteger(nFeat)
   nwn.engine.ExecuteCommand(543, 2)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetIsInvisible()
   return self:GetHasEffect(EFFECT_TYPE_INVISIBILITY)
      or self:GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY)
      or (self:GetHasSpellEffect(SPELL_DARKNESS) and self:GetHasSpellEffect(SPELL_DARKVISION))
      or self:GetActionMode(ACTION_MODE_STEALTH)
      or self:GetHasEffect(EFFECT_TYPE_SANCTUARY)
      or GetHasEffect(EFFECT_TYPE_ETHEREAL, oSelf)
end

---
function Creature:GetIsImmune(immunity, versus)
   nwn.engine.StackPushObject(versus)
   nwn.engine.StackPushInteger(immunity)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(274, 3)
   return StackPopBoolean()
end
