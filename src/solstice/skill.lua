-----------------------------------------------
-- Translating NWN constants:
--
-- + 
--
-- @module skill

local ffi = require 'ffi'
local bit = require 'bit'
local C = ffi.C
local TLK = require 'solstice.tlk'

local M = {}
M.const = {
   ANIMAL_EMPATHY   = 0,
   CONCENTRATION    = 1,
   DISABLE_TRAP     = 2,
   DISCIPLINE       = 3,
   HEAL             = 4,
   HIDE             = 5,
   LISTEN           = 6,
   LORE             = 7,
   MOVE_SILENTLY    = 8,
   OPEN_LOCK        = 9,
   PARRY            = 10,
   PERFORM          = 11,
   PERSUADE         = 12,
   PICK_POCKET      = 13,
   SEARCH           = 14,
   SET_TRAP         = 15,
   SPELLCRAFT       = 16,
   SPOT             = 17,
   TAUNT            = 18,
   USE_MAGIC_DEVICE = 19,
   APPRAISE         = 20,
   TUMBLE           = 21,
   CRAFT_TRAP       = 22,
   BLUFF            = 23,
   INTIMIDATE       = 24,
   CRAFT_ARMOR      = 25,
   CRAFT_WEAPON     = 26,
   RIDE             = 27,
   LAST             = 27,
   ALL              = 255,

   SUB_FLAGTRAP      = 100,
   SUB_RECOVERTRAP   = 101,
   SUB_EXAMINETRAP   = 102,
}
setmetatable(M, { __index = M.const })
--- Get skill's associated ability.
-- @return solstice.ability type constant
function M.GetAbility(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return -1 end

   return sk.sk_ability
end

function M.GetHasArmorCheckPenalty(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return false end

   return sk.sk_armor_check ~= 0
end

function M.GetName(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return "" end

   return TLK.GetString(sk.sk_name_strref)
end

return M