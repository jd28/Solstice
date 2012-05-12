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

require 'nwn.ctypes.effect'
require 'nwn.effects.creation'
require 'nwn.effects.custom'

local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
typedef struct Effect {
    CGameEffect     *eff;
    bool            direct;
} Effect;
]]

local effect_mt = { __index = Effect,
                    __gc = function(eff) 
                       if not eff.direct and eff.eff ~= nil then
                          C.free(eff.eff)
                       end
                    end
}

effect_t = ffi.metatype("Effect", effect_mt)

--- Returns effect's creator.
function Effect:GetCreator()
    return _NL_GET_CACHED_OBJECT(self.eff.eff_creator)
end

--- Gets the duration of an effect.
-- Returns the duration specified when applied for
-- the effect. The value of this is undefined for effects which are
-- not of nwn.DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function Effect:GetDuration ()
   return self.eff.eff_duration
end

--- Gets the remaing duration of an effect
-- Returns the remaining duration of the specified effect. The value
-- of this is undefined for effects which are not of
-- nwn.DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function Effect:GetDurationRemaining ()
   local current = ffi.C.nwn_GetWorldTime(nil, nil)
   local expire = self.eff.eff_expire_time
   expire = (expire * 2880000LL) + self.eff.eff_expire_time
   return expire - current / 1000.0
end 

--- Get duration type
-- @return nwn.DURATION_TYPE_*
function Effect:GetDurationType()
   return bit.band(self.eff.eff_dursubtype, 0x7)
end

--- Gets the specifed effects Id
function Effect:GetId()
   return self.eff.eff_id
end

--- Determines whether an effect is valid.
function Effect:GetIsValid()
    nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, self)
    nwn.engine.ExecuteCommand(88, 1)
    return nwn.engine.StackPopBoolean()
end

--- Returns the internal effect integer at the index specified.
-- @param index The index is limited to being between 0 and 15, and which index contains what
-- value depends entirely on the type of effect.  Source: nwnx_structs by Acaos
function Effect:GetInt(index)
   if index < 0 or index > self.eff.eff_num_integers then
      error "Effect integer index is out of bounds."
      return -1
   end
   return self.eff.eff_integers[index]
end

--- Gets Spell Id associated with effect
function Effect:GetSpellId()
   return self.eff.eff_spellid
end

--- Get the subtype of the effect.
-- @return nwn.SUBTYPE_*
function Effect:GetSubType()
   return bit.band(self.eff.eff_dursubtype, 0xFFF8)
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:GetTrueType()
   if self.eff.eff_type == nwn.EFFECT_TRUETYPE_MODIFYNUMATTACKS then
      return self:GetInt(0)
   end

   return self.eff.eff_type
end

--- Sets the effects creator
-- @param object 
function Effect:SetCreator(object)
    self.eff.eff_creator = object.id
end

function Effect:SetDuration(dur)
   self.eff.eff_duration = dur
   return self.eff.eff_duration
end

function Effect:SetDurationType(dur)
   self.eff.eff_dursubtype = bit.bor(dur, bit.band(self.eff.eff_dursubtype, 0xFFF8))
   return self.eff.eff_dursubtype
end

--- Sets the internal effect integer at the specified index to the
-- value specified. Source: nwnx_structs by Acaos
function Effect:SetInt(index, value)
   if index < 0 or index > self.eff.eff_num_integers then
      return -1
   end
   self.eff.eff_integers[index] = value
   return self.eff.eff_integers[index]
end

---
function Effect:SetNumIntegers(num)
   C.nwn_EffectSetNumIntegers(self.eff, num)
end

--- Sets the effect's spell id as specified, which will later be returned
-- with Effect:GetSpellId(). Source: nwnx_structs by Acaos
function Effect:SetSpellId (spellid)
   self.eff.eff_spellid = spellid
end

---
function Effect:SetString(index, str)
   if index < 0 or index > 5 then
      error "Effect:SetString must be between 0 and 5"
      return
   end
   self.eff.eff_strings[index].text = C.strdup(str)
   self.eff.eff_strings[index].len = #str
end

--- Set the subtype of the effect.
-- @param value nwn.SUBTYPE_*
function Effect:SetSubType(value)
   self.eff.eff_dursubtype = bit.bor(value, bit.band(self.eff.eff_dursubtype, 0x7))
   return self.eff.eff_dursubtype
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:SetTrueType(value)
   self.eff.eff_type = value
   return self.eff.eff_type
end

function Effect:SetVersusAlignment(lawchaos, goodevil)
   local lcidx
   local geidx
   local type = self.eff.eff_type
   lawchaos = lawchaos or nwn.ALIGNMENT_ALL
   goodevil = goodevil or nwn.ALIGNMENT_ALL

   if type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE
      or type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE
      or type == nwn.EFFECT_TRUETYPE_AC_INCREASE
      or type == nwn.EFFECT_TRUETYPE_AC_DECREASE
      or type == nwn.EFFECT_TRUETYPE_SKILL_INCREASE
      or type == nwn.EFFECT_TRUETYPE_SKILL_DECREASE 
   then
      lcidx, geidx = 3, 4
   elseif type == nwn.EFFECT_TRUETYPE_CONCEALMENT 
      or type == nwn.EFFECT_TRUETYPE_IMMUNITY 
      or type == nwn.EFFECT_TRUETYPE_INVISIBILITY
      or type == nwn.EFFECT_TRUETYPE_SANCTUARY
   then
      lcidx, geidx = 2, 3
   else
      error(string.format("Effect Type (%d) does not support versus alignment", type))
      return
   end

   self:SetInt(lcidx, lawchaos)
   self:SetInt(geidx, goodevil)
end

function Effect:SetVersusDeity(deity)
   local idx
   local type = self.eff.eff_type

   if type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_DECREASE 
   then
      idx = 6
   elseif type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_AC_INCREASE
      or type == nwn.EFFECT_TRUETYPE_AC_DECREASE
   then
      idx = 7
   elseif type == nwn.EFFECT_TRUETYPE_IMMUNITY then
      
   else
      error(string.format("Effect Type (%d) does not support versus deity", type))
      return
   end

   self:SetInt(idx, deity)
end

function Effect:SetVersusRace(race)
   local idx
   local type = self.eff.eff_type

  if type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE
      or type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE
      or type == nwn.EFFECT_TRUETYPE_AC_INCREASE
      or type == nwn.EFFECT_TRUETYPE_AC_DECREASE
      or type == nwn.EFFECT_TRUETYPE_SKILL_INCREASE
      or type == nwn.EFFECT_TRUETYPE_SKILL_DECREASE 
   then
      idx = 2
   elseif type == nwn.EFFECT_TRUETYPE_CONCEALMENT 
      or type == nwn.EFFECT_TRUETYPE_IMMUNITY 
      or type == nwn.EFFECT_TRUETYPE_INVISIBILITY
      or type == nwn.EFFECT_TRUETYPE_SANCTUARY
   then
      idx = 1
      error(string.format("Effect Type (%d) does not support versus race", type))
      return
   end

   self:SetInt(idx, race)
end

function Effect:SetVersusSubrace(subrace)
   local idx
   local type = self.eff.eff_type

   if type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_DECREASE 
   then
      idx = 5
   elseif type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_AC_INCREASE
      or type == nwn.EFFECT_TRUETYPE_AC_DECREASE
   then
      idx = 6
   elseif type == nwn.EFFECT_TRUETYPE_CONCEALMENT then
   elseif type == nwn.EFFECT_TRUETYPE_IMMUNITY then
   else
      error(string.format("Effect Type (%d) does not support versus subrace", type))
      return
   end

   self:SetInt(idx, subrace)
end

function Effect:SetVersusTarget(target)
   if not target:GetIsValid() then return end

   local idx
   local type = self.eff.eff_type

   if type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_INCREASE 
      or type == nwn.EFFECT_TRUETYPE_SKILL_DECREASE 
   then
      idx = 7
   elseif type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE
      or type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE 
      or type == nwn.EFFECT_TRUETYPE_AC_INCREASE
      or type == nwn.EFFECT_TRUETYPE_AC_DECREASE
   then
      idx = 8
   elseif type == nwn.EFFECT_TRUETYPE_IMMUNITY then
   else
      error(string.format("Effect Type (%d) does not support versus target", type))
      return
   end

   self:SetInt(idx, target.id)
end