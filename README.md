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
* nwnx_combat
* nwnx_nsevents
* nwnx_nschat
* [LuaFun](https://github.com/rtsisyk/luafun)

## Combat Engine Differences
* No support for weapons with multiple damage types.
* Little to no support for effects versus targets.  This does not
  include Favored Enemy, Training Verus, both of which are supported.

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
