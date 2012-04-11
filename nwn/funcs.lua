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

require 'nwn.ctypes.foundation'
require 'nwn.ctypes.vector'
require 'nwn.ctypes.location'
require 'nwn.ctypes.effect'
require 'nwn.ctypes.object'
require 'nwn.ctypes.area'
require 'nwn.ctypes.aoe'
require 'nwn.ctypes.client'
require 'nwn.ctypes.combat'
require 'nwn.ctypes.creature'
require 'nwn.ctypes.door'
require 'nwn.ctypes.encounter'
require 'nwn.ctypes.item'
require 'nwn.ctypes.module'
require 'nwn.ctypes.placeable'
require 'nwn.ctypes.trigger'
require 'nwn.ctypes.waypoint'

local ffi = require 'ffi'

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
int                   nwn_AddKnownFeat(CNWSCreature *cre, uint16_t feat, uint32_t level);
uint32_t              nwn_CalculateSpellDC(CNWSCreature *cre, uint32_t spellid);
//void                  nwn_DelayCommand(uint32_t obj_id, double delay, CVirtualMachineScript *vms);
void                  nwn_DeleteLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalInt(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalObject(CNWSScriptVarTable *vt, const char *var_name);
void                  nwn_DeleteLocalString(CNWSScriptVarTable *vt, const char *var_name);
//void                  nwn_DoCommand(CNWSObject *obj, CVirtualMachineScript *vms);
void                  nwn_ExecuteCommand(int command, int num_args);
CNWSArea             *nwn_GetAreaById(uint32_t id);
CExoLocStringElement *nwn_GetCExoLocStringElement(CExoLocString* str, uint32_t locale);
char                 *nwn_GetCExoLocStringText(CExoLocString* str, uint32_t locale);
uint32_t              nwn_GetCommandObjectId();
int                   nwn_GetCriticalHitMultiplier(CNWSCreatureStats *stats, bool offhand);
int                   nwn_GetCriticalHitRange(CNWSCreatureStats *stats, bool offhand);
CGameEffect*          nwn_GetEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                    const int eff_spellid, const int eff_type, const int eff_int0, const int eff_int1);
int32_t               nwn_GetFactionId(uint32_t id);
int                   nwn_GetHasEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                       const int eff_spellid, const int eff_type, const int eff_int0);
bool                  nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
bool                  nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
CNWSItem             *nwn_GetItemById(uint32_t id);
//CNWSStats_Level      *nwn_GetLevelStats(CNWSCreatureStats *stats, int level);
float                 nwn_GetLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
int32_t               nwn_GetLocalInt(CNWSScriptVarTable *vt, const char *var_name);
CScriptLocation      *nwn_GetLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
uint32_t              nwn_GetLocalObject(CNWSScriptVarTable *vt, const char *var_name);
const char           *nwn_GetLocalString(CNWSScriptVarTable *vt, const char *var_name);
CScriptVariable      *nwn_GetLocalVariableByPosition (CNWSScriptVarTable *vt, int idx);
int                   nwn_GetLocalVariableCount (CNWSScriptVarTable *vt);
CNWSModule           *nwn_GetModule();
//CNWSPlayer           *nwn_GetPlayerByID (nwn_objid_t oid);
int                   nwn_GetRelativeWeaponSize(CNWSCreature *cre, CNWSItem *weapon);
int                   nwn_GetRemainingFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int                   nwn_GetTotalEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                         const int eff_spellid, const int eff_type, const int eff_int0);
int                   nwn_GetTotalFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int8_t                nwn_GetWeaponAttackType(CNWSCombatRound *cr);
int                   nwn_RecalculateDexModifier(CNWSCreatureStats *stats);
void                  nwn_RemoveEffectById(CNWSObject *obj, uint32_t id);
//void                  nwn_RemoveKnownFeat(CNWSCreatureStats *stats, uint16_t feat);
void                  nwn_ResolveCachedSpecialAttacks(CNWSCreature *cre);
void                  nwn_ResolveSituationalModifiers(CNWSCreature *cre, CNWSObject *target);
void                  nwn_SendMessage(uint32_t mode, uint32_t id, char *msg, uint32_t to);
uint8_t               nwn_SetAbilityScore(CNWSCreatureStats *stats, int abil, int val);
uint32_t              nwn_SetCommandObjectId(uint32_t obj);
void                  nwn_SetFactionId(nwn_objid_t id, int32_t faction);
void                  nwn_SetLocalFloat(CNWSScriptVarTable *vt, const char *var_name, float value);
void                  nwn_SetLocalInt(CNWSScriptVarTable *vt, const char *var_name, int32_t value);
void                  nwn_SetLocalLocation(CNWSScriptVarTable *vt, const char *var_name, CScriptLocation * value);
void                  nwn_SetLocalObject(CNWSScriptVarTable *vt, const char *var_name, uint32_t id);
void                  nwn_SetLocalString(CNWSScriptVarTable *vt, const char *var_name, const char *value);
void                  nwn_SetTag(CNWSObject *obj, const char *);
void                  nwn_SignalMeleeDamage(CNWSCreature *cre, CNWSObject *target, int32_t attack_count);
bool                  nwn_StackPopBoolean();
int                   nwn_StackPopxInteger();
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
void         ns_ActionDoCommand(CNWSObject * object, uint32_t token);
void         ns_DelayCommand(CNWSObject *obj, float delay, uint32_t token);
void         ns_RepeatCommand(CNWSObject *obj, float delay, uint32_t token);
]]