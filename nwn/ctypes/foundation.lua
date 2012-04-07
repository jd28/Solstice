local ffi = require 'ffi'

ffi.cdef[[
typedef uint32_t nwn_objid_t;

typedef struct CExoString {
    char               *text;
    uint32_t            len;
} CExoString;

typedef struct CResRef_s {
	char resref[16];
} CResRef; 

typedef struct CExoLocString {
    void                *list;
    uint32_t            strref;

 /*
  * char *GetStringText (int32_t lang);
  * CExoLocStringElement *GetLangEntry (int32_t lang);
  */
} CExoLocString;

typedef struct CExoLocStringElement {
    int32_t             lang;
    CExoString          text;
} CExoLocStringElement;

typedef struct CExoLinkedList_s {
    void                       *header;
    uint32_t                    len;

 /* 
  * CExoLinkedListNode GetFirst (void);
  * void *GetAtPos (CExoLinkedListNode *pos);
  * CExoLinkedListNode GetNext (CExoLinkedListNode *pos);
  */
} CExoLinkedList;

typedef struct CScriptVariable {
    CExoString          var_name;
    uint32_t            var_type;
    uint32_t            var_value;
} CScriptVariable;

typedef struct CNWSScriptVarTable {
    CScriptVariable    *vt_list;
    uint32_t            vt_len;
} CNWSScriptVarTable;

typedef struct ArrayList {
    void *list;
    uint32_t len;
    uint32_t alloc;
} ArrayList;
]]
