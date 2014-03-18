## Status
* Status: alpha
* Currently undergoing some major resturcturing.
* Attempting to get the doc generator working.

## Goals
* Ease of modification.  Due to Lua's dynamic nature it's possible to
  overwrite any Solstice function, allowing you to customize every
  aspect of the system.

## Dependencies
* Luajit 2.0
* luafilesystem
* nwnx_effects
* nwnx_nsevents
* nwnx_nschat
* [LuaFun](https://github.com/rtsisyk/luafun)

## Combat Engine Differences
* No support for weapons with multiple damage types.
* Little to no support for effects versus targets.  This does not
  include Favored Enemy, Training Verus, both of which are supported.

## Effects
General Changes:

* A number of effect creation functions have been combined where there
  were Increase/Decrease versions when it made sense to do so.  To
  create either version pass positive or negative values.
* Effect types are not NWScipt types, but internal engine types.
* Added 2das to define effect, subtype, and duration type constants:
  see 2da/effects.2da, 2da/effectsubtypes.2da, 2da/durtypes.2da.
* ApplyEffectOnObject expanded to allow DURATION\_TYPE\_EQUIPPED and
  DURATION\_TYPE\_INNATE (via nwnx_effects).

Exposed effect types:

  * Bonus Feat
  * Disarm
  * Icon
  * Wounding

Modified effects:

  * Immunity - An additional parameter indicating percent immmunity to
    an immunity type.  An additional effect type:
    EFFECT\_TYPE\_IMMUNITY\_DECREASE to allow penalties, etc.  Note:
    effects created from NWScript or from default item properties are
    still treated as being a 100% immunity.
  * Temporary hitpoints - Renamed and expanded to allow normal
    hitpoints.  That is, hitpoints that can be healed, etc.
  * AC - Removed versus damage type parameter.

Additional effect types:

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
