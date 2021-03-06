--- Dice Rolls
-- @module dice

local ffi = require 'ffi'
local random = math.random

local M = {}

--- Functions.
-- @section drs

--- Rolls dice
-- @param dice Number of dice to roll
-- @param sides Number of sides the dice have
-- @param bonus Bonus added to roll
-- @param times Number of times to do roll.
local function Roll(dice, sides, bonus, times)
   if not times or times <= 1 then
      times = 1
   end

   bonus = bonus or 0
   local result = 0

   for j = 1, times do
      for i = 1, dice do
         result = result + random(sides)
      end
   end

   return result + (bonus * times)
end

--- Determines the highest maximum roll
-- @param roll1 DiceRoll ctype
-- @param roll2 DiceRoll ctype
function M.DetermineBestDiceRoll(roll1, roll2)
   local r1 = (roll1.dice * roll1.sides) + roll1.bonus
   local r2 = (roll2.dice * roll2.sides) + roll2.bonus

   if r1 >= r2 then
      return roll1
   else
      return roll2
   end
end

--- Determines if roll is valid.
-- A roll is considered valid if dice and sides are greater than
-- zero or the bonus is.
-- @param roll DiceRoll ctype
function M.IsValid(roll)
   return (roll.dice > 0 and roll.sides > 0) or roll.bonus > 0
end

--- Do a dice roll.
-- @param roll DiceRoll ctype
-- @param times Number of times to do roll.
function M.DoRoll(roll, times)
   if not times or times <= 1 then
      times = 1
   end
   return Roll(roll.dice, roll.sides, roll.bonus, times)
end

--- Converts a dice roll to formatted string.
-- @param roll DiceRoll ctype
function M.DiceRollToString(roll)
   return string.format("%dd%d + %d", roll.dice, roll.sides, roll.bonus)
end

--- Specific dice rolls.
-- @section drs

--- Rolls a d2
-- @param count number of dice to roll
function M.d2(count)
   count = count or 1
   return Roll(count, 2)
end

--- Rolls a d3
-- @param count number of dice to roll
function M.d3(count)
   count = count or 1
   return Roll(count, 3)
end

--- Rolls a d4
-- @param count number of dice to roll
function M.d4(count)
   count = count or 1
   return Roll(count, 4)
end

--- Rolls a d6
-- @param count number of dice to roll
function M.d6(count)
   count = count or 1
   return Roll(count, 6)
end

--- Rolls a d8
-- @param count number of dice to roll
function M.d8(count)
   count = count or 1
   return Roll(count, 8)
end

--- Rolls a d10
-- @param count number of dice to roll
function M.d10(count)
   count = count or 1
   return Roll(count, 10)
end

--- Rolls a d12
-- @param count number of dice to roll
function M.d12(count)
   count = count or 1
   return Roll(count, 12)
end

--- Rolls a d20
-- @param count number of dice to roll
function M.d20(count)
   count = count or 1
   return Roll(count, 20)
end

--- Rolls a d100
-- @param count number of dice to roll
function M.d100(count)
   count = count or 1
   return Roll(count, 100)
end

M.Roll = Roll

return M
