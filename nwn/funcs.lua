require 'nwn.ctypes.foundation'
require 'nwn.ctypes.2da'
require 'nwn.ctypes.vector'
require 'nwn.ctypes.location'
require 'nwn.ctypes.effect'
require 'nwn.ctypes.itemprop'
require 'nwn.ctypes.object'
require 'nwn.ctypes.area'
require 'nwn.ctypes.aoe'
require 'nwn.ctypes.client'
require 'nwn.ctypes.combat'
require 'nwn.ctypes.creature'
require 'nwn.ctypes.door'
require 'nwn.ctypes.encounter'
require 'nwn.ctypes.feat'
require 'nwn.ctypes.item'
require 'nwn.ctypes.module'
require 'nwn.ctypes.nwnx'
require 'nwn.ctypes.placeable'
require 'nwn.ctypes.trigger'
require 'nwn.ctypes.waypoint'

local ffi = require 'ffi'

-- clib functions
ffi.cdef[[
char *strdup(const char *s);
]]

-- Exalt NWN Functions
ffi.cdef[[
CGameObject *nwn_GetObjectByID (nwn_objid_t oid);
CGameObject *nwn_GetObjectByStringID (const char *oid);
CNWSPlayer *nwn_GetPlayerByID (nwn_objid_t oid);

bool nwn_GetKnowsFeat (const CNWSCreatureStats *stats, int feat);
int nwn_GetKnowsSkill (const CNWSCreatureStats *stats, int skill);
int nwn_GetLevelByClass (const CNWSCreatureStats *stats, int cl);
CNWSStats_Level *nwn_GetLevelStats (const CNWSCreatureStats *stats, int level);
int64_t nwn_GetWorldTime (uint32_t *time_2880s, uint32_t *time_msec);
void nwn_UpdateQuickBar (CNWSCreature *cre);
void nwn_ExecuteScript (const char *scr, nwn_objid_t oid);
]]

-- 2da.h
ffi.cdef [[
C2DA *nwn_GetCached2da(const char *file);
int nwn_Get2daColumnCount(C2DA *tda);
int nwn_Get2daRowCount(C2DA *tda);
char * nwn_Get2daString(C2DA *tda, const char* col, uint32_t row);
char * nwn_Get2daStringIdx(C2DA *tda, int col, uint32_t row);
int32_t nwn_Get2daInt(C2DA *tda, const char* col, uint32_t row);
int32_t nwn_Get2daIntIdx(C2DA *tda, int col, uint32_t row);
float nwn_Get2daFloat(C2DA *tda, const char* col, uint32_t row);
float nwn_Get2daFloatIdx(C2DA *tda, int col, uint32_t row);
]]

-- area.h
ffi.cdef [[
CNWSArea *nwn_GetAreaByID(uint32_t id);
bool      nwn_ClearLineOfSight(CNWSArea *area, Vector pointa, Vector pointb);
float     nwn_GetGroundHeight(CNWSArea *area, CScriptLocation *loc);
bool      nwn_GetIsWalkable(CNWSArea *area, CScriptLocation *loc);
]]

-- cexolocstring.h
ffi.cdef [[
CExoLocStringElement *nwn_GetCExoLocStringElement(CExoLocString* str, uint32_t locale);
const char           *nwn_GetCExoLocStringText(CExoLocString* str, uint32_t locale);
]]

-- class.h
ffi.cdef [[
bool    nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool    nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
uint8_t nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
bool    nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
]]

-- creature.h
ffi.cdef [[
CNWSCreature *nwn_GetCreatureByID(uint32_t oid);

void      nwn_ActionUseItem(CNWSCreature *cre, CNWSItem* it, CNWSObject *target, CNWSArea* area, CScriptLocation *loc, int prop);
void      nwn_AddKnownFeat(CNWSCreature *cre, uint16_t feat, uint32_t level);
int       nwn_AddKnownSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_level);
uint32_t  nwn_CalculateSpellDC(CNWSCreature *cre, uint32_t spellid);
void      nwn_DecrementFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
int8_t    nwn_GetAbilityModifier(CNWSCreatureStats *stats, int8_t abil, bool armorcheck);
int       nwn_GetAttacksPerRound(CNWSCreatureStats *stats);
int8_t    nwn_GetBaseSavingThrow(CNWSCreature *cre, uint32_t type);
int       nwn_GetBonusSpellSlots(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetCriticalHitMultiplier(CNWSCreatureStats *stats, bool offhand);
int       nwn_GetCriticalHitRange(CNWSCreatureStats *stats, bool offhand);
uint16_t  nwn_GetDamageFlags(CNWSCreature *cre);
int32_t   nwn_GetDexMod(CNWSCreatureStats *stats, bool armor_check);
bool      nwn_GetEffectImmunity(CNWSCreature *cre, int type, CNWSCreature *vs);
int       nwn_GetFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
bool      nwn_GetFlanked(CNWSCreature *cre, CNWSCreature *target);
bool      nwn_GetFlatFooted(CNWSCreature *cre);
int       nwn_GetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
bool      nwn_GetKnowsSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id);
bool      nwn_GetHasFeat(CNWSCreatureStats *stats, uint16_t feat);
int32_t   nwn_GetHasNthFeat(CNWSCreature *cre, uint16_t start, uint16_t stop);
bool      nwn_GetIsInvisible(CNWSCreature *cre, CNWSObject *obj);
bool      nwn_GetIsVisible(CNWSCreature *cre, nwn_objid_t target);
CNWSItem *nwn_GetItemInSlot(CNWSCreature *cre, uint32_t slot);
double    nwn_GetMaxAttackRange(CNWSCreature *cre, nwn_objid_t target);
int       nwn_GetMaxSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
int       nwn_GetRelativeWeaponSize(CNWSCreature *cre, CNWSItem *weapon);
int       nwn_GetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int8_t    nwn_GetSkillRank(CNWSCreature *cre, uint8_t skill, CNWSObject *vs, bool base);
int       nwn_GetTotalFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int       nwn_GetTotalKnownSpells (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetTotalNegativeLevels(CNWSCreatureStats *stats);
void      nwn_NotifyAssociateActionToggle(CNWSCreature *cre, int32_t mode);
int       nwn_RecalculateDexModifier(CNWSCreatureStats *stats);
int       nwn_RemoveKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_id);
int       nwn_ReplaceKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_new);
void      nwn_ResolveItemCastSpell(CNWSCreature *cre, CNWSObject *target);
void      nwn_ResolveSafeProjectile(CNWSCreature *cre, uint32_t delay, int attack_num);
uint8_t   nwn_SetAbilityScore(CNWSCreatureStats *stats, int abil, int val);
void      nwn_SetActivity(CNWSCreature *cre, int32_t a, int32_t b);
void      nwn_SetAnimation(CNWSCreature *cre, uint32_t anim);
void      nwn_SetCombatMode(CNWSCreature *cre, uint8_t mode);
int       nwn_SetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_id);
int       nwn_SetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_spell, uint32_t sp_meta, uint32_t sp_flags);
int       nwn_SetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_slots);
void      nwn_SendMessage(uint32_t mode, uint32_t id, const char *msg, uint32_t to);
]]

-- effect.h
ffi.cdef [[
void nwn_EffectSetNumIntegers(CGameEffect *eff, uint32_t num);
]]

-- faction.h
ffi.cdef [[
int32_t               nwn_GetFactionId(uint32_t id);
void                  nwn_SetFactionId(nwn_objid_t id, int32_t faction);
]]

-- item.h
ffi.cdef [[
CNWSItem        *nwn_GetItemByID(uint32_t id);
uint8_t          nwn_GetItemSize(CNWSItem *item);
CNWItemProperty *nwn_GetPropertyByType(CNWSItem *item, uint16_t type);
bool             nwn_HasPropertyType(CNWSItem *item, uint16_t type);
CNWBaseItem     *nwn_GetBaseItem(uint32_t basetype);
]]

-- message.h
--ffi.cdef [[
--]]

-- module.h
ffi.cdef [[
CNWSModule *nwn_GetModule();
]]

-- object.h
ffi.cdef [[
void             nwn_DelayCommand(uint32_t obj_id, double delay, void *vms);

void             nwn_DeleteLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalInt(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalObject(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalString(CNWSScriptVarTable *vt, const char *var_name);

void             nwn_DoCommand(CNWSObject *obj, void *vms);

CGameEffect*     nwn_GetEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                    const int eff_spellid, const int eff_type, const int eff_int0, const int eff_int1);

int              nwn_GetHasEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                       const int eff_spellid, const int eff_type, const int eff_int0);

int32_t          nwn_GetLocalInt(CNWSScriptVarTable *vt, const char *var_name);
float            nwn_GetLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
CScriptLocation  nwn_GetLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
uint32_t         nwn_GetLocalObject(CNWSScriptVarTable *vt, const char *var_name);
const char      *nwn_GetLocalString(CNWSScriptVarTable *vt, const char *var_name);

CScriptVariable *nwn_GetLocalVariableByPosition (CNWSScriptVarTable *vt, int idx);
int              nwn_GetLocalVariableCount (CNWSScriptVarTable *vt);
bool             nwn_GetLocalVariableSet(CNWSScriptVarTable *vt, const char *var_name, int8_t type);

void             nwn_SetLocalFloat(CNWSScriptVarTable *vt, const char *var_name, float value);
void             nwn_SetLocalInt(CNWSScriptVarTable *vt, const char *var_name, int32_t value);
void             nwn_SetLocalLocation(CNWSScriptVarTable *vt, const char *var_name, CScriptLocation * value);
void             nwn_SetLocalObject(CNWSScriptVarTable *vt, const char *var_name, uint32_t id);
void             nwn_SetLocalString(CNWSScriptVarTable *vt, const char *var_name, const char *value);

void             nwn_RemoveEffectById(CNWSObject *obj, uint32_t id);
void             nwn_SetTag(CNWSObject *obj, const char *value);
]]

-- stack.h
ffi.cdef [[
void      nwn_ExecuteCommand(int command, int num_args);

uint32_t  nwn_GetCommandObjectId();
uint32_t  nwn_SetCommandObjectId(uint32_t obj);

bool      nwn_StackPopBoolean();
int       nwn_StackPopInteger();
float     nwn_StackPopFloat();
char     *nwn_StackPopString();
Vector   *nwn_StackPopVector();
uint32_t  nwn_StackPopObject();
void      nwn_StackPushBoolean(bool value);
void     *nwn_StackPopEngineStructure(uint32_t type);
void      nwn_StackPushFloat(float value);
void      nwn_StackPushInteger(int value);
void      nwn_StackPushString(const char *value);
void      nwn_StackPushVector(Vector *value);
void      nwn_StackPushObject(uint32_t value);
void      nwn_StackPushEngineStructure(uint32_t type, void * value);
]]

-- waypoint.h
ffi.cdef [[
CNWSWaypoint *nwn_GetWaypointByID(uint32_t id);
]]


-- Solstice Functions
ffi.cdef [[
void ns_ActionDoCommand(CNWSObject * object, uint32_t token);
int  ns_BitScanFFS(uint32_t mask);
void ns_DelayCommand(CNWSObject *obj, float delay, uint32_t token);
void ns_RepeatCommand(CNWSObject *obj, float delay, uint32_t token);


ChatMessage   *Local_GetLastChatMessage();
CombatMessage *Local_GetLastCombatMessage();
EquipEvent    *Local_GetLastEquipEvent();
EventEffect   *Local_GetLastEffectEvent();
EventItemprop *Local_GetLastItemPropEvent();
CGameEffect   *Local_GetLastDamageEffect();
Event         *Local_GetLastNWNXEvent();
void           Local_NWNXLog(int level, const char* log);
]]
