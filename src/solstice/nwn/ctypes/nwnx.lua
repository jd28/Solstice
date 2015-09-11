require 'solstice.nwn.ctypes.messages'
local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    char* msg;
    uint32_t to;
    uint32_t from;
    uint8_t channel;
    bool suppress;
} ChatMessageEvent;

typedef struct {
    int type;
    int subtype;
    uint32_t to;
    CNWCCMessageData *msg_data;
    bool suppress;
} ChatCCMessageEvent;

typedef struct {
    /* The object on which the effect is applied/removed. */
    CNWSObject  *object;
    /* The effect itself. */
    CGameEffect *effect;
    /* Return true here if the effect cant be applied; this deletes it. */
    bool         failed;
} EffectsCustomEvent;

typedef struct {
    int      type;
    int      subtype;
    uint32_t object;
    uint32_t target;
    uint32_t item;
    Vector   loc;
    bool     bypass;
    int32_t  result;
} Event;

typedef struct {
    int      type;
    uint32_t object;
    uint32_t item;
    bool     use_result;
    uint32_t  result;
} ItemsInfoEvent;

typedef struct {
    CNWSCreature    *obj;
    CNWSItem        *item;
    CNWItemProperty *ip;
    uint32_t         slot;
    bool             suppress;
} EffectsItempropEvent;
]]
