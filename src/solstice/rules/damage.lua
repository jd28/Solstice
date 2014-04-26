--- Rules
-- @module rules

local TLK = require 'solstice.tlk'
local TDA = require 'solstice.2da'

--- Damages
-- @section damages

local function GetDamageName(index)
   return TLK.GetString(TDA.Get2daInt('damages', 'Name', index))
end

local M = require 'solstice.rules.init'
M.GetDamageName = GetDamageName
