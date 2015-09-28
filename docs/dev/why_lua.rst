Why Lua?
========

There are also other projects similar to this: nwnx_jvm, nwnx_ruby,
nwnx_lua. So you might wonder why make another?

There are a few reasons I felt Lua and particularly LuaJIT was better suited for this particular project:

- Lua is very easy to embed.
- Lua is a much more powerful language and also has a great deal of gamedev industry support.  It's used by World of Warcraft, CryEngine, Dark Souls, even in the Baldur's Gate series, and `many others`_. So someone looking to develop skills for a career in gamedev will be able to learn a directly applicable programming language, while availing themselves of the accessibility of the NWN Toolset.
- Due to the dynamic nature of Lua, everything can be replaced.  If you don't like the way some library function works: replace it.  There is the caveat that some functions forward to NWScript built-in functions. In those cases you have a couple options: Redo them in Lua or redo them in nwnx_solstice and expose a C(++) function that does what you want. Depending on what you want those will have varying levels of difficulty.
- Building and distributing libraries is much simpler, since you have a mechanism for creating modules.  Namespacing is also much more pleasant since you don't have to rely on resref prefixes.
- LuaJIT is one of the fastest implementations of any dynamic language.
- LuaJIT's Foreign Function Interface (FFI) library makes it very easy to expose C data structures, so the huge amount of reverse engineering work done for NWNX can be easily reused.  It's also quite easy to import other C libraries.
- Access to a number of `Lua libraries`_. If you have reason to use a database, a socket, or file related operations, you can do those directly and not rely on NWNX extensions and shunting all data through LocalStrings.
- Access to more data structures: arrays, tables, and the ability to implement your own.
- Constants don't have to be predefined, they can be loaded at runtime.  You can do this however you choose: Read from 2DAs, parse NWScript, or another document.
- Advanced NWNX users can directly hook nwserver functions with Lua functions.

In the fairness of disclosure there are some things about Lua that aren't so pleasant:

- Lua is extremely different from NWScript.  It's a dynamically typed language, so many errors that would have been caught at compile time will only be found at runtime.  If you make a typo or a syntax error restarting the server might be necessary.
- As above: testing would require a Linux server, either online or in a VM.
- Debugging is pretty much limited to printing/logging.
- Features like nwnx_resman's live reloading are not fully supported.
- Lua indexes arrays starting at 1.  Some functions that communicate with C(++) have indexes starting at 0.  This is sometimes confusing.
- You need to be aware of the global exports from `solstice.util` because you can clobber these with your own scripts, which will introduce varying levels of breakage.

.. _many others: http://en.wikipedia.org/wiki/Category:Lua-scripted_video_games
.. _Lua libraries: https://rocks.moonscript.org/