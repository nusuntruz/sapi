local Saved = {}

return {
    Init = function(name, enabler, multiplyer, default)
        local animtime = Client.m_flFrameTime * (multiplyer or 1)
    
        if not Saved[name] then
            Saved[name] = math.clamp(default or 0, 0, 1)
        end
    
        if enabler then
            if Saved[name] < 1 then
                Saved[name] = Saved[name] + animtime
            end
        else
            if Saved[name] > 0 then
                Saved[name] = Saved[name] - animtime
            end
        end
    
        Saved[name] = math.clamp(Saved[name], 0, 1)
    
        return Saved[name]
    end,
    Get = function (name)
        return Saved[name]
    end
}