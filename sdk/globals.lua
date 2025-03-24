ffi.cdef[[
    typedef struct {
        float m_flRealTime;
        int m_iFrameCount;
        float m_flAbsoluteFrameTime;
        float m_flAbsoluteFrameStartTimeStdDev;
        float m_flCurentTime;
        float m_flFrameTime;
        int m_iMaxClients;
        int m_iTickCount;
        float m_flIntervalPerTick;
        float m_flInterpolationAmount;
        int m_iSimulationTicksThisFrame;
        int m_iNetworkProtocol;
        void* m_pSaveData;
        bool m_bClient;
        bool m_bRemoteClient;
        int m_nTimestampNetworkingBase;
        int m_nTimestampRandomizeWindow;
    } CGlobalVarsBase;
]]

local VClient018 = Utils.CreateInterface("client.dll", "VClient018")
return ffi.cast("CGlobalVarsBase*", ffi.cast("unsigned int **", ffi.cast("unsigned int", Utils.VirtualFunction(VClient018, 0) + 0x1f))[0][0])