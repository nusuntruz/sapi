# sapi
SeaSide Extended API

<a name="-1"></a>

|Contents|
|--------|
|[cheat](#0)|
|[Utils](#1)|

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
