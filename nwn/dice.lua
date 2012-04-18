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
   local result = 0
   
   for i = 1, count do
      result = result + math.random(2)
   end
   return result
end

--- Rolls a d3
-- @param count number of dice to roll
function nwn.d3(count)
   count = count or 1
   local result = 0    

   for i = 1, count do
      result = result + math.random(3)
   end
   return result
end

--- Rolls a d4
-- @param count number of dice to roll
function nwn.d4(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(4)
   end
   return result
end

--- Rolls a d6
-- @param count number of dice to roll
function nwn.d6(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(6)
   end
   return result
end

--- Rolls a d8
-- @param count number of dice to roll
function nwn.d8(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(8)
   end
end

--- Rolls a d10
-- @param count number of dice to roll
function nwn.d10(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(10)
   end
   return result
end

--- Rolls a d12
-- @param count number of dice to roll
function nwn.d12(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(12)
   end
end

--- Rolls a d20
-- @param count number of dice to roll
function nwn.d20(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(20)
   end
   return result
end

--- Rolls a d100
-- @param count number of dice to roll
function nwn.d100(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(100)
   end
   return result
end

function nwn.DoDiceRoll(roll)
   return nwn.RollDice(roll.dice, roll.sides, roll.bonus)
end

function nwn.RollDice(dice, sides, bonus)
   local result = 0
   
   for i = 1, dice do
      result = result + math.random(sides)
   end
   
   return result + bonus
end