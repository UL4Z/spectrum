-- Spectrum UI Library
-- Tween utility module

local TweenService = game:GetService("TweenService")

local Tween = {}

local DEFAULT_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FAST_INFO = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SLOW_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function Tween.play(object, props, speed)
    local info = DEFAULT_INFO
    if speed == "fast" then
        info = FAST_INFO
    elseif speed == "slow" then
        info = SLOW_INFO
    elseif type(speed) == "number" then
        info = TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end
    
    TweenService:Create(object, info, props):Play()
end

function Tween.flash(object, prop, flashColor, duration)
    local original = object[prop]
    object[prop] = flashColor
    task.delay(duration or 0.1, function()
        Tween.play(object, {[prop] = original}, 0.2)
    end)
end

return Tween
