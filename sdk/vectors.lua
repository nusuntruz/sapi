ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } vec3_t;

    typedef struct
    {
        float x;
        float y;
    } vec2_t;
]]

local vector_data_t = {
    x = 0,
    y = 0,
    z = nil,
    type = ''
}

function vector_data_t:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local vec2_t = function (x, y, z)
    if type(x) == "table" then
        if type(x.z) == "number" then
            z = x.z
        end
        y = type(x.y) == "number" and x.y or 0
        x = type(x.x) == "number" and x.x or 0
    end
    if type(x) ~= 'number' and x ~= nil then error('[S-API](vec2_t) Invalid argument .x (must be a number)') end
    if type(y) ~= 'number' and y ~= nil then error('[S-API](vec2_t) Invalid argument .y (must be a number)') end
    if z and type(z) == "number" then
        if cheat.API() == "gamesense" then
            x, y = cheat.WorldToScreen({x = x, y = y, z = z})
        else
            local vec2 = cheat.WorldToScreen({x = x, y = y, z = z})
            x = vec2.x
            y = vec2.y
            vec2 = nil -- release memory
        end
    end

    return vector_data_t:new({
        x = x or 0,
        y = y or 0,
        type = 'vec2_t'
    })
end

local vec3_t = function (x, y, z)
    if type(x) == "table" then
        z = type(x.z) == "number" and x.z or 0
        y = type(x.y) == "number" and x.y or 0
        x = type(x.x) == "number" and x.x or 0
    end

    if type(x) ~= 'number' and x ~= nil then error('[S-API](vec3_t) Invalid argument .x (must be a number)') end
    if type(y) ~= 'number' and y ~= nil then error('[S-API](vec3_t) Invalid argument .y (must be a number)') end
    if type(z) ~= 'number' and z ~= nil then error('[S-API](vec3_t) Invalid argument .z (must be a number)') end

    return vector_data_t:new({
        x = x or 0,
        y = y or 0,
        z = z or 0,
        type = 'vec3_t'
    })
end

function vector_data_t:ffi()
    if self.type == 'vec3_t' then
        return ffi.new(ffi.typeof('vec3_t'), {x = self.x, y = self.y, z = self.z})
    end
    return ffi.new(ffi.typeof('vec2_t'), {x = self.x, y = self.y})
end

function vector_data_t:Add(i)
    if type(i) ~= 'number' and type(i) ~= 'table' then error('[S-API](' .. self.type .. ':Add) Invalid argument .i (must be a number)') end

    if type(i) == 'number' then
        self.x = self.x + i
        self.y = self.y + i
        if self.type == "vec3_t" then
            self.z = self.z + i
        end
    else
        self.x = self.x + i.x
        self.y = self.y + i.y
        if self.type == "vec3_t" then
            self.z = self.z + i.z
        end
    end
    return self
end

function vector_data_t:Sub(i)
    if type(i) == "number" then
        i = -i
    elseif type(i) == "table" then
        i.x = -i.x
        i.y = -i.y
        if i.z then i.z = -i.z end
    else error('[S-API](' .. self.type .. ':Sub) Invalid argument .i (must be a number)')
    end
    return self:Add(i)
end

function vector_data_t:Multiply(i)
    if type(i) ~= 'number' and type(i) ~= 'table' then error('[S-API](' .. self.type .. ':Multiply) Invalid argument .i (must be a number)') end

    if type(i) == 'number' then
        return (self.type == "vec2_t" and vec2_t or vec3_t)(self.x * i, self.y * i, self.z * i)
    else
        return (self.type == "vec2_t" and vec2_t or vec3_t)(self.x * i.x, self.y * i.y , self.z * i.z)
    end
end

function vector_data_t:Fraction(i)
    if type(i) ~= 'number' and type(i) ~= 'table' then error('[S-API](' .. self.type .. ':Fraction) Invalid argument .i (must be a number)') end

    if type(i) == 'number' then
        return (self.type == "vec2_t" and vec2_t or vec3_t)(self.x / i, self.y / i, self.z / i)
    else
        return (self.type == "vec2_t" and vec2_t or vec3_t)(self.x / i.x, self.y / i.y, self.z / i.z)
    end
end

function vector_data_t:Dot(vector)
    if type(vector) ~= 'table' then error('[S-API](' .. self.type .. ':Dot) Invalid argument .vector (must be a vec2_t or a vec3_t)') end
    return (self.x * vector.x + self.y * vector.y + (self.type == 'vector3d' and self.z * (vector.z or 1) or 0))
end

function vector_data_t:Length()
    return math.sqrt(self:Dot(self))
end

function vector_data_t:Length2d()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function vector_data_t:Distance(distance)
    distance = distance or 0
    if type(distance) ~= 'number' then error('[S-API](' .. self.type .. ':Distance) Invalid argument .distance (must be a number)') end
    return self:Sub(distance):Length()
end

function vector_data_t:Angle(vector)
    if type(vector) ~= 'table' then error('[S-API](' .. self.type .. ':Angle) Invalid argument .vector (must be a vec2_t or a vec3_t)') end
    return math.acos(self:Dot(vector) / (self:Length() + vector:Length()))
end

function vector_data_t:Cross(vector)
    if type(vector) ~= 'table' then error('[S-API](' .. self.type .. ':Cross) Invalid argument .vector (must be a vec3_t)') end
    if self.type == 'vec2_t' then error('[S-API](' .. self.type .. ':Cross) Invalid vector type (must be a vec3_t)') end
    if vector.type == 'vec2_t' then error('[S-API](' .. self.type .. ':Cross) Invalid vector type argument (must be a vec3_t)') end
    return vec3_t(self.y * vector.z - (self.z or 0) * vector.y, (self.z or 0) * vector.x - self.x * vector.z, self.x * vector.y - self.y * vector.x)
end

function vector_data_t:unpack()
    if self.type == 'vec3_t' then
        return self.x, self.y, self.z
    end

    return self.x, self.y
end

function vector_data_t:Copy()
    return table.deepcopy(self)
end

function vector_data_t:copy()
    return table.deepcopy(self)
end

function vector_data_t:Hovered(dim)
    local mouse_pos = Input.GetCursorPosition()
    return ((mouse_pos.x >= self.x) and (mouse_pos.x <= self.x + dim.x)) and
               ((mouse_pos.y >= self.y) and (mouse_pos.y <= self.y + dim.y))
end

local vector_dragging_data = {}
function vector_data_t:Drag(vec2d, m_szName, m_bShouldBlockDragging)
    if not vector_dragging_data[m_szName] then
        vector_dragging_data[m_szName] = {
            x = self.x,
            y = self.y,
            clicked = false,
            drag = false,
            memory_x = 0,
            memory_y = 0
        }
    end
    vector_dragging_data[m_szName].w = vec2d.x
    vector_dragging_data[m_szName].h = vec2d.y

    local mouse_pos = Input.GetCursorPosition()
    local is_hovering_area = vec2_t(vector_dragging_data[m_szName].x, vector_dragging_data[m_szName].y):Hovered(vec2_t(vector_dragging_data[m_szName].w, vector_dragging_data[m_szName].h))
    local key = ButtonCode_t("MOUSE_LEFT")

    if Input.IsKeyPressed(key) and not m_bShouldBlockDragging then
        if not vector_dragging_data[m_szName].clicked then
            if is_hovering_area then
                vector_dragging_data[m_szName].drag = true
                vector_dragging_data[m_szName].memory_x = vector_dragging_data[m_szName].x - mouse_pos.x
                vector_dragging_data[m_szName].memory_y = vector_dragging_data[m_szName].y - mouse_pos.y
            end

            vector_dragging_data[m_szName].clicked = true
        end
    else
        vector_dragging_data[m_szName].clicked = false
        vector_dragging_data[m_szName].drag = false
    end

    if vector_dragging_data[m_szName].drag then
        vector_dragging_data[m_szName].x = mouse_pos.x + vector_dragging_data[m_szName].memory_x
        vector_dragging_data[m_szName].y = mouse_pos.y + vector_dragging_data[m_szName].memory_y
    end

    self.x = vector_dragging_data[m_szName].x
    self.y = vector_dragging_data[m_szName].y

    return self
end

return {vec2_t, vec3_t}