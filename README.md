## Status
* Status: alpha
* Currently undergoing some major resturcturing.
* Attempting to get the doc generator working.

## Goals
* Ease of modification.  Due to Lua's dynamic nature it's possible to
  overwrite any Solstice function, allowing you to customize evert
  aspect of the system.

## Dependencies
* Luajit 2.0 
* luafilesystem
* nwnx_effects
* nwnx_nsevents
* nwnx_nschat

## NWScript Differences
* Solstice is a more object oriented framework.  e.g. rather than
  SendMessageToPC(pc, "Hello") in Solstice it would be
  pc:SendMessage("Hello").
* Solstice uses Luajit and its Foreign Function Interface (FFI) library.
  Therefore all game objects, data, etc are trivially accessible and any C
  library is trivial to import and use.  Some care naturally has to be
  taken since Luajit's FFI does not protect you, if you pass bad data
  into C your server _will_ segfault. General scripting with Solstice
  doesn't require any knowledge of C however.

## Effects
* Default number of effect integers increased to 10
* Non-physical damage effects that are applied to a creature will be
  properly in the damage roll and will be modified by the targets
  damage immunity and resistance.
* Modifications to default effects:
    * EffectDamage redone to allow for additional damage types.
    * A number of effects can be made versus a Subrace, Deity, or an
      individual target.  (In the case of subrace and deity, it's
      necessary to convert Subrace names to integer IDs)
    * EffectImmunity has been extended to have a percent chance of
      blocking an effect.  Example: a creature could be 20% immune to
      knockdown or 35% immune to critical hits.  All those created in
      NWScript are defaulted to 100%.
* Additional effect types:
    * EffectDamageRangeIncrease/Decrease allows damage bonuses of the
      type X - Y.  (i.e. 5 - 10 fire damage).
	* EffectRecurring allows creating an effect that can apply another
      effect at arbitrary intervals.
	* EffectIcon (source nwnx_structs.nss)
	* EffectBonusFeat (source nwnx_structs.nss)
	* EffectWounding

# Effect Stacking / Caps
* Hardcoded effect caps have been mostly removed.  They can now be determined on
  a creature-by-creature case-by-case basis.
* The stacking policies of almost all effects are changeable.
  See `examples/stacking_policies.lua`.


## Combat Engine Differences
* Concealment in the combat log is the modified amount, as in nwnx_defenses.
* Defensive Roll: the entire damage roll is used to calculate if death
  will occur, rather just base damage.  Likewise, the entire damage
  roll will be halved on a successful reflex save.
* Added the concept of "Situational Attacks" these abstract situations
  like Sneak/Death attacks and Coup de Grace.  They can be extend to
  modify combat by a number of situational factors.
  
## Combat Modifiers
* 'Combat' is a slight misnomer as these adjustment are all in effect
  outside of combat.  The only ones used only in combat are Favored
  Enemy and situational attacks as they are dependent on attack target
  and other factors.
* Hitpoint adjustments are not possible versus Favored Enemy or in
  situational attacks.
* Modifications to AB, AC, Damage Bonus, Hitpoints can be determined
  by area, class, feat, combat mode, race, creature size, skill,
  versus favored enemies, and in situational attacks.
* All functions determining adjustments to be made are fully
  overwritable so there is no limitation on how they are determined.

## Weapons
* Monster Damage is usable on all weapons.  When used it overrides the base weapon damage.
* A weapons attack bonus, attack bonus ability, damage bonus ability
  (always strength in the NWN engine), critical hit bonus damage
  (i.e. from overwhelming critical), critical hit range, critical hit
  multiplier, and iteration (i.e. amount a creatures base attack is
  decremented each attack) are all totaly modifiable on a
  creature-by-creature basis.


