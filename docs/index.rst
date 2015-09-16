.. highlight:: lua

Solstice
========

Solstice is a scripting library and optionally a combat engine
replacement plugin system for `Neverwinter Nights`_ (NWN). My main goal
was to expand NWN from a platform for building adventures to also allow
building new/different rulesets. The project also aims at a tight level
of integration: where you could create a server with no NWN scripts, but
also where you could add/replace a script without having to change a
single line of NWN script.

This project is open source and licensed under the MIT License (any
mentions of GPL v2 in the docs are wrong). Contributions, pull requests,
feedback on API design, questions, bug reports (use the GitHub issues
here) are welcome and appreciated.

Currently, this is used in production on my own server. Some things are
geared towards it. You can get a sense of what I’ve done `here`_. The
code there is likewise MIT Licensed.

If you’re curious how everything comes together take a look at the Rules
module, which is the core of the system. If you want to see the details
of the combat engine replacement see
``examples/core_combat_engine.lua``, just be aware that that code is
atypical in that it’s written for the highest performance possible.

There are also other projects similar to this: nwnx_jvm, nwnx_ruby,
nwnx_lua. So if you like the idea but not Lua or the implementation,
there are other options.

Status
------

-  Status: Very near beta.
-  Working on getting nicer docs.
-  No build instructions yet.

Dependencies
------------

-  Linux
-  `Luajit 2.0`_
-  luafilesystem
-  lualogging
-  nwnx_effects
-  nwnx_solstice

git
---

-  ``develop`` is the branch with ongoing development.
-  ``master`` will (hopefully) be stable releases.

Scripting
---------

NWN scripts are mapped to functions in the global Lua namespace. There
is no concept of ``void main() {...}`` or
``int StartingConditional() {...}``. In the former case, in Lua it’s
merely a function that returns no value; in the latter a function that
returns a boolean. There is no concept of ``OBJECT_SELF``, the object is
passed explicitly.

Solstice is a more object oriented framework. e.g. rather than
``SendMessageToPC(pc, "Hello")`` in Solstice it would be
``pc:SendMessage("Hello")``.

Examples:

A normal ‘script’:

.. code:: lua

    function hello_world(obj)
        obj:SendMessage('Hello, world!')
    end

A ‘script’ that can be used in a conversation conditional:

.. code:: lua

    function is_epic_char(obj)
        return obj:GetHitDice() >= 20
    end

This has a some side effects:

-  Lua function names that you’re using as ‘scripts’ are limited to 16
   characters, like script file names.
-  Script editing needs to be done in external editor.
-  Scripts placed into events, like in the dialog editor, will not
   display their contents.
-  Many Lua functions can be placed into a single file.
-  None of these external Lua scripts count towards resource limits and
   if you build your module they will be c

.. _Neverwinter Nights: http://neverwinternights.info/
.. _here: https://github.com/jd28/the_awakening/tree/master/scripts/lua
.. _Luajit 2.0: http://luajit.org/

.. toctree::
  :caption: Tutorials
  :maxdepth: 3

  get_started

.. toctree::
  :caption: Modules
  :maxdepth: 3

  attack
  color
  dice
  effect
  itemprop
  game
  hooks
  nwn
  nwnx
  objects
  rules
  system

.. toctree::
  :caption: Development
  :maxdepth: 3

  known_issues
  todo

Indices and tables
==================

* :ref:`genindex`
* :ref:`search`

