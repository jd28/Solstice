--- Rules module.
-- Globally exported as `Rules`.
-- @alias M

local ffi = require 'ffi'
local bit = require 'bit'
local C = ffi.C
local TLK = require 'solstice.tlk'

local M = require 'solstice.rules.init'
safe_require 'solstice.rules.ability'
safe_require 'solstice.rules.classes'
safe_require 'solstice.rules.combatmods'
safe_require 'solstice.rules.conceal'
safe_require 'solstice.rules.constants'
safe_require 'solstice.rules.damage'
safe_require 'solstice.rules.dmgred'
safe_require 'solstice.rules.feats'
safe_require 'solstice.rules.hitpoints'
safe_require 'solstice.rules.immunities'
safe_require 'solstice.rules.modes'
safe_require 'solstice.rules.polymorph'
safe_require 'solstice.rules.races'
safe_require 'solstice.rules.situations'
safe_require 'solstice.rules.specattack'
safe_require 'solstice.rules.skills'
safe_require 'solstice.rules.weapons'
safe_require 'solstice.rules.levels'

local TDA = require 'solstice.2da'

local DMG_VFX = {}
for i = 0, TDA.Get2daRowCount("damagehitvisual") - 1 do
   DMG_VFX[i] = TDA.Get2daInt("damagehitvisual", "VisualEffectID", i)
end

--- Get damage impact visual.
-- See damagehitvisual.2da
-- @param dmg DAMAGE\_INDEX\_*
function M.GetDamageVisual(dmg)
   return DMG_VFX[dmg] or 0
end

--- Convert damage type constant to item property damage constant.
function M.ConvertDamageToItempropConstant(const)
   if const == DAMAGE_TYPE_BLUDGEONING then
      return IP_CONST_DAMAGE_BLUDGEONING
   elseif const == DAMAGE_TYPE_PIERCING then
      return IP_CONST_DAMAGE_PIERCING
   elseif const == DAMAGE_TYPE_SLASHING then
      return IP_CONST_DAMAGE_SLASHING
   elseif const == DAMAGE_TYPE_MAGICAL then
      return IP_CONST_DAMAGE_MAGICAL
   elseif const == DAMAGE_TYPE_ACID then
      return IP_CONST_DAMAGE_ACID
   elseif const == DAMAGE_TYPE_COLD then
      return IP_CONST_DAMAGE_COLD
   elseif const == DAMAGE_TYPE_DIVINE then
      return IP_CONST_DAMAGE_DIVINE
   elseif const == DAMAGE_TYPE_ELECTRICAL then
      return IP_CONST_DAMAGE_ELECTRICAL
   elseif const == DAMAGE_TYPE_FIRE then
      return IP_CONST_DAMAGE_FIRE
   elseif const == DAMAGE_TYPE_NEGATIVE then
      return IP_CONST_DAMAGE_NEGATIVE
   elseif const == DAMAGE_TYPE_POSITIVE then
      return IP_CONST_DAMAGE_POSITIVE
   elseif const == DAMAGE_TYPE_SONIC then
      return IP_CONST_DAMAGE_SONIC
   else
      error "Unable to convert damage contant to damage IP constant."
   end
end

--- Convert damage type constant to item property damage constant.
function M.ConvertDamageIndexToItempropConstant(const)
   if const == DAMAGE_INDEX_BLUDGEONING then
      return IP_CONST_DAMAGE_BLUDGEONING
   elseif const == DAMAGE_INDEX_PIERCING then
      return IP_CONST_DAMAGE_PIERCING
   elseif const == DAMAGE_INDEX_SLASHING then
      return IP_CONST_DAMAGE_SLASHING
   elseif const == DAMAGE_INDEX_MAGICAL then
      return IP_CONST_DAMAGE_MAGICAL
   elseif const == DAMAGE_INDEX_ACID then
      return IP_CONST_DAMAGE_ACID
   elseif const == DAMAGE_INDEX_COLD then
      return IP_CONST_DAMAGE_COLD
   elseif const == DAMAGE_INDEX_DIVINE then
      return IP_CONST_DAMAGE_DIVINE
   elseif const == DAMAGE_INDEX_ELECTRICAL then
      return IP_CONST_DAMAGE_ELECTRICAL
   elseif const == DAMAGE_INDEX_FIRE then
      return IP_CONST_DAMAGE_FIRE
   elseif const == DAMAGE_INDEX_NEGATIVE then
      return IP_CONST_DAMAGE_NEGATIVE
   elseif const == DAMAGE_INDEX_POSITIVE then
      return IP_CONST_DAMAGE_POSITIVE
   elseif const == DAMAGE_INDEX_SONIC then
      return IP_CONST_DAMAGE_SONIC
   else
      error "Unable to convert damage contant to damage IP constant."
   end
end

--- Convert damage type constant to item property damage constant.
function M.ConvertItempropConstantToDamageIndex(const)
   if const == IP_CONST_DAMAGE_BLUDGEONING then
      return DAMAGE_INDEX_BLUDGEONING
   elseif const == IP_CONST_DAMAGE_PIERCING then
      return DAMAGE_INDEX_PIERCING
   elseif const == IP_CONST_DAMAGE_SLASHING then
      return DAMAGE_INDEX_SLASHING
   elseif const == IP_CONST_DAMAGE_MAGICAL then
      return DAMAGE_INDEX_MAGICAL
   elseif const == IP_CONST_DAMAGE_ACID then
      return DAMAGE_INDEX_ACID
   elseif const == IP_CONST_DAMAGE_COLD then
      return DAMAGE_INDEX_COLD
   elseif const == IP_CONST_DAMAGE_DIVINE then
      return DAMAGE_INDEX_DIVINE
   elseif const == IP_CONST_DAMAGE_ELECTRICAL then
      return DAMAGE_INDEX_ELECTRICAL
   elseif const == IP_CONST_DAMAGE_FIRE then
      return DAMAGE_INDEX_FIRE
   elseif const == IP_CONST_DAMAGE_NEGATIVE then
      return DAMAGE_INDEX_NEGATIVE
   elseif const == IP_CONST_DAMAGE_POSITIVE then
      return DAMAGE_INDEX_POSITIVE
   elseif const == IP_CONST_DAMAGE_SONIC then
      return DAMAGE_INDEX_SONIC
   else
      return 0
   end
end

function M.ConvertSaveToItempropConstant(const)
   if const == SAVING_THROW_FORT then
      return IP_CONST_SAVEBASETYPE_FORTITUDE
   elseif const == SAVING_THROW_REFLEX then
      return IP_CONST_SAVEBASETYPE_REFLEX
   elseif const == SAVING_THROW_WILL then
      return IP_CONST_SAVEBASETYPE_WILL
   else
      error "Unable to convert save contant to IP constant."
   end
end

function M.ConvertSaveVsToItempropConstant(const)
   if const == SAVING_THROW_VS_ALL then
      return IP_CONST_SAVEVS_UNIVERSAL
   elseif const == SAVING_THROW_VS_ACID then
      return IP_CONST_SAVEVS_ACID
   elseif const == SAVING_THROW_VS_COLD then
      return IP_CONST_SAVEVS_COLD
   elseif const == SAVING_THROW_VS_DEATH then
      return IP_CONST_SAVEVS_DEATH
   elseif const == SAVING_THROW_VS_DISEASE then
      return IP_CONST_SAVEVS_DISEASE
   elseif const == SAVING_THROW_VS_DIVINE then
      return IP_CONST_SAVEVS_DIVINE
   elseif const == SAVING_THROW_VS_ELECTRICITY then
      return IP_CONST_SAVEVS_ELECTRICAL
   elseif const == SAVING_THROW_VS_FEAR then
      return IP_CONST_SAVEVS_FEAR
   elseif const == SAVING_THROW_VS_FIRE then
      return IP_CONST_SAVEVS_FIRE
   elseif const == SAVING_THROW_VS_MIND_SPELLS then
      return IP_CONST_SAVEVS_MINDAFFECTING
   elseif const == SAVING_THROW_VS_NEGATIVE then
      return IP_CONST_SAVEVS_NEGATIVE
   elseif const == SAVING_THROW_VS_POISON then
      return IP_CONST_SAVEVS_POISON
   elseif const == SAVING_THROW_VS_POSITIVE then
      return IP_CONST_SAVEVS_POSITIVE
   elseif const == SAVING_THROW_VS_SONIC then
      return IP_CONST_SAVEVS_SONIC
   else
      error "Unable to convert save contant to IP constant."
   end
end

function M.ConvertImmunityToIPConstant(const)
   if const == IMMUNITY_TYPE_SNEAK_ATTACK then
      return IP_CONST_IMMUNITYMISC_BACKSTAB
   elseif const == IMMUNITY_TYPE_ABILITY_DECREASE then
      return IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN
   elseif const == IMMUNITY_TYPE_NEGATIVE_LEVEL then
      return IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN
   elseif const == IMMUNITY_TYPE_MIND_SPELLS then
      return IP_CONST_IMMUNITYMISC_MINDSPELLS
   elseif const == IMMUNITY_TYPE_POISON then
      return IP_CONST_IMMUNITYMISC_POISON
   elseif const == IMMUNITY_TYPE_DISEASE then
      return IP_CONST_IMMUNITYMISC_DISEASE
   elseif const == IMMUNITY_TYPE_FEAR then
      return IP_CONST_IMMUNITYMISC_FEAR
   elseif const == IMMUNITY_TYPE_KNOCKDOWN then
      return IP_CONST_IMMUNITYMISC_KNOCKDOWN
   elseif const == IMMUNITY_TYPE_PARALYSIS then
      return IP_CONST_IMMUNITYMISC_PARALYSIS
   elseif const == IMMUNITY_TYPE_CRITICAL_HIT then
      return IP_CONST_IMMUNITYMISC_CRITICAL_HITS
   elseif const == IMMUNITY_TYPE_DEATH then
      return IP_CONST_IMMUNITYMISC_DEATH_MAGIC
   else
      error "Unable to convert immunity contant to IP constant."
   end
end


return M
