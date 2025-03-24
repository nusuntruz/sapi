local blur = function()
    local idk = {}
    panorama.loadstring([[
        if (true) {
            invoke = function(gauss) {
                let _root_panel = $.GetContextPanel()
                let _panel = $.CreatePanel("Panel", _root_panel, "Leaf")
                let _info = { visibility: gauss, res: { x: 0, y: 0, w: 0, h: 0 } }
                let co_r = function(res, or) { return (res/or)*100 }
        
                if(!_panel)
                    return
        
                let layout = `
                    <root>
                        <styles>
                            <include src='file://{resources}/styles/csgostyles.css' />
                            <include src='file://{resources}/styles/hud/hud.css' />
                        </styles>
                        <Panel class='full-width full-height' hittest='false' hittestchildren='false'>
                            <CSGOBlurTarget id='HudBlurG' style='width:100%;height:100%;-s2-mix-blend-mode:opaque;blur:fastgaussian(${gauss},${gauss},${gauss});'>
                                <CSGOBackbufferImagePanel class='full-width full-height' />
                            </CSGOBlurTarget>
                        </Panel>
                    </root>
                `
                
                if(!_panel.BLoadLayoutFromString(layout, false, false))
                    return
        
                _panel.visible = true
                _panel.style.clip = null
                _panel.style.clip = `rect(0%, 0%, 0%, 0%)`

                return {
                    visibility: function(value) {
                        if (_panel == null || _info.visibility === value)
                            return;

                        value = value === false ? 0 : value
                        value = value === true ? 1 : value

                        let res = (gauss - 1) * value + 1

                        _panel.visible = value > 0.000
                        _panel.GetChild(0).style.blur = `fastgaussian(${res},${res},${res})`

                        _info.visibility = value
                    },

                    set_position: function(x, y, w, h) {
                        let res = { x: x, y: y, w: w, h: h }

                        if (_panel == null || _info.res === res || (_root_panel.contentwidth == 0 || _root_panel.contentheight == 0))
                            return;

                        _x = co_r(x, _root_panel.contentwidth)
                        _y = co_r(y, _root_panel.contentheight)
                        w =  co_r(x+w, _root_panel.contentwidth)
                        h =  co_r(y+h, _root_panel.contentheight)
        
                        _panel.style.clip = null
                        _panel.style.clip = `rect( ${_y}%, ${_x}%, ${h}%, ${w}% )`

                        _info.res = res
                    },
        
                    release: function() {
                        if (_panel == null)
                            return;

                        _panel.RemoveAndDeleteChildren()
                        _panel.DeleteAsync(0.0)
                        _panel = null
                    },
        
                    panel: _panel
                }
            }
        }
    ]])

    local data = {}

    idk.invoke = function(name, radius)
        panorama.loadstring(string.format([[
            %s = invoke(%s);
        ]], name, radius))
    end
    idk.set_position = function(name, pos)
        panorama.loadstring(string.format([[
            %s.set_position(%s, %s, %s, %s)
        ]], name, pos[1], pos[2], pos[3], pos[4]))
    end
    idk.reset = function(name)
        panorama.loadstring(string.format([[
            %s.release()
        ]], name))
    end
    Render.Blur = function(pos, dim, radius)
        local x, y = pos:unpack()
        local w, h = dim:unpack()
        local name = tostring(x) .. tostring(y) .. tostring(w) .. tostring(h)
        if data[name] == nil then
            data[name] = {
                pos = {x, y, w, h},
                radius = radius,
                allow_invoke = false,
                execute = true,
                recover = false,
            }
            idk.invoke(name, radius)
            idk.set_position(name, {x, y, w, h})
        end

        local current = {
            pos = {x, y, w, h},
            radius = radius
        }

        -- allow invoke if position changed
        for i = 1, 4 do
            if data[name].pos[i] ~= current.pos[i] then
                data[name].allow_invoke = true
            end
            data[name].pos[i] = current.pos[i]
        end

        -- allow invoke if radius changed
        if data[name].radius ~= current.radius then
            data[name].allow_invoke = true
        end
        data[name].radius = current.radius

        data[name].execute = true
    end
    if not idk._function then idk._function = {} end
    table.insert(idk._function, function()
        for k, v in pairs(data) do
            if v.allow_invoke then
                idk.set_position(k, v.pos)
                v.allow_invoke = false
            end

            local _execute = v.execute
            v.execute = false

            if not _execute then
                v.recover = true
                idk.reset(k)
            else
                if v.recover then
                    idk.invoke(k, v.radius)
                    idk.set_position(k, v.pos)
                    v.recover = false
                end
            end
        end
    end)
    cheat.Callback(nil, function()
        for k, _ in pairs(data) do
            idk.reset(k)
        end
    end)
end

blur()