--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local bit = require 'bit'
local DAMAGES = {}
local color = require 'nwn.color'
DAMAGES.roll = {}
DAMAGES.index = {}
DAMAGES.format = {}

--- Register Damage Types.
-- This function MUST only be called from OnModuleLoad!
-- @param damage_type nwn.DAMAGE_TYPE_*
function nwn.RegisterDamage(damage_type, index, name, dmg_color, melee_vfx)
   table.insert(DAMAGES, damage_type)
   DAMAGES[damage_type] = { name = name,
                            color = dmg_color,
                            melee_vfx = melee_vfx
   }
   DAMAGES.index[damage_type] = index
   DAMAGES.format[index] = dmg_color .. "%d " .. name  .. color.END
end

function nwn.RegisterDamageRoll(id, dice, side, bonus)
   if dice == 0 and bonus == 0 then
      error "The number of dice or a bonus amount must be specified"
      return
   end

   DAMAGES.roll[id] = dice_roll_t(dice, side, bonus)
end

function nwn.GetDamageFormatByIndex(idx)
   return DAMAGES.format[idx]
end

function nwn.GetDamageCount()
   return #DAMAGES
end

function nwn.GetDamageIndexFromFlag(flag)
   local idx = DAMAGES.index[flag]
   if not idx then
      return -1
   end
   return idx
end

function nwn.GetDamageRollFromConstant(id)
   return DAMAGES.roll[id] or dice_roll_t(0,0,0)
end

function nwn.GetDamageVFX(flag, is_ranged)
   if is_ranaged then
      return
   end

   return DAMAGES[flag].melee_vfx
end

nwn.RegisterDamage(nwn.DAMAGE_TYPE_BLUDGEONING, 0, "Bludgeoning", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_PIERCING, 1, "Piercing", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SLASHING, 2, "Slashing", color.ORANGE)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_MAGICAL, 3, "Magical", color.PURPLE, 76)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ACID, 4, "Acid", color.GREEN, 283)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_COLD, 5, "Cold", color.LIGHT_BLUE, 281)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_DIVINE, 6, "Divine", color.YELLOW, 289)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_ELECTRICAL, 7, "Electrical", color.DARK_BLUE, 282)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_FIRE, 8, "Fire", color.RED, 280)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_NEGATIVE, 9, "Negative", color.GRAY, 282)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_POSITIVE, 10, "Positive", color.WHITE, 289)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_SONIC, 11, "Sonic", color.LIGHT_ORANGE, 284)
nwn.RegisterDamage(nwn.DAMAGE_TYPE_BASE_WEAPON, 12, "Physical", color.ORANGE)

nwn.RegisterDamageRoll(1, 0, 0, 1)
nwn.RegisterDamageRoll(2, 0, 0, 2)
nwn.RegisterDamageRoll(3, 0, 0, 3)
nwn.RegisterDamageRoll(4, 0, 0, 4)
nwn.RegisterDamageRoll(5, 0, 0, 5)
nwn.RegisterDamageRoll(6, 1, 4, 0)
nwn.RegisterDamageRoll(7, 1, 6, 0)
nwn.RegisterDamageRoll(8, 1, 8, 0)
nwn.RegisterDamageRoll(9, 1, 10, 0)
nwn.RegisterDamageRoll(10, 2, 6, 0)
nwn.RegisterDamageRoll(11, 2, 8, 0)
nwn.RegisterDamageRoll(12, 2, 4, 0)
nwn.RegisterDamageRoll(13, 2, 10, 0)
nwn.RegisterDamageRoll(14, 1, 12, 0)
nwn.RegisterDamageRoll(15, 2, 12, 0)
nwn.RegisterDamageRoll(16, 0, 0, 6)
nwn.RegisterDamageRoll(17, 0, 0, 7)
nwn.RegisterDamageRoll(18, 0, 0, 8)
nwn.RegisterDamageRoll(19, 0, 0, 9)
nwn.RegisterDamageRoll(20, 0, 0, 10)
nwn.RegisterDamageRoll(21, 0, 0, 11)
nwn.RegisterDamageRoll(22, 0, 0, 12)
nwn.RegisterDamageRoll(23, 0, 0, 13)
nwn.RegisterDamageRoll(24, 0, 0, 14)
nwn.RegisterDamageRoll(25, 0, 0, 15)
nwn.RegisterDamageRoll(26, 0, 0, 16)
nwn.RegisterDamageRoll(27, 0, 0, 17)
nwn.RegisterDamageRoll(28, 0, 0, 18)
nwn.RegisterDamageRoll(29, 0, 0, 19)
nwn.RegisterDamageRoll(30, 0, 0, 20)
nwn.RegisterDamageRoll(31, 3, 4, 0)
nwn.RegisterDamageRoll(32, 4, 4, 0)
nwn.RegisterDamageRoll(33, 5, 4, 0)
nwn.RegisterDamageRoll(34, 6, 4, 0)
nwn.RegisterDamageRoll(35, 7, 4, 0)
nwn.RegisterDamageRoll(36, 8, 4, 0)
nwn.RegisterDamageRoll(37, 9, 4, 0)
nwn.RegisterDamageRoll(38, 10, 4, 0)
nwn.RegisterDamageRoll(39, 3, 6, 0)
nwn.RegisterDamageRoll(40, 4, 6, 0)
nwn.RegisterDamageRoll(41, 5, 6, 0)
nwn.RegisterDamageRoll(42, 6, 6, 0)
nwn.RegisterDamageRoll(43, 7, 6, 0)
nwn.RegisterDamageRoll(44, 8, 6, 0)
nwn.RegisterDamageRoll(45, 9, 6, 0)
nwn.RegisterDamageRoll(46, 10, 6, 0)
nwn.RegisterDamageRoll(47, 11, 6, 0)
nwn.RegisterDamageRoll(48, 12, 6, 0)
nwn.RegisterDamageRoll(49, 13, 6, 0)
nwn.RegisterDamageRoll(50, 14, 6, 0)
nwn.RegisterDamageRoll(51, 15, 6, 0)
nwn.RegisterDamageRoll(52, 3, 8, 0)
nwn.RegisterDamageRoll(53, 4, 8, 0)
nwn.RegisterDamageRoll(54, 5, 8, 0)
nwn.RegisterDamageRoll(55, 6, 8, 0)
nwn.RegisterDamageRoll(56, 7, 8, 0)
nwn.RegisterDamageRoll(57, 8, 8, 0)
nwn.RegisterDamageRoll(58, 9, 8, 0)
nwn.RegisterDamageRoll(59, 10, 8, 0)
nwn.RegisterDamageRoll(60, 11, 8, 0)
nwn.RegisterDamageRoll(61, 12, 8, 0)
nwn.RegisterDamageRoll(62, 13, 8, 0)
nwn.RegisterDamageRoll(63, 14, 8, 0)
nwn.RegisterDamageRoll(64, 15, 8, 0)
nwn.RegisterDamageRoll(65, 3, 10, 0)
nwn.RegisterDamageRoll(66, 4, 10, 0)
nwn.RegisterDamageRoll(67, 5, 10, 0)
nwn.RegisterDamageRoll(68, 6, 10, 0)
nwn.RegisterDamageRoll(69, 7, 10, 0)
nwn.RegisterDamageRoll(70, 8, 10, 0)
nwn.RegisterDamageRoll(71, 9, 10, 0)
nwn.RegisterDamageRoll(72, 10, 10, 0)
nwn.RegisterDamageRoll(73, 11, 10, 0)
nwn.RegisterDamageRoll(74, 12, 10, 0)
nwn.RegisterDamageRoll(75, 13, 10, 0)
nwn.RegisterDamageRoll(76, 14, 10, 0)
nwn.RegisterDamageRoll(77, 15, 10, 0)
nwn.RegisterDamageRoll(78, 3, 12, 0)
nwn.RegisterDamageRoll(79, 4, 12, 0)
nwn.RegisterDamageRoll(80, 5, 12, 0)
nwn.RegisterDamageRoll(81, 6, 12, 0)
nwn.RegisterDamageRoll(82, 7, 12, 0)
nwn.RegisterDamageRoll(83, 8, 12, 0)
nwn.RegisterDamageRoll(84, 9, 12, 0)
nwn.RegisterDamageRoll(85, 10, 12, 0)
nwn.RegisterDamageRoll(86, 3, 20, 0)
nwn.RegisterDamageRoll(87, 4, 20, 0)
nwn.RegisterDamageRoll(88, 5, 20, 0)
nwn.RegisterDamageRoll(89, 6, 20, 0)
nwn.RegisterDamageRoll(90, 7, 20, 0)
nwn.RegisterDamageRoll(91, 8, 20, 0)
nwn.RegisterDamageRoll(92, 9, 20, 0)
nwn.RegisterDamageRoll(93, 10, 20, 0)
nwn.RegisterDamageRoll(94, 11, 20, 0)
nwn.RegisterDamageRoll(95, 12, 20, 0)
nwn.RegisterDamageRoll(96, 13, 20, 0)
nwn.RegisterDamageRoll(97, 14, 20, 0)
nwn.RegisterDamageRoll(98, 15, 20, 0)
nwn.RegisterDamageRoll(99, 16, 20, 0)
nwn.RegisterDamageRoll(100, 17, 20, 0)
nwn.RegisterDamageRoll(101, 18, 20, 0)
nwn.RegisterDamageRoll(102, 19, 20, 0)
nwn.RegisterDamageRoll(103, 20, 20, 0)
nwn.RegisterDamageRoll(104, 21, 20, 0)
nwn.RegisterDamageRoll(105, 22, 20, 0)
nwn.RegisterDamageRoll(106, 23, 20, 0)
nwn.RegisterDamageRoll(107, 24, 20, 0)
nwn.RegisterDamageRoll(108, 25, 20, 0)
nwn.RegisterDamageRoll(109, 26, 20, 0)
nwn.RegisterDamageRoll(110, 27, 20, 0)
nwn.RegisterDamageRoll(111, 28, 20, 0)
nwn.RegisterDamageRoll(112, 29, 20, 0)
nwn.RegisterDamageRoll(113, 30, 20, 0)
nwn.RegisterDamageRoll(114, 31, 20, 0)
nwn.RegisterDamageRoll(115, 32, 20, 0)
nwn.RegisterDamageRoll(116, 33, 20, 0)
nwn.RegisterDamageRoll(117, 34, 20, 0)
nwn.RegisterDamageRoll(118, 35, 20, 0)
nwn.RegisterDamageRoll(119, 36, 20, 0)
nwn.RegisterDamageRoll(120, 37, 20, 0)
nwn.RegisterDamageRoll(121, 38, 20, 0)
nwn.RegisterDamageRoll(122, 39, 20, 0)
nwn.RegisterDamageRoll(123, 40, 20, 0)
nwn.RegisterDamageRoll(124, 11, 12, 0)
nwn.RegisterDamageRoll(125, 12, 12, 0)
nwn.RegisterDamageRoll(126, 13, 12, 0)
nwn.RegisterDamageRoll(127, 14, 12, 0)
nwn.RegisterDamageRoll(128, 15, 12, 0)
nwn.RegisterDamageRoll(129, 16, 12, 0)
nwn.RegisterDamageRoll(130, 17, 12, 0)
nwn.RegisterDamageRoll(131, 18, 12, 0)
nwn.RegisterDamageRoll(132, 19, 12, 0)
nwn.RegisterDamageRoll(133, 20, 12, 0)
nwn.RegisterDamageRoll(134, 11, 4, 0)
nwn.RegisterDamageRoll(135, 12, 4, 0)
nwn.RegisterDamageRoll(136, 13, 4, 0)
nwn.RegisterDamageRoll(137, 14, 4, 0)
nwn.RegisterDamageRoll(138, 15, 4, 0)
nwn.RegisterDamageRoll(139, 16, 4, 0)
nwn.RegisterDamageRoll(140, 17, 4, 0)
nwn.RegisterDamageRoll(141, 18, 4, 0)
nwn.RegisterDamageRoll(142, 19, 4, 0)
nwn.RegisterDamageRoll(143, 20, 4, 0)
nwn.RegisterDamageRoll(144, 16, 6, 0)
nwn.RegisterDamageRoll(145, 17, 6, 0)
nwn.RegisterDamageRoll(146, 18, 6, 0)
nwn.RegisterDamageRoll(147, 19, 6, 0)
nwn.RegisterDamageRoll(148, 20, 6, 0)
nwn.RegisterDamageRoll(149, 16, 8, 0)
nwn.RegisterDamageRoll(150, 17, 8, 0)
nwn.RegisterDamageRoll(151, 18, 8, 0)
nwn.RegisterDamageRoll(152, 19, 8, 0)
nwn.RegisterDamageRoll(153, 20, 8, 0)
nwn.RegisterDamageRoll(154, 16, 10, 0)
nwn.RegisterDamageRoll(155, 17, 10, 0)
nwn.RegisterDamageRoll(156, 18, 10, 0)
nwn.RegisterDamageRoll(157, 19, 10, 0)
nwn.RegisterDamageRoll(158, 20, 10, 0)

return DAMAGES

