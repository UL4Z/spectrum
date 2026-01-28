-- Spectrum UI Library
-- TabSystem.lua
-- Horizontal tab system with Two-Column parvus-style layout
-- Author: @gr6wl

local TabSystem = {}
TabSystem.__index = TabSystem

local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

function TabSystem.new(lib, window)
    local self = setmetatable({}, TabSystem)

    self.Lib = lib
    self.Window = window
    self.TabBar = window._tabBar
    self.Content = window._content
    self.Tabs = {}

    self.FirstTab = true

    return self
end

-- Helper for underline (identical to init.lua)
local function createUnderline(parent, accent)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = accent
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.ZIndex = 4
    line.Parent = parent
    return line
end

function TabSystem:CreateTab(name, icon)
    local lib = self.Lib
    local theme = lib.theme
    local accent = lib.accent

    -- Button Creation
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 70, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = icon and "" or name
    Button.TextColor3 = theme.tab.inactive
    Button.Font = Enum.Font.Code
    Button.TextSize = 12
    Button.AutoButtonColor = false
    Button.ZIndex = 3
    Button.Parent = self.TabBar

    local Label, IconImg

    if icon then
        IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(0, 14, 0, 14)
        IconImg.Position = UDim2.new(0, 8, 0.5, -7)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = icon
        IconImg.ImageColor3 = theme.tab.inactive
        IconImg.ZIndex = 4
        IconImg.Parent = Button

        Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -26, 1, 0)
        Label.Position = UDim2.new(0, 26, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = theme.tab.inactive
        Label.Font = Enum.Font.Code
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 4
        Label.Parent = Button

        local txtSize = TextService:GetTextSize(name, 12, Enum.Font.Code, Vector2.new(1000, 1000))
        Button.Size = UDim2.new(0, txtSize.X + 36, 1, 0)
    end

    local Underline = createUnderline(Button, accent)
    lib:_registerAccent(Underline, "BackgroundColor3")

    -- Page / Content
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -4, 1, -4)
    Page.Position = UDim2.new(0, 2, 0, 2)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = theme.scrollbar
    lib:_registerTheme(Page, "ScrollBarImageColor3", nil, "scrollbar")
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.ZIndex = 5
    Page.Parent = self.Content
    
    -- Two-Column Layout
    local LeftColumn = Instance.new("Frame")
    LeftColumn.Name = "Left"
    LeftColumn.Size = UDim2.new(0.5, -4, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = Page
    
    local LeftList = Instance.new("UIListLayout")
    LeftList.Padding = UDim.new(0, 6)
    LeftList.SortOrder = Enum.SortOrder.LayoutOrder
    LeftList.Parent = LeftColumn
    
    local RightColumn = Instance.new("Frame")
    RightColumn.Name = "Right"
    RightColumn.Size = UDim2.new(0.5, -4, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 4, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = Page
    
    local RightList = Instance.new("UIListLayout")
    RightList.Padding = UDim.new(0, 6)
    RightList.SortOrder = Enum.SortOrder.LayoutOrder
    RightList.Parent = RightColumn
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 4)
    PagePadding.PaddingLeft = UDim.new(0, 4)
    PagePadding.PaddingRight = UDim.new(0, 4)
    PagePadding.Parent = Page

    -- Activation Logic
    local function setButtonState(active)
        local col = active and theme.tab.active or theme.tab.inactive
        if active then
             lib:_safeTween(Button, {TextColor3 = col})
             if Label then lib:_safeTween(Label, {TextColor3 = col}) end
             if IconImg then lib:_safeTween(IconImg, {ImageColor3 = col}) end
             lib:_safeTween(Underline, {BackgroundTransparency = 0})
        else
             lib:_safeTween(Button, {TextColor3 = col})
             if Label then lib:_safeTween(Label, {TextColor3 = col}) end
             if IconImg then lib:_safeTween(IconImg, {ImageColor3 = col}) end
             lib:_safeTween(Underline, {BackgroundTransparency = 1})
        end
    end

    local function activate()
        for _, c in ipairs(self.Content:GetChildren()) do
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
        for _, b in ipairs(self.TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                lib:_safeTween(b, {TextColor3 = theme.tab.inactive})
                local lbl = b:FindFirstChildWhichIsA("TextLabel")
                if lbl then lib:_safeTween(lbl, {TextColor3 = theme.tab.inactive}) end
                local icn = b:FindFirstChildWhichIsA("ImageLabel")
                if icn then lib:_safeTween(icn, {ImageColor3 = theme.tab.inactive}) end
                local ul = b:FindFirstChildOfClass("Frame")
                if ul then lib:_safeTween(ul, {BackgroundTransparency = 1}) end
            end
        end
        Page.Visible = true
        setButtonState(true)
    end

    Button.MouseButton1Click:Connect(activate)
    Button.MouseEnter:Connect(function()
        if not Page.Visible then
            local col = theme.tab.hover
            lib:_safeTween(Button, {TextColor3 = col})
            if Label then lib:_safeTween(Label, {TextColor3 = col}) end
            if IconImg then lib:_safeTween(IconImg, {ImageColor3 = col}) end
        end
    end)
    Button.MouseLeave:Connect(function()
        if not Page.Visible then
            local col = theme.tab.inactive
            lib:_safeTween(Button, {TextColor3 = col})
            if Label then lib:_safeTween(Label, {TextColor3 = col}) end
            if IconImg then lib:_safeTween(IconImg, {ImageColor3 = col}) end
        end
    end)

    if self.FirstTab then
        self.FirstTab = false
        activate()
    end

    local tab = {
        _page = Page,
        _left = LeftColumn,
        _right = RightColumn,
        _lib = lib
    }

    -- Implement Groupbox creation with side support
    function tab:Groupbox(title, side)
        local registry = lib._componentRegistry
        if registry then
            local ctor = registry:Get("Groupbox")
            if ctor then
                -- Determine parent based on side
                local parent = tab._left
                if side and (side:lower() == "right" or side == 2) then
                    parent = tab._right
                end
                
                return ctor(lib, parent, {Name = title})
            end
        end
        warn("[Spectrum] Groupbox component not found in registry")
        return nil
    end
    
    -- Canvas Size Auto-Update
    local function updateCanvas()
        local leftH = LeftList.AbsoluteContentSize.Y
        local rightH = RightList.AbsoluteContentSize.Y
        local maxH = math.max(leftH, rightH)
        Page.CanvasSize = UDim2.new(0, 0, 0, maxH + 20)
    end
    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    table.insert(self.Tabs, tab)
    return tab
end

return TabSystem
