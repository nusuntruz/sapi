ffi.cdef[[
    typedef struct
    {
        void* vtable;
        unsigned char gap4 [ 72 ];
        unsigned long dword4C;
        unsigned char gap50 [ 20 ];
        unsigned short word64;
        unsigned char gap66 [ 42 ];
        unsigned long dword90;
        unsigned char gap94 [ 16 ];
        unsigned long dwordA4;
        unsigned char gapA8 [ 244 ];
        unsigned short word19C;
        unsigned char gap19E [ 3 ];
        unsigned char byte1A1;
        unsigned short word1A2;
        unsigned char byte1A4;
        unsigned char gap1A5 [ 19 ];
        char char1B8;
        unsigned char gap1B9 [ 77823 ];
        float m_FrameRate;
        float m_AvgLatency;
        float m_AvgPacketLoss;
        float m_AvgPacketChoke;
        int m_IncomingSequence;
        int m_OutgoingSequence;
        unsigned long m_UpdateWindowSize;
        float m_IncomingData;
        float m_OutgoingData;
        float m_AvgPacketIn;
        float m_AvgPacketOut;
        unsigned char gap131E4 [ 16 ];
        int dword131F4;
        unsigned long dword131F8;
        unsigned long dword131FC;
        unsigned long dword13200;
        unsigned long dword13204;
        unsigned long m_hFontProportional;
        unsigned long m_hFont;
        unsigned long dword13210;
        void* cl_updaterate;
        void* cl_cmdrate;
        unsigned long dword1321C;
        unsigned long dword13220;
        unsigned long dword13224;
        unsigned long dword13228;
        unsigned long dword1322C;
        unsigned long dword13230;
        unsigned long dword13234;
        unsigned long m_nNetGraphHeight;
        unsigned long dword1323C;
        unsigned long dword13240;
        unsigned long dword13244;
        unsigned long dword13248;
    } CNetGraphPanel;
]]
local pNetGraphPanelAddr = ffi.cast("unsigned int", Utils.FindSignature("client.dll", "89 1D ? ? ? ? 8B C3 5B 8B E5 5D C2 04 00")) + 2

return ffi.cast("CNetGraphPanel***", pNetGraphPanelAddr)[0][0]