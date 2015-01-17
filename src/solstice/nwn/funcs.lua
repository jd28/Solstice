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
]]

-- rules.h
ffi.cdef [[
bool      nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool      nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
uint8_t   nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
bool      nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
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
void      nwn_SendMessage(uint32_t mode, uint32_t id, const char *msg, uint32_t to);
void      nwn_EquipItem(CNWSCreature *cre, int32_t slot, CNWSItem *it, int32_t a, int32_t b);
void      nwn_UnequipItem(CNWSCreature *cre, CNWSItem *it, int32_t a);
void      nwn_CreateItemAndEquip(CNWSCreature *cre, const char *resref, int32_t slot);
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
void             nwn_DestroyItem(CNWSItem *it);
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

bool      nwn_StackPopBoolean();
int32_t   nwn_StackPopInteger();
float     nwn_StackPopFloat();
char     *nwn_StackPopString();
Vector   *nwn_StackPopVector();
uint32_t  nwn_StackPopObject();
void      nwn_StackPushBoolean(bool value);
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

-- effects/creation.h
ffi.cdef [[
CGameEffect * nwn_CreateEffect(int32_t show_icon);

CGameEffect * effect_ability(int32_t ability, int32_t amount);
CGameEffect * effect_ac(int32_t amount, int32_t modifier_type, int32_t damage_type);

CGameEffect * effect_appear(bool animation);
CGameEffect * effect_aoe(int32_t aoe, const char * enter, const char * heartbeat, const char * exit);

CGameEffect * effect_attack(int32_t amount, int32_t modifier_type);

CGameEffect * effect_beam(int32_t beam, int32_t creator, int32_t bodypart, int32_t miss_effect);
CGameEffect * effect_blindess();
CGameEffect * effect_feat (int32_t feat);
CGameEffect * effect_charmed();
CGameEffect * effect_concealment(int32_t amount, int32_t miss_type);
CGameEffect * effect_confused();
CGameEffect * effect_curse(int32_t str, int32_t dex, int32_t con,
			   int32_t intg, int32_t wis, int32_t cha);

CGameEffect * effect_cutscene_dominated();
CGameEffect * effect_cutscene_ghost();
CGameEffect * effect_cutscene_immobilize();
CGameEffect * effect_cutscene_paralyze();

CGameEffect * effect_damage(int32_t amount, int32_t damage_type, int32_t power);
CGameEffect * effect_damage_decrease(int32_t amount, int32_t damage_type, int32_t attack_type);
CGameEffect * effect_damage_increase(int32_t amount, int32_t damage_type, int32_t attack_type);

/*
CGameEffect * effect_DamageRangeDecrease(start, stop, damage_type, attack_type);
CGameEffect * effect_DamageRangeIncrease(start, stop, damage_type, attack_type);
*/

CGameEffect * effect_damage_immunity(int32_t damage_type, int32_t percent);
CGameEffect * effect_damage_reduction(int32_t amount, int32_t power, int32_t limit);
CGameEffect * effect_damage_resistance(int32_t damage_type, int32_t amount, int32_t limit);
CGameEffect * effect_damage_shield(int32_t amount, int32_t random, int32_t damage_type);

CGameEffect * effect_darkness();
CGameEffect * effect_dazed();
CGameEffect * effect_deaf();
CGameEffect * effect_death(bool spectacular, bool feedback);
CGameEffect * effect_disappear(bool animation);
CGameEffect * effect_disappear_appear(CScriptLocation location, bool animation);

CGameEffect * effect_disarm();
CGameEffect * effect_disease(int32_t disease);

CGameEffect * effect_dispel_all(int32_t diseasecaster_level);
CGameEffect * effect_dispel_best(int32_t diseasecaster_level);

CGameEffect * effect_dominated();
CGameEffect * effect_entangle();
CGameEffect * effect_ethereal();
CGameEffect * effect_frightened();
CGameEffect * effect_haste();

CGameEffect * effect_heal(int32_t amount);

CGameEffect * effect_hp_change_when_dying(float hitpoint_change);

/*
CGameEffect * effect_hp_decrease(int32_t amount);
CGameEffect * effect_hp_increase(int32_t amount);
*/

CGameEffect * effect_icon(int32_t icon);

CGameEffect * effect_immunity(int32_t immunity, int32_t percent);

CGameEffect * effect_invisibility(int32_t type);

CGameEffect * effect_knockdown();

CGameEffect * effect_link(CGameEffect *child, CGameEffect *parent);

CGameEffect * effect_miss_chance(int32_t amount, int32_t miss_type);

CGameEffect * effect_additional_attacks(int32_t amount);
CGameEffect * effect_move_speed(int32_t amount);
CGameEffect * effect_negative_level(int32_t amount, bool hp_bonus);

CGameEffect * effect_paralyze();
CGameEffect * effect_petrify();
CGameEffect * effect_poison(int32_t type);

CGameEffect * effect_polymorph(int32_t polymorph, bool locked);

CGameEffect * effect_regen(int32_t amount, float interval);

CGameEffect * effect_resurrection();
CGameEffect * effect_sanctuary(int32_t dc);

CGameEffect * effect_save(int32_t save, int32_t amount, int32_t save_type);

CGameEffect * effect_see_invisible();
CGameEffect * effect_silence();
CGameEffect * effect_skill(int32_t skill, int32_t amount);
CGameEffect * effect_sleep();
CGameEffect * effect_slow();
CGameEffect * effect_spell_failure(int32_t percent, int32_t spell_school);

CGameEffect * effect_spell_immunity(int32_t spell);

CGameEffect * effect_spell_absorbtion(int32_t max_level, int32_t max_spells, int32_t school);
CGameEffect * effect_spell_resistance(int32_t amount);
CGameEffect * effect_stunned();

CGameEffect * effect_summon(const char * resref, int32_t vfx, float delay, bool appear);
CGameEffect * effect_swarm(bool looping, const char * resref1, const char * resref2, const char * resref3, const char * resref4);

CGameEffect * effect_hp_temporary(int32_t amount);
CGameEffect * effect_time_stop();
CGameEffect * effect_true_seeing();
CGameEffect * effect_turned();

CGameEffect * effect_turn_resistance(int32_t amount);
CGameEffect * effect_ultravision();
CGameEffect * effect_visual(int32_t id, bool miss);
CGameEffect * effect_wounding (int32_t amount);
]]

-- effects/itemprop.h
ffi.cdef [[
CGameEffect * ip_create(bool show_icon);
CGameEffect * ip_set_values(CGameEffect *eff, int32_t type, int32_t subtype, int32_t cost,
			     int32_t cost_val, int32_t param1, int32_t param1_val,
			     int32_t uses_per_day, int32_t chance);

CGameEffect * ip_ability(int32_t ability, int32_t bonus);

CGameEffect * ip_ac(int32_t bonus, uint8_t ac_type);

CGameEffect * ip_enhancement(int32_t bonus);

CGameEffect * ip_weight_increase(int32_t amount);
CGameEffect * ip_weight_reduction(int32_t amount);

CGameEffect * ip_feat(int32_t feat);

CGameEffect * ip_spell_cast(int32_t spell, int32_t uses);
CGameEffect * ip_spell_slot(int32_t cls, int32_t level);

CGameEffect * ip_damage(int32_t damage_type, int32_t damage);
CGameEffect * ip_damage_extra(int32_t damage_type, bool is_ranged);

CGameEffect * ip_damage_immunity(int32_t damage_type, int32_t amount);
CGameEffect * ip_damage_penalty(int32_t penalty);
CGameEffect * ip_damage_reduction(int32_t enhancement, int32_t soak);
CGameEffect * ip_damage_resistance(int32_t damage_type, int32_t amount);

CGameEffect * ip_damage_vulnerability(int32_t damage_type, int32_t amount);

CGameEffect * ip_darkvision();

CGameEffect * ip_skill(int32_t skill, int32_t amount);

CGameEffect * ip_container_reduced_weight(int32_t amount);

CGameEffect * ip_haste();
CGameEffect * ip_holy_avenger();
CGameEffect * ip_immunity_misc(int32_t immumity_type);
CGameEffect * ip_improved_evasion();

CGameEffect * ip_spell_resistance(int32_t amount);

CGameEffect * ip_save(int32_t save_type, int32_t amount);
CGameEffect * ip_save_vs(int32_t save_type, int32_t amount);

CGameEffect * ip_keen();

CGameEffect * ip_light(int32_t brightness, int32_t color);

CGameEffect * ip_mighty(int32_t modifier);

CGameEffect * ip_no_damage();

CGameEffect * ip_onhit(int32_t prop, int32_t dc, int32_t special);

CGameEffect * ip_regen(int32_t amount);

CGameEffect * ip_immunity_spell(int32_t spell);

CGameEffect * ip_immunity_spell_school(int32_t school);

CGameEffect * ip_thieves_tools(int32_t modifier);

CGameEffect * ip_attack(int32_t bonus);

CGameEffect * ip_unlimited_ammo(int32_t ammo);

CGameEffect * ip_use_align(int32_t align_group);
CGameEffect * ip_use_class(int32_t cls);
CGameEffect * ip_use_race(int32_t race);
CGameEffect * ip_use_salign(int32_t nAlignment);

CGameEffect * ip_regen_vampiric(int32_t amount);

CGameEffect * ip_trap(int32_t level, int32_t trap_type);

CGameEffect * ip_true_seeing();

CGameEffect * ip_onhit_monster(int32_t prop, int32_t special);

CGameEffect * ip_turn_resistance(int32_t modifier);

CGameEffect * ip_massive_critical(int32_t damage);

CGameEffect * ip_freedom();

CGameEffect * ip_monster_damage(int32_t damage);

CGameEffect * ip_immunity_spell_level(int32_t level);

CGameEffect * ip_special_walk(int32_t walk);

CGameEffect * ip_healers_kit(int32_t modifier);

CGameEffect * ip_material(int32_t material);

CGameEffect * ip_onhit_castspell(int32_t spell, int32_t level);

CGameEffect * ip_quality(int32_t quality);

CGameEffect * ip_additional(int32_t addition);

CGameEffect * ip_visual_effect(int32_t effect);
]]

-- Solstice Functions
ffi.cdef [[
void ns_ActionDoCommand(CNWSObject * object, uint32_t token);
int32_t ns_BitScanFFS(uint32_t mask);
void ns_DelayCommand(uint32_t objid, float delay, uint32_t token);
void ns_RepeatCommand(uint32_t objid, float delay, uint32_t token);
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
    const DamageResult *dmg);

ChatMessage   *Local_GetLastChatMessage();
CombatMessage *Local_GetLastCombatMessage();
ItemEvent    *Local_GetLastItemEvent();
EventEffect   *Local_GetLastEffectEvent();
EventItemprop *Local_GetLastItemPropEvent();
CGameEffect   *Local_GetLastDamageEffect();
Event         *Local_GetLastNWNXEvent();
void           Local_NWNXLog(int32_t level, const char* log);
void           Local_DeleteCreature(uint32_t id);
CombatInfo    *Local_GetCombatInfo(uint32_t id);
Attack        *Local_GetAttack();

C2DA          *Local_GetPoly2da();
CGameEffect   *Local_GetPolyEffect();
void           Local_SetDamageInfo(int32_t index, const char* name, const char* color);
]]
