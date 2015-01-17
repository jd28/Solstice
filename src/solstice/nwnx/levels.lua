--- NWNX Levels
-- nwnx_levels allows you to set the maximum level beyond 40th.  Due
-- to some limitations of the client the post 40th level process must
-- still be done via conversation.
--
-- The LevelUp function requires certain local variables to be set:
--
-- * 'LL\_CLASS': CLASS_TYPE\_* + 1
-- * 'LL\_SKILL\_POINTS': Number of unspent skillpoints.
-- * 'LL\_HP': Number of class hitpoints gained.
-- * 'LL\_STAT': ABILITY\_* + 1
-- * 'LL\_FEAT\_COUNT': Number of feats added.
-- * 'LL\_FEAT\_[Nth feat]': Feat to add. Value: FEAT\_* + 1
-- * 'LL_SPGN[Spell Level]\_USED': Number of spells gained at spell.
-- * 'LL_SPGN[Spell Level]\_[Nth spell]': Spells removed at each spell level.
-- Value: SPELL_* + 1
-- * 'LL_SPRM[Spell Level]\_USED': Number of spells removes at spell
-- * 'LL_SPRM1[Spell Level]\_[Nth spell]': Spells removed at each spell level.
-- Value: SPELL_* + 1
--
-- Notes:
--
-- * Using builtin functions to add / remove XP can cause deleveling.
-- In Solstice you'd need to use the `direct` parameter.  Because of
-- this it requires having your own custom XP gained on kill scripts.
-- * All of the [Nth ...] start at 0.
--
-- @module nwnx.levels
-- @alias M

local mod
local M = {}

--- Get maximum level limit.
function M.GetMaxLevelLimit()
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT", "none")
   return tonumber(mod:GetLocalString("NWNX!LEVELS!GETMAXLEVELLIMIT"))
end

--- Set maximum level limit
-- @param level New maximum level.
function M.SetMaxLevelLimit (level)
   if not mod then mod = Game.GetModule() end
   mod:SetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT", tostring(level))
   return tonumber(mod:GetLocalString("NWNX!LEVELS!SETMAXLEVELLIMIT"))
end

--- Levels down a PC one level.
-- @param pc Player
function M.LevelDown(pc)
    pc:SetLocalString("NWNX!LEVELS!LEVELDOWN", "1");
    return tonumber(pc:GetLocalString("NWNX!LEVELS!LEVELDOWN"))
end

--- Level up a PC.
-- @param pc Player
function M.LevelUp(pc)
    pc:SetLocalString("NWNX!LEVELS!LEVELUP", "  ")
    return tonumber(pc:GetLocalString("NWNX!LEVELS!LEVELUP"))
end

--- Determine if creature meets feat requirement.
-- This takes into account all level related local variables already
-- set on creature.
-- @param cre Creature
-- @param feat FEAT_*
function M.GetMeetsLevelUpFeatRequirements (cre, feat)
   cre:SetLocalString("NWNX!LEVELS!GETMEETSFEATREQUIREMENTS", ">" .. tostring(feat))
   return tonumber(cre:GetLocalString("NWNX!LEVELS!GETMEETSFEATREQUIREMENTS")) == 1
end

-- NWNX functions cannot be JITed.
for _, func in pairs(M) do
   if type(func) == "function" then
      jit.off(func)
   end
end

return M
