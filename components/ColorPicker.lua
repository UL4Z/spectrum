-- Spectrum UI Library
-- Components/ColorPicker.lua
-- HSV color picker with hex entry (popup)
-- Author: @gr6wl

local UserInputService = game:GetService("UserInputService")

local ColorPicker = {}

function ColorPicker.new(lib, parent, config)
    config = config or {}

    local text     = config.Name or config.Text or "Color"
    local default  = config.Default or Color3.fromRGB(255, 0, 0)
    local callback = config.Callback

    local theme = lib.theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.ClipsDescendants = false
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = theme.textbox.label
    lib:_registerTheme(Label, "TextColor3", "textbox", "label")
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local currentColor = default

    local ColorBtn = Instance.new("TextButton")
    ColorBtn.Size = UDim2.new(0, 60, 0, 22)
    ColorBtn.Position = UDim2.new(1, -60, 0.5, -11)
    ColorBtn.BackgroundColor3 = currentColor
    ColorBtn.Text = ""
    ColorBtn.AutoButtonColor = false
    ColorBtn.ZIndex = 11
    ColorBtn.Parent = Frame
    lib:_corner(ColorBtn, 4)
    local btnStroke = lib:_stroke(ColorBtn, Color3.new(1, 1, 1), 2)
    btnStroke.Transparency = 0.7

    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.new(0, 185, 0, 155)
    PickerFrame.Position = UDim2.new(1, -185, 1, 5)
    PickerFrame.BackgroundColor3 = theme.groupbox.background
    lib:_registerTheme(PickerFrame, "BackgroundColor3", "groupbox", "background")
    PickerFrame.BorderSizePixel = 0
    PickerFrame.Visible = false
    PickerFrame.ZIndex = 100
    PickerFrame.Parent = Frame:FindFirstAncestorWhichIsA("ScreenGui") or lib._screenGui or Frame
    lib:_corner(PickerFrame, 6)
    local ps = lib:_stroke(PickerFrame, theme.groupbox.border, 1)
    lib:_registerTheme(ps, "Color", "groupbox", "border")

    local SatVal = Instance.new("Frame")
    SatVal.Size = UDim2.new(0, 120, 0, 100)
    SatVal.Position = UDim2.new(0, 10, 0, 10)
    SatVal.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
    SatVal.BorderSizePixel = 0
    SatVal.ZIndex = 101
    SatVal.Parent = PickerFrame
    lib:_corner(SatVal, 4)

    local WhiteOverlay = Instance.new("Frame")
    WhiteOverlay.Size = UDim2.new(1, 0, 1, 0)
    WhiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
    WhiteOverlay.BorderSizePixel = 0
    WhiteOverlay.ZIndex = 102
    WhiteOverlay.Parent = SatVal
    lib:_corner(WhiteOverlay, 4)

    local WhiteGradient = Instance.new("UIGradient")
    WhiteGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    WhiteGradient.Parent = WhiteOverlay

    local BlackOverlay = Instance.new("Frame")
    BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
    BlackOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    BlackOverlay.BorderSizePixel = 0
    BlackOverlay.ZIndex = 103
    BlackOverlay.Parent = SatVal
    lib:_corner(BlackOverlay, 4)

    local BlackGradient = Instance.new("UIGradient")
    BlackGradient.Rotation = 90
    BlackGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    BlackGradient.Parent = BlackOverlay

    local HueBar = Instance.new("Frame")
    HueBar.Size = UDim2.new(0, 22, 0, 100)
    HueBar.Position = UDim2.new(0, 140, 0, 10)
    HueBar.BackgroundColor3 = Color3.new(1, 1, 1)
    HueBar.BorderSizePixel = 0
    HueBar.ZIndex = 101
    HueBar.Parent = PickerFrame
    lib:_corner(HueBar, 4)

    local HueGradient = Instance.new("UIGradient")
    HueGradient.Rotation = 90
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(0.999, 1, 1)),
    })
    HueGradient.Parent = HueBar

    local SatValPicker = Instance.new("Frame")
    SatValPicker.Size = UDim2.new(0, 12, 0, 12)
    SatValPicker.BackgroundColor3 = Color3.new(1, 1, 1)
    SatValPicker.BackgroundTransparency = 0.1
    SatValPicker.BorderSizePixel = 0
    SatValPicker.ZIndex = 105
    SatValPicker.Parent = SatVal
    lib:_corner(SatValPicker, 6)
    lib:_stroke(SatValPicker, Color3.new(0, 0, 0), 2)

    local HuePicker = Instance.new("Frame")
    HuePicker.Size = UDim2.new(1, 4, 0, 6)
    HuePicker.Position = UDim2.new(0, -2, 0, 0)
    HuePicker.BackgroundColor3 = Color3.new(1, 1, 1)
    HuePicker.BorderSizePixel = 0
    HuePicker.ZIndex = 102
    HuePicker.Parent = HueBar
    lib:_corner(HuePicker, 3)
    lib:_stroke(HuePicker, Color3.new(0, 0, 0), 1)

    local HexInput = Instance.new("TextBox")
    HexInput.Size = UDim2.new(0, 85, 0, 22)
    HexInput.Position = UDim2.new(0, 10, 1, -32)
    HexInput.BackgroundColor3 = theme.textbox.background
    lib:_registerTheme(HexInput, "BackgroundColor3", "textbox", "background")
    HexInput.BorderSizePixel = 0
    HexInput.Text = "#"
        .. string.format(
            "%02X%02X%02X",
            math.floor(currentColor.R * 255),
            math.floor(currentColor.G * 255),
            math.floor(currentColor.B * 255)
        )
    HexInput.PlaceholderText = "#FFFFFF"
    HexInput.TextColor3 = theme.textbox.text
    lib:_registerTheme(HexInput, "TextColor3", "textbox", "text")
    HexInput.Font = Enum.Font.Code
    HexInput.TextSize = 11
    HexInput.ZIndex = 101
    HexInput.ClearTextOnFocus = false
    HexInput.Parent = PickerFrame
    lib:_corner(HexInput, 3)
    local hexStroke = lib:_stroke(HexInput, theme.textbox.border, 1)
    lib:_registerTheme(hexStroke, "Color", "textbox", "border")

    local h, s, v = Color3.toHSV(currentColor)

    local function updateColor()
        currentColor = Color3.fromHSV(h, s, v)
        ColorBtn.BackgroundColor3 = currentColor
        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        SatValPicker.Position = UDim2.new(s, -6, 1 - v, -6)
        HuePicker.Position = UDim2.new(0, -2, h, -3)
        HexInput.Text = "#"
            .. string.format(
                "%02X%02X%02X",
                math.floor(currentColor.R * 255),
                math.floor(currentColor.G * 255),
                math.floor(currentColor.B * 255)
            )
        if callback then
            callback(currentColor)
        end
    end

    updateColor()

    local open = false
    ColorBtn.MouseButton1Click:Connect(function()
        open = not open
        PickerFrame.Visible = open
    end)

    local draggingSV, draggingH = false, false

    BlackOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = true
            s = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
            updateColor()
        end
    end)

    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingH = true
            h = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 0.999)
            updateColor()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV, draggingH = false, false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingSV then
                s = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                updateColor()
            elseif draggingH then
                h = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 0.999)
                updateColor()
            end
        end
    end)

    HexInput.FocusLost:Connect(function()
        local hex = HexInput.Text:gsub("#", ""):gsub("%s", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            if r and g and b then
                h, s, v = Color3.toHSV(Color3.fromRGB(r, g, b))
                updateColor()
            end
        end
    end)

    return {
        getColor = function()
            return currentColor
        end,
        setColor = function(c)
            h, s, v = Color3.toHSV(c)
            updateColor()
        end,
    }
end

return ColorPicker

