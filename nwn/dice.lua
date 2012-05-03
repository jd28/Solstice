local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
   uint8_t      dice;
   uint8_t      sides;
   uint16_t     bonus;
} DiceRoll;
]]

dice_roll_t = ffi.typeof('DiceRoll')

--- Rolls a d2
-- @param count number of dice to roll
function nwn.d2(count)
   count = count or 1
   return nwn.RollDice(count, 2)
end

--- Rolls a d3
-- @param count number of dice to roll
function nwn.d3(count)
   count = count or 1
   return nwn.RollDice(count, 3)
end

--- Rolls a d4
-- @param count number of dice to roll
function nwn.d4(count)
   count = count or 1
   return nwn.RollDice(count, 4)
end

--- Rolls a d6
-- @param count number of dice to roll
function nwn.d6(count)
   count = count or 1
   return nwn.RollDice(count, 6)
end

--- Rolls a d8
-- @param count number of dice to roll
function nwn.d8(count)
   count = count or 1
   return nwn.RollDice(count, 8)
end

--- Rolls a d10
-- @param count number of dice to roll
function nwn.d10(count)
   count = count or 1
   return nwn.RollDice(count, 10)
end

--- Rolls a d12
-- @param count number of dice to roll
function nwn.d12(count)
   count = count or 1
   return nwn.RollDice(count, 12)
end

--- Rolls a d20
-- @param count number of dice to roll
function nwn.d20(count)
   count = count or 1
   return nwn.RollDice(count, 20)
end

--- Rolls a d100
-- @param count number of dice to roll
function nwn.d100(count)
   count = count or 1
   return nwn.RollDice(count, 100)
end

--- Do a dice roll.
-- @param roll DiceRoll ctype
function nwn.DoDiceRoll(roll)
   return nwn.RollDice(roll.dice, roll.sides, roll.bonus)
end

--- Rolls dice
-- @param dice Number of dice to roll
-- @param sides Number of sides the dice have
-- @param bonus Bonus added to roll
function nwn.RollDice(dice, sides, bonus)
   bonus = bonus or 0
   local result = 0
   
   for i = 1, dice do
      result = result + math.random(sides)
   end
   
   return result + bonus
end