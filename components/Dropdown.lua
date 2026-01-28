-- Spectrum UI Library
-- Components/Dropdown.lua
-- Dropdown / select component
-- Author: @gr6wl

local Dropdown = {}

function Dropdown.new(lib, parent, config)
    config = config or {}

    local text     = config.Name or config.Text or "Dropdown"
    local options  = config.Options or {}
    local default  = config.Default
    local callback = config.Callback

    local theme = lib.theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.ClipsDescendants = false
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.35, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = theme.dropdown.text
    lib:_registerTheme(Label, "TextColor3", "dropdown", "text")
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local Current = default or options[1] or ""

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.6, 0, 0, 22)
    Button.Position = UDim2.new(0.4, 0, 0.5, -11)
    Button.BackgroundColor3 = theme.dropdown.background
    lib:_registerTheme(Button, "BackgroundColor3", "dropdown", "background")
    Button.BorderSizePixel = 0
    Button.Text = tostring(Current) .. " ▼"
    Button.TextColor3 = theme.dropdown.text
    lib:_registerTheme(Button, "TextColor3", "dropdown", "text")
    Button.Font = theme.fonts.value
    lib:_registerTheme(Button, "Font", "fonts", "value")
    Button.TextSize = theme.sizes.value
    lib:_registerTheme(Button, "TextSize", "sizes", "value")
    Button.AutoButtonColor = false
    Button.ZIndex = 11
    Button.Parent = Frame

    lib:_corner(Button, 2)

    local DropFrame = Instance.new("Frame")
    DropFrame.Name = "DropFrame"
    DropFrame.Size = UDim2.new(0, 0, 0, 0)
    DropFrame.Position = UDim2.new(0, 0, 0, 0)
    DropFrame.BackgroundColor3 = theme.dropdown.list_bg
    lib:_registerTheme(DropFrame, "BackgroundColor3", "dropdown", "list_bg")
    DropFrame.BorderSizePixel = 0
    DropFrame.Visible = false
    DropFrame.ZIndex = 9999
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = Button:FindFirstAncestorWhichIsA("ScreenGui") or lib._screenGui or Frame

    lib:_corner(DropFrame, 2)
    local s = lib:_stroke(DropFrame, theme.dropdown.border, 1)
    lib:_registerTheme(s, "Color", "dropdown", "border")

    local List = Instance.new("UIListLayout")
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 1)
    List.Parent = DropFrame

    local open = false
    local function toggleDrop()
        open = not open
        if open then
            local btnPos = Button.AbsolutePosition
            local btnSize = Button.AbsoluteSize
            local h = math.min(#options * 20, 120)
            DropFrame.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
            DropFrame.Size = UDim2.new(0, btnSize.X, 0, h)
            DropFrame.Visible = true
        else
            DropFrame.Visible = false
        end
    end

    Button.MouseButton1Click:Connect(toggleDrop)

    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 20)
        OptBtn.BackgroundColor3 = theme.dropdown.list_item
        lib:_registerTheme(OptBtn, "BackgroundColor3", "dropdown", "list_item")
        OptBtn.BorderSizePixel = 0
        OptBtn.Text = tostring(opt)
        OptBtn.TextColor3 = theme.dropdown.list_text
        lib:_registerTheme(OptBtn, "TextColor3", "dropdown", "list_text")
        OptBtn.Font = theme.fonts.value
        lib:_registerTheme(OptBtn, "Font", "fonts", "value")
        OptBtn.TextSize = theme.sizes.value
        lib:_registerTheme(OptBtn, "TextSize", "sizes", "value")
        OptBtn.AutoButtonColor = false
        OptBtn.ZIndex = 10000
        OptBtn.Parent = DropFrame

        OptBtn.MouseEnter:Connect(function()
            OptBtn.BackgroundColor3 = lib.theme.dropdown.list_item_hover
        end)
        OptBtn.MouseLeave:Connect(function()
            OptBtn.BackgroundColor3 = lib.theme.dropdown.list_item
        end)
        OptBtn.MouseButton1Click:Connect(function()
            Current = opt
            Button.Text = tostring(opt) .. " ▼"
            if callback then
                callback(opt)
            end
            toggleDrop()
        end)
    end

    return {
        Frame = Frame,
        get = function()
            return Current
        end,
        set = function(v)
            Current = v
            Button.Text = tostring(v) .. " ▼"
        end,
    }
end

return Dropdown

