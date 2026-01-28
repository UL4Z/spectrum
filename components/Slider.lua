-- Spectrum UI Library
-- Components/Slider.lua
-- Advanced slider component
-- Author: @gr6wl

local UserInputService = game:GetService("UserInputService")

local Slider = {}

local function snap(number, step)
    if step == 0 then
        return number
    end
    return math.floor(number / step + 0.5) * step
end

function Slider.new(lib, parent, config)
    config = config or {}

    local text     = config.Name or config.Text or "Slider"
    local min      = config.Min or 0
    local max      = config.Max or 100
    local default  = config.Default or min
    local step     = config.Step or 1
    local suffix   = config.Suffix or ""
    local callback = config.Callback

    local theme  = lib.theme
    local accent = lib.accent

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 0, 14)
    Label.Position = UDim2.new(0, 0, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = theme.slider.label
    lib:_registerTheme(Label, "TextColor3", "slider", "label")
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local Val = Instance.new("TextLabel")
    Val.Size = UDim2.new(0, 80, 0, 14)
    Val.Position = UDim2.new(1, -80, 0, 2)
    Val.BackgroundTransparency = 1
    Val.TextColor3 = theme.slider.value
    lib:_registerTheme(Val, "TextColor3", "slider", "value")
    Val.Font = theme.fonts.value
    lib:_registerTheme(Val, "Font", "fonts", "value")
    Val.TextSize = theme.sizes.value
    lib:_registerTheme(Val, "TextSize", "sizes", "value")
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.ZIndex = 11
    Val.Parent = Frame

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0, 20)
    Track.BackgroundColor3 = theme.slider.track
    lib:_registerTheme(Track, "BackgroundColor3", "slider", "track")
    Track.BorderSizePixel = 0
    Track.Text = ""
    Track.AutoButtonColor = false
    Track.ZIndex = 11
    Track.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = accent
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 12
    Fill.Parent = Track
    lib:_registerAccent(Fill, "BackgroundColor3")

    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 8, 0, 8)
    Handle.Position = UDim2.new((default - min) / (max - min), -4, 0.5, -4)
    Handle.BackgroundColor3 = theme.slider.handle
    lib:_registerTheme(Handle, "BackgroundColor3", "slider", "handle")
    Handle.BorderSizePixel = 0
    Handle.ZIndex = 13
    Handle.Parent = Track

    local dragging = false

    local function formatValue(v)
        local decimals = 0
        if step < 1 then
            local sStr = tostring(step)
            local dot = sStr:find("%.")
            if dot then
                decimals = #sStr - dot
            end
        end
        local str = string.format("%." .. decimals .. "f", v)
        if suffix ~= "" then
            str = str .. " " .. suffix
        end
        return str
    end

    local function setFromInput(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local rawVal = min + ((max - min) * pos)
        local val = snap(rawVal, step)
        Val.Text = formatValue(val)
        Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        Handle.Position = UDim2.new((val - min) / (max - min), -4, 0.5, -4)
        if callback then
            callback(val)
        end
    end

    local inputEndedConn
    local inputChangedConn

    local function cleanup()
        if inputEndedConn then
            inputEndedConn:Disconnect()
            inputEndedConn = nil
        end
        if inputChangedConn then
            inputChangedConn:Disconnect()
            inputChangedConn = nil
        end
        dragging = false
    end

    Track.MouseButton1Down:Connect(function()
        dragging = true
        if not inputEndedConn then
            inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            inputChangedConn = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    setFromInput(input)
                end
            end)
        end
    end)

    Track.MouseButton1Click:Connect(function(input)
        if input then
            setFromInput(input)
        end
    end)

    Frame.AncestryChanged:Connect(function()
        if not Frame:IsDescendantOf(game) then
            cleanup()
        end
    end)

    Val.Text = formatValue(default)

    return {
        Frame = Frame,
    }
end

return Slider

