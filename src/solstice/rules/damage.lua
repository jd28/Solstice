--- Rules
-- @module rules

local TLK = require 'solstice.tlk'
local TDA = require 'solstice.2da'
local Color = require 'solstice.color'
local C = require ('ffi').C

--- Damages
-- @section damages

local function GetDamageName(index)
   return TLK.GetString(TDA.Get2daInt('damages', 'Name', index))
end

local function GetDamageColor(index)
   return Color.Encode(TDA.Get2daInt('damages', 'R', index),
                       TDA.Get2daInt('damages', 'G', index),
                       TDA.Get2daInt('damages', 'B', index))
end

for i=0, DAMAGE_INDEX_NUM - 1 do
   C.Local_SetDamageInfo(i, GetDamageName(i), GetDamageColor(i))
end

local M = require 'solstice.rules.init'
M.GetDamageName = GetDamageName
M.GetDamageColor = GetDamageColor
