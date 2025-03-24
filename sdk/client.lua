ffi.cdef[[
    typedef struct
    {
        float m_ClockOffsets[ 16 ];
        int m_iCurClockOffset;
        int m_nServerTick;
        int	m_nClientTick;
    } CClockDriftMgr;

    typedef struct
    {
        /*
        bool SendNetMsg( INetMessage* msg , bool rel = false , bool voice = false ) {
            return util::get_virtual_function< bool( __thiscall* )( void* , void* , bool , bool ) >( this , 40 )( this , msg , rel , voice );
        }
        
        int SendDatagram( bf_write* data = NULL )
        {
            return util::get_virtual_function< int( __thiscall* )( void* , bf_write* ) >( this , 46 )( this , data );
        }
        */
        uint8_t pad_0x14[ 0x14 ];
        bool m_bProcessingMessages;		// 0x0014
        bool m_bShouldDelete;			// 0x0015
        uint8_t pad_0x2[ 0x2 ];
        int m_nOutSequenceNr;			// 0x0018 last send outgoing sequence number
        int m_nInSequenceNr;			// 0x001C last received incoming sequnec number
        int m_nOutSequenceNrAck;		// 0x0020 last received acknowledge outgoing sequnce number
        int m_nOutReliableState;		// 0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int m_nInReliableState;			// 0x0028 state of incoming reliable data
        int m_nChokedPackets;			// 0x002C number of choked packets
        uint8_t pad_0x414[ 0x414 ];					// 0x0030
    } INetChannel;

    typedef struct
    {
        char pad_0000 [ 156 ];
        INetChannel* m_NetChannel;
        int m_nChallengeNr;
        char pad_00A4 [ 100 ];
        int m_nSignonState;
        int signon_pads [ 2 ];
        float m_flNextCmdTime;
        int m_nServerCount;
        int m_nCurrentSequence;
        int musor_pads [ 2 ];
        CClockDriftMgr m_ClockDriftMgr;
        int m_nDeltaTick;
        bool m_bPaused;
        char paused_align [ 3 ];
        int m_nViewEntity;
        int m_nPlayerSlot;
        int bruh;
        char m_szLevelName [ 260 ];
        char m_szLevelNameShort [ 80 ];
        char m_szGroupName [ 80 ];
        char pad_032 [ 92 ];
        int m_iMaxClients;
        char pad_0314 [ 18828 ];
        float m_iLastServerTickTime;
        bool m_bInSimulation;
        char pad_4C9D [ 3 ];
        int m_iOldTickcount;
        float m_flTickRemainder;
        float m_flFrameTime;
        int m_iLastOutGoingConnect;
        int m_iChockedCommands;
        int m_iLastCommandAck;
        int m_iLastServerTick;
        int m_iCommandAck;
        int m_nSoundSequence;
        char pad_4CCD [ 76 ];
        vec3_t m_vecViewAngles;
        int pads [ 54 ];
        void* m_nEvents;
    } CClientState;
]]

local CClientStateAddress = ffi.cast("unsigned int", Utils.FindSignature("engine.dll", "A1 ? ? ? ? 33 D2 6A 00 6A 00 33 C9 89 B0")) + 1

return ffi.cast("CClientState***", CClientStateAddress)[0][0][0]