--- Rules module.
-- Globally exported as `Rules`.
-- @alias M

local ffi = require 'ffi'
local bit = require 'bit'
local C = ffi.C

local M = require 'solstice.rules.init'
safe_require 'solstice.rules.ability'
safe_require 'solstice.rules.classes'
safe_require 'solstice.rules.combatmods'
safe_require 'solstice.rules.combat'
safe_require 'solstice.rules.conceal'
safe_require 'solstice.rules.constants'
safe_require 'solstice.rules.damage'
safe_require 'solstice.rules.dmgred'
safe_require 'solstice.rules.effects'
safe_require 'solstice.rules.feats'
safe_require 'solstice.rules.hitpoints'
safe_require 'solstice.rules.immunities'
safe_require 'solstice.rules.modes'
safe_require 'solstice.rules.races'
safe_require 'solstice.rules.saves'
safe_require 'solstice.rules.situations'
safe_require 'solstice.rules.specattack'
safe_require 'solstice.rules.skills'
safe_require 'solstice.rules.weapons'
safe_require 'solstice.rules.levels'



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
