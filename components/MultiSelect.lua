-- Spectrum UI Library
-- Components/MultiSelect.lua
-- Multi-select dropdown component
-- Author: @gr6wl

local MultiSelect = {}

function MultiSelect.new(lib, parent, config)
    config = config or {}

    local text     = config.Name or config.Text or "MultiSelect"
    local options  = config.Options or {}
    local defaults = config.Defaults or {}
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
    Label.Font = theme.fonts.label
    Label.TextSize = theme.sizes.label
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local selected = {}
    for _, d in ipairs(defaults) do
        selected[d] = true
    end

    local function getDisplayText()
        local items = {}
        for _, opt in ipairs(options) do
            if selected[opt] then
                table.insert(items, opt)
            end
        end
        if #items == 0 then
            return "None ▼"
        end
        if #items > 2 then
            return tostring(#items) .. " selected ▼"
        end
        return table.concat(items, ", ") .. " ▼"
    end

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.6, 0, 0, 22)
    Button.Position = UDim2.new(0.4, 0, 0.5, -11)
    Button.BackgroundColor3 = theme.dropdown.background
    Button.BorderSizePixel = 0
    Button.Text = getDisplayText()
    Button.TextColor3 = theme.dropdown.text
    Button.Font = theme.fonts.value
    Button.TextSize = theme.sizes.value
    Button.AutoButtonColor = false
    Button.ZIndex = 11
    Button.Parent = Frame
    lib:_corner(Button, 2)

    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(0.6, 0, 0, 0)
    DropFrame.Position = UDim2.new(0.4, 0, 1, 2)
    DropFrame.BackgroundColor3 = theme.dropdown.list_bg
    DropFrame.BorderSizePixel = 0
    DropFrame.Visible = false
    DropFrame.ZIndex = 50
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = Frame
    lib:_corner(DropFrame, 2)
    lib:_stroke(DropFrame, theme.dropdown.border, 1)

    local List = Instance.new("UIListLayout")
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 1)
    List.Parent = DropFrame

    local open = false
    local function toggleDrop()
        open = not open
        DropFrame.Size = UDim2.new(0.6, 0, 0, open and math.min(#options * 22, 110) or 0)
        DropFrame.Visible = open
    end

    Button.MouseButton1Click:Connect(toggleDrop)

    local optBtns = {}
    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 22)
        OptBtn.BackgroundColor3 = selected[opt] and theme.dropdown.list_item_hover or theme.dropdown.list_item
        OptBtn.BorderSizePixel = 0
        OptBtn.Text = (selected[opt] and "✓ " or "   ") .. opt
        OptBtn.TextColor3 = theme.dropdown.list_text
        OptBtn.Font = theme.fonts.value
        OptBtn.TextSize = theme.sizes.value
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.AutoButtonColor = false
        OptBtn.ZIndex = 51
        OptBtn.Parent = DropFrame
        optBtns[opt] = OptBtn

        local function fireCallback()
            if not callback then
                return
            end
            local list = {}
            for _, o in ipairs(options) do
                if selected[o] then
                    table.insert(list, o)
                end
            end
            callback(list)
        end

        local function updateBtn()
            OptBtn.Text = (selected[opt] and "✓ " or "   ") .. opt
            OptBtn.BackgroundColor3 = selected[opt] and theme.dropdown.list_item_hover or theme.dropdown.list_item
        end

        OptBtn.MouseButton1Click:Connect(function()
            selected[opt] = not selected[opt]
            updateBtn()
            Button.Text = getDisplayText()
            fireCallback()
        end)
    end

    return {
        Frame = Frame,
        getSelected = function()
            local list = {}
            for _, o in ipairs(options) do
                if selected[o] then
                    table.insert(list, o)
                end
            end
            return list
        end,
        setSelected = function(list)
            selected = {}
            for _, v in ipairs(list) do
                selected[v] = true
            end
            for opt, btn in pairs(optBtns) do
                btn.Text = (selected[opt] and "✓ " or "   ") .. opt
                btn.BackgroundColor3 = selected[opt] and theme.dropdown.list_item_hover or theme.dropdown.list_item
            end
            Button.Text = getDisplayText()
        end,
    }
end

return MultiSelect

