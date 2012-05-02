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

require 'nwn.item'
require 'nwn.area'
require 'nwn.location'

local ffi = require 'ffi'
local C = ffi.C

---
-- @param target Target to attack.
-- @param passive
function Creature:ActionAttack(target, passive)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if passive == nil then passive = true end

   nwn.engine.StackPushBoolean(passive)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(37, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param spell nwn.SPELL_*
-- @param target Object to cast fake spell at.
-- @param path_type nwn.PROJECTILE_PATH_TYPE_*. (Default: nwn.PROJECTILE_PATH_TYPE_DEFAULT)
function Creature:ActionCastFakeSpellAtObject(spell, target, path_type)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   path_type = path_type or nwn.PROJECTILE_PATH_TYPE_DEFAULT
   
   nwn.engine.StackPushInteger(path_type)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(501, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param spell nwn.SPELL_*
-- @param target Location to cast spell at.
-- @param path_type nwn.PROJECTILE_PATH_TYPE_*. (Default: nwn.PROJECTILE_PATH_TYPE_DEFAULT)
function Creature:ActionCastFakeSpellAtLocation(spell, target, path_type)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   path_type = path_type or nwn.PROJECTILE_PATH_TYPE_DEFAULT

   nwn.engine.StackPushInteger(path_type)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, target)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(502, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param spell nwn.SPELL_*
-- @param target Location to cast spell at.
-- @param metamagic nwn.METAMAGIC_*. (Default: nwn.METAMAGIC_ANY)
-- @param cheat If true cast spell even if target does not have the ability.
-- @param projectile_path nwn.PROJECTILE_PATH_TYPE_*. (Default: nwn.PROJECTILE_PATH_TYPE_DEFAULT)
-- @param instant If true spell can instantaneously.
function Creature:ActionCastSpellAtLocation(spell, target, metamagic, cheat, projectile_path, instant)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   metamagic = metamagic or nwn.METAMAGIC_ANY
   if cheat == nil then cheat = false end
   projectile_path = projectile_path or nwn.PROJECTILE_PATH_TYPE_DEFAULT

   nwn.engine.StackPushBoolean(instant)
   nwn.engine.StackPushInteger(projectile_path)
   nwn.engine.StackPushInteger(cheat)
   nwn.engine.StackPushInteger(metamagic)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, target)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(234, 6)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param spell 
-- @param target
-- @param metamagic nwn.METAMAGIC_*
-- @param cheat If true cast spell even if target does not have the ability.
-- @param projectile_path
-- @param instant
function Creature:ActionCastSpellAtObject(spell, target, metamagic, cheat, projectile_path, instant)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   metamagic = metamagic or METAMAGIC_ANY
   if cheat == nil then cheat = false end
   projectile_path = projectile_path or PROJECTILE_PATH_TYPE_DEFAULT
   if instant == nil then instant = false end

   nwn.engine.StackPushInteger(instant)
   nwn.engine.StackPushInteger(projectile_path)
   nwn.engine.StackPushInteger(cheat)
   nwn.engine.StackPushInteger(metamagic)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, target)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(48, 7)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
function Creature:ActionCounterSpell(target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target);
   nwn.engine.ExecuteCommand(566, 1);

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param feedback Send feedback.
-- @param improved Determines if effect is Improved Whirlwind Attack
function Creature:ActionDoWhirlwindAttack(feedback, improved)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if feedback == nil then feedback = true end
   
   nwn.engine.StackPushInteger(improved)
   nwn.engine.StackPushInteger(feedback)
   nwn.engine.ExecuteCommand(709, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param item
-- @param slot
function Creature:ActionEquipItem(item, slot)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushInteger(slot)
   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(32, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param versus
-- @param offhand
function Creature:ActionEquipMostDamagingMelee(versus, offhand)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushInteger(offhand)
   nwn.engine.StackPushObject(versus)
   nwn.engine.ExecuteCommand(399, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param versus
function Creature:ActionEquipMostDamagingRanged(versus)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(versus)
   nwn.engine.ExecuteCommand(400, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
function Creature:ActionEquipMostEffectiveArmor()
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.ExecuteCommand(404, 0)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target Object to examine.
function Creature:ActionExamine(target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(738, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param distance
function Creature:ActionForceFollowObject(target, distance)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushFloat(distance or 0)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(167, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param run
-- @param timeout
function Creature:ActionForceMoveToLocation(target, run, timeout)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushFloat(timeout or 30)
   nwn.engine.StackPushInteger(run)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, target)
   nwn.engine.ExecuteCommand(382, 3)
   

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param run
-- @param range
-- @param timeout
function Creature:ActionForceMoveToObject(target, run, range, timeout)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)
   
   nwn.engine.StackPushFloat(timeout or 30)
   nwn.engine.StackPushFloat(range or 1)
   nwn.engine.StackPushBoolean(run)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(383, 4)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
function Creature:ActionInteractObject(target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(329, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param loc
function Creature:ActionJumpToLocation(loc)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.ExecuteCommand(214, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param 
-- @return
function Creature:ActionJumpToObject(destination, straight_line)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if straight_line == nil then
      straight_line = true
   end

   nwn.engine.StackPushInteger(straight_line)
   nwn.engine.StackPushObject(destination)
   nwn.engine.ExecuteCommand(196, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param loc
-- @param run
-- @param range
function Creature:ActionMoveAwayFromLocation(loc, run, range)
   if bRun == nil then bRun = false end
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   fRange = fRange or 40.0
   
   nwn.engine.StackPushFloat(range)
   nwn.engine.StackPushBoolean(run)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.ExecuteCommand(360, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param run
-- @param range
function Creature:ActionMoveAwayFromObject(target, run, range)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushFloat(range or 40)
   nwn.engine.StackPushInteger(run)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(23, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param run
function Creature:ActionMoveToLocation(target, run)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)
   
   nwn.engine.StackPushBoolean(run)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, target)
   nwn.engine.ExecuteCommand(21, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param run
-- @param range
function Creature:ActionMoveToObject(target, run, range)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushFloat(range or 1)
   nwn.engine.StackPushInteger(run)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(22, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param item
function Creature:ActionPickUpItem(item)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(34, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param animation
-- @param speed
-- @param dur
function Creature:ActionPlayAnimation(animation, speed, dur)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   print(nwn.engine.GetCommandObjectId())
   speed = speed or 1.0
   dur = dur or 0.0
   
   nwn.engine.StackPushFloat(dur or 0)
   nwn.engine.StackPushFloat(speed or 1)
   nwn.engine.StackPushInteger(animation)
   nwn.engine.ExecuteCommand(300, 3)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param item
function Creature:ActionPutDownItem(item)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(35, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param 
-- @return
function Creature:ActionRandomWalk()
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.ExecuteCommand(20, 0)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param check_sight
function Creature:ActionRest(check_sight)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushBoolean(check_sight)
   nwn.engine.ExecuteCommand(402, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param chair
function Creature:ActionSit(chair)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(chair)
   nwn.engine.ExecuteCommand(194, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param target
-- @param feedback
function Creature:ActionTouchAttackMelee(target, feedback)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if feedback == nil then feedback = true end

   nwn.engine.StackPushInteger(feedback)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(146, 2)

   nwn.engine.SetCommandObjectId(temp)
   return nwn.engine.StackPopInteger()
end

---
-- @param target
-- @param feedback
function Creature:ActionTouchAttackRanged(target, feedback)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if feedback == nil then feedback = true end

   nwn.engine.StackPushInteger(feedback)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(147, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param freat
-- @param target
function Creature:ActionUseFeat(feat, target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.ExecuteCommand(287, 2)

   nwn.engine.SetCommandObjectId(temp)
end

--- TODO Broken
function Creature:ActionUseItem(item, target, area, loc, prop)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   if not area:GetIsValid() then return end

--   ffi.C.nl_ActionUseItem

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param skill
-- @param target
-- @param subskill
-- @param item
function Creature:ActionUseSkill(skill, target, subskill, item)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)
   
   nwn.engine.StackPushObject(item)
   nwn.engine.StackPushInteger(subskill or 0)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushInteger(skill)
   nwn.engine.ExecuteCommand(288, 4)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param talent
-- @param loc
function Creature:ActionUseTalentAtLocation(talent, loc)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, talent)
   nwn.engine.ExecuteCommand(310, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param talent
-- @param target
function Creature:ActionUseTalentOnObject(talent, target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, talent)
   nwn.engine.ExecuteCommand(309, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param item
function Creature:ActionUnequipItem(item)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(item)
   nwn.engine.ExecuteCommand(33, 1)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param id
function Creature:PlayVoiceChat(id)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(id)
   nwn.engine.ExecuteCommand(421, 2)

   nwn.engine.SetCommandObjectId(temp)
end

---
-- @param resref 
-- @param target
function Creature:SpeakOneLinerConversation(resref, target)
   local temp = nwn.engine.GetCommandObjectId()
   nwn.engine.SetCommandObjectId(self)

   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushString(resref)
   nwn.engine.ExecuteCommand(417, 2)

   nwn.engine.SetCommandObjectId(temp)
end
