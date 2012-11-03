local ffi = require 'ffi'

ffi.cdef[[
typedef struct CSpawnPoint
{
    Vector      position;
    float       orientation;
} CSpawnPoint;

typedef struct CNWSEncounter {
    CNWSObject obj;
    uint32_t field_1C0;
    uint32_t Faction;
    uint8_t LocalizedName;
    uint8_t field_1C9;
    uint8_t field_1CA;
    uint8_t field_1CB;
    uint32_t field_1CC;
    uint8_t enc_is_active;
    uint8_t field_1D1;
    uint8_t field_1D2;
    uint8_t field_1D3;
    uint8_t enc_reset;
    uint8_t field_1D5;
    uint8_t field_1D6;
    uint8_t field_1D7;
    int32_t enc_reset_time;   /* 01D8 */
    int SpawnOption;          /* 01DC */
    uint32_t Difficulty;      /* 01E1 */
    uint32_t enc_difficulty;   /* 01E4 */
    uint32_t RecCreatures;
    int MaxCreatures;
    int32_t enc_number_spawned;
    uint32_t HeartbeatDay;
    uint32_t HeartbeatTime;
    uint32_t LastSpawnDay;
    uint32_t LastSpawnTime;
    uint8_t enc_started;
    uint8_t field_205;
    uint8_t field_206;
    uint8_t field_207;
    uint8_t enc_exhausted;
    uint8_t field_209;
    uint8_t field_20A;
    uint8_t field_20B;
    int AreaListMaxSize;
    uint8_t field_210;
    uint8_t field_211;
    uint8_t field_212;
    uint8_t field_213;
    uint8_t field_214;
    uint8_t field_215;
    uint8_t field_216;
    uint8_t field_217;
    uint8_t field_218;
    uint8_t field_219;
    uint8_t field_21A;
    uint8_t field_21B;
    uint8_t field_21C;
    uint8_t field_21D;
    uint8_t field_21E;
    uint8_t field_21F;
    uint8_t field_220;
    uint8_t field_221;
    uint8_t field_222;
    uint8_t field_223;
    uint8_t field_224;
    uint8_t field_225;
    uint8_t field_226;
    uint8_t field_227;
    uint8_t field_228;
    uint8_t field_229;
    uint8_t field_22A;
    uint8_t field_22B;
    uint8_t field_22C;
    uint8_t field_22D;
    uint8_t field_22E;
    uint8_t field_22F;
    uint8_t field_230;
    uint8_t field_231;
    uint8_t field_232;
    uint8_t field_233;
    uint8_t field_234;
    uint8_t field_235;
    uint8_t field_236;
    uint8_t field_237;
    uint8_t field_238;
    uint8_t field_239;
    uint8_t field_23A;
    uint8_t field_23B;
    uint8_t field_23C;
    uint8_t field_23D;
    uint8_t field_23E;
    uint8_t field_23F;
    uint8_t field_240;
    uint8_t field_241;
    uint8_t field_242;
    uint8_t field_243;
    CSpawnPoint *enc_spawn_points;               /* 0x0248 */  // a 4 x n array of floats, x, y, z, orientation.
    uint32_t enc_spawn_points_len;          /* 0x024C */
    int Respawns;
    int32_t enc_spawns_max;
    int32_t enc_spawns_current;
    uint8_t field_25C;
    uint8_t field_25D;
    uint8_t field_25E;
    uint8_t field_25F;
    float *AreaPoints;
    uint8_t field_264;
    uint8_t field_265;
    uint8_t field_266;
    uint8_t field_267;
    float SpawnPoolActive;
    uint32_t LastEntered;
    uint32_t LastLeft;
    CExoString OnEntered;
    CExoString OnExit;
    CExoString OnHeartbeat;
    CExoString OnExhausted;
    CExoString OnUserDefined;
    uint8_t field_29C;
    uint8_t field_29D;
    uint8_t field_29E;
    uint8_t field_29F;
    int CustomScriptId;
    uint8_t enc_player_only;
    uint8_t field_2A5;
    uint8_t field_2A6;
    uint8_t field_2A7;
} CNWSEncounter;
]]