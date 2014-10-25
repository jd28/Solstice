local ffi = require 'ffi'

ffi.cdef[[
typedef uint32_t nwn_objid_t;

typedef struct {
    char               *text;
    uint32_t            len;
} CExoString;

typedef struct {
	char resref[16];
} CResRef;

typedef struct {
    void                *list;
    uint32_t            strref;

 /*
  * char *GetStringText (int32_t lang);
  * CExoLocStringElement *GetLangEntry (int32_t lang);
  */
} CExoLocString;

typedef struct {
    int32_t             lang;
    CExoString          text;
} CExoLocStringElement;

typedef struct {
    void                       *header;
    uint32_t                    len;

 /*
  * CExoLinkedListNode GetFirst (void);
  * void *GetAtPos (CExoLinkedListNode *pos);
  * CExoLinkedListNode GetNext (CExoLinkedListNode *pos);
  */
} CExoLinkedList;

typedef struct {
    float       x;
    float       y;
    float       z;
} Vector;

typedef struct {
    float       x;
    float       y;
} Vector2;

typedef struct {
    Vector          position;
    Vector          orientation;
    uint32_t        area;
} CScriptLocation;

typedef struct {
    CExoString          var_name;
    uint32_t            var_type;
    union {
       uint32_t         val_object;
       int32_t          val_int;
       float            val_float;
       CExoString      *val_string;
       CScriptLocation *val_loc;
    } var_value;
} CScriptVariable;

typedef struct {
    CScriptVariable    *vt_list;
    uint32_t            vt_len;
} CNWSScriptVarTable;

typedef struct {
    void *data;
    uint32_t len;
    uint32_t alloc;
} ArrayList;
]]

local al = [[typedef struct {
    %s *data;
    uint32_t len;
    uint32_t alloc;
} ArrayList_%s;]]

function make_array_list(type, id)
   ffi.cdef(string.format(al, type, id))
end

make_array_list('int32_t', 'int32')
make_array_list('uint32_t', 'uint32')
make_array_list('uint16_t', 'uint16')
make_array_list('float', 'float')
make_array_list('CExoString', 'string')

vector3_t = ffi.typeof("Vector")
vector2_t = ffi.typeof("Vector2")
