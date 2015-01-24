local Hook = require 'solstice.hooks'

-- Hook CNWSCreature::GetTotalEffectBonus, print the parameters and return -2
-- for everything if a global `is_april_fools` is not false, else it calls and returns the
-- value from the original function.

local GetTotalEffectBonus_orig
local function Hook_GetTotalEffectBonus(cre, eff_switch , versus, elemental,
                                        is_crit, save, save_vs, skill,
                                        ability, is_offhand)

   print(cre, eff_switch , versus, elemental,
         is_crit, save, save_vs, skill,
         ability, is_offhand)

   if is_april_fools then
      return -2
   else
      -- If you want to inspect parameters and just call the original function you can:
      return GetTotalEffectBonus_orig(cre, eff_switch , versus, elemental,
                                      is_crit, save, save_vs, skill,
                                      ability, is_offhand)
   end
end

GetTotalEffectBonus_orig = Hook.hook {
   address = 0x08132298,
   func = Hook_GetTotalEffectBonus,
   type = "int (*)(CNWSCreature *, uint8_t, CNWSObject *, int32_t, int32_t, uint8_t, uint8_t, uint8_t, uint8_t, int32_t)",
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE),
   length = 5
}
