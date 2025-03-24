if not ffi then ffi = require 'ffi' end

(function () -- math extended
    math.round = function (num)
        return math.floor(num + 0.5)
    end

    math.deg2rad = function (x)
        return x * (math.pi / 180)
    end

    math.lerp = function(a, b, t)
        return a + (b - a) * t
    end

    math.mapnumber = function(input, input_min, input_max, output_min, output_max)
        return (input - input_min) / (input_max - input_min) * (output_max - output_min) + output_min
    end

    math.clamp = function(v, min, max)
        if min > max then
            min, max = max, min
        end
        if v < min then
            return min
        end
        if v > max then
            return max
        end
        return v
    end

    math.percentage = function (initial, percentage)
        if percentage > 100 then
            percentage = 100
        end

        return (percentage * initial) / 100
    end
end)()

string.totable = function(text)
    local _text = {}
    for i = 1, #text do _text[i] = text:sub(i, i) end
    return _text
end

table.unpack = table.unpack or unpack

function table.deepcopy(obj, seen)
    -- Handle non-tables and previously-seen tables.
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end

    -- New table; mark it as seen an copy recursively.
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in next, obj do res[table.deepcopy(k, s)] = table.deepcopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end