local InputSystemVersion001Raw = Utils.CreateInterface('inputsystem.dll', 'InputSystemVersion001') or error('[S-API](Signatures.GetScrollInterface) Invalid or unable to found scroll interface')
local InputSystemVersion001 = ffi.cast(ffi.typeof('void***'), InputSystemVersion001Raw)
local GetEventData = Utils.VTableBind(InputSystemVersion001, 21, 'const struct {int m_nType, m_nTick, m_nData, m_nData2, m_nData3;}*(__thiscall*)(void*)')
local ButtonCodeToString = Utils.VTableBind(InputSystemVersion001, 40, "const char*(__thiscall*)(void*, int)")
local IsButtonDown = Utils.VTableBind(InputSystemVersion001, 15, "int(__thiscall*)(void*, int)")
local PrevScrollTick = 0

local event_types = {
	[0] = "IE_ButtonPressed",
	[1] = "IE_ButtonReleased",
	[2] = "IE_ButtonDoubleClicked",
	[3] = "IE_AnalogValueChanged",
	[100] = "IE_FirstSystemEvent",
	[101] = "IE_ControllerInserted",
	[102] = "IE_ControllerUnplugged",
	[103] = "IE_Close",
	[104] = "IE_WindowSizeChanged",
	[105] = "IE_PS_CameraUnplugged",
	[106] = "IE_PS_Move_OutOfView",
	[200] = "IE_FirstUIEvent",
	[201] = "IE_SetCursor",
	[202] = "IE_KeyTyped",
	[203] = "IE_KeyCodeTyped",
	[204] = "IE_InputLanguageChanged",
	[205] = "IE_IMESetWindow",
	[206] = "IE_IMEStartComposition",
	[207] = "IE_IMEComposition",
	[208] = "IE_IMEEndComposition",
	[209] = "IE_IMEShowCandidates",
	[210] = "IE_IMEChangeCandidates",
	[211] = "IE_IMECloseCandidates",
	[212] = "IE_IMERecomputeModes",
	[213] = "IE_OverlayEvent",
	[1000] = "IE_FirstVguiEvent",
	[2000] = "IE_FirstAppEvent",
	[2001] = "IE_EnteredLeftMainWindow" -- if m_nData is 0 it left, if its 1 it entered
}

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

local GetScroll = function ()
    local data = GetEventData()
    if not data then
        return 0
    end
    if data.m_nTick ~= PrevScrollTick then
        PrevScrollTick = data.m_nTick;
        return ((data.m_nData == 112 and 1 or (data.m_nData == 113 and -1 or 0)))
    end
    return 0
end

local InputStates = {}
local CurrentInput = function ()
    local event_data = GetEventData()
	local etype = event_types[event_data.m_nType]

    if event_data.m_nData ~= 112 and event_data.m_nData ~= 113 and (etype == "IE_ButtonPressed" or etype == "IE_ButtonDoubleClicked" or etype == "IE_KeyCodeTyped") then
        InputStates[event_data.m_nData] = {
			szName = ffi.string(ButtonCodeToString(event_data.m_nData)),
			bActive = true
		}
    elseif etype == "IE_ButtonReleased" then
        InputStates[event_data.m_nData] = {
			szName = ffi.string(ButtonCodeToString(event_data.m_nData)),
			bActive = false
		}
    end
end

local IsKeyPressed = function(key)
    return (IsButtonDown(ButtonCode_t(key)) == 2049 and true or false)
end

local IsKeyToggled = function (key)
	if not InputStates[key].bToggled then
		InputStates[key].bToggled = false
	end

	if IsKeyPressed(key) then
		InputStates[key].bToggledSwitch = true
	else
		if InputStates[key].bToggledSwitch then
			InputStates[key].bToggled = not InputStates[key].bToggled
		end
		InputStates[key].bToggledSwitch = false
	end

	return InputStates[key].bToggled
end

local GetCursorPosition = function ()
    return Render.GetCursorPosition()
end

Hooks.Draw(function ()
    CurrentInput()
end)

return {
    IsKeyPressed = IsKeyPressed,
    IsKeyToggled = IsKeyToggled,
    GetScroll = GetScroll,
    GetCursorPosition = GetCursorPosition,
	ButtonCode_t = ButtonCode_t,
	Buttons = InputStates
}