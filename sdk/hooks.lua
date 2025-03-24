local Calls = cheat.Calls()
local Draw = function (func)
    cheat.Callback(Calls.draw, func)
end
local CreateMove = function (func)
    cheat.Callback(Calls.setup_command, func)
end
local FrameStage

return {
    Draw = Draw,
    CreateMove = CreateMove
}