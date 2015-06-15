# Solstice

Solstice is a scripting library and optionally a combat engine
replacement plugin system for
[Neverwinter Nights](http://neverwinternights.info/) (NWN).  My main
goal was to expand NWN from a platform for building adventures to also
allow building new/different rulesets.  The project also aims at a
tight level of integration: where you could create a server with
no NWN scripts, but also where you could add/replace a script
without having to change a single line of NWN script.

This project is open source and licensed under the MIT License (any mentions
of GPL v2 in the docs are wrong).  Contributions, pull requests, feedback on
API design, questions, bug reports (use the GitHub issues here) are welcome
and appreciated.

Currently, this is used in production on my own server.  Some things are
geared towards it.  You can get a sense of what I've done
[here](https://github.com/jd28/the_awakening/tree/master/scripts/lua).
The code there is likewise MIT Licensed.

If you're curious how everything comes together take a look at the Rules module,
which is the core of the system.  If you want to see the details of
the combat engine replacement see `examples/core_combat_engine.lua`, just be
aware that that code is atypical in that it's written for the highest
performance possible.

There are also other projects similar to this: nwnx\_jvm, nwnx\_ruby, nwnx\_lua.  So
if you like the idea but not Lua or the implementation, there are other
options.

## Status
* Status: Very near beta.
* Working on getting nicer docs.
* No build instructions yet.

## Dependencies
* Linux
* [Luajit 2.0](http://luajit.org/)
* luafilesystem
* lualogging
* nwnx_effects
* nwnx_solstice

## git
* `develop` is the branch with ongoing development.
* `master` will (hopefully) be stable releases.

## Scripting

NWN scripts are mapped to functions in the global Lua namespace.
There is no concept of `void main() {...}` or `int StartingConditional() {...}`.
In the former case, in Lua it's merely a function that returns no value;
in the latter a function that returns a boolean.  There is no concept
of `OBJECT_SELF`, the object is passed explicitly.

Solstice is a more object oriented framework.  e.g. rather than
`SendMessageToPC(pc, "Hello")` in Solstice it would be
`pc:SendMessage("Hello")`.

Examples:

A normal 'script':

```lua
function hello_world(obj)
    obj:SendMessage('Hello, world!')
end
```

A 'script' that can be used in a conversation conditional:

```lua
function is_epic_char(obj)
    return obj:GetHitDice() >= 20
end
```

This has a some side effects:

* Lua function names that you're using as 'scripts' are limited to 16
  characters, like script file names.
* Script editing needs to be done in external editor.
* Scripts placed into events, like in the dialog editor, will not display
  their contents.
* Many Lua functions can be placed into a single file.
* None of these external Lua scripts count towards resource limits and
  if you build your module they will be considered 'missing'.

## The plus side.
* Lua is a much more powerful language and also has a great deal of
  gamedev industry support.  It's used by World of Warcraft, CryEngine,
  Dark Souls, even in the Baldur's Gate series, and [many others](http://en.wikipedia.org/wiki/Category:Lua-scripted_video_games).
  So someone looking to develop skills for a career in gamedev will
  be able to learn a directly applicable programming language, while
  availing themselves of the accessibility of the NWN Toolset.
* Due to the dynamic nature of Lua, everything can be replaced.  If you
  don't like the way some library function works: replace it.  There is
  the caveat that some functions forward to NWScript built-in functions.
  In those cases you have a couple options: Redo them in Lua or redo them
  in nwnx_solstice and expose a C(++) function that does what you want.
  Depending on what you want those will have varying levels of
  unpleasantness.
* Building and distributing libraries is much simpler, since you have
  a mechanism for creating modules.  Namespacing is also much more pleasant
  since you don't have to rely on resref tags.
* Solstice uses Luajit and its Foreign Function Interface (FFI) library.
  Therefore all game objects, data, etc are accessible and any C
  library is easily imported and used.  Some care does have to be
  taken since Luajit's FFI does not protect you, if you pass bad data
  into C your server _will_ segfault.
* Access to a number of [Lua libraries](https://rocks.moonscript.org/).
  If you have reason to use a database, a socket, or file related operations,
  you can do those directly and not rely on NWNX extensions and shunting all
  data through LocalStrings.
* Access to more data structures: arrays, tables, and the ability to implement
  your own.
* Constants are not defined directly, but loaded at run time.  You can do this
  however you chose.  Read from 2das, parse nwscript, or another document.
* Advanced NWNX users can directly hook nwserver functions with Lua
  functions.

## The not-all-roses side
* Learning Lua is a task.  It's a dynamically typed language, so many
  errors that would have been caught at compile time will only be found
  at runtime.  If you make a typo or a syntax error restarting the server
  might be necessary.  Currently there is no built in way to reload scripts.
* As above: testing would require a Linux server, either online or in a VM.
* print/log debugging is pretty much the only option at this point.
* Features like nwnx_resman's live reloading are not fully supported.
* As mentioned above all editing must be done in an external editor.
* Lua indexes arrays starting at 1.  Some functions that communicate
  with C(++) have indexes starting at 0.  This is sometimes confusing.
  Also, the C(++) underbelly is still rather visible in places.
* The probability of this being ported to the client or Windows is 0%.
* You need to be aware of the global exports from `solstice.util` because you can clobber these with your own scripts, which
  will introduce varying levels of breakage.
