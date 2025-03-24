ffi.cdef[[
    typedef struct
    {
        char        pad0[0x60]; // 0x00
        void*       m_nEntity; // 0x60
        void*       m_nActiveWeapon; // 0x64
        void*       m_nLastActiveWeapon; // 0x68
        float       m_flLastUpdateTime; // 0x6C
        int         m_iLastUpdateFrame; // 0x70
        float       m_flLastUpdateIncrement; // 0x74
        float       m_flEyeYaw; // 0x78
        float       m_flEyePitch; // 0x7C
        float       m_flGoalFeetYaw; // 0x80
        float       m_flLastFeetYaw; // 0x84
        float       m_flMoveYaw; // 0x88
        float       m_flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float       m_flLeanAmount; // 0x90
        char        pad1[0x4]; // 0x94
        float       m_flFeetCycle; // 0x98 0 to 1
        float       m_flMoveWeight; // 0x9C 0 to 1
        float       m_flMoveWeightSmoothed; // 0xA0
        float       m_flDuckAmount; // 0xA4
        float       m_flHitGroundCycle; // 0xA8
        float       m_flRecrouchWeight; // 0xAC
        vec3_t      m_vecOrigin; // 0xB0
        vec3_t      m_vecLastOrigin;// 0xBC
        vec3_t      m_vecVelocity; // 0xC8
        vec3_t      m_vecVelocityNormalized; // 0xD4
        vec3_t      m_vecVelocityNormalizedNonZero; // 0xE0
        float       m_flVelocityLenght2D; // 0xEC
        float       m_flJumpFallVelocity; // 0xF0
        float       m_flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float       m_flRunningSpeed; // 0xF8
        float       m_flDuckingSpeed; // 0xFC
        float       m_flDurationMoving; // 0x100
        float       m_flDurationStill; // 0x104
        bool        m_bOnGround; // 0x108
        bool        m_bHitGroundAnimation; // 0x109
        char        pad2[0x2]; // 0x10A
        float       m_flNextLowerBodyYawUpdateTime; // 0x10C
        float       m_flDurationInAir; // 0x110
        float       m_flLeftGroundHeight; // 0x114
        float       m_flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float       m_flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char        pad3[0x4]; // 0x120
        float       m_flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char        pad4[0x208]; // 0x128
        char        pad_because_yes[0x4]; // 0x330
        float       m_flMinBodyYaw; // 0x330 + 0x4
        float       m_flMaxBodyYaw; // 0x334 + 0x4
        float       m_flMinPitch; //0x338 + 0x4
        float       m_flMaxPitch; // 0x33C + 0x4
        int         m_iAnimsetVersion; // 0x340 + 0x4
    } CCSGOPlayerAnimationState_t;
    typedef struct
    {
        float   m_flAnimationTime;		
        float   m_flFadeOutTime;	
        int     m_iFlags;			
        int     m_iActivity;			
        int     m_iPriority;			
        int     m_iOrder;			
        int     m_iSequence;			
        float   m_flPrevCycle;		
        float   m_flWeight;			
        float   m_flWeightDeltaRate;
        float   m_flPlaybackRate;	
        float   m_flCycle;			
        void*   m_nOwner;			
        int     m_iBits;				
    } C_AnimationLayer;
]]

local VEngineClient014 = Utils.CreateInterface( "engine.dll", "VEngineClient014" )
local VClientEntityList003 = Utils.CreateInterface( "client.dll", "VClientEntityList003" )

local VEngineClient014VFTable = ffi.cast( "void***", VEngineClient014 )
local VClientEntityList003VFTable = ffi.cast( "void***", VClientEntityList003 )

local VGetLocalPlayer = ffi.cast( "int( __thiscall* )( void* )", Utils.VirtualFunction( VEngineClient014, 12 ) )
local VGetClientEntity = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.VirtualFunction( VClientEntityList003, 3 ) )
local VGetClientHandle = ffi.cast( "void*( __thiscall* )( void*, int )", Utils.VirtualFunction( VClientEntityList003, 4 ) )

local CEntity = {
    m_iIndex = -1,
    m_szType = 'Entity',
    m_hAddress = nil
}

function CEntity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CEntity:GetProp(typedef, m_hOffset)
    return ffi.cast((typedef .. "*"), ffi.cast('unsigned int', self.m_hAddress) + m_hOffset)[0]
end

function CEntity:m_iHealth()
    return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0x100)[0]
end

function CEntity:m_iTeamNum()
    return ffi.cast('int*', ffi.cast('unsigned int', self.m_hAddress) + 0xF4)[0]
end

function CEntity:m_nAnimationLayers()
    return ffi.cast("C_AnimationLayer**", ffi.cast("uintptr_t", self.m_hAddress) + 0x2990)[0]
end

local m_PlayerAnimState = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", Utils.FindSignature("client.dll", "8B 8E ? ? ? ? F3 0F 10 48 04 E8 ? ? ? ? E9")) + 2)[0]
function CEntity:m_nAnimationState()
    return ffi.cast("CCSGOPlayerAnimationState_t**", ffi.cast("uintptr_t", self.m_hAddress) + m_PlayerAnimState)[0]
end

function CEntity:m_nPoseParameters()
    return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 10104)
end

function CEntity:m_bDormant()
    return ffi.cast("bool*", ffi.cast("uintptr_t", self.m_hAddress) + 0xED)[0]
end

function CEntity:m_fFlags()
    return ffi.cast("float*", ffi.cast("uintptr_t", self.m_hAddress) + 0x104)[0]
end

function CEntity:m_vecVelocity()
    return ffi.cast('vec3_t*', ffi.cast('unsigned int', self.m_hAddress) + 0x114)[0]
end

function CEntity:m_flVelocity()
    return vec3_t(self:m_vecVelocity()):Length2d()
end

function CEntity:m_flSimulationTime()
    return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268)[0]
end

function CEntity:m_flOldSimulationTime()
    return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x268 + ffi.sizeof('float'))[0]
end

function CEntity:m_flLowerBodyYawTarget()
    return ffi.cast('float*', ffi.cast('uintptr_t', self.m_hAddress) + 0x9ADC)[0]
end

return {
    GetLocalPlayer = function ()
        return VGetLocalPlayer(VEngineClient014VFTable)
    end,
    Get = function (m_iIndex)
        if m_iIndex < 1 then return end
        if not Engine.InGame() then return end
        local m_hAddress = VGetClientEntity(VClientEntityList003VFTable, m_iIndex)
        if not m_hAddress or m_hAddress == ffi.NULL then return end
        return CEntity:new({
            m_iIndex = m_iIndex,
            m_szType = 'Entity',
            m_hAddress = m_hAddress
        })
    end,
    GetHandle = function (m_iHandle)
        if m_iHandle < 1 then return end
        if not Engine.InGame() then return end
        local m_hAddress = VGetClientHandle(VClientEntityList003VFTable, m_iHandle)
        if not m_hAddress or m_hAddress == ffi.NULL then return end
        return CEntity:new({
            m_iIndex = m_iHandle,
            m_szType = 'Handle',
            m_hAddress = m_hAddress
        })
    end
}