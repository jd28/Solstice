require 'nwn.ctypes.effect'
require 'nwn.effects.creation'

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

function nwn.CreateEffect(ints, show_icon)
   ints = ints or 10
   show_icon = show_icon or 0
   local eff = effect_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetCreator(nwn.engine.GetCommandObject())
   eff:SetNumIntegers(ints)
   eff:SetAllInts(0)
   eff:SetSubType(nwn.SUBTYPE_MAGICAL)
   eff:SetDurationType(nwn.DURATION_TYPE_PERMANENT)

   return eff
end

--- Converts an effect to a formatted string.
function Effect:ToString()
   local t = {}
   local fmt = "Id: %d, Type: %d, Subtype: %d, Duration Type: %d, Duration %.2f Integers: "

   table.insert(t, string.format("Id: %d", self:GetId()))
   local cre = self:GetCreator()
   table.insert(t, string.format("Creator: %X", cre.id))
   table.insert(t, string.format("Spell Id: %d", self:GetSpellId()))
   table.insert(t, string.format("Type: %d", self:GetTrueType()))
   table.insert(t, string.format("Subtype: %d", self:GetSubType()))
   table.insert(t, string.format("Duration Type: %d", self:GetDurationType()))
   table.insert(t, string.format("Duration: %.2f", self:GetDuration()))

   ints = {}
   for i = 0, self.eff.eff_num_integers - 1 do
      table.insert(ints, string.format("%d: %d", i, self:GetInt(i)))
   end

   table.insert(t, string.format("Integers: %s", table.concat(ints, ", ")))

   return table.concat(t, "\n")
end

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
   local current = C.nwn_GetWorldTime(nil, nil)
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
   if index < 0 or index >= self.eff.eff_num_integers then
      print(debug.traceback())
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
   return bit.band(self.eff.eff_dursubtype, 0x18)
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:GetTrueType()
   return self.eff.eff_type
end

--- Set all integers to a specified value
function Effect:SetAllInts(val)
   for i = 0, self.eff.eff_num_integers - 1 do
      self:SetInt(i, val)
   end
end

--- Sets the effects creator
-- @param object 
function Effect:SetCreator(object)
   if type(object) == "number" then
      self.eff.eff_creator = object
   else
      self.eff.eff_creator = object.id
   end
end

function Effect:SetDuration(dur)
   self.eff.eff_duration = dur
   return self.eff.eff_duration
end

function Effect:SetDurationType(dur)
   self.eff.eff_dursubtype = bit.bor(dur, self:GetSubType())
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

--- Set number of integers stored on an effect.
-- Calling this on an effect will erase any integers already stored on the effect.
-- @param num Number of integers.
function Effect:SetNumIntegers(num)
   C.nwn_EffectSetNumIntegers(self.eff, num)
end

--- Sets the effect's spell id as specified, which will later be returned
-- with Effect:GetSpellId(). Source: nwnx_structs by Acaos
function Effect:SetSpellId (spellid)
   self.eff.eff_spellid = spellid
end

--- Sets a string on an effect.
-- @param idx Index to store the string.  [0, 5]
-- @param str String to store.
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
   self.eff.eff_dursubtype = bit.bor(value, self:GetDurationType())
   return self.eff.eff_dursubtype
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:SetTrueType(value)
   self.eff.eff_type = value
   return self.eff.eff_type
end

--- Sets an effect versus a specified alignment
-- @param lawchaos (Default: nwn.ALIGNMENT_ALL)
-- @param goodevil (Default: nwn.ALIGNMENT_ALL)
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

--- Set an effect versus a specified deity.
-- @param subrace An integer value indicating a deity id.
--    This value is server dependent.
-- @see Creature:GetDeityId()
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

--- Sets an effect 'versus' a percentage.
-- That is the effect has a specified % of being applicable.
-- A value of 60% would mean that the creature must roll a 1d100 <= 60.
-- @param perc Percent: [0, 100).  Value 0 is always applicable.
function Effect:SetVersusPercentage(perc)
   if perc < 0 or perc >= 100 then
      error "Versus percentage takes a value [0, 100)"
   end

   local idx
   local type = self.eff.eff_type

   if type == nwn.EFFECT_TRUETYPE_IMMUNITY then
      idx = 1
   else
      error(string.format("Effect Type (%d) does not support versus subrace", type))
      return
   end

   self:SetInt(idx, subrace)
end

--- Sets an effect versus a race
-- @param race nwn.RACIAL_TYPE_*
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

--- Set an effect versus a specified subrace.
-- @param subrace An integer value indicating a subrace id.
--    This value is server dependent.
-- @see Creature:GetSubraceId()
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

--- Sets an effect versus a particular target.
-- @param target Target creature.
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

function nwn.CreateEffectAmountFunc(index)
   return function (eff)
             return eff:GetInt(index)
	  end
end

function nwn.CreateEffectRangeFunc(start, stop)
   return function (type)
             return type == start or type == stop
	  end
end

--- Determine which of two damage reduction effects are better.
-- The effects are assumed to have the same damage power.
-- @param eff1 An effect.
-- @param eff2 An effect.
function nwn.DetermineBestReductionEffect(eff1, eff2)
   local amount = eff1.eff.eff_integers[0]
   local limit = eff1.eff.eff_integers[2]

   local amount2 = eff1.eff.eff_integers[0]
   local limit2 = eff1.eff.eff_integers[2]
   
   -- If the soak amount is higher or if they are equal prefer the one
   -- with the highest damage limit.
   if amount > amount2
      or (amount == amount2 and limit > limit2)
   then
      return eff1
   else
      return eff2
   end
end

--- Determine which of two damage resistance effects are better.
-- @param eff1 An effect.
-- @param eff2 An effect.
function nwn.DetermineBestResistEffect(eff1, eff2)
   local amount = eff1.eff.eff_integers[1]
   local limit = eff1.eff.eff_integers[2]

   local amount2 = eff2.eff.eff_integers[1]
   local limit2 = eff2.eff.eff_integers[2]
   
   -- If the resist amount is higher, set the resist effect list to the effect index.
   -- If they are equal prefer the one with the highest damage limit.
   if amount > amount2
      or (amount == amount2 and limit > limit2)
   then
      return eff1
   else
      return eff2
   end
end

