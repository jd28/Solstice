--- Effects module
-- @module effect
-- @alias M

local ffi = require 'ffi'
local C   = ffi.C

local M = require 'solstice.effect.init'
require 'solstice.effect.creation'

local Effect = {}
M.Effect = Effect

local effect_mt = {
   __index = Effect,
   __gc = function(eff)
      if not eff.direct and eff.eff ~= nil then
         C.free(eff.eff)
      end
   end
}

-- Internal ctype.
M.effect_t = ffi.metatype("Effect", effect_mt)

--- Class Effect
-- @section sol_effect_Effect

--- Converts an effect to a formatted string.
function Effect:ToString()
   local t = {}
   local fmt = "Id: %d, Type: %d, Subtype: %d, Duration Type: %d, Duration %.2f Integers: "

   table.insert(t, string.format("Id: %d", self:GetId()))
   local cre = self:GetCreator()
   table.insert(t, string.format("Creator: %X", cre.id))
   table.insert(t, string.format("Spell Id: %d", self:GetSpellId()))
   table.insert(t, string.format("Type: %d", self:GetType()))
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
    return Game.GetObjectByID(self.eff.eff_creator)
end

--- Gets the duration of an effect.
-- Returns the duration specified when applied for
-- the effect. The value of this is undefined for effects which are
-- not of DURATION_TYPE_TEMPORARY.
-- Source: nwnx_structs by Acaos
function Effect:GetDuration ()
   return self.eff.eff_duration
end

--- Gets the remaing duration of an effect
-- Returns the remaining duration of the specified effect. The value
-- of this is undefined for effects which are not of
-- DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function Effect:GetDurationRemaining ()
   local current = C.nwn_GetWorldTime(nil, nil)
   local expire = self.eff.eff_expire_time
   expire = (expire * 2880000LL) + self.eff.eff_expire_time
   return expire - current / 1000.0
end

--- Get duration type
-- @return DURATION_TYPE_*
function Effect:GetDurationType()
   return bit.band(self.eff.eff_dursubtype, 0x7)
end

--- Get float
-- @param index Index
function Effect:GetFloat(index)
   return self.eff.eff_floats[index]
end

--- Gets the specifed effects Id
function Effect:GetId()
   return self.eff.eff_id
end

--- Determines whether an effect is valid.
function Effect:GetIsValid()
   return self.eff.eff_type ~= EFFECT_TYPE_INVALID
end

--- Returns the internal effect integer at the index specified.
-- @param index The index.
function Effect:GetInt(index)
   if index < 0 or index >= self.eff.eff_num_integers then
      print(debug.traceback())
      error "Effect integer index is out of bounds."
   end
   return self.eff.eff_integers[index]
end

--- Get effect object
-- @param index Index to store the string.  [0, 3]
function Effect:GetObject(index)
   if index < 0 or index > 3 then
      error "Effect:GetObject must be between 0 and 3"
   end
   return Game.GetObjectByID(self.eff.eff_objects[index])
end

--- Gets Spell Id associated with effect
function Effect:GetSpellId()
   return self.eff.eff_spellid
end

--- Gets a string on an effect.
-- @param index Index to store the string.  [0, 5]
function Effect:GetString(index)
   if index < 0 or index > 5 then
      error "Effect:SetString must be between 0 and 5"
   end
   return ffi.string(self.eff.eff_strings[index].text)
end

--- Get the subtype of the effect.
-- @return SUBTYPE_*
function Effect:GetSubType()
   return bit.band(self.eff.eff_dursubtype, 0x18)
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:GetType()
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

--- Set effect float
-- @param index Index. [0, 3]
-- @param float Float
function Effect:SetFloat(index, float)
   if index < 0 or index > 3 then
      error "Effect:SetObject must be between 0 and 3"
   end
   self.eff.eff_floats[index] = float
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

--- Set effect object
-- @param index Index. [0, 3]
-- @param object Object
function Effect:SetObject(index, object)
   if index < 0 or index > 3 then
      error "Effect:SetObject must be between 0 and 3"
   end
   self.eff.eff_objects[index] = object.id
end

--- Sets the effect's spell id as specified, which will later be returned
-- with Effect:GetSpellId(). Source: nwnx_structs by Acaos
function Effect:SetSpellId (spellid)
   self.eff.eff_spellid = spellid
end

--- Sets a string on an effect.
-- @param index Index to store the string.  [0, 5]
-- @param str String to store.
function Effect:SetString(index, str)
   if index < 0 or index > 5 then
      error "Effect:SetString must be between 0 and 5"
   end
   self.eff.eff_strings[index].text = C.strdup(str)
   self.eff.eff_strings[index].len = #str
end

--- Set the subtype of the effect.
-- @param value SUBTYPE_*
function Effect:SetSubType(value)
   self.eff.eff_dursubtype = bit.bor(value, self:GetDurationType())
   return self.eff.eff_dursubtype
end

--- Sets effects type.
-- @param value EFFECT_TYPE_*
function Effect:SetType(value)
   if not value then
      error(debug.traceback())
   end
   self.eff.eff_type = value
   return self.eff.eff_type
end

--- Set exposed.
-- @bool val Value
function Effect:SetExposed(val)
   self.eff.eff_is_exposed = val and 1 or 0
end

--- Set icon shown.
-- @bool val Value
function Effect:SetIconShown(val)
   self.eff.eff_is_iconshown = val and 1 or 0
end

return M
