local function CreateInterface(module, interface)
    return ffi.cast("void*", cheat.CreateInterface(module, interface)) or error("invalid interface")
end

local function FindSignature(module, pattern)
    return ffi.cast("void*", cheat.FindSignature(module, pattern))
end

local function VTableEntry(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function VirtualFunction(vTable, m_iIndex, typedef)
	return ffi.cast((typedef or "uintptr_t**"), vTable)[0][m_iIndex]
end

-- instance is bound to the callback as an upvalue
local function VTableBind(instance, index, typestring)
	if type(index) ~= "number" then
		local aux = index
		index = typestring
		typestring = aux
		aux = nil
	end
	local success, typeof = pcall(ffi.typeof, typestring)
	if not success then
		error(typeof, 2)
	end
	local fnptr = VTableEntry(instance, index, typeof) or error("invalid vtable")
	return function(...)
		return fnptr(instance, ...)
	end
end

-- instance will be passed to the function at runtime
local function VTableThunk(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return VTableEntry(instance, index, t)(instance, ...)
		end
	end
end

local function UnloadFunction(func)
	return cheat.Callback(nil, func)
end

return {
    CreateInterface = CreateInterface,
    FindSignature = FindSignature,
	VirtualFunction = VirtualFunction,
    VTableEntry = VTableEntry,
    VTableBind = VTableBind,
    VTableThunk = VTableThunk,
	UnloadFunction = UnloadFunction
}