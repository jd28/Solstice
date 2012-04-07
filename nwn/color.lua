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

-- TODO: Unbork these...

local color = {}

color.END = "</c>"
color.ORANGE    = "<cþh>" -- NWN Orange. Used in Log (Ex. "... killed Gobln")
color.GREEN_L   = "<c þ >" -- NWN Green. Used in tell channel
color.GREEN = "<c þ >" --tells - acid
color.RED = "<cþ<<>"
color.RED2 = "<cþ>" --fire damage
color.GRAY      = "<c°°°>" -- NWN Gray. Used in Log on players enter\leave
color.WHITE     = "<cððð>" -- NWN White. Used in Talk Channel
color.WHITE_T   = "<cþþþ>" -- True White
color.BLUE = "<c!}þ>"  --electrical damage
color.BLUE_L    = "<c™þþ>" -- NWN Light Blue. Used in player name
color.BLUE_N    = "<cf²þ>" -- NWN Normal Blue. Used in Conversations
color.BLUE_D    = "<cþ>" -- Dark Blue
color.PURPLE = "<cþ>" --names
color.LT_PURPLE = "<cÍþ>"
color.LT_GREEN = "<c´þd>"
color.GOLD = "<cþïP>" --shouts
color.YELLOW = "<cþþ>" --send message to pc default (server messages)
color.LT_BLUE = "<cßþ>" --dm channel
color.LT_BLUE2 = "<c›þþ>" --cold damage
color.CRIMSON = "<c‘  >"
color.MAGENTA   = "<c? ?>" -- Magenta
color.VIOLET    = "<cþ>" -- NWN Violet. Used in Names in Chat Channel
color.VIOLET_L  = "<cÌwþ>" -- NWN Light Violet. Used in cast-action in Log (Ex. "casting unnkown spell")
color.VIOLET_SL = "<cÌ™Ì>" -- NWN SuperLight Violet. Used in Object Names, who does cast-action in Log
color.PLUM = "<cþww>"
color.TANGERINE = "<cÇZ >"
color.PEACH = "<cþÇ >"
color.AMBER = "<cœœ >"
color.LEMON = "<cþþw>"
color.EMERALD = "<c ~ >"
color.LIME = "<cwþw>"
color.MIDNIGHT = "<c  t>"
color.NAVY = "<c  ‘>"
color.AZURE = "<c~~þ>"
color.SKYBLUE = "<cÇÇþ>"
color.LAVENDER = "<cþ~þ>"
color.BLACK = "<c   >"
color.SLATE = "<c666>"
color.DK_GREY = "<cZZZ>"
color.GREY = "<c~~~>"
color.LT_GREY = "<c¯¯¯>"
color.TURQUOISE = "<c ¥¥>"
color.JADE = "<c tt>"
color.CYAN = "<c þþ>"
color.CERULEAN = "<cœþþ>"
color.AQUA = "<cZÇ¯>"
color.SILVER = "<c¿¯Ç>"
color.ROSE = "<cÎFF>"
color.PINK = "<cþV¿>"
color.WOOD = "<c‘Z(>"
color.BROWN = "<cÇ~6>"
color.TAN = "<cß‘F>"
color.FLESH = "<cû¥Z>"
color.IVORY = "<cþÎ¥>"
color.NONE = ""
color.ASCII = [[                                            !!#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥§©©ª«¬­®¯°±²³´µ¶·¸¸º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïñòóôõö÷øùúûüýþþþ]]

return color