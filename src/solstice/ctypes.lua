---
-- This module defines some C structs for use by Solstice.  The constructors
-- all take parameters for their respective fields.  These are generated
-- dynamically by LuaJIT and so are dependent on some constants being
-- defined.
--
-- If you have any desire to change these... note which ones need to
-- be synced with nwnx_solstice.  Typically any additions will work fine,
-- any deletions will require a greater understanding of the entire
-- library.
--
-- Note about documentation.  If a field is an array is it will be
-- specified `field:` \[length\]
--
-- @module ctypes

local ffi = require 'ffi'
local C = ffi.C

local function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

require 'solstice.nwn.ctypes.foundation'
require 'solstice.nwn.ctypes.2da'
require 'solstice.nwn.ctypes.effect'
require 'solstice.nwn.ctypes.itemprop'
require 'solstice.nwn.ctypes.object'
require 'solstice.nwn.ctypes.area'
require 'solstice.nwn.ctypes.aoe'
require 'solstice.nwn.ctypes.client'
require 'solstice.nwn.ctypes.combat'
require 'solstice.nwn.ctypes.creature'
require 'solstice.nwn.ctypes.door'
require 'solstice.nwn.ctypes.encounter'
require 'solstice.nwn.ctypes.feat'
require 'solstice.nwn.ctypes.item'
require 'solstice.nwn.ctypes.messages'
require 'solstice.nwn.ctypes.module'
require 'solstice.nwn.ctypes.skill'
require 'solstice.nwn.ctypes.placeable'
require 'solstice.nwn.ctypes.race'
require 'solstice.nwn.ctypes.store'
require 'solstice.nwn.ctypes.sound'
require 'solstice.nwn.ctypes.trigger'
require 'solstice.nwn.ctypes.waypoint'

--- Unsynced structs.
-- @section types

--- Constructor: dice_roll_t
-- @table DiceRoll
-- @field dice Number of dice.
-- @field sides Number of sides.
-- @field bonus Bonus

--- Constructor: damage_roll_t
--
-- The mask is defined:
--
-- * 0x1 = Damage roll is a penalty
-- * 0x2 = Damage roll is applicable only to criticals.
-- * 0x4 = Damage roll is unblockable by resistances.
-- @table DamageRoll
-- @field type DAMAGE_INDEX_*
-- @field roll DiceRoll
-- @field mask Critical/Unblockable bitmask.

ffi.cdef[[
typedef struct {
   int32_t      dice;
   int32_t      sides;
   int32_t     bonus;
} DiceRoll;

typedef struct {
    int32_t  type;
    DiceRoll roll;
    int32_t  mask;
} DamageRoll;

typedef struct Effect {
    CGameEffect     *eff;
    bool            direct;
} Effect;

typedef struct Itemprop {
    CGameEffect     *eff;
    bool            direct;
} Itemprop;

typedef struct {
    CNWSObject *obj;
    CGameEffect *eff;
    bool is_remove;
} EffectData;
]]

require 'solstice.nwn.funcs'

dice_roll_t = ffi.typeof('DiceRoll')
damage_roll_t = ffi.typeof('DamageRoll')

