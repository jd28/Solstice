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

bool nwn_GetKnowsFeat (const CNWSCreatureStats *stats, int32_t feat);
int32_t nwn_GetKnowsSkill (const CNWSCreatureStats *stats, int32_t skill);
int32_t nwn_GetLevelByClass (const CNWSCreatureStats *stats, int32_t cl);
CNWSStats_Level *nwn_GetLevelStats (const CNWSCreatureStats *stats, int32_t level);
int64_t nwn_GetWorldTime (uint32_t *time_2880s, uint32_t *time_msec);
void nwn_UpdateQuickBar (CNWSCreature *cre);
void nwn_ExecuteScript (const char *scr, nwn_objid_t oid);
]]

-- 2da.h
ffi.cdef [[
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

-- client.h
ffi.cdef [[
CNWSPlayer *nwn_GetPlayerByPlayerID (uint32_t id);
void        nwn_BootPCWithMessage(nwn_objid_t id, int32_t strref);
const char* nwn_GetPCFileName(CNWSCreature *cre);
]]

-- rules.h
ffi.cdef [[
bool      nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool      nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
uint8_t   nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
int32_t   nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
CNWFeat  *nwn_GetFeat(uint32_t feat);
CNWSkill *nwn_GetSkill(uint32_t skill);
CNWRace  *nwn_GetRace(uint32_t race);
]]

-- combat.h
ffi.cdef[[
void nwn_AddCombatMessageData(
    CNWSCombatAttackData *attack, int32_t type, int32_t num_obj, uint32_t obj1, uint32_t obj2,
    int32_t num_int, int32_t int1, int32_t int2, int32_t int3, int32_t int4,
    const char* str);
void nwn_AddOnHitEffect(CNWSCreature *cre, CGameEffect *eff);
CNWSCombatAttackData *nwn_GetAttack(CNWSCreature *cre, int32_t attack);
CNWSItem *nwn_GetCurrentAttackWeapon(CNWSCreature *cre, int32_t attack_type);
void nwn_SignalMeleeDamage(CNWSCreature *cre, CNWSObject *target, uint32_t attack_count);
void nwn_SignalRangedDamage(CNWSCreature *cre, CNWSObject *target, uint32_t attack_count);
int32_t nwn_GetWeaponAttackType(CNWSCreature *cre);
void nwn_ResolveCachedSpecialAttacks(CNWSCreature *cre);
void nwn_ResolveMeleeAnimations(CNWSCreature *attacker, int32_t i, int32_t attack_count,
                                CNWSObject *target, int32_t anim);
void nwn_ResolveRangedAnimations(CNWSCreature *attacker, CNWSObject *target,
                                 int32_t anim);
void nwn_ResolveRangedMiss(CNWSCreature *attacker, CNWSObject *target);
void nwn_AddCircleKickAttack(CNWSCreature *cre, uint32_t target);
void nwn_AddCleaveAttack(CNWSCreature *cre, uint32_t target, bool great);
void nwn_ResolveOnHitEffect(CNWSCreature *cre, CNWSObject* target, bool offhand,
                            bool critical);
void nwn_ApplyOnHitDeathAttack(CNWSCreature *cre, CNWSObject *target, int32_t dc);
]]

-- creature.h
ffi.cdef [[
CNWSCreature *nwn_GetCreatureByID(uint32_t oid);

void      nwn_ActionUseItem(CNWSCreature *cre, CNWSItem* it, CNWSObject *target, CNWSArea* area, CScriptLocation *loc, int32_t prop);
void      nwn_AddKnownFeat(CNWSCreature *cre, uint16_t feat, uint32_t level);
int32_t       nwn_AddKnownSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_level);
uint32_t  nwn_CalculateSpellDC(CNWSCreature *cre, uint32_t spellid);
bool      nwn_CanUseSkill(CNWSCreature* cre, uint8_t skill);
void      nwn_DecrementFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
int8_t    nwn_GetAbilityModifier(CNWSCreatureStats *stats, int8_t abil, bool armorcheck);
int32_t       nwn_GetAttacksPerRound(CNWSCreatureStats *stats);
int8_t    nwn_GetBaseSavingThrow(CNWSCreature *cre, uint32_t type);
int32_t       nwn_GetBonusSpellSlots(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int32_t       nwn_GetCriticalHitMultiplier(CNWSCreatureStats *stats, bool offhand);
int32_t       nwn_GetCriticalHitRange(CNWSCreatureStats *stats, bool offhand);
uint16_t  nwn_GetDamageFlags(CNWSCreature *cre);
int32_t   nwn_GetDexMod(CNWSCreatureStats *stats, bool armor_check);
bool      nwn_GetEffectImmunity(CNWSCreature *cre, int32_t type, CNWSCreature *vs);
int32_t       nwn_GetFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
bool      nwn_GetFlanked(CNWSCreature *cre, CNWSCreature *target);
bool      nwn_GetFlatFooted(CNWSCreature *cre);
int32_t       nwn_GetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
bool      nwn_GetKnowsSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id);
bool      nwn_GetHasFeat(CNWSCreatureStats *stats, uint16_t feat);
int32_t   nwn_GetHasNthFeat(CNWSCreature *cre, uint16_t start, uint16_t stop);
bool      nwn_GetIsInvisible(CNWSCreature *cre, CNWSObject *obj);
bool      nwn_GetIsVisible(CNWSCreature *cre, nwn_objid_t target);
CNWSItem *nwn_GetItemInSlot(CNWSCreature *cre, uint32_t slot);
float     nwn_GetMaxAttackRange(CNWSCreature *cre, nwn_objid_t target);
int32_t       nwn_GetMaxSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int32_t       nwn_GetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
uint32_t      nwn_GetNearestTarget(CNWSCreature *cre, float max_range, nwn_objid_t target);
int32_t       nwn_GetRelativeWeaponSize(CNWSCreature *cre, CNWSItem *weapon);
int32_t       nwn_GetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int8_t    nwn_GetSkillRank(CNWSCreature *cre, uint8_t skill, CNWSObject *vs, bool base);
int32_t       nwn_GetTotalFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int32_t       nwn_GetTotalKnownSpells (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int32_t       nwn_GetTotalNegativeLevels(CNWSCreatureStats *stats);
void      nwn_JumpToLimbo(CNWSCreature *cre);
void      nwn_NotifyAssociateActionToggle(CNWSCreature *cre, int32_t mode);
int32_t       nwn_RecalculateDexModifier(CNWSCreatureStats *stats);
int32_t       nwn_RemoveKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_id);
int32_t       nwn_ReplaceKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_new);
void      nwn_ResolveItemCastSpell(CNWSCreature *cre, CNWSObject *target);
void      nwn_ResolveSafeProjectile(CNWSCreature *cre, uint32_t delay, int32_t attack_num);
uint8_t   nwn_SetAbilityScore(CNWSCreatureStats *stats, int32_t abil, int32_t val);
void      nwn_SetActivity(CNWSCreature *cre, int32_t a, int32_t b);
void      nwn_SetAnimation(CNWSCreature *cre, uint32_t anim);
void      nwn_SetCombatMode(CNWSCreature *cre, uint8_t mode);
int32_t       nwn_SetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_id);
int32_t       nwn_SetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_spell, uint32_t sp_meta, uint32_t sp_flags);
void      nwn_SetMovementRate(CNWSCreature *cre, int rate);
int32_t       nwn_SetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_slots);
void      nwn_EquipItem(CNWSCreature *cre, int32_t slot, CNWSItem *it, int32_t a, int32_t b);
void      nwn_UnequipItem(CNWSCreature *cre, CNWSItem *it, int32_t a);
void      nwn_CreateItemAndEquip(CNWSCreature *cre, const char *resref, int32_t slot);
]]

-- effect.h
ffi.cdef [[
CGameEffect * nwn_CreateEffect(int32_t gen_id);
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
void             nwn_DestroyItem(CNWSItem *it);
int32_t          nwn_ComputeArmorClass(CNWSItem *it);
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
                                    const int32_t eff_spellid, const int32_t eff_type, const int32_t eff_int0, const int32_t eff_int1);

int32_t          nwn_GetHasEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                  const int32_t eff_spellid, const int32_t eff_type, const int32_t eff_int0);

int32_t          nwn_GetLocalInt(CNWSScriptVarTable *vt, const char *var_name);
float            nwn_GetLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
CScriptLocation  nwn_GetLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
uint32_t         nwn_GetLocalObject(CNWSScriptVarTable *vt, const char *var_name);
const char      *nwn_GetLocalString(CNWSScriptVarTable *vt, const char *var_name);

CScriptVariable *nwn_GetLocalVariableByPosition (CNWSScriptVarTable *vt, int32_t idx);
int32_t          nwn_GetLocalVariableCount (CNWSScriptVarTable *vt);
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
void      nwn_ExecuteCommand(int32_t command, int32_t num_args);

uint32_t  nwn_GetCommandObjectId();
uint32_t  nwn_SetCommandObjectId(uint32_t obj);

int32_t   nwn_StackPopInteger();
float     nwn_StackPopFloat();
char     *nwn_StackPopString();
Vector   *nwn_StackPopVector();
uint32_t  nwn_StackPopObject();
void     *nwn_StackPopEngineStructure(uint32_t type);
void      nwn_StackPushFloat(float value);
void      nwn_StackPushInteger(int32_t value);
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
int32_t ns_BitScanFFS(uint32_t mask);
void ns_DelayCommand(uint32_t objid, float delay, uint32_t token);
const char** str_split(const char* s, const char* sep, bool isany);
const char* str_rtrim(const char* str);
const char* str_ltrim(const char* str);
const char* str_trim(const char* str);

void ns_AddOnHitSpells(CNWSCombatAttackData *data,
                       CNWSCreature *attacker,
                       CNWSObject *target,
                       CNWSItem *item,
                       bool from_target);

void ns_PostPolymorph(CNWSCreature *cre, int32_t ignore_pos, bool is_apply);

uint32_t ns_GetAmmunitionAvailable(CNWSCreature *attacker, int32_t num_attacks, int32_t ranged_type, bool equip);

const char* ns_GetCombatDamageString(
    const char *attacker,
    const char *target,
    const DamageResult *dmg,
    bool simple);

ChatMessage   *Local_GetLastChatMessage();
CombatMessage *Local_GetLastCombatMessage();
ItemEvent    *Local_GetLastItemEvent();
EventEffect   *Local_GetLastEffectEvent();
EventItemprop *Local_GetLastItemPropEvent();
CGameEffect   *Local_GetLastDamageEffect();
Event         *Local_GetLastNWNXEvent();
void           Local_NWNXLog(int32_t level, const char* log);
Attack        *Local_GetAttack();
void           Local_SetDamageInfo(int32_t index, const char* name, const char* color);
void           Local_SetCombatEngineActive(bool active);
EffectData    *Local_GetLastEffect();
]]

ffi.cdef [[
uint32_t nl_CalculateSpellDC(CWNSCreature *cre, uint32_t spellid);
]]