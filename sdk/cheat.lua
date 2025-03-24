local OriginalApi
local api -- From luv8 Panorama lib
while true do
    if _G == nil then
        if quick_maths == nil then
            if info.fatality == nil then
                api = 'ev0lve'
                break
            end
            api = 'fa7ality'
            break
        end
        api = 'rifk7'
        break
    end
    if MatSystem ~= nil then
        api = 'spirthack'
        break
    end
    if file ~= nil then
        api = 'legendware'
        break
    end
    if GameEventManager ~= nil then
        api = 'memesense'
        break
    end
    if penetration ~= nil then
        api = 'pandora'
        break
    end
    if math_utils ~= nil then
        api = 'legion'
        break
    end
    if plist ~= nil then
        api = 'gamesense'
        break
    end
    if network ~= nil then
        api = 'neverlose'
        break
    end
    if renderer ~= nil and renderer.setup_texture ~= nil then
        api = 'nixware'
        break
    end
    api = 'primordial'
    break
end

if api == "primordial" then
    OriginalApi = {
        vec2_t = vec2_t,
        vec3_t = vec3_t,
        world_to_screen = render.world_to_screen,
        create_interface = memory.create_interface,
        find_signature = memory.find_pattern,
        set_callback = callbacks.add,
        cheatui_open = menu.is_open,
        callbacks = {
            shutdown = e_callbacks.SHUTDOWN,
            draw = e_callbacks.PAINT,
            setup_command = e_callbacks.SETUP_COMMAND
        }
    }
elseif api == "gamesense" then
    OriginalApi = {
        world_to_screen = renderer.world_to_screen,
        create_interface = client.create_interface,
        find_signature = client.find_signature,
        set_callback = client.set_event_callback,
        cheatui_open = ui.is_menu_open,
        callbacks = {
            shutdown = "shutdown",
            draw = "paint_ui",
            setup_command = "setup_command"
        }
    }
end

if not api or not OriginalApi then
    return error("[SAPI] Invalid platform")
end

return {
    bUnloaded = false,
    API = function ()
        return api
    end,
    User = function ()
        return {
            name = "Ruzule",
            id = 1337
        }
    end,
    WorldToScreen = function (vec)
        if api == "gamesense" then
            return OriginalApi.world_to_screen(vec.x, vec.y, vec.z)
        else
            return OriginalApi.world_to_screen(OriginalApi.vec3_t(vec.x, vec.y, vec.z))
        end
    end,
    CreateInterface = OriginalApi.create_interface,
    FindSignature = function (module, pattern)
        if api == "gamesense" then
            local gsPattern = ''
            for token in pattern:gmatch('%S+') do
                gsPattern = gsPattern .. (token == '?' and '\xCC' or _G.string.char(tonumber(token, 16)))
            end
            return OriginalApi.find_signature(module, gsPattern)
        end
        return OriginalApi.find_signature(module, pattern)
    end,
    Callback = function (call, func)
        if not func or type(func) ~= "function" then return end
        if not call then
           call = OriginalApi.callbacks.shutdown
        end

        OriginalApi.set_callback(call, func)
    end,
    MenuVisible = function ()
        return OriginalApi.cheatui_open()
    end,
    Calls = function ()
        return OriginalApi.callbacks
    end
}