-- Spectrum UI Library
-- Components/Toggle.lua
-- Advanced toggle component
-- Author: @gr6wl

local Toggle = {}

function Toggle.new(lib, parent, config)
    config = config or {}

    local text      = config.Name or config.Text or "Toggle"
    local default   = config.Default or false
    local callback  = config.Callback
    local configKey = config.ConfigKey

    local theme  = lib.theme
    local accent = lib.accent

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.Parent = parent

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 14, 0, 14)
    Checkbox.Position = UDim2.new(0, 0, 0.5, -7)
    Checkbox.BackgroundColor3 = theme.toggle.background
    lib:_registerTheme(Checkbox, "BackgroundColor3", "toggle", "background")
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.ZIndex = 11
    Checkbox.Parent = Frame

    lib:_corner(Checkbox, 2)
    local BoxStroke = lib:_stroke(Checkbox, default and accent or theme.toggle.border_off, 1)

    local Check = Instance.new("Frame")
    Check.Size = UDim2.new(0, 8, 0, 8)
    Check.Position = UDim2.new(0.5, -4, 0.5, -4)
    Check.BackgroundColor3 = accent
    Check.BackgroundTransparency = default and 0 or 1
    Check.ZIndex = 12
    Check.Parent = Checkbox
    lib:_corner(Check, 1)
    lib:_registerAccent(Check, "BackgroundColor3")

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -24, 1, 0)
    Label.Position = UDim2.new(0, 22, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = default and theme.toggle.label_on or theme.toggle.label_off
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local state = default

    local function setState(newState, skipCallback)
        if state == newState then
            return
        end
        state = newState
        local th = lib.theme
        lib:_safeTween(Check, {BackgroundTransparency = state and 0 or 1})
        lib:_safeTween(BoxStroke, {Color = state and lib.accent or th.toggle.border_off})
        lib:_safeTween(Label, {TextColor3 = state and th.toggle.label_on or th.toggle.label_off})
        if not skipCallback and callback then
            callback(state)
        end
    end

    if configKey then
        lib._toggleRegistry[configKey] = {
            Checkbox = Checkbox,
            Check = Check,
            BoxStroke = BoxStroke,
            setState = setState,
            getState = function()
                return state
            end,
        }
    end

    Checkbox.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    Label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setState(not state)
        end
    end)

    return {
        Frame = Frame,
        setState = setState,
        getState = function()
            return state
        end,
    }
end

return Toggle

