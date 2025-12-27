--[[
    Spectrum UI Library
    
    Multi-theme UI library for Roblox exploits.
    Themes: skeet, neverlose, aimware
    
    Usage:
        local Spectrum = loadstring(readfile("libs/spectrum/init.lua"))()
        local UI = Spectrum.new({
            title = "My Script",
            theme = "skeet",
            accent = Color3.fromRGB(255, 0, 0),
            key = "YOUR-KEY-HERE"
        })
        
        local Window = UI:Window()
        local Tab = Window:Tab("Main")
        local Group = Tab:Groupbox("Settings")
        Group:Toggle("Enabled", true, function(v) print(v) end)
]]

local Spectrum = {}
Spectrum.__index = Spectrum

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local THEMES = {
    skeet = {
        name = "skeet",
        fonts = {title = Enum.Font.Code, label = Enum.Font.Gotham, value = Enum.Font.Code, header = Enum.Font.GothamBold},
        sizes = {title = 13, label = 11, value = 10, header = 11, corner = 2, corner_groupbox = 4},
        window = {background = Color3.fromRGB(24, 24, 28), border = Color3.fromRGB(8, 8, 10), border_thickness = 2, titlebar = Color3.fromRGB(20, 20, 24), title_text = Color3.fromRGB(200, 200, 200), watermark = Color3.fromRGB(60, 60, 65), content = Color3.fromRGB(28, 28, 32)},
        tab = {background = Color3.fromRGB(28, 28, 32), inactive = Color3.fromRGB(120, 120, 125), hover = Color3.fromRGB(180, 180, 185), active = Color3.fromRGB(255, 255, 255)},
        groupbox = {background = Color3.fromRGB(22, 22, 28), header = Color3.fromRGB(28, 28, 35), border = Color3.fromRGB(40, 40, 50)},
        toggle = {background = Color3.fromRGB(35, 35, 42), border_off = Color3.fromRGB(60, 60, 70), label_on = Color3.fromRGB(220, 220, 220), label_off = Color3.fromRGB(150, 150, 155)},
        button = {background = Color3.fromRGB(32, 32, 38), background_hover = Color3.fromRGB(45, 45, 52), background_click = Color3.fromRGB(60, 60, 70), text = Color3.fromRGB(180, 180, 185), text_hover = Color3.fromRGB(220, 220, 225)},
        slider = {track = Color3.fromRGB(40, 40, 48), handle = Color3.fromRGB(220, 220, 225), label = Color3.fromRGB(180, 180, 185), value = Color3.fromRGB(140, 140, 150)},
        dropdown = {background = Color3.fromRGB(32, 32, 40), text = Color3.fromRGB(160, 160, 170), list_bg = Color3.fromRGB(28, 28, 35), list_item = Color3.fromRGB(35, 35, 42), list_item_hover = Color3.fromRGB(50, 50, 60), list_text = Color3.fromRGB(170, 170, 180), border = Color3.fromRGB(50, 50, 60)},
        textbox = {background = Color3.fromRGB(28, 28, 34), border = Color3.fromRGB(50, 50, 60), text = Color3.fromRGB(200, 200, 205), placeholder = Color3.fromRGB(80, 80, 90), label = Color3.fromRGB(180, 180, 185)},
        keybind = {background = Color3.fromRGB(35, 35, 42), text = Color3.fromRGB(150, 150, 160), label = Color3.fromRGB(180, 180, 185)},
        scrollbar = Color3.fromRGB(60, 60, 70),
        close_hover = Color3.fromRGB(255, 100, 100),
    },
    neverlose = {
        name = "neverlose",
        fonts = {title = Enum.Font.GothamBold, label = Enum.Font.Gotham, value = Enum.Font.Gotham, header = Enum.Font.GothamBold},
        sizes = {title = 14, label = 12, value = 11, header = 12, corner = 8, corner_groupbox = 10},
        window = {background = Color3.fromRGB(18, 18, 24), border = Color3.fromRGB(45, 45, 60), border_thickness = 1, titlebar = Color3.fromRGB(22, 22, 30), title_text = Color3.fromRGB(235, 235, 240), watermark = Color3.fromRGB(100, 100, 115), content = Color3.fromRGB(20, 20, 28)},
        tab = {background = Color3.fromRGB(25, 25, 32), inactive = Color3.fromRGB(130, 130, 145), hover = Color3.fromRGB(200, 200, 210), active = Color3.fromRGB(255, 255, 255)},
        groupbox = {background = Color3.fromRGB(24, 24, 32), header = Color3.fromRGB(28, 28, 38), border = Color3.fromRGB(50, 50, 65)},
        toggle = {background = Color3.fromRGB(32, 32, 42), border_off = Color3.fromRGB(70, 70, 85), label_on = Color3.fromRGB(240, 240, 245), label_off = Color3.fromRGB(140, 140, 155)},
        button = {background = Color3.fromRGB(35, 35, 48), background_hover = Color3.fromRGB(50, 50, 65), background_click = Color3.fromRGB(65, 65, 85), text = Color3.fromRGB(200, 200, 210), text_hover = Color3.fromRGB(240, 240, 245)},
        slider = {track = Color3.fromRGB(40, 40, 55), handle = Color3.fromRGB(255, 255, 255), label = Color3.fromRGB(200, 200, 210), value = Color3.fromRGB(160, 160, 175)},
        dropdown = {background = Color3.fromRGB(32, 32, 45), text = Color3.fromRGB(180, 180, 195), list_bg = Color3.fromRGB(26, 26, 38), list_item = Color3.fromRGB(35, 35, 48), list_item_hover = Color3.fromRGB(55, 55, 72), list_text = Color3.fromRGB(190, 190, 205), border = Color3.fromRGB(55, 55, 72)},
        textbox = {background = Color3.fromRGB(28, 28, 40), border = Color3.fromRGB(55, 55, 72), text = Color3.fromRGB(220, 220, 230), placeholder = Color3.fromRGB(90, 90, 105), label = Color3.fromRGB(200, 200, 210)},
        keybind = {background = Color3.fromRGB(35, 35, 48), text = Color3.fromRGB(170, 170, 185), label = Color3.fromRGB(200, 200, 210)},
        scrollbar = Color3.fromRGB(70, 70, 90),
        close_hover = Color3.fromRGB(255, 90, 90),
    },
    aimware = {
        name = "aimware",
        fonts = {title = Enum.Font.SourceSans, label = Enum.Font.SourceSans, value = Enum.Font.Code, header = Enum.Font.SourceSansBold},
        sizes = {title = 14, label = 13, value = 11, header = 13, corner = 0, corner_groupbox = 0},
        window = {background = Color3.fromRGB(12, 12, 12), border = Color3.fromRGB(0, 0, 0), border_thickness = 1, titlebar = Color3.fromRGB(20, 20, 20), title_text = Color3.fromRGB(255, 200, 0), watermark = Color3.fromRGB(80, 80, 80), content = Color3.fromRGB(16, 16, 16)},
        tab = {background = Color3.fromRGB(22, 22, 22), inactive = Color3.fromRGB(140, 140, 140), hover = Color3.fromRGB(200, 200, 200), active = Color3.fromRGB(255, 200, 0)},
        groupbox = {background = Color3.fromRGB(18, 18, 18), header = Color3.fromRGB(24, 24, 24), border = Color3.fromRGB(50, 50, 50)},
        toggle = {background = Color3.fromRGB(30, 30, 30), border_off = Color3.fromRGB(70, 70, 70), label_on = Color3.fromRGB(255, 255, 255), label_off = Color3.fromRGB(160, 160, 160)},
        button = {background = Color3.fromRGB(28, 28, 28), background_hover = Color3.fromRGB(40, 40, 40), background_click = Color3.fromRGB(55, 55, 55), text = Color3.fromRGB(200, 200, 200), text_hover = Color3.fromRGB(255, 200, 0)},
        slider = {track = Color3.fromRGB(35, 35, 35), handle = Color3.fromRGB(255, 200, 0), label = Color3.fromRGB(200, 200, 200), value = Color3.fromRGB(255, 200, 0)},
        dropdown = {background = Color3.fromRGB(28, 28, 28), text = Color3.fromRGB(180, 180, 180), list_bg = Color3.fromRGB(20, 20, 20), list_item = Color3.fromRGB(30, 30, 30), list_item_hover = Color3.fromRGB(45, 45, 45), list_text = Color3.fromRGB(190, 190, 190), border = Color3.fromRGB(50, 50, 50)},
        textbox = {background = Color3.fromRGB(24, 24, 24), border = Color3.fromRGB(50, 50, 50), text = Color3.fromRGB(220, 220, 220), placeholder = Color3.fromRGB(100, 100, 100), label = Color3.fromRGB(200, 200, 200)},
        keybind = {background = Color3.fromRGB(30, 30, 30), text = Color3.fromRGB(180, 180, 180), label = Color3.fromRGB(200, 200, 200)},
        scrollbar = Color3.fromRGB(60, 60, 60),
        close_hover = Color3.fromRGB(255, 80, 80),
    },
}

local function tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function corner(parent, radius)
    if radius and radius > 0 then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = parent
    end
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

function Spectrum.new(config)
    config = config or {}
    
    local self = setmetatable({}, Spectrum)
    self.title = config.title or "Spectrum"
    self.theme = THEMES[config.theme or "skeet"] or THEMES.skeet
    self.accent = config.accent or Color3.fromRGB(200, 55, 55)
    self.size = config.size or {610, 460}
    self.toggleKey = config.toggleKey or Enum.KeyCode.Insert
    self._windows = {}
    self._accentElements = {}
    self._toggleRegistry = {}
    
    return self
end

function Spectrum:SetTheme(themeName)
    if THEMES[themeName] then
        self.theme = THEMES[themeName]
    end
end

function Spectrum:SetAccent(color)
    self.accent = color
    for _, entry in ipairs(self._accentElements) do
        if entry.element and entry.element.Parent then
            pcall(function()
                entry.element[entry.property] = color
            end)
        end
    end
    for _, toggle in pairs(self._toggleRegistry) do
        if toggle.BoxStroke and toggle.getState and toggle.getState() then
            pcall(function()
                toggle.BoxStroke.Color = color
            end)
        end
    end
end

function Spectrum:_registerAccent(element, property)
    table.insert(self._accentElements, {element = element, property = property})
end

function Spectrum:Window()
    local lib = self
    local theme = self.theme
    local accent = self.accent
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Spectrum_" .. tostring(math.random(100000, 999999))
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, self.size[1], 0, self.size[2])
    Main.Position = UDim2.new(0.5, -self.size[1]/2, 0.5, -self.size[2]/2)
    Main.BackgroundColor3 = theme.window.background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ZIndex = 1
    Main.Parent = ScreenGui
    
    corner(Main, theme.sizes.corner)
    stroke(Main, theme.window.border, theme.window.border_thickness)
    
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BackgroundColor3 = accent
    AccentLine.BorderSizePixel = 0
    AccentLine.ZIndex = 10
    AccentLine.Parent = Main
    lib:_registerAccent(AccentLine, "BackgroundColor3")
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 28)
    TitleBar.Position = UDim2.new(0, 0, 0, 2)
    TitleBar.BackgroundColor3 = theme.window.titlebar
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = Main
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = self.title:lower()
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = theme.window.title_text
    TitleLabel.Font = theme.fonts.title
    TitleLabel.TextSize = theme.sizes.title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = TitleBar
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -28, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "x"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.Font = Enum.Font.Code
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = TitleBar
    
    CloseBtn.MouseEnter:Connect(function()
        CloseBtn.TextColor3 = theme.close_hover
    end)
    CloseBtn.MouseLeave:Connect(function()
        CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
    end)
    
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -10, 0, 26)
    TabBar.Position = UDim2.new(0, 5, 0, 32)
    TabBar.BackgroundColor3 = theme.tab.background
    TabBar.BorderSizePixel = 0
    TabBar.ZIndex = 2
    TabBar.Parent = Main
    
    corner(TabBar, theme.sizes.corner)
    
    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 2)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabBar
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -10, 1, -65)
    ContentArea.Position = UDim2.new(0, 5, 0, 60)
    ContentArea.BackgroundColor3 = theme.window.content
    ContentArea.BackgroundTransparency = 0
    ContentArea.BorderSizePixel = 0
    ContentArea.ZIndex = 2
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = Main
    
    corner(ContentArea, theme.sizes.corner)
    
    local Watermark = Instance.new("TextLabel")
    Watermark.Text = "spectrum"
    Watermark.Size = UDim2.new(0, 60, 0, 14)
    Watermark.Position = UDim2.new(1, -65, 0, 4)
    Watermark.BackgroundTransparency = 1
    Watermark.TextColor3 = theme.window.watermark
    Watermark.Font = Enum.Font.Code
    Watermark.TextSize = 10
    Watermark.TextXAlignment = Enum.TextXAlignment.Right
    Watermark.ZIndex = 3
    Watermark.Parent = TitleBar
    
    local Mini = Instance.new("TextButton")
    Mini.Name = "Mini"
    Mini.Size = UDim2.new(0, 40, 0, 40)
    Mini.Position = UDim2.new(0, 15, 0.5, -20)
    Mini.BackgroundColor3 = theme.window.background
    Mini.Text = "S"
    Mini.TextColor3 = accent
    Mini.Font = Enum.Font.Code
    Mini.TextSize = 18
    Mini.Visible = false
    Mini.Active = true
    Mini.Draggable = true
    Mini.Parent = ScreenGui
    
    corner(Mini, theme.sizes.corner)
    local miniStroke = stroke(Mini, accent, 1)
    lib:_registerAccent(Mini, "TextColor3")
    lib:_registerAccent(miniStroke, "Color")
    
    Mini.MouseButton1Click:Connect(function()
        Mini.Visible = false
        Main.Visible = true
    end)
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == lib.toggleKey or input.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
            Mini.Visible = not Main.Visible
        end
    end)
    
    local Window = {}
    Window._lib = lib
    Window._main = Main
    Window._tabBar = TabBar
    Window._content = ContentArea
    Window._tabs = {}
    Window._firstTab = true
    
    function Window:Tab(name)
        local tab = {}
        local theme = lib.theme
        local accent = lib.accent
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 70, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = name
        Button.TextColor3 = theme.tab.inactive
        Button.Font = Enum.Font.Code
        Button.TextSize = 12
        Button.AutoButtonColor = false
        Button.ZIndex = 3
        Button.Parent = self._tabBar
        
        local Underline = Instance.new("Frame")
        Underline.Size = UDim2.new(1, 0, 0, 2)
        Underline.Position = UDim2.new(0, 0, 1, -2)
        Underline.BackgroundColor3 = accent
        Underline.BackgroundTransparency = 1
        Underline.BorderSizePixel = 0
        Underline.ZIndex = 4
        Underline.Parent = Button
        lib:_registerAccent(Underline, "BackgroundColor3")
        
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -4, 1, -4)
        Page.Position = UDim2.new(0, 2, 0, 2)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = theme.scrollbar
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.ZIndex = 5
        Page.Parent = self._content
        
        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 6)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        List.Parent = Page
        
        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop = UDim.new(0, 4)
        Padding.PaddingLeft = UDim.new(0, 4)
        Padding.PaddingRight = UDim.new(0, 4)
        Padding.Parent = Page
        
        Button.MouseEnter:Connect(function()
            if not Page.Visible then
                tween(Button, {TextColor3 = theme.tab.hover})
            end
        end)
        Button.MouseLeave:Connect(function()
            if not Page.Visible then
                tween(Button, {TextColor3 = theme.tab.inactive})
            end
        end)
        
        local function activate()
            for _, c in pairs(self._content:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            for _, b in pairs(self._tabBar:GetChildren()) do
                if b:IsA("TextButton") then
                    tween(b, {TextColor3 = theme.tab.inactive})
                    local ul = b:FindFirstChildOfClass("Frame")
                    if ul then tween(ul, {BackgroundTransparency = 1}) end
                end
            end
            Page.Visible = true
            tween(Button, {TextColor3 = theme.tab.active})
            tween(Underline, {BackgroundTransparency = 0})
        end
        
        Button.MouseButton1Click:Connect(activate)
        
        if self._firstTab then
            self._firstTab = false
            activate()
        end
        
        tab._page = Page
        tab._lib = lib
        
        function tab:Groupbox(title)
            local group = {}
            local theme = lib.theme
            local accent = lib.accent
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -10, 0, 0)
            Container.AutomaticSize = Enum.AutomaticSize.Y
            Container.BackgroundColor3 = theme.groupbox.background
            Container.BorderSizePixel = 0
            Container.ZIndex = 10
            Container.Parent = self._page
            
            corner(Container, theme.sizes.corner_groupbox)
            stroke(Container, theme.groupbox.border, 1)
            
            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Padding = UDim.new(0, 0)
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Parent = Container
            
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 24)
            Header.BackgroundColor3 = theme.groupbox.header
            Header.BorderSizePixel = 0
            Header.LayoutOrder = 1
            Header.ZIndex = 10
            Header.Parent = Container
            
            corner(Header, theme.sizes.corner_groupbox)
            
            local HeaderLabel = Instance.new("TextLabel")
            HeaderLabel.Size = UDim2.new(1, -10, 1, 0)
            HeaderLabel.Position = UDim2.new(0, 8, 0, 0)
            HeaderLabel.BackgroundTransparency = 1
            HeaderLabel.Text = title
            HeaderLabel.TextColor3 = accent
            HeaderLabel.Font = theme.fonts.header
            HeaderLabel.TextSize = theme.sizes.header
            HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
            HeaderLabel.ZIndex = 11
            HeaderLabel.Parent = Header
            lib:_registerAccent(HeaderLabel, "TextColor3")
            
            local Content = Instance.new("Frame")
            Content.Size = UDim2.new(1, 0, 0, 0)
            Content.AutomaticSize = Enum.AutomaticSize.Y
            Content.BackgroundTransparency = 1
            Content.LayoutOrder = 2
            Content.ZIndex = 10
            Content.Parent = Container
            
            local ContentList = Instance.new("UIListLayout")
            ContentList.Padding = UDim.new(0, 4)
            ContentList.SortOrder = Enum.SortOrder.LayoutOrder
            ContentList.Parent = Content
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.PaddingTop = UDim.new(0, 6)
            ContentPadding.PaddingBottom = UDim.new(0, 8)
            ContentPadding.PaddingLeft = UDim.new(0, 8)
            ContentPadding.PaddingRight = UDim.new(0, 8)
            ContentPadding.Parent = Content
            
            group._content = Content
            group._lib = lib
            
            function group:Toggle(text, default, callback, configKey)
                local theme = lib.theme
                local accent = lib.accent
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.Parent = self._content
                
                local Checkbox = Instance.new("TextButton")
                Checkbox.Size = UDim2.new(0, 14, 0, 14)
                Checkbox.Position = UDim2.new(0, 0, 0.5, -7)
                Checkbox.BackgroundColor3 = theme.toggle.background
                Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.ZIndex = 11
                Checkbox.Parent = Frame
                
                corner(Checkbox, 2)
                local BoxStroke = stroke(Checkbox, default and accent or theme.toggle.border_off, 1)
                
                local Check = Instance.new("Frame")
                Check.Size = UDim2.new(0, 8, 0, 8)
                Check.Position = UDim2.new(0.5, -4, 0.5, -4)
                Check.BackgroundColor3 = accent
                Check.BackgroundTransparency = default and 0 or 1
                Check.ZIndex = 12
                Check.Parent = Checkbox
                corner(Check, 1)
                lib:_registerAccent(Check, "BackgroundColor3")
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -24, 1, 0)
                Label.Position = UDim2.new(0, 22, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = default and theme.toggle.label_on or theme.toggle.label_off
                Label.Font = theme.fonts.label
                Label.TextSize = theme.sizes.label
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local state = default
                
                local function setState(newState, skipCallback)
                    if state == newState then return end
                    state = newState
                    tween(Check, {BackgroundTransparency = state and 0 or 1})
                    tween(BoxStroke, {Color = state and accent or theme.toggle.border_off})
                    tween(Label, {TextColor3 = state and theme.toggle.label_on or theme.toggle.label_off})
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
                        getState = function() return state end
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
                
                return {setState = setState, getState = function() return state end}
            end
            
            function group:Button(text, callback)
                local theme = lib.theme
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -10, 0, 24)
                Btn.BackgroundColor3 = theme.button.background
                Btn.BorderSizePixel = 0
                Btn.Text = text
                Btn.TextColor3 = theme.button.text
                Btn.Font = theme.fonts.label
                Btn.TextSize = theme.sizes.label
                Btn.AutoButtonColor = false
                Btn.ZIndex = 10
                Btn.Parent = self._content
                
                corner(Btn, 2)
                
                Btn.MouseEnter:Connect(function()
                    tween(Btn, {BackgroundColor3 = theme.button.background_hover, TextColor3 = theme.button.text_hover})
                end)
                Btn.MouseLeave:Connect(function()
                    tween(Btn, {BackgroundColor3 = theme.button.background, TextColor3 = theme.button.text})
                end)
                Btn.MouseButton1Click:Connect(function()
                    Btn.BackgroundColor3 = theme.button.background_click
                    task.delay(0.1, function()
                        tween(Btn, {BackgroundColor3 = theme.button.background}, 0.2)
                    end)
                    if callback then callback() end
                end)
                
                return Btn
            end
            
            function group:Slider(text, min, max, default, step, callback)
                local theme = lib.theme
                local accent = lib.accent
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.Parent = self._content
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 0, 14)
                Label.Position = UDim2.new(0, 0, 0, 2)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = theme.slider.label
                Label.Font = theme.fonts.label
                Label.TextSize = theme.sizes.label
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local Val = Instance.new("TextLabel")
                Val.Size = UDim2.new(0, 40, 0, 14)
                Val.Position = UDim2.new(1, -40, 0, 2)
                Val.BackgroundTransparency = 1
                Val.Text = tostring(default)
                Val.TextColor3 = theme.slider.value
                Val.Font = theme.fonts.value
                Val.TextSize = theme.sizes.value
                Val.TextXAlignment = Enum.TextXAlignment.Right
                Val.ZIndex = 11
                Val.Parent = Frame
                
                local Track = Instance.new("TextButton")
                Track.Size = UDim2.new(1, 0, 0, 4)
                Track.Position = UDim2.new(0, 0, 0, 20)
                Track.BackgroundColor3 = theme.slider.track
                Track.BorderSizePixel = 0
                Track.Text = ""
                Track.AutoButtonColor = false
                Track.ZIndex = 11
                Track.Parent = Frame
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min)/(max-min), 0, 1, 0)
                Fill.BackgroundColor3 = accent
                Fill.BorderSizePixel = 0
                Fill.ZIndex = 12
                Fill.Parent = Track
                lib:_registerAccent(Fill, "BackgroundColor3")
                
                local Handle = Instance.new("Frame")
                Handle.Size = UDim2.new(0, 8, 0, 8)
                Handle.Position = UDim2.new((default - min)/(max-min), -4, 0.5, -4)
                Handle.BackgroundColor3 = theme.slider.handle
                Handle.BorderSizePixel = 0
                Handle.ZIndex = 13
                Handle.Parent = Track
                
                local function snap(number, s)
                    if s == 0 then return number end
                    return math.floor(number / s + 0.5) * s
                end
                
                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local rawVal = min + ((max - min) * pos)
                    local val = snap(rawVal, step)
                    
                    local decimals = 0
                    if step < 1 then
                        local sStr = tostring(step)
                        if sStr:find("%.") then decimals = #sStr - sStr:find("%.") end
                    end
                    Val.Text = string.format("%." .. decimals .. "f", val)
                    
                    Fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
                    Handle.Position = UDim2.new((val - min)/(max - min), -4, 0.5, -4)
                    if callback then callback(val) end
                end
                
                Track.MouseButton1Down:Connect(function() dragging = true end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
                end)
            end
            
            function group:Dropdown(text, options, default, callback)
                local theme = lib.theme
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.ClipsDescendants = false
                Frame.Parent = self._content
                
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
                
                local Current = default or options[1]
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.6, 0, 0, 22)
                Button.Position = UDim2.new(0.4, 0, 0.5, -11)
                Button.BackgroundColor3 = theme.dropdown.background
                Button.BorderSizePixel = 0
                Button.Text = Current .. " ▼"
                Button.TextColor3 = theme.dropdown.text
                Button.Font = theme.fonts.value
                Button.TextSize = theme.sizes.value
                Button.AutoButtonColor = false
                Button.ZIndex = 11
                Button.Parent = Frame
                
                corner(Button, 2)
                
                local DropFrame = Instance.new("Frame")
                DropFrame.Name = "DropFrame"
                DropFrame.Size = UDim2.new(0.6, 0, 0, 0)
                DropFrame.Position = UDim2.new(0.4, 0, 1, 2)
                DropFrame.BackgroundColor3 = theme.dropdown.list_bg
                DropFrame.BorderSizePixel = 0
                DropFrame.Visible = false
                DropFrame.ZIndex = 50
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = Frame
                
                corner(DropFrame, 2)
                stroke(DropFrame, theme.dropdown.border, 1)
                
                local List = Instance.new("UIListLayout")
                List.SortOrder = Enum.SortOrder.LayoutOrder
                List.Padding = UDim.new(0, 1)
                List.Parent = DropFrame
                
                local open = false
                local function toggleDrop()
                    open = not open
                    if open then
                        local h = math.min(#options * 20, 100)
                        DropFrame.Size = UDim2.new(0.6, 0, 0, h)
                        DropFrame.Visible = true
                    else
                        DropFrame.Size = UDim2.new(0.6, 0, 0, 0)
                        DropFrame.Visible = false
                    end
                end
                
                Button.MouseButton1Click:Connect(toggleDrop)
                
                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 20)
                    OptBtn.BackgroundColor3 = theme.dropdown.list_item
                    OptBtn.BorderSizePixel = 0
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = theme.dropdown.list_text
                    OptBtn.Font = theme.fonts.value
                    OptBtn.TextSize = theme.sizes.value
                    OptBtn.AutoButtonColor = false
                    OptBtn.ZIndex = 51
                    OptBtn.Parent = DropFrame
                    
                    OptBtn.MouseEnter:Connect(function()
                        OptBtn.BackgroundColor3 = theme.dropdown.list_item_hover
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        OptBtn.BackgroundColor3 = theme.dropdown.list_item
                    end)
                    OptBtn.MouseButton1Click:Connect(function()
                        Current = opt
                        Button.Text = opt .. " ▼"
                        if callback then callback(opt) end
                        toggleDrop()
                    end)
                end
            end
            
            function group:TextBox(label, placeholder, callback)
                local theme = lib.theme
                local accent = lib.accent
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.Parent = self._content
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.35, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = label
                Label.TextColor3 = theme.textbox.label
                Label.Font = theme.fonts.label
                Label.TextSize = theme.sizes.label
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(0.6, 0, 0, 22)
                InputFrame.Position = UDim2.new(0.4, 0, 0.5, -11)
                InputFrame.BackgroundColor3 = theme.textbox.background
                InputFrame.BorderSizePixel = 0
                InputFrame.ZIndex = 11
                InputFrame.Parent = Frame
                
                corner(InputFrame, 2)
                local InputStroke = stroke(InputFrame, theme.textbox.border, 1)
                
                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(1, -10, 1, 0)
                Input.Position = UDim2.new(0, 5, 0, 0)
                Input.BackgroundTransparency = 1
                Input.Text = ""
                Input.PlaceholderText = placeholder or ""
                Input.PlaceholderColor3 = theme.textbox.placeholder
                Input.TextColor3 = theme.textbox.text
                Input.Font = theme.fonts.value
                Input.TextSize = theme.sizes.value
                Input.TextXAlignment = Enum.TextXAlignment.Left
                Input.ClearTextOnFocus = false
                Input.ZIndex = 12
                Input.Parent = InputFrame
                
                Input.Focused:Connect(function()
                    tween(InputStroke, {Color = accent})
                end)
                Input.FocusLost:Connect(function(enterPressed)
                    tween(InputStroke, {Color = theme.textbox.border})
                    if callback then callback(Input.Text, enterPressed) end
                end)
                
                return Input
            end
            
            function group:Keybind(label, configTable, configKey)
                local theme = lib.theme
                local accent = lib.accent
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.Parent = self._content
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.5, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = label
                Label.TextColor3 = theme.keybind.label
                Label.Font = theme.fonts.label
                Label.TextSize = theme.sizes.label
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local currentKey = configTable and configTable[configKey]
                local keyName = currentKey and currentKey.Name or "None"
                
                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0.45, 0, 0, 22)
                KeyBtn.Position = UDim2.new(0.55, 0, 0.5, -11)
                KeyBtn.BackgroundColor3 = theme.keybind.background
                KeyBtn.Text = "[" .. keyName .. "]"
                KeyBtn.TextColor3 = theme.keybind.text
                KeyBtn.Font = theme.fonts.value
                KeyBtn.TextSize = theme.sizes.value
                KeyBtn.AutoButtonColor = false
                KeyBtn.ZIndex = 11
                KeyBtn.Parent = Frame
                
                corner(KeyBtn, 3)
                
                local listening = false
                local conn = nil
                
                KeyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    KeyBtn.Text = "[...]"
                    KeyBtn.TextColor3 = accent
                    
                    conn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if configTable and configKey then
                                configTable[configKey] = input.KeyCode
                            end
                            KeyBtn.Text = "[" .. input.KeyCode.Name .. "]"
                            KeyBtn.TextColor3 = theme.keybind.text
                            listening = false
                            conn:Disconnect()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or
                               input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyBtn.Text = "[" .. keyName .. "]"
                            KeyBtn.TextColor3 = theme.keybind.text
                            listening = false
                            conn:Disconnect()
                        end
                    end)
                end)
                
                return Frame
            end
            
            function group:Label(text)
                local theme = lib.theme
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 18)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = theme.textbox.label
                Label.Font = theme.fonts.label
                Label.TextSize = theme.sizes.label
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = self._content
                
                return Label
            end
            
            return group
        end
        
        table.insert(self._tabs, tab)
        return tab
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    table.insert(lib._windows, Window)
    return Window
end

Spectrum.Key = {
    validate = function(key, options)
        options = options or {}
        if not key or key == "" then return false, "No key" end
        if options.whitelist then
            for _, v in ipairs(options.whitelist) do
                if key == v then return true, "Valid" end
            end
            return false, "Invalid key"
        end
        return true, "Valid"
    end,
    getHWID = function()
        local hwid = nil
        pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
        return hwid or tostring(LocalPlayer.UserId)
    end
}

Spectrum.Config = {
    save = function(name, data, folder)
        if not writefile then return false end
        folder = folder or "spectrum_configs"
        pcall(function()
            if not isfolder(folder) then makefolder(folder) end
            writefile(folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end)
        return true
    end,
    load = function(name, folder)
        if not readfile or not isfile then return nil end
        folder = folder or "spectrum_configs"
        local path = folder .. "/" .. name .. ".json"
        if not isfile(path) then return nil end
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        return success and result or nil
    end
}

return Spectrum
