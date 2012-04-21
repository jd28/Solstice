Currently doing some major restructuring.  

# Dependencies
* Luajit
* nwnx_effects
* nwnx_nsevents
* nwnx_nschat

# NWScript Differences
* Solstice uses Luajit and its Foreign Function Interface (FFI) library.
  Therefore all game objects, data, etc are trivially accessible and any C
  library is trivial to import and use.  Some care naturally has to be
  taken since Luajit's FFI does not protect you, if you pass bad data
  into C your server _will_ segfault. Using Solstice doesn't require
  any knowledge of C.
* Solstice is a more object oriented framework.  e.g. rather than
  SendMessageToPC(oPC, "Hello") in using Solstice would be
  pc:SendMessage("Hello").

# Effect Differences


# Combat Engine Differences

* Concealment in the combat log is the modified amount, as in nwnx_defenses.
* All weapon damages stack rather than using only the highest applying damage.
* Monster Damage is usable on all weapons.  When used it overrides the base weapon damage.
* Defense Roll: the entire damage roll is used to calculate if death
  will occur, rather just base damage.  Likewise, the entire damage
  roll will be halved on a successful reflex save.
* Only one melee damage visual effect per hit is applied to the
  target, rather than one for each elemental and energy damage that damages the target.
