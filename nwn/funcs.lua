require 'nwn.ctypes.foundation'
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

-- NWN ext Functions
ffi.cdef [[
void                  nwn_ActionUseItem(CNWSCreature *cre, CNWSItem* it, CNWSObject *target, CNWSArea* area, CScriptLocation *loc, int prop);
void                  nwn_AddCombatMessageData(CNWSCombatAttackData *attack, uint32_t type, uint32_t num_objs, uint32_t obj1, uint32_t obj2, 
					       uint32_t num_ints, int32_t i1, int32_t i2, int32_t i3, int32_t i4);
int                   nwn_AddKnownFeat(CNWSCreature *cre, uint16_t feat, uint32_t level);
void                  nwn_AddParryAttack(CNWSCombatRound *cr, nwn_objid_t target);
void                  nwn_AddParryIndex(CNWSCombatRound *cr);
void                  nwn_ApplyEffect(CNWSObject *, CGameEffect *, int a, int b);
int                   nwn_CalculateOffHandAttacks(CNWSCombatRound *cr);
uint32_t              nwn_CalculateSpellDC(CNWSCreature *cre, uint32_t spellid);
bool                  nwn_ClearLineOfSight(CNWSArea *area, Vector pointa, Vector pointb);
CGameEffect          *nwn_CreateEffect(int32_t show_icon);
void                  nwn_DelayCommand(uint32_t obj_id, double delay, void *vms);
void                  nwn_DeleteLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalInt(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalObject(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalString(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DoCommand(CNWSObject *obj, void *vms);
int32_t               nwn_DoDamage(void *obj, uint32_t obj_type, int32_t amount);
void                  nwn_EffectSetNumIntegers(CGameEffect *eff, uint32_t num);
void                  nwn_ExecuteCommand(int command, int num_args);
CNWSArea             *nwn_GetAreaById(uint32_t id);
CNWSCombatAttackData *nwn_GetAttack(CNWSCombatRound *cr, int attack);
int                   nwn_GetAttackResultHit(CNWSCreature *cre, CNWSCombatAttackData *data);
int                   nwn_GetAttacksPerRound(CNWSCreatureStats *stats);
CNWBaseItem          *nwn_GetBaseItem(uint32_t basetype);
CExoLocStringElement *nwn_GetCExoLocStringElement(CExoLocString* str, uint32_t locale);
char                 *nwn_GetCExoLocStringText(CExoLocString* str, uint32_t locale);
uint32_t              nwn_GetCommandObjectId();
int                   nwn_GetCriticalHitMultiplier(CNWSCreatureStats *stats, bool offhand);
int                   nwn_GetCriticalHitRange(CNWSCreatureStats *stats, bool offhand);
CNWSItem             *nwn_GetCurrentAttackWeapon(CNWSCombatRound *cr, int attack_type);
uint16_t              nwn_GetDamageFlags(CNWSCreature *cre);
int32_t               nwn_GetDexMod(CNWSCreatureStats *stats, bool armor_check);
CGameEffect*          nwn_GetEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                    const int eff_spellid, const int eff_type, const int eff_int0, const int eff_int1);
int32_t               nwn_GetFactionId(uint32_t id);
CNWFeat              *nwn_GetFeat(uint16_t feat);
int                   nwn_GetFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
bool                  nwn_GetFlanked(CNWSCreature *cre, CNWSCreature *target);
bool                  nwn_GetFlatFooted(CNWSCreature *cre);
int                   nwn_GetHasEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                       const int eff_spellid, const int eff_type, const int eff_int0);
bool                  nwn_HasPropertyType(CNWSItem *item, uint16_t type);
bool                  nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
bool                  nwn_GetIsInvisible(CNWSCreature *cre, CNWSObject *obj);
bool                  nwn_GetIsVisible(CNWSCreature *cre, nwn_objid_t target);
CNWSItem             *nwn_GetItemById(uint32_t id);
//CNWSStats_Level      *nwn_GetLevelStats(CNWSCreatureStats *stats, int level);
float                 nwn_GetLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
int32_t               nwn_GetLocalInt(CNWSScriptVarTable *vt, const char *var_name);
CScriptLocation      *nwn_GetLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
uint32_t              nwn_GetLocalObject(CNWSScriptVarTable *vt, const char *var_name);
const char           *nwn_GetLocalString(CNWSScriptVarTable *vt, const char *var_name);
CScriptVariable      *nwn_GetLocalVariableByPosition (CNWSScriptVarTable *vt, int idx);
int                   nwn_GetLocalVariableCount (CNWSScriptVarTable *vt);
bool                  nwn_GetLocalVariableSet(CNWSScriptVarTable *vt, const char *var_name, int8_t type);
double                nwn_GetMaxAttackRange(CNWSCreature *cre, nwn_objid_t target);
CNWSModule           *nwn_GetModule();
CNWSPlayer           *nwn_GetPlayerByID (nwn_objid_t oid);
CNWItemProperty      *nwn_GetPropertyByType(CNWSItem *item, uint16_t type);
int                   nwn_GetRelativeWeaponSize(CNWSCreature *cre, CNWSItem *weapon);
int                   nwn_GetRemainingFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int                   nwn_GetTotalDamage(CNWSCombatAttackData *data, int a);
int                   nwn_GetTotalEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                         const int eff_spellid, const int eff_type, const int eff_int0);
int                   nwn_GetTotalFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int                   nwn_GetTotalNegativeLevels(CNWSCreatureStats *stats);
CNWSWaypoint         *nwn_GetWaypointById(uint32_t id);
int8_t                nwn_GetWeaponAttackType(CNWSCombatRound *cr);
void                  nwn_NotifyAssociateActionToggle(CNWSCreature *cre, int32_t mode);
void                  nwn_PrintDamage(nwn_objid_t attacker, nwn_objid_t target, int32_t total_damage, int32_t *damages);
int                   nwn_RecalculateDexModifier(CNWSCreatureStats *stats);
void                  nwn_RemoveEffectById(CNWSObject *obj, uint32_t id);
void                  nwn_ResolveAmmunition(CNWSCreature *cre, uint32_t delay);
void                  nwn_ResolveCachedSpecialAttacks(CNWSCreature *cre);
void                  nwn_ResolveItemCastSpell(CNWSCreature *cre, CNWSObject *target);
void                  nwn_ResolveMeleeAnimations(CNWSCreature *attacker, int32_t attack_num, int32_t attack_count, CNWSObject *target, int32_t anim);
void                  nwn_ResolveSafeProjectile(CNWSCreature *cre, uint32_t delay, int attack_num);
void                  nwn_ResolveSituationalModifiers(CNWSCreature *cre, CNWSObject *target);
void                  nwn_ResolveOnHitEffect(CNWSCreature *attacker, CNWSObject *target, bool is_offhand, bool crit);
void                  nwn_ResolveOnHitVisuals(CNWSCreature *cre, CNWSObject *target);
void                  nwn_ResolveRangedAnimations(CNWSCreature *attacker, CNWSObject *target, int32_t anim);
void                  nwn_ResolveRangedMiss(CNWSCreature *attacker, CNWSObject *target);
void                  nwn_SendMessage(uint32_t mode, uint32_t id, const char *msg, uint32_t to);
uint8_t               nwn_SetAbilityScore(CNWSCreatureStats *stats, int abil, int val);
void                  nwn_SetActivity(CNWSCreature *cre, int32_t a, int32_t b);
void                  nwn_SetAnimation(CNWSCreature *cre, uint32_t anim);
void                  nwn_SetCombatMode(CNWSCreature *cre, uint8_t mode);
uint32_t              nwn_SetCommandObjectId(uint32_t obj);
void                  nwn_SetFactionId(nwn_objid_t id, int32_t faction);
void                  nwn_SetLocalFloat(CNWSScriptVarTable *vt, const char *var_name, float value);
void                  nwn_SetLocalInt(CNWSScriptVarTable *vt, const char *var_name, int32_t value);
void                  nwn_SetLocalLocation(CNWSScriptVarTable *vt, const char *var_name, CScriptLocation * value);
void                  nwn_SetLocalObject(CNWSScriptVarTable *vt, const char *var_name, uint32_t id);
void                  nwn_SetLocalString(CNWSScriptVarTable *vt, const char *var_name, const char *value);
int                   nwn_SetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_id);
int                   nwn_SetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_spell, uint32_t sp_meta, uint32_t sp_flags);
void                  nwn_SetPauseTimer(CNWSCombatRound *cr, uint32_t a, uint32_t b);
int                   nwn_SetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_slots);
void                  nwn_SetRoundPaused(CNWSCombatRound *cr, uint32_t a, uint32_t b);
void                  nwn_SetTag(CNWSObject *obj, const char *);
void                  nwn_SignalMeleeDamage(CNWSCreature *cre, CNWSObject *target, int32_t attack_count);
void                  nwn_SignalRangedDamage(CNWSCreature *cre, CNWSObject *target, int32_t attack_count);
bool                  nwn_StackPopBoolean();
int                   nwn_StackPopInteger();
float                 nwn_StackPopFloat();
char                 *nwn_StackPopString();
Vector               *nwn_StackPopVector();
uint32_t              nwn_StackPopObject();
void                  nwn_StackPushBoolean(bool value);
void                 *nwn_StackPopEngineStructure(uint32_t type);
void                  nwn_StackPushFloat(float value);
void                  nwn_StackPushInteger(int value);
void                  nwn_StackPushString(const char *value);
void                  nwn_StackPushVector(Vector *value);
void                  nwn_StackPushObject(uint32_t value);
void                  nwn_StackPushEngineStructure(uint32_t type, void * value);
          ]]

-- Solstice Functions
ffi.cdef [[
void ns_ActionDoCommand(CNWSObject * object, uint32_t token);
void ns_AddAttackFeedback(CNWSCombatAttackData *attack, int32_t strref);
void ns_AddOnHitEffect(CNWSCombatAttackData *attack, nwn_objid_t creator, CGameEffect *eff);
void ns_AddOnHitVisual(CNWSCombatAttackData *attack, nwn_objid_t creator, uint32_t vfx);
int  ns_BitScanFFS(uint32_t mask);
void ns_DelayCommand(CNWSObject *obj, float delay, uint32_t token);
void ns_RepeatCommand(CNWSObject *obj, float delay, uint32_t token);
void ns_SignalAOO(CNWSCreature *cre, CNWSObject *obj, CNWSCombatAttackData* attack, int32_t anim_len);
void ns_SignalAttack(CNWSCreature *cre, CNWSObject *obj, CNWSCombatAttackData* attack, int32_t anim_len);
void ns_SignalDamage(CNWSCreature *cre, CNWSObject *obj, double event_number, int32_t anim_len);
void ns_SignalMiss(CNWSCreature *cre, CNWSObject *obj, CNWSCombatAttackData* attack, int32_t anim_len);
void ns_SignalOnHitEffects(CNWSCreature *cre, CNWSObject *obj, CNWSCombatAttackData* attack, int32_t anim_len);

ChatMessage   *Local_GetLastChatMessage();
CombatMessage *Local_GetLastCombatMessage();
EquipEvent    *Local_GetLastEquipEvent();
EventEffect   *Local_GetLastEffectEvent();
EventItemprop *Local_GetLastItemPropEvent();
CGameEffect   *Local_GetLastDamageEffect();
Event         *Local_GetLastNWNXEvent();
void           Local_NWNXLog(int level, const char* log);
]]
