--- NWNX Combat
-- @module nwnx.combat

local Mod = require 'solstice.module'

local M = {}

M.INFO_INVALID       = 0
M.INFO_ARMOR_CLASS   = 0x1
M.INFO_HITPOINTS     = 0x2
M.INFO_CONCEALMENT   = 0x4
M.INFO_RESISTANCE    = 0x8
M.INFO_REDUCTION     = 0x10
M.INFO_IMMUNITY      = 0x20
M.INFO_DEFENSE       = 0x3F

M.INFO_WEAPONS       = 0x40
M.INFO_ATTACKS       = 0x80
M.INFO_IMMUNITY_MISC = 0x100

function M.InitializeTables()
   local mod = Mod.Get()
   mod:SetLocalString("NWNX!COMBAT!INIT_TABLES", " ")
end

function M.GetMaxHitPoints(obj)
   obj:SetLocalString("NWNX!COMBAT!GETMAXHITPOINTS", " ")
end

function M.GetSkillRank(obj, skill, vs, base)
   vs = vs and vs.id or 0x7f000000
   base = base and 1 or 0

   obj:SetLocalString("NWNX!COMBAT!GETSKILLRANK", string.format("%d %x %d", skill, vs, base))
   return tonumber(obj:GetLocalString("NWNX!COMBAT!GETSKILLRANK"))
end

function M.Log(obj)
   obj:SetLocalString("NWNX!COMBAT!DUMBCOMBATMODS", " ")
end

function M.SendCombatInfo(obj)
   obj:SetLocalString("NWNX!COMBAT!GETCOMBATINFO", " ")
end

function M.SendCombatInfo(obj, flags)
   flags = flags or M.INFO_INVALID
   obj:SetLocalString("NWNX!COMBAT!SENDCOMBATINFO",
		      tostring(flags))
end

function M.SendDamageRoll(obj, equip, is_crit)
   local crit = is_crit and 1 or 0
   obj:SetLocalString("NWNX!COMBAT!SENDDAMAGEROLL",
		      string.format("%d %d", equip, crit))
end

function M.Update(obj)
   obj:SetLocalString("NWNX!COMBAT!UPDATE", " ")
end

return M