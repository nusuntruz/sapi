local Engine = {}

local VEngineClient014 = Utils.CreateInterface("engine.dll", "VEngineClient014")

Engine.InGame = Utils.VTableBind(VEngineClient014, 26, "bool( __thiscall* )( void* )")

Engine.IsConnected = Utils.VTableBind(VEngineClient014, 27, "bool( __thiscall* )( void* )")

local GetScreenSizeVFunc = Utils.VTableBind(VEngineClient014, 5, "void(__thiscall*)(void*, int&, int&)")
Engine.GetScreenSize = function ()
    local w_ptr = ffi.typeof("int[1]")()
    local h_ptr = ffi.typeof("int[1]")()
    
    GetScreenSizeVFunc(w_ptr, h_ptr)

    return vec2_t(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
end

ffi.cdef[[
    typedef struct {
        uint64_t      m_uDataMap;
        union {
            int64_t   m_iSteamID64;
            struct {
                int   m_iSteamIDLow;
                int   m_iSteamIDHigh;
            };
        };
        char          m_szName [ 128 ];
        int           m_iUserID;
        char          m_szGUID [ 33 ];
        uint32_t      m_uFriendID;
        char          m_szFriendName [ 128 ];
        bool          m_bIsFakePlayer;
        bool          m_bIsHLTV;
        uint32_t      m_uCustomFiles [ 4 ];
        uint8_t       m_uFilesDownloaded;
    } player_info_t;
]]

local GetPlayerInfoVFunc = Utils.VTableBind(VEngineClient014, 8, "bool( __thiscall* )( void* , int , player_info_t* )")
Engine.GetPlayerInfo = function(m_iIndex)
    if not Engine.InGame() then return end
    local m_player_info = ffi.typeof("player_info_t")()
    GetPlayerInfoVFunc(ffi.cast("int", m_iIndex), m_player_info)
    return m_player_info
end

local GetPlayerByUserId = Utils.VTableBind(VEngineClient014, 9, "int( __thiscall* )( void* , int )")
Engine.GetPlayerByUserId = function (m_iUserID)
    if not Engine.InGame() then return end

    return GetPlayerByUserId(ffi.cast("int", m_iUserID))
end

local GetViewAngles = Utils.VTableBind(VEngineClient014, 18, "void( __thiscall* )( void* , vec3_t& )")
Engine.GetViewAngles = function ()
    if not Engine.InGame() then return end
    local angle = ffi.typeof("vec3_t[1]")()
    GetViewAngles(angle)
    return vec3_t(angle[0])
end

local SetViewAngles = Utils.VTableBind(VEngineClient014, 19, "void( __thiscall* )( void* , vec3_t& )")
Engine.SetViewAngles = function (m_vecAngle)
    if not Engine.InGame() then return end
    local angle = ffi.typeof("vec3_t[1]")()
    angle.x = m_vecAngle.x
    angle.y = m_vecAngle.y
    angle.z = m_vecAngle.z
    SetViewAngles(angle)
end

local ExecuteCMD = Utils.VTableBind(VEngineClient014, 108, "void( __thiscall* )( void* , const char* )")
Engine.Execute = function(cmd)
    return ExecuteCMD(ffi.cast("const char*", cmd))
end

Engine.IsPaused = Utils.VTableBind(VEngineClient014, 90, "bool( __thiscall* )( void* )")

Engine.IsHLTV = Utils.VTableBind(VEngineClient014, 90, "bool( __thiscall* )( void* )")

ffi.cdef[[
    typedef struct {
    	uint64_t m_uiCaseID;
    	uint32_t m_uiHeaderPrefixLength;
    	uint32_t m_uiLockFirstPersonAccountID;
    	bool m_bAnonymousPlayerIdentity;
    	uint32_t m_numRoundSkip;
    	uint32_t m_numRoundStop;
    	bool m_bSkipWarmup;
    	bool m_bPlayingLiveRemoteBroadcast;
    	uint64_t m_uiLiveMatchID;
    } CDemoPlaybackParameters_t;
]]

Engine.GetDemoPlaybackParameters = Utils.VTableBind(VEngineClient014, 218, "CDemoPlaybackParameters_t* ( __thiscall* )( void* )")

local GetScreenAspectRatio = Utils.VTableBind(VEngineClient014, 101, "float( __thiscall* )( void* , int , int )")
Engine.GetScreenAspectRatio = function (viewportWidth, viewportHeight)
    return GetScreenAspectRatio(viewportWidth, viewportHeight)
end

return Engine