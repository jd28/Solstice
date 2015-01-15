# Getting Started

In order to get Solstice up and running you'll need a few things.

### System

A Linux server or VM with NWN setup.

### LuaRocks

Install LuaRocks.

* Ubuntu: `sudo apt-get install luarocks`.

Install the required LuaRocks. Note that the following will require
the ability to compile C files.

Install [luafilesystem](http://keplerproject.github.io/luafilesystem/): `sudo
luarocks install luafilesystem`

Install [lualogging](http://keplerproject.org/lualogging/): `sudo luarocks install lualogging`

Install [luadbi](https://code.google.com/p/luadbi/wiki/DBI)
for your database (this is optional, if you don't use the
`system.database`):

* MySQL: `sudo luarocks install luadbi-mysql`
* Sqlite3: `sudo luarocks install luadbi-sqlite3`
* PostgreSQL: `sudo luarocks install luadbi-postgresql`

### NWNX

Download at install the NWNX plugins here: **TODO**

### Solstice

Download and install Solstice or clone git repository.

### Lua Scripts

Create a directory for your Lua scripts in your NWN install directory.
All the examples use `lua`.

Create your settings.lua, preload.lua, and constant.lua in your lua
script directory.  See the examples provided.
