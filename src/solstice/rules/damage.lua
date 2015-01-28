--- Rules
-- @module rules

local TLK = require 'solstice.tlk'
local TDA = require 'solstice.2da'
local Color = require 'solstice.color'
local ffi = require 'ffi'
local C = ffi.C

--- Damages
-- @section damages

local function GetDamageName(index)
   return TLK.GetString(TDA.GetInt('damages', 'Name', index))
end

local function GetDamageColor(index)
   return Color.Encode(TDA.GetInt('damages', 'R', index),
                       TDA.GetInt('damages', 'G', index),
                       TDA.GetInt('damages', 'B', index))
end

local DMG_VFX = {}
for i = 0, TDA.GetRowCount("damagehitvisual") - 1 do
   DMG_VFX[i] = TDA.GetInt("damagehitvisual", "VisualEffectID", i)
end

--- Get damage impact visual.
-- See damagehitvisual.2da
-- @param dmg DAMAGE\_INDEX\_*
local function GetDamageVisual(dmg)
   return DMG_VFX[dmg] or 0
end

--- Convert damage type constant to item property damage constant.
local function ConvertDamageToItempropConstant(const)
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
local function ConvertDamageIndexToItempropConstant(const)
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
local function ConvertItempropConstantToDamageIndex(const)
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

local _ROLLS
local _ROLLS_LEN = 0
local function UnpackItempropDamageRoll(ip)
   if _ROLLS_LEN == 0 then
      local tda = TDA.GetCached2da("iprp_damagecost")
      if tda == nil then error "Unable to locate iprp_damagecost.2da!" end

      _ROLLS_LEN = TDA.GetRowCount(tda)
      _ROLLS = ffi.new("DiceRoll[?]", _ROLLS_LEN)

      for i=1, TDA.GetRowCount(tda) - 1 do

         local d = TDA.GetInt(tda, "NumDice", i)
         local s = TDA.GetInt(tda, "Die", i)
         if d == 0 then
            _ROLLS[i].dice, _ROLLS[i].sides, _ROLLS[i].bonus = 0, 0, s
         else
            _ROLLS[i].dice, _ROLLS[i].sides, _ROLLS[i].bonus = d, s, 0
         end
      end
   end

   if ip < 0 or ip >= _ROLLS_LEN then
      error(string.format("Invalid IP Const: %d, %s", ip, debug.traceback()))
   end

   return _ROLLS[ip].dice, _ROLLS[ip].sides, _ROLLS[ip].bonus

end

local _MONSTER_ROLLS
local _MONSTER_ROLLS_LEN = 0
local function UnpackItempropMonsterRoll(ip)
   if _MONSTER_ROLLS_LEN == 0 then
      local tda = TDA.GetCached2da("iprp_monstcost")
      if tda == nil then error "Unable to locate iprp_monstcost!" end

      _MONSTER_ROLLS_LEN = TDA.GetRowCount(tda)
      _MONSTER_ROLLS = ffi.new("DiceRoll[?]", _ROLLS_LEN)

      for i=1, TDA.GetRowCount(tda) - 1 do

         local d = TDA.GetInt(tda, "NumDice", i)
         local s = TDA.GetInt(tda, "Die", i)
         if d == 0 then
            _MONSTER_ROLLS[i].dice, _MONSTER_ROLLS[i].sides, _MONSTER_ROLLS[i].bonus = 0, 0, s
         else
            _MONSTER_ROLLS[i].dice, _MONSTER_ROLLS[i].sides, _MONSTER_ROLLS[i].bonus = d, s, 0
         end
      end
   end

   if ip < 0 or ip >= _MONSTER_ROLLS_LEN then
      error(string.format("Invalid IP Const: %d, %s", ip, debug.traceback()))
   end

   return _MONSTER_ROLLS[ip].dice, _MONSTER_ROLLS[ip].sides, _MONSTER_ROLLS[ip].bonus
end
for i=0, DAMAGE_INDEX_NUM - 1 do
   C.Local_SetDamageInfo(i, GetDamageName(i), GetDamageColor(i))
end

local M = require 'solstice.rules.init'
M.GetDamageName = GetDamageName
M.GetDamageColor = GetDamageColor
M.GetDamageVisual = GetDamageVisual
M.ConvertDamageToItempropConstant = ConvertDamageToItempropConstant
M.ConvertDamageIndexToItempropConstant = ConvertDamageIndexToItempropConstant
M.ConvertItempropConstantToDamageIndex = ConvertItempropConstantToDamageIndex
M.UnpackItempropDamageRoll = UnpackItempropDamageRoll
M.UnpackItempropMonsterRoll = UnpackItempropMonsterRoll
