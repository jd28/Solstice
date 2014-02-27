require 'solstice.nwn.ctypes.messages'
local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    char* msg;
    uint32_t to;
    uint32_t from;
    uint8_t channel;
    bool suppress;
} ChatMessage;

typedef struct {
    int type;
    int subtype;
    uint32_t to;
    void *msg_data;
    bool suppress;
} CombatMessage;

typedef struct {
    int type;
    bool event_type; // exists if one wanted to have apply/remove be the same...
    bool success;
    CGameEffect *effect;
} CustomEffect;

typedef struct {
    int      type;
    int      subtype;
    uint32_t object;
    uint32_t target;
    uint32_t item;
    Vector   loc;
    bool     bypass;
    bool     use_result;
    int32_t  result;
} Event;

typedef struct {
    int      type;
    uint32_t object;
    uint32_t item;
    bool     use_result;
    int32_t  result;
} EquipEvent;

typedef struct {
    CNWSObject  *obj;
    CGameEffect *eff;
    bool         is_remove;
    bool         suppress;
    bool         delete_eff;
    bool         preapply;
} EventEffect;

typedef struct {
    CNWSCreature    *obj;
    CNWSItem        *item;
    CNWItemProperty *ip;
    bool             remove;
} EventItemprop;
]]
