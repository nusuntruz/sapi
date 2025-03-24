local Render = {}

local ScreenSize = Engine.GetScreenSize()

local iScale
Render.EnableScaledRendering = function (custom)
    if custom then
        iScale = custom
    else
        iScale = math.max(0.85, Engine.GetScreenSize().y / 1080)
    end
end

Render.DisableScaledRendering = function ()
    iScale = nil
end

local new_charbuffer = ffi.typeof("char[?]")
local new_intptr = ffi.typeof("int[1]")
local new_widebuffer = ffi.typeof("wchar_t[?]")

-- localize
local Localize_001 = Utils.CreateInterface("localize.dll", "Localize_001")
local native_Localize_ConvertAnsiToUnicode = Utils.VTableBind(Localize_001, 15, "int(__thiscall*)(void*, const char*, wchar_t*, int)")
local native_Localize_ConvertUnicodeToAnsi = Utils.VTableBind(Localize_001, 16, "int(__thiscall*)(void*, wchar_t*, char*, int)")
local native_Localize_FindSafe = Utils.VTableBind(Localize_001, 12, "wchar_t*(__thiscall*)(void*, const char*)")

local VGUI_Surface031 = Utils.CreateInterface("vguimatsurface.dll", "VGUI_Surface031")

ffi.cdef[[
    typedef struct {
        vec2_t m_Position;
        vec2_t m_TexCoord;
    } Vertex_t;
]]

-- surface
local native_Surface = {}
native_Surface.ISurface = VGUI_Surface031
native_Surface.UnlockCursor = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void)", 66) --vmt_bind(VGUI_Surface031, "void(__thiscall*)(void)", 66)
native_Surface.LockCursor = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void)", 67)
native_Surface.DrawSetColor = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, int, int, int)", 15)
native_Surface.DrawTexturedRect = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, int, int, int)", 41)
native_Surface.DrawSetTextureFile = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, const char*, int, bool)", 36)
native_Surface.DrawSetTextureRGBA = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, const unsigned char*, int, int)", 37)
native_Surface.DrawSetTexture = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int)", 38)
native_Surface.DrawFilledRectFade = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)", 123)
native_Surface.DrawFilledRect = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, int, int, int, int)', 16)
native_Surface.DrawOutlinedRect = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, int, int, int, int)', 18)
native_Surface.CreateNewTextureID = Utils.VTableBind(VGUI_Surface031, "int(__thiscall*)(void*, bool)", 43)
native_Surface.IsTextureIDValid = Utils.VTableBind(VGUI_Surface031, "bool(__thiscall*)(void*, int)", 42)
native_Surface.FontCreate = Utils.VTableBind(VGUI_Surface031, 'unsigned long(__thiscall*)(void*)', 71)
native_Surface.SetFontGlyphSet = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
native_Surface.GetTextSize = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
native_Surface.DrawSetTextColor = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, int, int, int, int)', 25)
native_Surface.DrawSetTextFont = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, unsigned long)', 23)
native_Surface.DrawSetTextPos = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, int, int)', 26)
native_Surface.DrawPrintText = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)
native_Surface.DrawLine = Utils.VTableBind(VGUI_Surface031, 'void(__thiscall*)(void*, int, int, int, int)', 19)
native_Surface.DrawTexturedPolygon = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, Vertex_t*, bool)", 106)
native_Surface.DrawTexturedPolyLine = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, const Vertex_t*, int)", 104)
native_Surface.LimitDrawingArea = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int, int, int, int)", 147)
native_Surface.GetDrawingArea = Utils.VTableBind(VGUI_Surface031, "void(__thiscall*)(void*, int&, int&, int&, int&)", 146)
native_Surface.GetCursorPosition = Utils.VTableBind(VGUI_Surface031, "unsigned int(__thiscall*)(void*, int*, int*)", 100)

local RoundingFlags = {} do
	RoundingFlags.CORNER_NONE = 0
    RoundingFlags.CORNER_TOP_LEFT = bit.lshift(1, 0)
    RoundingFlags.CORNER_TOP_RIGHT = bit.lshift(1, 1)
    RoundingFlags.CORNER_BOTTOM_LEFT = bit.lshift(1, 2)
    RoundingFlags.CORNER_BOTTOM_RIGHT = bit.lshift(1, 3)
    RoundingFlags.CORNER_TOP = bit.bor(RoundingFlags.CORNER_TOP_LEFT, RoundingFlags.CORNER_TOP_RIGHT)
    RoundingFlags.CORNER_RIGHT = bit.bor(RoundingFlags.CORNER_TOP_RIGHT, RoundingFlags.CORNER_BOTTOM_RIGHT)
    RoundingFlags.CORNER_BOTTOM = bit.bor(RoundingFlags.CORNER_BOTTOM_LEFT, RoundingFlags.CORNER_BOTTOM_RIGHT)
    RoundingFlags.CORNER_LEFT = bit.bor(RoundingFlags.CORNER_TOP_LEFT, RoundingFlags.CORNER_BOTTOM_LEFT)
    RoundingFlags.CORNER_TOP_LEFT_BOTTOM_RIGHT = bit.bor(RoundingFlags.CORNER_TOP_LEFT, RoundingFlags.CORNER_BOTTOM_RIGHT)
    RoundingFlags.CORNER_TOP_RIGHT_BOTTOM_LEFT = bit.bor(RoundingFlags.CORNER_TOP_RIGHT, RoundingFlags.CORNER_BOTTOM_LEFT)
    RoundingFlags.CORNER_ALL = bit.bor(RoundingFlags.CORNER_TOP, RoundingFlags.CORNER_RIGHT, RoundingFlags.CORNER_BOTTOM, RoundingFlags.CORNER_LEFT)
end

local function draw_print_text(text, localized)
	local size = 1024.0
    if localized then
        local char_buffer = ffi.typeof("char[?]")(size)
        native_Localize_ConvertUnicodeToAnsi(text, char_buffer, size)
        return native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
    else
        local wide_buffer = ffi.typeof("wchar_t[?]")(size)
        native_Localize_ConvertAnsiToUnicode(text, wide_buffer, size)
        return native_Surface.DrawPrintText(wide_buffer, #text, 0)
    end
end

local function get_text_size(font, text)
	local wide_buffer = new_widebuffer(1024)
	local w_ptr = new_intptr()
	local h_ptr = new_intptr()

	native_Localize_ConvertAnsiToUnicode(text, wide_buffer, 1024)
	native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

	return vec2_t(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
end

Render.GetCursorPosition = function ()
    local x_ptr = new_intptr()
	local y_ptr = new_intptr()

    native_Surface.GetCursorPosition(x_ptr, y_ptr)

    return vec2_t(tonumber(x_ptr[0]), tonumber(y_ptr[0]))
end

local Cast_m_bClippingEnabled = ffi.cast('int*', ffi.cast("unsigned int", VGUI_Surface031) + 0x280)

local clipCache = {
    x = ffi.typeof("int[1]")(),
    y = ffi.typeof("int[1]")(),
    x1 = ffi.typeof("int[1]")(),
    y1 = ffi.typeof("int[1]")()
}

--[[
local EFontFlags = ffi.typeof([[
    enum {
	    NONE,
	    ITALIC			= 0x001,
	    UNDERLINE		= 0x002,
	    STRIKEOUT		= 0x004,
	    SYMBOL			= 0x008,
	    ANTIALIAS		= 0x010,
	    GAUSSIANBLUR		= 0x020,
	    ROTARY			= 0x040,
	    DROPSHADOW		= 0x080,
	    ADDITIVE		= 0x100,
	    OUTLINE		= 0x200,
	    CUSTOM			= 0x400,
    }
]]--)]]

local EFontFlags = {
    ANTIALIAS = 0x010,
    SHADOW = 0x080,
    ITALIC = 0x001
}

local font_cache = {}

local font_data_t = {
    name = "",
    flags = 0
}

function font_data_t:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function InitFont(font, height)
    font.cache_key = string.format("%s\0%d\0%d\0%d", font.name, height, 400, font.flags)
    if not font_cache[font.cache_key] then
        font_cache[font.cache_key] = native_Surface.FontCreate()
		native_Surface.SetFontGlyphSet(font_cache[font.cache_key], font.name, height, 400, 0, 0, bit.bor(font.flags), 0, 0)
    end
    return font_cache[font.cache_key]
end

Render.CreateFont = function (fontname, flags)
    if not fontname or type(fontname) ~= "string" then return error("[SAPI](Render.CreateFont) Invalid Font Name") end
    local flags_i = 0
    if flags then
        local t = type(flags)
	    if t == "number" then
	    	flags_i = flags
	    elseif t == "table" then
	    	for i=1, #flags do
	    		flags_i = flags_i + flags[i]
	    	end
	    else
	    	error("[SAPI](Render.CreateFont) Invalid Font Flags, has to be number or table")
	    end
    end

    return font_data_t:new({
        name = fontname,
        flags = flags_i
    })
end

local Text = function(font, pos, clr, text)
	native_Surface.DrawSetTextPos(pos.x, pos.y)
	native_Surface.DrawSetTextFont(font)
	native_Surface.DrawSetTextColor(clr:unpack())
	return draw_print_text(text, false)
end

function font_data_t:Text(pos, size, ...)
    local a = {...}
    if #a < 1 then return end
    if not pos or type(pos) ~= "table" or not pos.type or pos.type ~= "vec2_t" then return error("[S-API](font:Text) Invalid Position Vector") end
    if type(size) ~= "number" and type(size) ~= "table" then return error("[S-API](font:Text) Size is 0") end

    if type(size) == "table" then
        local flags_i = 0
	    local t = type(size[2])
	    if t == "number" then
	    	flags_i = size[2]
	    elseif t == "table" then
	    	for i=1, #size[2] do
	    		flags_i = flags_i + size[2][i]
	    	end
	    else
	    	error("invalid flags type, has to be number or table")
	    end

        self.flags = self.flags + flags_i
        size = size[1]
    end

    if iScale then
        size = math.floor(size * iScale)
    end

    local draw_font = InitFont(self, size)
    local draw_clr = Color()
    local offset = 0
    for i = 1, #a do
        if type(a[i]) == "number" then
            a[i] = tostring(a[i])
        end
        if type(a[i]) == "string" then
			Text(draw_font, vec2_t(pos.x + offset, pos.y), draw_clr, a[i])
            offset = offset + get_text_size(draw_font, a[i]).x
        elseif type(a[i]) == "table" then
			if a[i] and a[i].type then
				draw_clr = a[i].type == 'rgba' and a[i] or a[i]:toRGB()
			end
        end
    end
end

function font_data_t:Measure(size, ...)
    local a = {...}
    if not a[1] then return vec2_t(0, 0) end
    local text = ""
    if #a > 1 then
        for i = 1, #a do
            if type(a[i]) == "string" then
                text = text .. a[i]
            end
        end
    else
        text = a[1]
    end
    if not text then return vec2_t(0, 0) end
    if type(size) ~= "number" and type(size) ~= "table" then return error("[S-API](font:Text) Size is 0") end

    if type(size) == "table" then
        local flags_i = 0
	    local t = type(size[2])
	    if t == "number" then
	    	flags_i = size[2]
	    elseif t == "table" then
	    	for i=1, #size[2] do
	    		flags_i = flags_i + size[2][i]
	    	end
	    else
	    	error("invalid flags type, has to be number or table")
	    end

        self.flags = self.flags + flags_i
        size = size[1]
    end

    if iScale then
        size = math.floor(size * iScale)
    end

    local draw_font = InitFont(self, size)
    return get_text_size(draw_font, text)
end

function font_data_t:Test(pos, size)
    self:Text(pos, size, "a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ß + # ä ö ü , . -")
    self:Text(vec2_t(pos.x, pos.y + size), size, "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z = ! \" § $ % & / ( ) = ? { [ ] } \\ * ' _ : ; ~ ")
end

Render.Line = function (startpos, endpos, clr)
    if not startpos or type(startpos) ~= "table" or startpos.type ~= 'vec2_t' then return error("[SAPI](Render.Line) Invalid Start Position Vector") end
    if not endpos or type(endpos) ~= "table" or endpos.type ~= 'vec2_t' then return error("[SAPI](Render.Line) Invalid End Position Vector") end
    clr = clr or Color()
    if clr.type ~= "rgba" then
        clr = clr:toRGB()
    end
    native_Surface.DrawSetColor(clr:unpack())
	return native_Surface.DrawLine(startpos.x, startpos.y, endpos.x, endpos.y)
end

local vec2_t_zero = ffi.new(ffi.typeof('vec2_t'), {x = 0, y = 0})

Render.Polygon = function(vertices, clr, clipvertices, no_draw_set_color)
    if not vertices or type(vertices) ~= "table" then return error("[SAPI](Render.Polygon) Vertices Vector Empty") end
    clr = clr or Color()
    if clr.type ~= "rgba" then
        clr = clr:toRGB()
    end
    local numvert = #vertices
    local buf = ffi.typeof('Vertex_t[?]')(numvert)
    local i = 0
    for k, vec in pairs(vertices) do
        buf[i].m_Position = vec:ffi()
        buf[i].m_TexCoord = vec2_t_zero
        i = i + 1
    end
    if not no_draw_set_color then
        native_Surface.DrawSetColor(clr:unpack())
        native_Surface.DrawSetTexture(-1)
    end
    native_Surface.DrawTexturedPolygon(numvert, buf, (clipvertices or true))
end

Render.Polyline = function(vertices, clr)
    if not vertices or type(vertices) ~= "table" then return error("[SAPI](Render.Polyline) Vertices Vector Empty") end
    clr = clr or Color()
    if clr.type ~= "rgba" then
        clr = clr:toRGB()
    end
    local numvert = #vertices
    local buf = ffi.typeof('Vertex_t[?]')(numvert)
    local i = 0
    for k, vec in pairs(vertices) do
        buf[i].m_Position = vec:ffi()
        buf[i].m_TexCoord = vec2_t_zero
        i = i + 1
    end
    native_Surface.DrawSetColor(clr:unpack())
    native_Surface.DrawSetTexture(-1)
    native_Surface.DrawTexturedPolyLine(buf, numvert)
end

Render.SetClip = function(pos, size)
    if iScale then
        size = vec2_t(size.x * iScale, size.y * iScale)
    end
	Cast_m_bClippingEnabled[0] = true
	native_Surface.GetDrawingArea(clipCache.x, clipCache.y, clipCache.x1, clipCache.y1)
	native_Surface.LimitDrawingArea(pos.x, pos.y, pos.x + size.x, pos.y + size.y)
end

Render.EndClip = function()
	native_Surface.LimitDrawingArea(clipCache.x[0], clipCache.y[0], clipCache.x1[0], clipCache.y1[0])
	Cast_m_bClippingEnabled[0] = false
end

local draw_func_gradient_rect = function(pos, dim, clr, clr2, horizontal)
    horizontal = horizontal or false
    native_Surface.DrawSetColor(clr:unpack())
    native_Surface.DrawFilledRectFade(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y, 255, 0, horizontal)
    native_Surface.DrawSetColor(clr2:unpack())
    return native_Surface.DrawFilledRectFade(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y, 0, 255, horizontal)
end

local draw_filled_rect_box = function(pos, dim, clr)
    if clr then
        native_Surface.DrawSetColor(clr:unpack())
    end
    return native_Surface.DrawFilledRect(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y)
end

local draw_outlined_rect = function(pos, dim, clr)
    native_Surface.DrawSetColor(clr:unpack())
    return native_Surface.DrawOutlinedRect(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y)
end

local draw_rect_rounded = function(pos, dim, clr, rounding, flags, is_filled, no_draw_set_color)
    if not flags and rounding and rounding > 0.5 then
        flags = RoundingFlags.CORNER_ALL
    elseif not flags and not rounding then
        flags = RoundingFlags.CORNER_NONE
    end
    local f_rectangle_vertices = {}
    rounding = rounding or 0
    if rounding > 0.5 and flags ~= RoundingFlags.CORNER_NONE then
        local round_top_left = bit.band(flags, RoundingFlags.CORNER_TOP_LEFT) ~= 0
        local round_top_right = bit.band(flags, RoundingFlags.CORNER_TOP_RIGHT) ~= 0
        local round_bottom_left = bit.band(flags, RoundingFlags.CORNER_BOTTOM_LEFT) ~= 0
        local round_bottom_right = bit.band(flags, RoundingFlags.CORNER_BOTTOM_RIGHT) ~= 0

        local num_segments = rounding * 4
    
        for i = 0, 3 do
            local round_corner = true

            if i == 0 then
                round_corner = round_top_right
            elseif i == 1 then
                round_corner = round_bottom_right
            elseif i == 2 then
                round_corner = round_bottom_left
            elseif i == 3 then
                round_corner = round_top_left
            end

            local corner_point = vec2_t(
                pos.x + ((i < 2) and (dim.x - (round_corner and rounding or 0)) or round_corner and rounding or 0),
                pos.y + ((i % 3 ~= 0) and (dim.y - (round_corner and rounding or 0)) or round_corner and rounding or 0)
            )

            if round_corner then
                for p = 0, num_segments - 1 do
                    local angle = math.deg2rad(90 * (i - 1) + (90 / num_segments) * p)

                    f_rectangle_vertices[#f_rectangle_vertices + 1] = vec2_t(corner_point.x + rounding * math.cos(angle), corner_point.y + rounding * math.sin(angle))
                end
            else
                f_rectangle_vertices[#f_rectangle_vertices + 1] = corner_point
            end
        end
        f_rectangle_vertices[#f_rectangle_vertices + 1] = f_rectangle_vertices[1]

        if is_filled then
            Render.Polygon(f_rectangle_vertices, clr, nil, no_draw_set_color)
        else
            Render.Polyline(f_rectangle_vertices, clr)
        end
    else
        if is_filled then
            draw_filled_rect_box(pos, dim, clr)
        else
            draw_outlined_rect(pos, dim, clr)
        end
    end
end

local rect_checks = function(...)
    local a = {...}
    if #a < 1 then return end

    local clr2, horizontal, rounding, flags
    for i = 1, #a do
        if type(a[i]) == "table" then
            if a[i].type then
                if a[i].type == "rgba" then
                    clr2 = a[i]
                elseif a[i].type == "hsv" or a[i].type == "hex" then
                    clr2 = a[i]:toRGB()
                end
            else
                flags = 0
                for j = 1, #a[i] do
                    flags = bit.bor(flags, a[i][j])
                end
            end
        elseif type(a[i]) == "boolean" then
            horizontal = a[i]
        elseif type(a[i]) == "number" then
            if a[i] >= 1 then
                rounding = math.floor(a[i])
            end
        end
    end

    return clr2, horizontal, rounding, flags
end

local vecMultiColorRectsBackup = {}
Render.MultiColorRect = function (pos, dim, clr_top_left, clr_top_right, clr_bottom_right, clr_bottom_left)
    clr_top_left = clr_top_left:toRGB()
    clr_top_right = clr_top_right:toRGB()
    clr_bottom_right = clr_bottom_right:toRGB()
    clr_bottom_left = clr_bottom_left:toRGB()
    local identifier = string.format("%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d", clr_top_left.r, clr_top_left.g, clr_top_left.b, clr_top_left.a, clr_top_right.r, clr_top_right.g, clr_top_right.b, clr_top_right.a, clr_bottom_right.r, clr_bottom_right.g, clr_bottom_right.b, clr_bottom_right.a, clr_bottom_left.r, clr_bottom_left.g, clr_bottom_left.b, clr_bottom_left.a)

    if not vecMultiColorRectsBackup[identifier] then
        local PIXEL_BYTES = 4 -- RGBA format

        -- Create the image buffer
        local abPic = ffi.new("unsigned char[?]", dim.x * dim.y * PIXEL_BYTES)

        for y = 0, dim.y - 1 do
            local stepY = y / dim.y
            local first_raw_color = clr_top_left:Lerp(clr_bottom_left, stepY)
            local last_raw_color = clr_top_right:Lerp(clr_bottom_right, stepY)
            for x = 0, dim.x - 1 do
                local stepX = x / dim.x
                local clr = first_raw_color:Lerp(last_raw_color, stepX)
                local offset = (x + y * dim.y) * PIXEL_BYTES
                abPic[offset] = clr.r
                abPic[offset + 1] = clr.g
                abPic[offset + 2] = clr.b
                abPic[offset + 3] = clr.a
            end
        end

        local tid = native_Surface.CreateNewTextureID(true)
        if not tid or not native_Surface.IsTextureIDValid(tid) then
            return
        end

        native_Surface.DrawSetTextureRGBA(tid, abPic, dim.x, dim.y)
        vecMultiColorRectsBackup[identifier] = tid
    end
    
    native_Surface.DrawSetColor(255, 255, 255, 255)
    native_Surface.DrawSetTexture(vecMultiColorRectsBackup[identifier])
    return native_Surface.DrawTexturedRect(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y)
end

Render.FilledRect = function (pos, dim, clr, ...)
    if not pos or type(pos) ~= "table" or pos.type ~= "vec2_t" then return error("[SAPI](Render.FilledRect) Invalid Position Vector") end
    if not dim or type(dim) ~= "table" or dim.type ~= "vec2_t" then return error("[SAPI](Render.FilledRect) Invalid Dimesion Vector") end
    clr = clr or Color()

    if iScale then
        dim = vec2_t(dim.x * iScale, dim.y * iScale)
    end

    local clr2, horizontal, rounding, flags = rect_checks(...)

    if clr.type ~= 'rgba' then
        clr = clr:toRGB()
    end

    if clr2 and clr2.type == "rgba" and rounding and (horizontal and (dim.x - rounding * 2 > 0) or (dim.y - rounding * 2 > 0)) then
        if horizontal then
            Render.SetClip(vec2_t(pos.x, pos.y), vec2_t(rounding, dim.y))
            draw_rect_rounded(vec2_t(pos.x, pos.y), vec2_t(rounding * 2, dim.y), clr, rounding, flags, true)
            Render.EndClip()

            Render.SetClip(vec2_t(pos.x + dim.x - rounding, pos.y), vec2_t(rounding, dim.y))
            draw_rect_rounded(vec2_t(pos.x + dim.x - rounding * 2, pos.y), vec2_t(rounding * 2, dim.y), clr2, rounding, flags, true)
            Render.EndClip()

            --Render.MultiColorRect(vec2_t(pos.x + rounding, pos.y), vec2_t(dim.x - rounding * 2, dim.y), clr, clr2, clr2, clr)
            draw_func_gradient_rect(vec2_t(pos.x + rounding, pos.y), vec2_t(dim.x - rounding * 2, dim.y), clr, clr2, true)
        else
            Render.SetClip(vec2_t(pos.x, pos.y), vec2_t(dim.x, rounding))
            draw_rect_rounded(vec2_t(pos.x, pos.y), vec2_t(dim.x, rounding * 2), clr, rounding, flags, true)
            Render.EndClip()

            Render.SetClip(vec2_t(pos.x, pos.y + dim.y - rounding), vec2_t(dim.x, rounding))
            draw_rect_rounded(vec2_t(pos.x, pos.y + dim.y - rounding * 2), vec2_t(dim.x, rounding * 2), clr2, rounding, flags, true)
            Render.EndClip()

            --Render.MultiColorRect(vec2_t(pos.x, pos.y + rounding), vec2_t(dim.x, dim.y - rounding * 2), clr2, clr2, clr, clr)
            draw_func_gradient_rect(vec2_t(pos.x, pos.y + rounding), vec2_t(dim.x, dim.y - rounding * 2), clr, clr2, false)
        end
    elseif clr2 and clr2.type == "rgba" then
        draw_func_gradient_rect(pos, dim, clr, clr2, (horizontal or false))
    elseif rounding then
        draw_rect_rounded(pos, dim, clr, rounding, flags, true)
    else
        draw_filled_rect_box(pos, dim, clr)
    end
end

Render.Rect = function (pos, dim, clr, ...)
    if not pos or type(pos) ~= "table" or pos.type ~= "vec2_t" then return error("[SAPI](Render.Rect) Invalid Position Vector") end
    if not dim or type(dim) ~= "table" or dim.type ~= "vec2_t" then return error("[SAPI](Render.Rect) Invalid Dimesion Vector") end
    clr = clr or Color()

    if iScale then
        dim = vec2_t(dim.x * iScale, dim.y * iScale)
    end

    local clr2, horizontal, rounding, flags = rect_checks(...)

    if clr.type ~= 'rgba' then
        clr = clr:toRGB()
    end

    if clr2 and clr2.type == "rgba" and rounding and (horizontal and (dim.x - rounding * 2 > 0) or (dim.y - rounding * 2 > 0)) then
        if horizontal then
            Render.SetClip(vec2_t(pos.x, pos.y), vec2_t(rounding, dim.y + 1))
            draw_rect_rounded(vec2_t(pos.x, pos.y), vec2_t(rounding * 2, dim.y), clr, rounding, flags, false)
            Render.EndClip()

            Render.SetClip(vec2_t(pos.x + dim.x - rounding, pos.y), vec2_t(rounding + 1, dim.y + 1))
            draw_rect_rounded(vec2_t(pos.x + dim.x - rounding * 2, pos.y), vec2_t(rounding * 2, dim.y), clr2, rounding, flags, false)
            Render.EndClip()

            draw_func_gradient_rect(vec2_t(pos.x + rounding, pos.y), vec2_t(dim.x - rounding * 2, 1), clr, clr2, true)
            draw_func_gradient_rect(vec2_t(pos.x + rounding, pos.y + dim.y), vec2_t(dim.x - rounding * 2, 1), clr, clr2, true)
        else
            Render.SetClip(vec2_t(pos.x, pos.y), vec2_t(dim.x + 1, rounding))
            draw_rect_rounded(vec2_t(pos.x, pos.y), vec2_t(dim.x, rounding * 2), clr, rounding, flags, false)
            Render.EndClip()

            Render.SetClip(vec2_t(pos.x, pos.y + dim.y - rounding), vec2_t(dim.x + 1, rounding + 1))
            draw_rect_rounded(vec2_t(pos.x, pos.y + dim.y - rounding * 2), vec2_t(dim.x, rounding * 2), clr2, rounding, flags, false)
            Render.EndClip()

            draw_func_gradient_rect(vec2_t(pos.x, pos.y + rounding), vec2_t(1, dim.y - rounding * 2), clr, clr2, false)
            draw_func_gradient_rect(vec2_t(pos.x + dim.x, pos.y + rounding), vec2_t(1, dim.y - rounding * 2), clr, clr2, false)
        end
    elseif clr2 and clr2.type == "rgba" then
        if horizontal then
            draw_filled_rect_box(pos, vec2_t(1, dim.y), clr) -- Left
            draw_filled_rect_box(vec2_t(pos.x + dim.x - 1, pos.y), vec2_t(1, dim.y), clr2) -- Right
            draw_func_gradient_rect(pos, vec2_t(dim.x, 1), clr, clr2, true) -- Top
            draw_func_gradient_rect(vec2_t(pos.x, pos.y + dim.y - 1), vec2_t(dim.x, 1), clr, clr2, true) -- Bottom
        else
            draw_filled_rect_box(pos, vec2_t(dim.x, 1), clr) -- Top
            draw_filled_rect_box(vec2_t(pos.x, pos.y + dim.y - 1), vec2_t(dim.x, 1), clr2) -- Bottom
            draw_func_gradient_rect(pos, vec2_t(1, dim.y), clr, clr2, false) -- Left
            draw_func_gradient_rect(vec2_t(pos.x + dim.x - 1, pos.y), vec2_t(1, dim.y), clr, clr2, false) -- Right
        end
    elseif rounding then
        draw_rect_rounded(pos, dim, clr, rounding, flags, false)
    else
        draw_outlined_rect(pos, dim, clr)
    end
end

local circle_vertices = function(pos, radius, start_angle, end_angle)
    local start_angle = start_angle or 0
    local end_angle = end_angle or 360
    local vertices = {}

    local step = 15
    step = end_angle >= start_angle and step or -step

    for i = start_angle, end_angle, step do
        local i_rad = math.rad(i)
        local point = vec2_t(pos.x + math.cos(i_rad) * radius, pos.y + math.sin(i_rad) * radius)
        vertices[#vertices + 1] = point
    end

    for i = #vertices, 1, -1 do
        vertices[#vertices + 1] = vertices[i]
    end

    return vertices
end

Render.Circle = function(pos, radius, color, start_angle, end_angle)
    if not pos or type(pos) ~= "table" or pos.type ~= "vec2_t" then return error("[SAPI](Render.Circle) Invalid Position Vector") end
    if not radius or type(radius) ~= "number" then return error("[SAPI](Render.Circle) Invalid Radius") end

    if iScale then
        radius = radius * iScale
    end

    color = color or Color()
    if color.type ~= "rgba" then
        color = color:toRGB()
    end

    Render.Polyline(circle_vertices(pos, radius, start_angle, end_angle), color)
end

Render.FilledCircle = function(pos, radius, color, start_angle, end_angle)
    if not pos or type(pos) ~= "table" or pos.type ~= "vec2_t" then return error("[SAPI](Render.FilledCircle) Invalid Position Vector") end
    if not radius or type(radius) ~= "number" then return error("[SAPI](Render.FilledCircle) Invalid Radius") end

    if iScale then
        radius = radius * iScale
    end

    color = color or Color()
    if color.type ~= "rgba" then
        color = color:toRGB()
    end

    Render.Polygon(circle_vertices(pos, radius, start_angle, end_angle), color)
end

Render.Circle3D = function(Position, flRadius, color)
    if not Position or type(Position) ~= "table" or Position.type ~= "vec3_t" then return error("[SAPI](Render.Circle3D) Invalid Position Vector") end
    if not flRadius or type(flRadius) ~= "number" then return error("[SAPI](Render.Circle3D) Invalid Radius") end

    color = color or Color()
    if color.type ~= "rgba" then
        color = color:toRGB()
    end
    
    local nResolution = math.floor((flRadius * 2.0) + 2)
    local vertices = {}

    for i = 0, nResolution, 1 do
        local rotation = (math.pi * (i / (nResolution / 2.0)))
        local wts = vec2_t(Position.x + flRadius * math.cos(rotation), Position.y + flRadius * math.sin(rotation), Position.z)

        if wts ~= nil then
            if wts.x - flRadius/2 < ScreenSize.x and wts.x + flRadius/2 > 0 and wts.y - flRadius/2 < ScreenSize.y and wts.y + flRadius/2 > 0 then
                table.insert(vertices, vec2_t(wts.x, wts.y))
            end
        end
    end

    Render.Polygon(vertices, color)
end

local transform_image_data_from_table = function (data, vec)
    local HEIGHT = vec.x
    local WIDTH = vec.y
    local PIXEL_BYTES = 4 -- RGBA format

    -- Create the image buffer
    local abPic = ffi.new("unsigned char[?]", HEIGHT * WIDTH * PIXEL_BYTES)

    local i = 1

    for y = 0, HEIGHT - 1 do
        for x = 0, WIDTH - 1 do
            local offset = (x + y * WIDTH) * PIXEL_BYTES
            abPic[offset] = data[i] or 0   -- Red
            i = i + 1
            abPic[offset + 1] = data[i] or 0 -- Green
            i = i + 1
            abPic[offset + 2] = data[i] or 0 -- Blue
            i = i + 1
            abPic[offset + 3] = data[i] or 0 -- Alpha
            i = i + 1
        end
    end

    return abPic
end

Render.InitTextureRGBA = function(data, vec)
    if not data then return error("[SAPI](Render.InitTexture) Image Data Empty") end
    if not vec or type(vec) ~= "table" or vec.type ~= "vec2_t" then return error("[SAPI](Render.InitTexture) Invalid Dimesion Vector") end
    local tid = native_Surface.CreateNewTextureID(true)
    if not tid or not native_Surface.IsTextureIDValid(tid) or not data then
        return
    end
    native_Surface.DrawSetTextureRGBA(tid, transform_image_data_from_table(data, vec), vec.x, vec.y)
    return {
        tid = tid,
        data = data
    }
end

Render.InitTexture = function (szFileName)
    local tid = native_Surface.CreateNewTextureID(false)
    if not tid or not native_Surface.IsTextureIDValid(tid) or not szFileName then
        return
    end
    native_Surface.DrawSetTextureFile(tid, szFileName, true, true)
    return {
        tid = tid,
        data = ""
    }
end

Render.Image = function(datatbl, pos, dim, alpha, rounding, flags)
    if not datatbl or type(datatbl) ~= "table" or not datatbl.tid then return error("[SAPI](Render.Image) Invalid Image Data Table") end
    if not pos or type(pos) ~= "table" or pos.type ~= "vec2_t" then return error("[SAPI](Render.Image) Invalid Position Vector") end
    if not dim or type(dim) ~= "table" or dim.type ~= "vec2_t" then return error("[SAPI](Render.Image) Invalid Dimesion Vector") end

    if iScale then
        dim = vec2_t(dim.x * iScale, dim.y * iScale)
    end

    if type(alpha) == "table" then
        native_Surface.DrawSetColor(alpha.r, alpha.g, alpha.b, alpha.a)
    else
        native_Surface.DrawSetColor(255, 255, 255, (alpha or 255))
    end
    native_Surface.DrawSetTexture(datatbl.tid)
    return native_Surface.DrawTexturedRect(pos.x, pos.y, pos.x + dim.x, pos.y + dim.y)
    --return draw_rect_rounded(pos, dim, nil, rounding, flags, true)
end

Render.GradientText = function (text, clr1, clr2)
    local ret = {}
    local tbl = string.totable(text)

    local len = #text - 1
    local rinc = (clr2.r - clr1.r) / len
    local ginc = (clr2.g - clr1.g) / len
    local binc = (clr2.b - clr1.b) / len
    local ainc = (clr2.a - clr1.a) / len

    local draw_color = clr1
    for i = 1, #tbl do
        if tbl[i] ~= nil and type(tbl[i]) == "string" then
            ret[#ret + 1] = Color(math.floor(math.clamp(draw_color.r, 0, 255)), math.floor(math.clamp(draw_color.g, 0, 255)), math.floor(math.clamp(draw_color.b, 0, 255)), math.floor(math.clamp(draw_color.a, 0, 255)))
            ret[#ret + 1] = tbl[i]

            draw_color.r = draw_color.r + rinc
            draw_color.g = draw_color.g + ginc
            draw_color.b = draw_color.b + binc
            draw_color.a = draw_color.a + ainc
        end
    end

    return unpack(ret)
end

return {Render, EFontFlags, RoundingFlags}