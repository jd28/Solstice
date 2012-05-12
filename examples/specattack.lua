require 'nwn.constants'
require 'nwn.specattack'

-- This file contained example special attacks.  I've split them out into
-- seperate files all starting with "sa_" in the examples folder.

-- Resolve Special Attack function template.
-- function resolve(attacker, target, attack_info)
--    -- Used to signal if 
--    local success = false
--    local eff
--
--    -- Whatever skill, alignment checks, etc here
-- 
--    -- The function should return a boolean value indicating whether
--    -- The Special Attack was successful and if so the effect to be
--    -- applied to the target
--    return success, eff
-- end

-- Resolve Special Attack Attack Bonus function template.
-- function resolve_ab(attacker, target, attack_info)
--    local ab = 0
-- 
--    -- Whatever alignment checks, etc here
-- 
--    return ab
-- end

-- Resolve Special Attack Damage Bonus function template.
-- Unlike the NWN dice rolls and damage type are available to
-- Special Attacks.
-- function resolve_dmg(attacker, target, attack_info)
--    local dice, sides, bonus = 0, 0, 0
--    local type = nwn.DAMAGE_TYPE_BASE_WEAPON
-- 
--    -- Whatever alignment checks, etc here
-- 
--    return ab
-- end


-- The Special attacks listed below do not need to be registered because
-- they are handled by the game engine or the combat engine.

----------------------------------------------------------------------------------------
-- Attack of Opportunity
-- There is no need to register any special attack.  The extra AoO attack
-- is handled in the game engine.

----------------------------------------------------------------------------------------
-- (Great) Cleave
-- There is no need to register any special attack.  The extra attacks
-- are handled in the game engine.

----------------------------------------------------------------------------------------
-- Ki Damge
-- There is no need to register any special attack.  The extra damage
-- are handled in the combat engine.


