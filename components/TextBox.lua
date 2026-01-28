-- Spectrum UI Library
-- Components/TextBox.lua
-- Text input component
-- Author: @gr6wl

local TextBox = {}

function TextBox.new(lib, parent, config)
    config = config or {}

    local label       = config.Name or config.Label or "Text"
    local placeholder = config.Placeholder or ""
    local callback    = config.Callback

    local theme = lib.theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.35, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = theme.textbox.label
    lib:_registerTheme(Label, "TextColor3", "textbox", "label")
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(0.6, 0, 0, 22)
    InputFrame.Position = UDim2.new(0.4, 0, 0.5, -11)
    InputFrame.BackgroundColor3 = theme.textbox.background
    lib:_registerTheme(InputFrame, "BackgroundColor3", "textbox", "background")
    InputFrame.BorderSizePixel = 0
    InputFrame.ZIndex = 11
    InputFrame.Parent = Frame

    lib:_corner(InputFrame, 2)
    local InputStroke = lib:_stroke(InputFrame, theme.textbox.border, 1)
    lib:_registerTheme(InputStroke, "Color", "textbox", "border")

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -10, 1, 0)
    Input.Position = UDim2.new(0, 5, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = config.DefaultText or ""
    Input.PlaceholderText = placeholder
    Input.PlaceholderColor3 = theme.textbox.placeholder
    lib:_registerTheme(Input, "PlaceholderColor3", "textbox", "placeholder")
    Input.TextColor3 = theme.textbox.text
    lib:_registerTheme(Input, "TextColor3", "textbox", "text")
    Input.Font = theme.fonts.value
    lib:_registerTheme(Input, "Font", "fonts", "value")
    Input.TextSize = theme.sizes.value
    lib:_registerTheme(Input, "TextSize", "sizes", "value")
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.ClearTextOnFocus = false
    Input.ZIndex = 12
    Input.Parent = InputFrame

    Input.Focused:Connect(function()
        lib:_safeTween(InputStroke, {Color = lib.accent})
    end)
    Input.FocusLost:Connect(function(enterPressed)
        lib:_safeTween(InputStroke, {Color = lib.theme.textbox.border})
        if callback then
            callback(Input.Text, enterPressed)
        end
    end)

    return Input
end

return TextBox

