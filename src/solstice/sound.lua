--- Sound
-- @module sound

local ffi = require 'ffi'
local Obj = require 'solstice.object'
local NWE = require 'solstice.nwn.engine'

local M = {}
local Sound = inheritsFrom({}, Obj.Object)
M.Sound = Sound

-- Internal ctype.
M.sound_t = ffi.metatype("Sound", { __index = M.Sound })

function M.Sound:Play()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(413, 1)
end

function M.Sound:Stop()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(414, 1)
end

function M.Sound:SetVolume(volume)
   NWE.StackPushInteger(volume)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(415, 2);
end

function M.Sound:SetPosition(position)
   NWE.StackPushVector(position)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(416, 2)
end

return M
