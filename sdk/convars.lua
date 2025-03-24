ffi.cdef[[
    typedef struct {
        char* m_string;
        int m_str_len;
        float m_float;
        int m_int;
    } CVValue_t;

    typedef struct {
        void* m_next; // 0x0004
	    int m_registered; // 0x0008
	    char* m_name; // 0x000C
	    char* m_help_string;// 0x0010
	    int m_flags;// 0x0014
	    void* m_callback;//0x0018
	    void* m_parent;
	    char* m_default_value;
	    CVValue_t m_value;
	    int m_has_min;
	    float m_min;
	    int m_has_max;
	    float m_max;
	    void* m_callbacks;
    } ConVar;
]]

local VEngineCvar007 = Utils.CreateInterface("vstdlib.dll" , "VEngineCvar007")
local FindVar = Utils.VTableBind(VEngineCvar007, 16, "ConVar * ( __thiscall* )( void* , const char* )")

local cvar_data = {
    convar = nil
}
function cvar_data:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function cvar_data:Int()
    return self.int()
end

function cvar_data:Float()
    return self.float()
end

function cvar_data:String()
    return (self.convar.m_value.m_string or "")
end

function cvar_data:SetString(s)
    self.setstring(ffi.cast("const char*", s))
end

function cvar_data:SetInt(i)
    self.setint(i)
end

function cvar_data:SetFloat(fl)
    self.setfloat(fl)
end

local m_backup = {}
return {
    Get = function (convar_name)
        if not m_backup[convar_name] then
            m_backup[convar_name] = cvar_data:new({convar = FindVar(convar_name),})
            m_backup[convar_name].float = Utils.VTableBind(m_backup[convar_name].convar, 12, "float( __thiscall* )(void*)")
            m_backup[convar_name].int = Utils.VTableBind(m_backup[convar_name].convar, 13, "int( __thiscall* )(void*)")
            m_backup[convar_name].setstring = Utils.VTableBind(m_backup[convar_name].convar, 14, "void( __thiscall* )(void*, const char*)")
            m_backup[convar_name].setfloat = Utils.VTableBind(m_backup[convar_name].convar, 15, "void( __thiscall* )(void*, float)")
            m_backup[convar_name].setint = Utils.VTableBind(m_backup[convar_name].convar, 16, "void( __thiscall* )(void*, int)")
        end
        return m_backup[convar_name]
    end
}