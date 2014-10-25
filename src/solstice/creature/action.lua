--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

--- Actions
-- @section Actions

local M = require 'solstice.creature.init'

local NWE = require 'solstice.nwn.engine'
local Eff = require 'solstice.effect'

---
-- @param target Target to attack.
-- @param passive
function M.Creature:ActionAttack(target, passive)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if passive == nil then passive = true end

   NWE.StackPushBoolean(passive)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(37, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param spell SPELL\_* constant.
-- @param target Object to cast fake spell at.
-- @param[opt=PROJECTILE_PATH_TYPE_DEFAULT] path_type PROJECTILE_PATH_TYPE_*.
function M.Creature:ActionCastFakeSpellAtObject(spell, target, path_type)
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
-- @param spell SPELL\_* constant.
-- @param target Location to cast spell at.
-- @param[opt=PROJECTILE\_PATH\_TYPE\_DEFAULT] path_type PROJECTILE\_PATH\_TYPE\_*.
function M.Creature:ActionCastFakeSpellAtLocation(spell, target, path_type)
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
-- @param spell SPELL\_* constant.
-- @param target Location to cast spell at.
-- @param[opt=METAMAGIC\_ANY] metamagic METAMAGIC\_*.
-- @param[opt=false] cheat If true cast spell even if target does not have the ability.
-- @param[opt=PROJECTILE\_PATH\_TYPE\_DEFAULT] path_type PROJECTILE\_PATH\_TYPE\_*.
-- @param[opt=false] instant If true spell can instantaneously.
function M.Creature:ActionCastSpellAtLocation(spell, target, metamagic, cheat, path_type, instant)
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
-- @param spell
-- @param target
-- @param[opt=METAMAGIC_ANY] metamagic METAMAGIC_*
-- @param[opt=false] cheat If true cast spell even if target does not have the ability.
-- @param[opt=PROJECTILE_PATH_TYPE_DEFAULT] path_type PROJECTILE_PATH_TYPE_*.
-- @param[opt=false] instant
function M.Creature:ActionCastSpellAtObject(spell, target, metamagic, cheat, path_type, instant)
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
-- @param target
function M.Creature:ActionCounterSpell(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target);
   NWE.ExecuteCommand(566, 1);

   NWE.SetCommandObject(temp)
end

---
-- @param feedback Send feedback.
-- @param improved Determines if effect is Improved Whirlwind Attack
function M.Creature:ActionDoWhirlwindAttack(feedback, improved)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if feedback == nil then feedback = true end

   NWE.StackPushInteger(improved)
   NWE.StackPushInteger(feedback)
   NWE.ExecuteCommand(709, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param item
-- @param slot
function M.Creature:ActionEquipItem(item, slot)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(slot)
   NWE.StackPushObject(item)
   NWE.ExecuteCommand(32, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param versus
-- @param offhand
function M.Creature:ActionEquipMostDamagingMelee(versus, offhand)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(offhand)
   NWE.StackPushObject(versus)
   NWE.ExecuteCommand(399, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param versus
function M.Creature:ActionEquipMostDamagingRanged(versus)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(versus)
   NWE.ExecuteCommand(400, 1)

   NWE.SetCommandObject(temp)
end

---
function M.Creature:ActionEquipMostEffectiveArmor()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(404, 0)

   NWE.SetCommandObject(temp)
end

---
-- @param target Object to examine.
function M.Creature:ActionExamine(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(738, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param[opt=0] distance
function M.Creature:ActionForceFollowObject(target, distance)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(distance or 0)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(167, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param run
-- @param[opt=30] timeout
function M.Creature:ActionForceMoveToLocation(target, run, timeout)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(timeout or 30)
   NWE.StackPushInteger(run)
   NWE.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, target)
   NWE.ExecuteCommand(382, 3)


   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param run
-- @param range
-- @param timeout
function M.Creature:ActionForceMoveToObject(target, run, range, timeout)
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
-- @param target
function M.Creature:ActionInteractObject(target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.ExecuteCommand(329, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param loc
function M.Creature:ActionJumpToLocation(loc)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.ExecuteCommand(214, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param destination
-- @param[opt=true] straight_line
-- @return
function M.Creature:ActionJumpToObject(destination, straight_line)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushInteger(straight_line or 1)
   NWE.StackPushObject(destination)
   NWE.ExecuteCommand(196, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param loc
-- @param[opt=false] run
-- @param[opt=40.0] range
function M.Creature:ActionMoveAwayFromLocation(loc, run, range)
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
-- @param target
-- @param run
-- @param range
function M.Creature:ActionMoveAwayFromObject(target, run, range)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(range or 40)
   NWE.StackPushInteger(run)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(23, 3)

   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param run
function M.Creature:ActionMoveToLocation(target, run)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(run)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, target)
   NWE.ExecuteCommand(21, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param run
-- @param range
function M.Creature:ActionMoveToObject(target, run, range)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushFloat(range or 1)
   NWE.StackPushInteger(run)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(22, 3)

   NWE.SetCommandObject(temp)
end

---
-- @param item
function M.Creature:ActionPickUpItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(34, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param animation
-- @param speed
-- @param dur
function M.Creature:ActionPlayAnimation(animation, speed, dur)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   print(NWE.GetCommandObject())
   speed = speed or 1.0
   dur = dur or 0.0

   NWE.StackPushFloat(dur or 0)
   NWE.StackPushFloat(speed or 1)
   NWE.StackPushInteger(animation)
   NWE.ExecuteCommand(300, 3)

   NWE.SetCommandObject(temp)
end

---
-- @param item
function M.Creature:ActionPutDownItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(35, 1)

   NWE.SetCommandObject(temp)
end

---
function M.Creature:ActionRandomWalk()
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.ExecuteCommand(20, 0)

   NWE.SetCommandObject(temp)
end

---
-- @param check_sight
function M.Creature:ActionRest(check_sight)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushBoolean(check_sight)
   NWE.ExecuteCommand(402, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param chair
function M.Creature:ActionSit(chair)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(chair)
   NWE.ExecuteCommand(194, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param target
-- @param[opt=true] feedback
function M.Creature:ActionTouchAttackMelee(target, feedback)
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
-- @param target
-- @param[opt=true] feedback
function M.Creature:ActionTouchAttackRanged(target, feedback)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if feedback == nil then feedback = true end

   NWE.StackPushBoolean(feedback)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(147, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param feat solstice.feat constant.
-- @param target Target
function M.Creature:ActionUseFeat(feat, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushInteger(feat)
   NWE.ExecuteCommand(287, 2)

   NWE.SetCommandObject(temp)
end

--- TODO Broken
function M.Creature:ActionUseItem(item, target, area, loc, prop)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   if not area:GetIsValid() then return end

--   ffi.C.nl_ActionUseItem

   NWE.SetCommandObject(temp)
end

---
-- @param skill
-- @param target
-- @param subskill
-- @param item
function M.Creature:ActionUseSkill(skill, target, subskill, item)
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
-- @param talent
-- @param loc
function M.Creature:ActionUseTalentAtLocation(talent, loc)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(310, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param talent
-- @param target
function M.Creature:ActionUseTalentOnObject(talent, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_TALENT, talent)
   NWE.ExecuteCommand(309, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param item
function M.Creature:ActionUnequipItem(item)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(item)
   NWE.ExecuteCommand(33, 1)

   NWE.SetCommandObject(temp)
end

---
-- @param id
function M.Creature:PlayVoiceChat(id)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(self)
   NWE.StackPushInteger(id)
   NWE.ExecuteCommand(421, 2)

   NWE.SetCommandObject(temp)
end

---
-- @param resref
-- @param target
function M.Creature:SpeakOneLinerConversation(resref, target)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)

   NWE.StackPushObject(target)
   NWE.StackPushString(resref)
   NWE.ExecuteCommand(417, 2)

   NWE.SetCommandObject(temp)
end

function M.Creature:JumpSafeToLocation(loc)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToLocation(loc)
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function M.Creature:JumpSafeToObject(obj)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToObject(obj)
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

function M.Creature:JumpSafeToWaypoint(way)
   self:ApplyEffect(DURATION_TYPE_TEMPORARY,
                    Eff.CutsceneImmobilize(), 0.1)
   self:ClearAllActions(true)
   self:ActionJumpToObject(Game.GetWaypointByTag(way))
   self:DoCommand(function (self) self:SetCommandable(true) end)
   self:SetCommandable(false)
end

return M
