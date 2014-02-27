---
-- @module creature

--- AI
-- @section AI

--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local M = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'

--- Gets creature's AI level.
function M.Creature:GetAILevel()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(712, 1)
   return NWE.StackPopInteger()
end

--- Sets creature's AI level.
-- @param ai_level solstice.ai.LEVEL_*
function M.Creature:SetAILevel(ai_level)
   NWE.StackPushInteger(ai_level);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(713, 2);
end
