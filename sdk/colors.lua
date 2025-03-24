local hex_t = {
    v = '#FFFFFFFF',
    type = 'hex'
}

local hsv_t = {
    h = 0,
    s = 0,
    v = 100,
    type = 'hsv'
}

local color_t = {
    r = 255,
    g = 255,
    b = 255,
    a = 255,
    type = 'rgba'
}

function hex_t:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local HEX = function(hex)
    return hex_t:new({
        v = hex or '#FFFFFFFF'
    })
end

function hsv_t:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local HSV = function(h, s, v)
    return hsv_t:new({
        h = h or 0,
        s = s or 0,
        v = v or 0
    })
end

function color_t:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local Color = function(r, g, b, a)
    return color_t:new({
        r = math.clamp(math.floor(tonumber(r) or 255), 0, 255),
        g = math.clamp(math.floor(tonumber(g) or 255), 0, 255),
        b = math.clamp(math.floor(tonumber(b) or 255), 0, 255),
        a = math.clamp(math.floor(tonumber(a) or 255), 0, 255)
    })
end

function hex_t:Get()
    return self.v
end

function hex_t:toRGB()
    local hexs = self.v
    
    if string.find(hexs, "#") then
        local hex = hexs:gsub("#", "")
        return Color(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)),
            tonumber("0x" .. hex:sub(7, 8)))
    else
        print('[S-API](hex_t:toRGB) Invalid Hex')
    end
    return Color()
end

function hex_t:toHEX()
    return self
end

function hsv_t:toHSV()
    return self
end

function hsv_t:toRGB()
    local hue = self.h or 0
    local sat = self.s or 0
    local val = self.v or 0

    local red = 0.0
    local grn = 0.0
    local blu = 0.0

    local i = 0.0
    local f = 0.0
    local p = 0.0
    local q = 0.0
    local t = 0.0

    if val == 0 then
        red = 0.0;
        grn = 0.0;
        blu = 0.0;
    else
        hue = hue / 60.0;
        i = math.floor(hue)
        f = hue - i;
        p = val * (1.0 - sat);
        q = val * (1.0 - (sat * f));
        t = val * (1.0 - (sat * (1.0 - f)));
        if i == 0.0 then
            red = val;
            grn = t;
            blu = p;
        elseif i == 1.0 then
            red = q;
            grn = val;
            blu = p;
        elseif i == 2.0 then
            red = p;
            grn = val;
            blu = t;
        elseif i == 3.0 then
            red = p;
            grn = q;
            blu = val;
        elseif i == 4.0 then
            red = t;
            grn = p;
            blu = val;
        elseif i == 5.0 then
            red = val;
            grn = p;
            blu = q;
        end
    end

    return Color(math.ceil(red * 255.0), math.ceil(grn * 255.0), math.ceil(blu * 255.0), 255)
end

function color_t:toHSV()
    local hue = 0.0
    local sat = 0.0
    local val = 0.0
    local x = 0.0
    local f = 0.0
    local i = 0.0

    local r = 0.0
    local g = 0.0
    local b = 0.0

    r = self.r / 255.0
    g = self.g / 255.0
    b = self.b / 255.0

    x = math.min(math.min(r, g), b)
    val = math.max(math.max(r, g), b)

    if x == val then
        hue = 0.0
        sat = 0.0
    else
        if r == x then
            f = g - b
            i = 3.0
        elseif g == x then
            f = b - r
            i = 5.0
        else
            f = r - g
            i = 1.0
        end

        hue = math.fmod((i - f / (val - x)) * 60.0, 360.0)
        sat = ((val - x) / val)
    end

    return HSV(hue, sat, val)
end

function color_t:unpack()
    return self.r, self.g, self.b, self.a
end

function color_t:toHEX()
    local rgb = {self.r, self.g, self.b, self.a}
    local hexadecimal = '#'

    for key, value in pairs(rgb) do
        local hex = ''

        while (value > 0) do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex
        end

        if (string.len(hex) == 0) then
            hex = '00'

        elseif (string.len(hex) == 1) then
            hex = '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
end

function color_t:SetAlpha(alpha)
    return Color(self.r, self.g, self.b, math.clamp(math.floor(alpha), 0, 255))
end

function color_t:SetAlphaIncrement(increment)
    return Color(self.r, self.g, self.b, math.clamp(math.floor(self.a * math.clamp(increment, 0, 1)), 0, 255))
end

function color_t:Print(b)
    b = b or ' '
    return tostring(self.r .. b .. self.g .. b .. self.b .. b .. self.a)
end

function color_t:toRGB()
    return self -- We might not know what type is it, so we return same color
end

function color_t:Lerp(new_color, fraction)
    if not new_color then return self end
    if type(new_color) ~= "table" then return self end
    new_color = new_color:toRGB()
    return Color(self.r + (new_color.r - self.r) * fraction, self.g + (new_color.g - self.g) * fraction,
        self.b + (new_color.b - self.b) * fraction, self.a + (new_color.a - self.a) * fraction)
end

function hsv_t:toHEX()
    return self:toRGB():toHEX()
end

function hex_t:toHSV()
    return self:toRGB():toHSV()
end

function hsv_t:unpack()
    return self.h, self.s, self.v
end

--[[
function color_t:Rainbow()
    self.r = math.floor(math.sin(Engine.GetRealTime() * 1.0) * 127 + 128)
    self.g = math.floor(math.sin(Engine.GetRealTime() * 1.0 + 2) * 127 + 128)
    self.b = math.floor(math.sin(Engine.GetRealTime() * 1.0 + 4) * 127 + 128)

    return self
end]]

return {HSV, HEX, Color}