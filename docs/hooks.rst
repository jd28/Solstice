.. highlight:: lua
.. module:: hooks

Hook
====

.. danger::

  Please note this is very advanced module.  Using it incorrectly will result in segfaults.  This is a very thin wrapper around the Acaos' NWNX `nx_hook_function` any documentation can probably (not) be found in the NWNX repository.

It allows you to hook nwserver functions and replace them with Lua functions directly. Note that the lua function and the original function returned by `hook` must be castable to the function pointer type passed in `HookDesc.type`, which means that the types of the parameters must be defined.  Currently not all types are defined, see src/solstice/nwn/ctypes for those that are.

Internally your hook is wrapped in an anonymous function which uses ``pcall``.  If for whatever reason your hook fails, the original function will be called.  This will mitigate most segfaults and also allows hook script files to be reloaded without requiring a server reboot.

Examples
--------

.. code-block:: lua
  :linenos:

  local Hook = require 'solstice.hooks'

  -- Hook CNWSCreature::GetTotalEffectBonus, print the parameters and return -2
  -- for everything if a global `is_april_fools` is not false, else it calls and returns
  -- the value from the original function.

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
     length = 5
  }


Tables
------

.. data:: HookDesc

  Table defining a hook.

  **Fields:**

  name : ``string``
    Name of hook.
  address : ``int``
    Address of function to hook
  type : ``string``
    Function pointer type.
  func : ``function``
    Function to be called by hook.
  length : ``int``
    Length of the hook.

Functions
---------

.. function:: hook(info)

  :param info: Table with hook data.
  :type info: :data:`HookDesc`

  :rtype: Function pointer to the trampoline.