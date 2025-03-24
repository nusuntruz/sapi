# sapi  
SeaSide Extended API  
Compatible with: gamesense, primordial  
Status: Unfinished  

# How to use  
Create a folder called "sapi" into the scripts directory  
Put all the files into the "sapi" directory  
**Note: In the case that the cheat has it s own seperate libraries folder, just do these steps into that**
```lua
require "sapi\\require.lua"

-- put this in the first line after that you can use the api
```

<a name="-1"></a>

|Contents|
|--------|
|[cheat](#0)|
|[Utils](#1)|
|[Hooks](#2)|
|[Input](#3)|
|[Console](#4)|
|[Netgraph](#5)|
|[Client](#6)|
|[Globals](#7)|
|[Engine](#8)|
|[Render](#9)|
|[Entity](#a)|
|[Animate](#b)|
|[json](#c)|
|[Color](#d)|
|[Vectors](#e)|

## <a name="0"></a>cheat
**API**  
Returns the current cheat name (ex. gamesense, primordial, etc.)
```lua
local api = cheat.API()
```

**User**  
Returns the user data such as name and user id in a table
```lua
local User = cheat.User()
print(string.format("%s %d", User.name, User.id))
```

**MenuVisible**  
Returns if the cheat menu is visible
```lua
local bVisible = cheat.MenuVisible
```
[back to Contents](#-1)

## <a name="1"></a>Utils
**CreateInterface**  
Returns a pointer to the interface, or nil on failure
```lua
local VClientEntityList003 = Utils.CreateInterface("client.dll","VClientEntityList003")
```

**FindSignature**  
Finds the specified pattern and returns a pointer to it, or nil if not found
```lua
local m_PlayerAnimStateOffset = ffi.cast("uintptr_t*", ffi.cast("uintptr_t", Utils.FindSignature("client.dll", "8B 8E ? ? ? ? F3 0F 10 48 04 E8 ? ? ? ? E9")) + 2)[0]
```

**VirtualFunction**  
Returns the n-th virtual function of the objects vtable
```lua
local VEngineClient014 = Utils.CreateInterface( "engine.dll", "VEngineClient014" )
local VEngineClient014VFTable = ffi.cast( "void***", VEngineClient014 )
local VGetLocalPlayer = ffi.cast( "int( __thiscall* )( void* )", Utils.VirtualFunction( VEngineClient014, 12 ) )
```

**VTableBind**  
Returns a structured interface for accessing custom data sources as if they were standard database tables
```lua
local VGUI_Surface031 = Utils.CreateInterface("vguimatsurface.dll", "VGUI_Surface031")
local UnlockCursor = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void)", 66)
```

**UnloadFunction**
```lua
Utils.UnloadFunction(function()
  -- do something when the script is unloaded
end)
```
[back to Contents](#-1)

## <a name="2"></a>Hooks
**Unload**
```lua
Hooks.Unload(function()
  -- do something when the script is unloaded
end)
```

**Draw**
```lua
Hooks.Draw(function()
  -- do something on each frame / mainly used for Render functions
end)
```

**CreateMove**
```lua
Hooks.CreateMove(function()
  -- do something on create move
end)
```
[back to Contents](#-1)

## <a name="3"></a>Input
**IsKeyPressed**
```lua
local LMousePressed = Input.IsKeyPressed(ButtonCode_t("MOUSE_LEFT"))
```

**IsKeyToggled**
```lua
local LMouseToggled = Input.IsKeyToggled(ButtonCode_t("MOUSE_LEFT"))
```

**GetScroll**
```lua
local iMouseScrollDelta = Input.GetScroll()
```

**GetCursorPosition**
```lua
local vecMousePos = Input.GetCursorPosition()
```

**Buttons**
```lua
local arrMouseLeft = Buttons[ButtonCode_t("MOUSE_LEFT")]
local szName = arrMouseLeft.szName
local bActive = arrMouseLeft.bActive
```

**ButtonCode_t**
```lua
-- Used like this
local KEY_F11 = ButtonCode_t("KEY_F11")

-- Full List
local ButtonCode_t = ffi.typeof([[
    enum
    {
    	KEY_NONE = 0,
    	KEY_0,
    	KEY_1,
    	KEY_2,
    	KEY_3,
    	KEY_4,
    	KEY_5,
    	KEY_6,
    	KEY_7,
    	KEY_8,
    	KEY_9,
    	KEY_A,
    	KEY_B,
    	KEY_C,
    	KEY_D,
    	KEY_E,
    	KEY_F,
    	KEY_G,
    	KEY_H,
    	KEY_I,
    	KEY_J,
    	KEY_K,
    	KEY_L,
    	KEY_M,
    	KEY_N,
    	KEY_O,
    	KEY_P,
    	KEY_Q,
    	KEY_R,
    	KEY_S,
    	KEY_T,
    	KEY_U,
    	KEY_V,
    	KEY_W,
    	KEY_X,
    	KEY_Y,
    	KEY_Z,
    	KEY_PAD_0,
    	KEY_PAD_1,
    	KEY_PAD_2,
    	KEY_PAD_3,
    	KEY_PAD_4,
    	KEY_PAD_5,
    	KEY_PAD_6,
    	KEY_PAD_7,
    	KEY_PAD_8,
    	KEY_PAD_9,
    	KEY_PAD_DIVIDE,
    	KEY_PAD_MULTIPLY,
    	KEY_PAD_MINUS,
    	KEY_PAD_PLUS,
    	KEY_PAD_ENTER,
    	KEY_PAD_DECIMAL,
    	KEY_LBRACKET,
    	KEY_RBRACKET,
    	KEY_SEMICOLON,
    	KEY_APOSTROPHE,
    	KEY_BACKQUOTE,
    	KEY_COMMA,
    	KEY_PERIOD,
    	KEY_SLASH,
    	KEY_BACKSLASH,
    	KEY_MINUS,
    	KEY_EQUAL,
    	KEY_ENTER,
    	KEY_SPACE,
    	KEY_BACKSPACE,
    	KEY_TAB,
    	KEY_CAPSLOCK,
    	KEY_NUMLOCK,
    	KEY_ESCAPE,
    	KEY_SCROLLLOCK,
    	KEY_INSERT,
    	KEY_DELETE,
    	KEY_HOME,
    	KEY_END,
    	KEY_PAGEUP,
    	KEY_PAGEDOWN,
    	KEY_BREAK,
    	KEY_LSHIFT,
    	KEY_RSHIFT,
    	KEY_LALT,
    	KEY_RALT,
    	KEY_LCONTROL,
    	KEY_RCONTROL,
    	KEY_LWIN,
    	KEY_RWIN,
    	KEY_APP,
    	KEY_UP,
    	KEY_LEFT,
    	KEY_DOWN,
    	KEY_RIGHT,
    	KEY_F1,
    	KEY_F2,
    	KEY_F3,
    	KEY_F4,
    	KEY_F5,
    	KEY_F6,
    	KEY_F7,
    	KEY_F8,
    	KEY_F9,
    	KEY_F10,
    	KEY_F11,
    	KEY_F12,
    	KEY_CAPSLOCKTOGGLE,
    	KEY_NUMLOCKTOGGLE,
    	KEY_SCROLLLOCKTOGGLE,
    	KEY_LAST = KEY_SCROLLLOCKTOGGLE,
    	KEY_COUNT = KEY_LAST - KEY_NONE + 1,
    	MOUSE_FIRST = KEY_LAST + 1,
    	MOUSE_LEFT = MOUSE_FIRST,
    	MOUSE_RIGHT,
    	MOUSE_MIDDLE,
    	MOUSE_4,
    	MOUSE_5,
    	KEY_MAX
    }
]])
```
[back to Contents](#-1)

## <a name="4"></a>Console
**Get**
```lua
local sv_cheats = Console.Get("sv_cheats")
```

**convar:Int()**
```lua
local sv_cheats_value = sv_cheats:Int()
```

**convar:Float()**
```lua
local cl_interp_value = cl_interp:Float()
```

**convar:String**
```lua
local con_filter_text_value = con_filter_text:String()
```

**convar:SetInt(int)**
```lua
sv_cheats:SetInt(1)
```

**convar:SetFloat(float)**
```lua
cl_interp:SetFloat(1.0)
```

**convar:SetString(string)**
```lua
con_filter_text:SetString("some string idk")
```
[back to Contents](#-1)

## <a name="5"></a>Netgraph
**Works only when netgraph is enabled**

```lua
-- Works like this
local m_AvgLatency = Netgraph.m_AvgLatency
```

```cpp
typedef struct {
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
        unsigned long m_hFontProportional;
        unsigned long m_hFont;
        void* cl_updaterate;
        void* cl_cmdrate;
        unsigned long m_nNetGraphHeight;
} CNetGraphPanel;
```
[back to Contents](#-1)

## <a name="6"></a>Client
```lua
-- Works like this
local m_flFrameTime = Client.m_flFrameTime
-- Only from values from CClientState
-- If you wanna use INetChannel or CClockDriftMgr
local m_nInSequenceNr = Client.m_NetChannel.m_nInSequenceNr
```

```cpp
typedef struct {
        float m_ClockOffsets[ 16 ];
        int m_iCurClockOffset;
        int m_nServerTick;
        int	m_nClientTick;
} CClockDriftMgr;

typedef struct {
        bool m_bProcessingMessages;		// 0x0014
        bool m_bShouldDelete;			// 0x0015
        int m_nOutSequenceNr;			// 0x0018 last send outgoing sequence number
        int m_nInSequenceNr;			// 0x001C last received incoming sequnec number
        int m_nOutSequenceNrAck;		// 0x0020 last received acknowledge outgoing sequnce number
        int m_nOutReliableState;		// 0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
        int m_nInReliableState;			// 0x0028 state of incoming reliable data
        int m_nChokedPackets;			// 0x002C number of choked packets
} INetChannel;

typedef struct {
        INetChannel* m_NetChannel;
        int m_nChallengeNr;
        int m_nSignonState;
        float m_flNextCmdTime;
        int m_nServerCount;
        int m_nCurrentSequence;
        CClockDriftMgr m_ClockDriftMgr;
        int m_nDeltaTick;
        bool m_bPaused;
        int m_nViewEntity;
        int m_nPlayerSlot;
        char m_szLevelName [ 260 ];
        char m_szLevelNameShort [ 80 ];
        char m_szGroupName [ 80 ];
        int m_iMaxClients;
        float m_iLastServerTickTime;
        bool m_bInSimulation;
        int m_iOldTickcount;
        float m_flTickRemainder;
        float m_flFrameTime;
        int m_iLastOutGoingConnect;
        int m_iChockedCommands;
        int m_iLastCommandAck;
        int m_iLastServerTick;
        int m_iCommandAck;
        int m_nSoundSequence;
        vec3_t m_vecViewAngles;
        void* m_nEvents;
} CClientState;
```
[back to Contents](#-1)

## <a name="7"></a>Globals
```lua
-- Works like this
local m_iTickCount = Globals.m_iTickCount
```

```cpp
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
```
[back to Contents](#-1)

## <a name="8"></a>Engine
**InGame**
```lua
local bInGame = Engine.InGame()
```

**IsConnected**
```lua
local bIsConnected = Engine.IsConnected()
```

**GetScreenSize**
```lua
local vecScreenSize = Engine.GetScreenSize()
```

**GetPlayerInfo**
```lua
local arrPlayerInfo = Engine.GetPlayerInfo(Entity.GetLocalPlayer())
```
```cpp
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
```

**GetPlayerByUserId**
```lua
local iPlayer = Engine.GetPlayerByUserId(userID) -- Not implemented a way to get userID yet
```

**GetViewAngles**
```lua
local vecViewAngles = Engine.GetViewAngles()
```

**SetViewAngles**
```lua
Engine.SetViewAngles(vec3_t(-89, 0, 0))
```

**Execute**
```lua
Engine.Execute("sv_cheats 1")
```

**IsPaused**
```lua
local bIsPaused = Engine.IsPaused()
```

**IsHLTV**
```lua
local bIsHLTV = Engine.IsHLTV()
```

**GetDemoPlaybackParameters**
```lua
local arrDemoPlayback = Engine.GetDemoPlaybackParameters()
```
```cpp
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
```

**GetScreenAspectRatio**
```lua
local r_aspectratio = Engine.GetScreenAspectRatio(1920, 1080)
```
[back to Contents](#-1)

## <a name="9"></a>Render
**pos and dim are 2D Vectors**  
**Every function in here works only on Hooks.Draw or any PaintTreverse Hook**

**GetCursorPosition**
```lua
local vecCursorPos = Render.GetCursorPosition()
```

**EFontFlags**
```lua
local AntiAlias = EFontFlags.ANTIALIAS
local Shadow = EFontFlags.SHADOW
```

**CreateFont**
```lua
local Verdana = Render.CreateFont("Verdana", EFontFlags.ANTIALIAS)
```

**font:Text**
```lua
Font:Text(pos, size, ...) --[[ [...] - Color(), "some text", Color(255, 0, 0), "another text", "again text", Color(), "yes draw me daddy"

Also we have Render.GradientText("This text is crazy", Color(), Color(255, 255, 255))
This text fades from white to black
]]
```

**font:Measure**
```lua
local vecTextSize = Font:Measure(size, text)
```

**font:Test**
```lua
Font:Test(pos, size)
```

**Line**
```lua
Render.Line(startpos, endpos, clr)
```

**Polygon**
```lua
local Vertices = {
  vec2_t(200, 200),
  vec2_t(300, 200),
  vec2_t(300, 300),
  vec2_t(200, 300)
}
Render.Polygon(vertices, clr)
```

**Polyline**
```lua
local Vertices = {
  vec2_t(200, 200),
  vec2_t(300, 200),
  vec2_t(300, 300),
  vec2_t(200, 300)
}
Render.Polyline(vertices, clr)
```

**SetClip**
```lua
Render.SetClip(pos, dim)
```

**EndClip**
```lua
Render.EndClip()
```

**MultiColorRect**
```lua
Render.MultiColorRect(pos, dim, clr_top_left, clr_top_right, clr_bottom_right, clr_bottom_left)
```

**FilledRect**
```lua
Render.FilledRect(pos, dim, clr, ...) --[[ [...] - clr2, horizontal, rounding, flags in any order
do flags like this - {RoundingFlags.CORNER_TOP_LEFT, RoundingFlags.CORNER_BOTTOM_RIGHT}
even if u have just one put it in the table
]]
```

**Rect**
```lua
Render.Rect(pos, dim, clr, ...)

-- same args as FilledRect
```

**Circle**
```lua
Render.Circle(pos, radius, color, start_angle, end_angle)
```

**FilledCircle**
```lua
Render.FilledCircle(pos, radius, color, start_angle, end_angle)
```

**Circle3D**
```lua
Render.Circle3D(Position, flRadius, color)

-- 3D Vector Position
```

**InitTextureRGBA**  
**Works only with my private image convertor, will be released later**
```lua
Render.InitTextureRGBA(data_table, size_vector)
```

**Image**
```lua
Render.Image(datatbl, pos, dim, clr)
```

```lua
RoundingFlags.CORNER_NONE
RoundingFlags.CORNER_TOP_LEFT
RoundingFlags.CORNER_TOP_RIGHT
RoundingFlags.CORNER_BOTTOM_LEFT
RoundingFlags.CORNER_BOTTOM_RIGHT
RoundingFlags.CORNER_TOP
RoundingFlags.CORNER_RIGHT
RoundingFlags.CORNER_BOTTOM
RoundingFlags.CORNER_LEFT
RoundingFlags.CORNER_TOP_LEFT_BOTTOM_RIGHT
RoundingFlags.CORNER_TOP_RIGHT_BOTTOM_LEFT
RoundingFlags.CORNER_ALL -- or leave rounding flags empty, if it has set a rounding radius it will default to this
```

[back to Contents](#-1)

## <a name="a"></a>Entity
**GetLocalPlayer**
```lua
local iLocalPlayerIndex = Entity.GetLocalPlayer()
```

**Get**
```lua
local entEntity = Entity.Get(iIndex)
```

**GetHandle**
```lua
local entHandle = Entity.GetHandle(nHandle)
```

**CEntity:GetProp**
```lua
local iHealth = entEntity:GetProp("int", 0x100)
```

**CEntity:m_iHealth()**  
**CEntity:m_iTeamNum()**  
**CEntity:m_bDormant()**  
**CEntity:m_fFlags()**  
**CEntity:m_vecVelocity()**  
**CEntity:m_flVelocity()**  
**CEntity:m_flSimulationTime()**  
**CEntity:m_flOldSimulationTime()**  
**CEntity:m_flLowerBodyYawTarget()**  
**CEntity:m_nPoseParameters()[iPose]**  
**CEntity:m_nAnimationLayers()[iLayer]**  
**CEntity:m_nAnimationState()**
```cpp
typedef struct {
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
        float       m_flNextLowerBodyYawUpdateTime; // 0x10C
        float       m_flDurationInAir; // 0x110
        float       m_flLeftGroundHeight; // 0x114
        float       m_flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float       m_flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        float       m_flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        float       m_flMinBodyYaw; // 0x330 + 0x4
        float       m_flMaxBodyYaw; // 0x334 + 0x4
        float       m_flMinPitch; //0x338 + 0x4
        float       m_flMaxPitch; // 0x33C + 0x4
        int         m_iAnimsetVersion; // 0x340 + 0x4
} CCSGOPlayerAnimationState_t;

typedef struct {
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
```

[back to Contents](#-1)

## <a name="b"></a>Animate
**Init**
```lua
local iAnimation = Animate.Init(szName, bEnabler, iMultiplyer, iDefault)
```

**Get**
```lua
-- if it was created previously
local iAnimation = Animate.Get(szName)
```

[back to Contents](#-1)

## <a name="c"></a>json
**encode**
```lua
json.encode(lua_code)
```

**decode**
```lua
local ret = json.decode(json_code)
```

[back to Contents](#-1)

## <a name="d"></a>Color
**Color**
```lua
local clrMainColor = Color() or Color(255, 255, 255) or Color(255, 255, 255, 255)
```
**color_t:toHSV()**  
**color_t:toHEX()**  
**color_t:unpack()**  
**color_t:SetAlpha(iAlpha) from 0 to 255**  
**color_t:SetAlphaIncrement(flAlpha) from 0 to 1**  
**color_t:Print(szSpacing)**  
**color_t:toRGB() eventho is already rgb, it just returns itself**  
**color_t:Lerp(anotherColor, fraction)**  

**HSV**
```lua
local clrMainColor = HSV(360, 1, 1)
```
**hsv_t:toRGB()**  
**hsv_t:toHEX()**  
**hsv_t:toHSV()**  
**hsv_t:unpack()**  

**HEX**
```lua
local clrMainColor = HEX("#FFFFFFFF") -- White
```
**hex_t:Get() returns string hex color**  
**hex_t:toRGB()**  
**hex_t:toHSV()**  
**hex_t:toHEX()**  

[back to Contents](#-1)

## <a name="e"></a>Vectors
**vec2_t**
```lua
local vecPosition2d = vec2_t(200, 200)
-- World to Screen
local vecWorldPositionOnScreen = vec2_t(200, 0, 150) or vec2_t(vec3_t(200, 0, 150))
```

**vec3_t**
```lua
local vecPosition3d = vec3_t(200, 0, 150)
```

**vector_data_t:ffi() get ffi vector**  
**vector_data_t:Add(i)**  
**vector_data_t:Sub(i)**  
**vector_data_t:Multiply(i)**  
**vector_data_t:Fraction(i)**  
**vector_data_t:Dot(vector)**  
**vector_data_t:Length()**  
**vector_data_t:Length2d()**  
**vector_data_t:Distance(distance)**  
**vector_data_t:Angle(vector)**  
**vector_data_t:unpack()**  
**vector_data_t:Copy() or vector_data_t:copy()**  
**vector_data_t:Hovered(dim)**  
**vector_data_t:Drag(vec2d, m_szName, m_bShouldBlockDragging)**  

[back to Contents](#-1)
