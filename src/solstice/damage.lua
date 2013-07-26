local M = {}
M.const = require 'solstice.damage.constant'
setmetatable(M, { __index = M.const })

local IPC = require 'solstice.itemprop.constant'

--- Convert damage type constant to item property damage constant.
function M.ConvertToItempropConstant(const)
   if const == M.BLUDGEONING then
      return IPC.DAMAGE_BLUDGEONING
   elseif const == M.PIERCING then
      return IPC.DAMAGE_PIERCING
   elseif const == M.SLASHING then
      return IPC.DAMAGE_SLASHING
   elseif const == M.MAGICAL then
      return IPC.DAMAGE_MAGICAL
   elseif const == M.ACID then
      return IPC.DAMAGE_ACID
   elseif const == M.COLD then
      return IPC.DAMAGE_COLD
   elseif const == M.DIVINE then
      return IPC.DAMAGE_DIVINE
   elseif const == M.ELECTRICAL then
      return IPC.DAMAGE_ELECTRICAL
   elseif const == M.FIRE then
      return IPC.DAMAGE_FIRE
   elseif const == M.NEGATIVE then
      return IPC.DAMAGE_NEGATIVE
   elseif const == M.POSITIVE then
      return IPC.DAMAGE_POSITIVE
   elseif const == M.SONIC then
      return IPC.DAMAGE_SONIC
   else 
      error "Unable to convert damage contant to damage IP constant."
   end
end


return M
