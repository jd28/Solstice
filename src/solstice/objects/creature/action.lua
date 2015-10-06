----
-- @module creature

--- Actions
-- @section Actions

local M = require 'solstice.objects.init'
local Creature = M.Creature

local NWE = require 'solstice.nwn.engine'
local Eff = require 'solstice.effect'

---
function Creature:ActionAttack(target, passive)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if passive == nil then passive = true end

   NWE.StackPushBoolean(passive)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(37, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionCastFakeSpellAtObject(spell, target, path_type)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   path_type = path_type or PROJECTILE_PATH_TYPE_DEFAULT

   NWE.StackPushInteger(path_type)
   NWE.StackPushObject(target)
   NWE.StackPushInteger(spell)
   NWE.ExecuteCommand(501, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionCastFakeSpellAtLocation(spell, target, path_type)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   path_type = path_type or PROJECTILE_PATH_TYPE_DEFAULT

   NWE.StackPushInteger(path_type)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, target)
   NWE.StackPushInteger(spell)
   NWE.ExecuteCommand(502, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionCastSpellAtLocation(spell, target, metamagic, cheat, path_type, instant)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   metamagic = metamagic or METAMAGIC_ANY
   path_type = path_type or PROJECTILE_PATH_TYPE_DEFAULT

   NWE.StackPushBoolean(instant)
   NWE.StackPushInteger(path_type)
   NWE.StackPushInteger(cheat)
   NWE.StackPushInteger(metamagic)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, target)
   NWE.StackPushInteger(spell)
   NWE.ExecuteCommand(234, 6)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionCastSpellAtObject(spell, target, metamagic, cheat, path_type, instant)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   metamagic = metamagic or METAMAGIC_ANY
   path_type = path_type or PROJECTILE_PATH_TYPE_DEFAULT

   NWE.StackPushBoolean(instant)
   NWE.StackPushBoolean(path_type)
   NWE.StackPushInteger(cheat)
   NWE.StackPushInteger(metamagic)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, target)
   NWE.StackPushInteger(spell)
   NWE.ExecuteCommand(48, 7)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionCounterSpell(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target);
   NWE.ExecuteCommand(566, 1);

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionDoWhirlwindAttack(feedback, improved)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if feedback == nil then feedback = true end

   NWE.StackPushInteger(improved)
   NWE.StackPushInteger(feedback)
   NWE.ExecuteCommand(709, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionEquipItem(item, slot)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(slot)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(32, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionEquipMostDamagingMelee(versus, offhand)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(offhand)
   NWE.StackPushObject(versus)
   NWE.ExecuteCommand(399, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionEquipMostDamagingRanged(versus)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(versus)
   NWE.ExecuteCommand(400, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionEquipMostEffectiveArmor()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)
   NWE.ExecuteCommand(404, 0)
   NWE.SetCommandObject(temp)
end

---
function Creature:ActionExamine(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(738, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionForceFollowObject(target, distance)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(distance or 0)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(167, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionForceMoveToLocation(target, run, timeout)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(timeout or 30)
   NWE.StackPushInteger(run)
   NWE.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, target)
   NWE.ExecuteCommand(382, 3)


   NWE.SetCommandObject(temp)
end

---
function Creature:ActionForceMoveToObject(target, run, range, timeout)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(timeout or 30)
   NWE.StackPushFloat(range or 1)
   NWE.StackPushBoolean(run)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(383, 4)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionInteractObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(329, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionJumpToLocation(loc)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.ExecuteCommand(214, 1)

   NWE.SetCommandObject(temp)
end

function Creature:ActionJumpToObject(destination, straight_line)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(straight_line or 1)
   NWE.StackPushObject(destination)
   NWE.ExecuteCommand(196, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionMoveAwayFromLocation(loc, run, range)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   range = range or 40.0

   NWE.StackPushFloat(range)
   NWE.StackPushBoolean(run)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.ExecuteCommand(360, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionMoveAwayFromObject(target, run, range)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(range or 40)
   NWE.StackPushInteger(run)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(23, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionMoveToLocation(target, run)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(run)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, target)
   NWE.ExecuteCommand(21, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionMoveToObject(target, run, range)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(range or 1)
   NWE.StackPushInteger(run)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(22, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionPickUpItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(34, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionPlayAnimation(animation, speed, dur)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   speed = speed or 1.0
   dur = dur or 0.0

   NWE.StackPushFloat(dur or 0)
   NWE.StackPushFloat(speed or 1)
   NWE.StackPushInteger(animation)
   NWE.ExecuteCommand(300, 3)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionPutDownItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(35, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionRandomWalk()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(20, 0)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionRest(check_sight)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(check_sight)
   NWE.ExecuteCommand(402, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionSit(chair)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(chair)
   NWE.ExecuteCommand(194, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionTouchAttackMelee(target, feedback)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if feedback == nil then feedback = true end

   NWE.StackPushBoolean(feedback)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(146, 2)

   NWE.SetCommandObject(temp)
   return NWE.StackPopInteger()
end

---
function Creature:ActionTouchAttackRanged(target, feedback)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if feedback == nil then feedback = true end

   NWE.StackPushBoolean(feedback)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(147, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionUseFeat(feat, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushInteger(feat)
   NWE.ExecuteCommand(287, 2)

   NWE.SetCommandObject(temp)
end

--- TODO Broken
function Creature:ActionUseItem(item, target, area, loc, prop)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if not area:GetIsValid() then return end

--   ffi.C.nl_ActionUseItem

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionUseSkill(skill, target, subskill, item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.StackPushInteger(subskill or 0)
   NWE.StackPushObject(target)
   NWE.StackPushInteger(skill)
   NWE.ExecuteCommand(288, 4)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionUseTalentAtLocation(talent, loc)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(310, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionUseTalentOnObject(talent, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(309, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:ActionUnequipItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(33, 1)

   NWE.SetCommandObject(temp)
end

---
function Creature:PlayVoiceChat(id)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(self)
   NWE.StackPushInteger(id)
   NWE.ExecuteCommand(421, 2)

   NWE.SetCommandObject(temp)
end

---
function Creature:SpeakOneLinerConversation(resref, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushString(resref)
   NWE.ExecuteCommand(417, 2)

   NWE.SetCommandObject(temp)
end

function Creature:JumpSafeToLocation(loc)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToLocation(loc)
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:JumpSafeToObject(obj)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToObject(obj)
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function Creature:JumpSafeToWaypoint(way)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToObject(Game.GetWaypointByTag(way))
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

return M
