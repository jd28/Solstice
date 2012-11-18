local NWNXEvents = require 'nwnx.events'

NWNXEvents.RegisterEventHandler(
   NWNXEvents.EVENT_TYPE_ATTACK,
   function (ev)
      local obj = ev.object
      local mode = obj:GetLocalInt("AI_TOGGLE_MODE")
      if mode > 0 then
         obj:SetCombatMode(mode)
      end

      return true
   end)
