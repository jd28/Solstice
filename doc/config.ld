-- ldoc configuration file
title = "Solstice Docs"
project = "Solstice"

description = [[
# Solstice

Solstice is a scripting library and combat engine replacement for
[Neverwinter Nights](http://neverwinternights.info/) (NWN).  My main goal
was to expand NWN from a platform building adventures to also allow building
new/different rulesets.

Due to the dynamic nature of Lua, everything can be replaced.  Nothing is hardcoded,
Nothing that is in the library can't be customized or modified.

If you're curious how everything comes together, take a look at the Rules module,
which is the core of the system.

## Status
* Status: Very near beta.  The last overhaul brought massive performance
  increases to the combat engine.
* Working on getting nicer docs...

## Dependencies
* Linux
* [Luajit 2.0](http://luajit.org/)
* luafilesystem
* nwnx_effects
* nwnx_nsevents (Temporary?)
* nwnx_nschat (Temporary?)
* [LuaFun](https://github.com/rtsisyk/luafun)

## Combat Engine Differences
* Weapons with multiple damage types are treated as being one or the other.
* Little to no support for effects versus targets.  This does not
  include Favored Enemy, Training Verus, both of which are supported.

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
    as they will become blockable.

### Additional effect types:

  * Recurring - A placeholder effect for creating recurring effects a
    la wounding/regeneration.

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
* Constants are not predefined but loaded from modified 2DAs, ensuring
  that they're never out of date or inconsistant.
]]

format = 'discount'
--topics = 'topics'
examples = {'../examples'}
merge=true
sort=true
no_summary = true
wrap = true
plain=true
file={
	'../src/solstice',
}
