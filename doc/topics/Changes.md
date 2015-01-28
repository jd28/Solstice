# Differences

## Incompatabilities

Due to a number of hooks needed to replace the combat engine, this
library and nwnx_solstice are not compatible with nwnx_weapons and
nwnx_defense.  All their features are not supported.  In order to do
so one would have create a custom combat engine.

### What can nwnx_solstice do that they can't?

* Pretty much anything you can think of.

### What can they do that nwnx_solstice can't (without using a combat engine)?

* Most modifications to the vanilla NWN combat engine, except critical
multipliers and threat ranges.
* Modifying the attack roll to show modified concealment.

## Sample Combat Engine Differences

* Weapons with multiple damage types are treated as being one or the other.
* Little to no support for effects versus targets.  This does not
  include Favored Enemy, Training Verus, both of which are supported.
* Attack roll shows modified concealment.
* All ranged weapon types are automatically equipped when they run
  out, if the player has extras.

## Effects
### General Changes:

* A number of effect creation functions have been combined where there
  were Increase/Decrease versions when it made sense to do so.  To
  create either version pass positive or negative values.
* Effect types are not NWScipt types, but internal engine types.
* Added 2das to define effect, subtype, and duration type constants:
  see 2da/effects.2da, 2da/effectsubtypes.2da, 2da/durtypes.2da.
* ApplyEffectOnObject expanded to allow DURATION\_TYPE\_EQUIPPED and
  DURATION\_TYPE\_INNATE (via nwnx_effects).

### Exposed effect types:

  * Bonus Feat
  * Disarm
  * Icon
  * Wounding

### Modified effects:

* Immunity - An additional parameter indicating percent immmunity to
  an immunity type.
* AC - Removed versus damage type parameter.
* Expaned DamageIncrease/Decrease to be able to specificaly create
  bonuses/penalties that are only applied on critical hits and/or
  are unblockable.  NOTE: This will require updating some NWN scripts
  as they will become blockable.  (This feature is dependent on using
  a combat engine replacement.)
* Damage Shields - An additional parameter `chance` allowing you to
  create effects that only have a chance of causing damage to the
  attacker.

### Additional effect types:
* Recurring - A placeholder effect for creating recurring effects a
  la wounding/regeneration.
