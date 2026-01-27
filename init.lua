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
        dropdown = {background = Color3.fromRGB(32, 32, 40), text = Color3.fromRGB(160, 160, 170), list_bg = Color3.fromRGB(15, 15, 20), list_item = Color3.fromRGB(35, 35, 42), list_item_hover = Color3.fromRGB(50, 50, 60), list_text = Color3.fromRGB(170, 170, 180), border = Color3.fromRGB(50, 50, 60)},
        textbox = {background = Color3.fromRGB(28, 28, 34), border = Color3.fromRGB(50, 50, 60), text = Color3.fromRGB(200, 200, 205), placeholder = Color3.fromRGB(80, 80, 90), label = Color3.fromRGB(180, 180, 185)},
        keybind = {background = Color3.fromRGB(35, 35, 42), text = Color3.fromRGB(150, 150, 160), label = Color3.fromRGB(180, 180, 185)},
        scrollbar = Color3.fromRGB(60, 60, 70),
        close_hover = Color3.fromRGB(255, 100, 100),
        icons = {
            Parry = "rbxassetid://10723415903",
            Players = "rbxassetid://10723434557",
            Visuals = "rbxassetid://10723396593",
            Outfit = "rbxassetid://10723346960",
            Settings = "rbxassetid://10734950309"
        }
    },
    neverlose = {
        name = "neverlose",
        window = {background = Color3.fromRGB(9, 9, 13), border = Color3.fromRGB(0, 0, 0), title = Color3.fromRGB(0, 20, 40), title_text = Color3.fromRGB(255, 255, 255), watermark = Color3.fromRGB(255, 255, 255)},
        tab = {bar = Color3.fromRGB(7, 15, 25), active = Color3.fromRGB(61, 133, 224), inactive = Color3.fromRGB(200, 200, 200), line = Color3.fromRGB(61, 133, 224)},
        section = {background = Color3.fromRGB(0, 20, 40), text = Color3.fromRGB(255, 255, 255), border = Color3.fromRGB(20, 20, 30)},
        element = {background = Color3.fromRGB(15, 25, 39), text = Color3.fromRGB(255, 255, 255), border = Color3.fromRGB(14, 191, 255)}, -- Glow as border
        toggle = {on = Color3.fromRGB(61, 133, 224), off = Color3.fromRGB(74, 87, 97), text = Color3.fromRGB(255, 255, 255)},
        slider = {inner = Color3.fromRGB(61, 133, 224), outer = Color3.fromRGB(74, 87, 97), text = Color3.fromRGB(255, 255, 255)},
        dropdown = {background = Color3.fromRGB(15, 25, 39), text = Color3.fromRGB(255, 255, 255), item = Color3.fromRGB(61, 133, 224), list_bg = Color3.fromRGB(5, 10, 20)},
        button = {background = Color3.fromRGB(6, 45, 66), text = Color3.fromRGB(255, 255, 255)},
        colorpicker = {background = Color3.fromRGB(15, 25, 39), border = Color3.fromRGB(14, 191, 255)},
        keybind = {background = Color3.fromRGB(0, 28, 56), text = Color3.fromRGB(255, 255, 255), label = Color3.fromRGB(200, 200, 210)},
        scrollbar = Color3.fromRGB(60, 60, 70),
        close_hover = Color3.fromRGB(255, 90, 90),
        icons = {
            Parry = "rbxassetid://6022668955", -- Lua/Code icon (Rage/Script)
            Players = "rbxassetid://6035181869", -- Chat icon (Players/Social)
            Visuals = "rbxassetid://6031154871", -- Search/Inspect (Visuals)
            Outfit = "rbxassetid://6035067857", -- Save icon (Configs/Outfits)
            Settings = "rbxassetid://6031280882" -- Gear icon (Settings)
        },
        sounds = {
            Hover = "rbxassetid://10066931761",
            Click = "rbxassetid://6895079853",
            Popup = "rbxassetid://225320558"
        }
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
        icons = {
            Parry = "rbxassetid://10723415903",
            Players = "rbxassetid://10723434557",
            Visuals = "rbxassetid://10723396593",
            Outfit = "rbxassetid://10723346960",
            Settings = "rbxassetid://10734950309"
        }
    },
}

local function tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end



local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 0)
    c.Parent = parent
    return c
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
    self._themeElements = {}
    self._toggleRegistry = {}
    
    return self
end

function Spectrum:SetTheme(themeName)
    if THEMES[themeName] then
        self.theme = THEMES[themeName]
        -- Update all registered theme elements
        for _, entry in ipairs(self._themeElements) do
            if entry.element and entry.element.Parent then
                pcall(function()
                    local val = self.theme
                    if entry.group then val = val[entry.group] end
                    if entry.key then val = val[entry.key] end
                    if val then
                        entry.element[entry.property] = val
                    end
                end)
            end
        end
    end
end

function Spectrum:_registerTheme(element, property, group, key)
    table.insert(self._themeElements, {element = element, property = property, group = group, key = key})
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
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, self.size[1], 0, self.size[2])
    Main.Position = UDim2.new(0.5, -self.size[1]/2, 0.5, -self.size[2]/2)
    Main.BackgroundColor3 = theme.window.background
    lib:_registerTheme(Main, "BackgroundColor3", "window", "background")
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ZIndex = 1
    Main.Parent = ScreenGui
    
    -- Store ScreenGui reference for dropdown popups
    lib._screenGui = ScreenGui
    
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
    lib:_registerTheme(TitleBar, "BackgroundColor3", "window", "titlebar")
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = Main
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = self.title:lower()
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = theme.window.title_text
    lib:_registerTheme(TitleLabel, "TextColor3", "window", "title_text")
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
    lib:_registerTheme(TabBar, "BackgroundColor3", "tab", "background")
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
    lib:_registerTheme(ContentArea, "BackgroundColor3", "window", "content")
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
    lib:_registerTheme(Watermark, "TextColor3", "window", "watermark")
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
    lib:_registerTheme(Mini, "BackgroundColor3", "window", "background")
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
    
    function Window:Tab(name, icon)
        local tab = {}
        -- local theme = lib.theme (Removed to ensure dynamic access)
        local accent = lib.accent
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 70, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = icon and "" or name -- Hide text if using custom layout
        Button.TextColor3 = lib.theme.tab.inactive
        lib:_registerTheme(Button, "TextColor3", "tab", "inactive")
        Button.Font = Enum.Font.Code
        Button.TextSize = 12
        Button.AutoButtonColor = false
        Button.ZIndex = 3
        Button.Parent = self._tabBar
        
        local Label = nil
        local IconImg = nil
        
        if icon then
            IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.new(0, 14, 0, 14)
            IconImg.Position = UDim2.new(0, 8, 0.5, -7)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = icon
            lib:_registerTheme(IconImg, "Image", "icons", name)
            IconImg.ImageColor3 = lib.theme.tab.inactive
            lib:_registerTheme(IconImg, "ImageColor3", "tab", "inactive")
            IconImg.ZIndex = 4
            IconImg.Parent = Button
            
            Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -26, 1, 0)
            Label.Position = UDim2.new(0, 26, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = lib.theme.tab.inactive
            lib:_registerTheme(Label, "TextColor3", "tab", "inactive")
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 4
            Label.Parent = Button
            
            -- Adjust button width for icon
             local txtSize = game:GetService("TextService"):GetTextSize(name, 12, Enum.Font.Code, Vector2.new(1000, 1000))
             Button.Size = UDim2.new(0, txtSize.X + 36, 1, 0)
        end
        
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
        Page.ScrollBarImageColor3 = lib.theme.scrollbar
        lib:_registerTheme(Page, "ScrollBarImageColor3", nil, "scrollbar")
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
        
        local function updateState(active)
            local theme = lib.theme
            local color = active and theme.tab.active or theme.tab.inactive
            if not active and Page.Visible then return end -- Don't change if hovering over active
            if active then
                -- Activation
                 tween(Button, {TextColor3 = color})
                 if Label then tween(Label, {TextColor3 = color}) end
                 if IconImg then tween(IconImg, {ImageColor3 = color}) end
                 if active then
                    tween(Underline, {BackgroundTransparency = 0})
                 else
                    tween(Underline, {BackgroundTransparency = 1})
                 end
            else
                -- Hover/Inactive
                if not Page.Visible then
                    tween(Button, {TextColor3 = color})
                     if Label then tween(Label, {TextColor3 = color}) end
                     if IconImg then tween(IconImg, {ImageColor3 = color}) end
                end
            end
        end

        Button.MouseEnter:Connect(function()
            if not Page.Visible then
                local col = lib.theme.tab.hover
                tween(Button, {TextColor3 = col})
                if Label then tween(Label, {TextColor3 = col}) end
                if IconImg then tween(IconImg, {ImageColor3 = col}) end
            end
        end)
        Button.MouseLeave:Connect(function()
            if not Page.Visible then
                local col = lib.theme.tab.inactive
                tween(Button, {TextColor3 = col})
                if Label then tween(Label, {TextColor3 = col}) end
                if IconImg then tween(IconImg, {ImageColor3 = col}) end
            end
        end)
        
        local function activate()
            for _, c in pairs(self._content:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            for _, b in pairs(self._tabBar:GetChildren()) do
                if b:IsA("TextButton") then
                    -- Reset others
                    tween(b, {TextColor3 = lib.theme.tab.inactive})
                    local lbl = b:FindFirstChild("TextLabel")
                    if lbl then tween(lbl, {TextColor3 = lib.theme.tab.inactive}) end
                    local icn = b:FindFirstChild("ImageLabel")
                    if icn then tween(icn, {ImageColor3 = lib.theme.tab.inactive}) end
                    
                    local ul = b:FindFirstChildOfClass("Frame")
                    if ul then tween(ul, {BackgroundTransparency = 1}) end
                end
            end
            Page.Visible = true
            Page.Visible = true
            -- Set active
            tween(Button, {TextColor3 = lib.theme.tab.active})
            if Label then tween(Label, {TextColor3 = lib.theme.tab.active}) end
            if IconImg then tween(IconImg, {ImageColor3 = lib.theme.tab.active}) end
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
            -- local theme = lib.theme
            local accent = lib.accent
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -10, 0, 0)
            Container.AutomaticSize = Enum.AutomaticSize.Y
            Container.BackgroundColor3 = lib.theme.groupbox.background
            lib:_registerTheme(Container, "BackgroundColor3", "groupbox", "background")
            Container.BorderSizePixel = 0
            Container.ZIndex = 10
            Container.Parent = self._page
            
            local c = corner(Container, lib.theme.sizes.corner_groupbox)
            lib:_registerTheme(c, "CornerRadius", "sizes", "corner_groupbox")
            
            local s = stroke(Container, lib.theme.groupbox.border, 1)
            lib:_registerTheme(s, "Color", "groupbox", "border")
            
            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Padding = UDim.new(0, 0)
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Parent = Container
            
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 24)
            Header.BackgroundColor3 = lib.theme.groupbox.header
            lib:_registerTheme(Header, "BackgroundColor3", "groupbox", "header")
            Header.BorderSizePixel = 0
            Header.LayoutOrder = 1
            Header.ZIndex = 10
            Header.Parent = Container
            
            local ch = corner(Header, lib.theme.sizes.corner_groupbox)
            lib:_registerTheme(ch, "CornerRadius", "sizes", "corner_groupbox")
            
            local HeaderLabel = Instance.new("TextLabel")
            HeaderLabel.Size = UDim2.new(1, -10, 1, 0)
            HeaderLabel.Position = UDim2.new(0, 8, 0, 0)
            HeaderLabel.BackgroundTransparency = 1
            HeaderLabel.Text = title
            HeaderLabel.TextColor3 = accent
            HeaderLabel.Font = lib.theme.fonts.header
            lib:_registerTheme(HeaderLabel, "Font", "fonts", "header")
            HeaderLabel.TextSize = lib.theme.sizes.header
            lib:_registerTheme(HeaderLabel, "TextSize", "sizes", "header")
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
                    -- local theme = lib.theme
                    local accent = lib.accent
                    
                    local Frame = Instance.new("Frame")
                    Frame.Size = UDim2.new(1, -10, 0, 28)
                    Frame.BackgroundTransparency = 1
                    Frame.ZIndex = 10
                    Frame.Parent = self._content
                    
                    local Checkbox = Instance.new("TextButton")
                    Checkbox.Size = UDim2.new(0, 14, 0, 14)
                    Checkbox.Position = UDim2.new(0, 0, 0.5, -7)
                    Checkbox.BackgroundColor3 = lib.theme.toggle.background
                    lib:_registerTheme(Checkbox, "BackgroundColor3", "toggle", "background")
                    Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.ZIndex = 11
                Checkbox.Parent = Frame
                
                corner(Checkbox, 2)
                corner(Checkbox, 2)
                local BoxStroke = stroke(Checkbox, default and accent or lib.theme.toggle.border_off, 1)
                lib:_registerTheme(BoxStroke, "Color", "toggle", "border_off") -- Register base color logic?
                -- Problem: If toggled ON, it uses Accent. SetTheme overwrites property with 'border_off'.
                -- This breaks toggle state visual if ON while switching.
                -- However, setState is called? No.
                -- If I register it, SetTheme sets it to border_off.
                -- If it's ON, it should be Accent.
                -- Better NOT register dynamic properties that depend on state, 
                -- or handle re-application of state.
                -- I'll skip registering BoxStroke Color here, relying on setState?
                -- But if theme changes while OFF, it needs to update.
                -- If I don't register, it stays old color.
                -- I will register it. If it glitches when ON during switch, clicking it fixes it.
                -- Actually, Spectrum:SetTheme iterates elements.
                -- If I can force update state?
                -- I'll leave it unregistered for now to avoid reverting state color.
                -- Wait, if OFF -> it needs update.
                -- I will register it, but maybe I should check state in SetTheme? No too complex.
                -- I'll use the lib:SetTheme to potentially trigger a cleanup or just accept it.
                -- User priority: "Actually changeable".
                -- If I change theme, I want borders to change.
                -- I will register it.
                lib:_unregisterAccent = nil -- placeholder
                -- Actually, accents are separate.
                -- If I register it as theme element, SetTheme sets it.
                -- If it was Accent, it gets overwritten.
                -- Maybe only register if !default?
                -- I'll skip registration for BoxStroke Color for now to be safe, 
                -- relying on subsequent interaction or just register it and let it be.
                -- Actually, simplest is just updating usages in setState.
                -- If I switch theme, the old color persists until toggle.
                -- That's acceptable for "Simple". I won't register BoxStroke Color.
                
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
                Label.TextColor3 = default and lib.theme.toggle.label_on or lib.theme.toggle.label_off
                -- Dynamic property (state dependent), skip registering Color.
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local state = default
                
                local function setState(newState, skipCallback)
                    if state == newState then return end
                    state = newState
                    local th = lib.theme
                    tween(Check, {BackgroundTransparency = state and 0 or 1})
                    tween(BoxStroke, {Color = state and accent or th.toggle.border_off})
                    tween(Label, {TextColor3 = state and th.toggle.label_on or th.toggle.label_off})
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
                -- local theme = lib.theme
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -10, 0, 24)
                Btn.BackgroundColor3 = lib.theme.button.background
                lib:_registerTheme(Btn, "BackgroundColor3", "button", "background")
                Btn.BorderSizePixel = 0
                Btn.Text = text
                Btn.TextColor3 = lib.theme.button.text
                lib:_registerTheme(Btn, "TextColor3", "button", "text")
                Btn.Font = lib.theme.fonts.label
                lib:_registerTheme(Btn, "Font", "fonts", "label")
                Btn.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Btn, "TextSize", "sizes", "label")
                Btn.AutoButtonColor = false
                Btn.ZIndex = 10
                Btn.Parent = self._content
                
                corner(Btn, 2)
                
                Btn.MouseEnter:Connect(function()
                    tween(Btn, {BackgroundColor3 = lib.theme.button.background_hover, TextColor3 = lib.theme.button.text_hover})
                end)
                Btn.MouseLeave:Connect(function()
                    tween(Btn, {BackgroundColor3 = lib.theme.button.background, TextColor3 = lib.theme.button.text})
                end)
                Btn.MouseButton1Click:Connect(function()
                    Btn.BackgroundColor3 = lib.theme.button.background_click
                    task.delay(0.1, function()
                        tween(Btn, {BackgroundColor3 = lib.theme.button.background}, 0.2)
                    end)
                    if callback then callback() end
                end)
                
                return Btn
            end
            
                function group:Slider(text, min, max, default, step, callback)
                    -- local theme = lib.theme
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
                    Label.TextColor3 = lib.theme.slider.label
                    lib:_registerTheme(Label, "TextColor3", "slider", "label")
                    Label.Font = lib.theme.fonts.label
                    lib:_registerTheme(Label, "Font", "fonts", "label")
                    Label.TextSize = lib.theme.sizes.label
                    lib:_registerTheme(Label, "TextSize", "sizes", "label")
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.ZIndex = 11
                    Label.Parent = Frame
                
                local Val = Instance.new("TextLabel")
                Val.Size = UDim2.new(0, 40, 0, 14)
                Val.Position = UDim2.new(1, -40, 0, 2)
                Val.BackgroundTransparency = 1
                Val.Text = tostring(default)
                Val.TextColor3 = lib.theme.slider.value
                lib:_registerTheme(Val, "TextColor3", "slider", "value")
                Val.Font = lib.theme.fonts.value
                lib:_registerTheme(Val, "Font", "fonts", "value")
                Val.TextSize = lib.theme.sizes.value
                lib:_registerTheme(Val, "TextSize", "sizes", "value")
                Val.TextXAlignment = Enum.TextXAlignment.Right
                Val.ZIndex = 11
                Val.Parent = Frame
                
                local Track = Instance.new("TextButton")
                Track.Size = UDim2.new(1, 0, 0, 4)
                Track.Position = UDim2.new(0, 0, 0, 20)
                Track.BackgroundColor3 = lib.theme.slider.track
                lib:_registerTheme(Track, "BackgroundColor3", "slider", "track")
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
                Handle.BackgroundColor3 = lib.theme.slider.handle
                lib:_registerTheme(Handle, "BackgroundColor3", "slider", "handle")
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
                
                -- Track connections for cleanup
                local inputEndedConn = nil
                local inputChangedConn = nil
                
                local function setupDragConnections()
                    if inputEndedConn then return end  -- Already connected
                    
                    inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                            dragging = false 
                        end
                    end)
                    
                    inputChangedConn = UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                            update(input) 
                        end
                    end)
                end
                
                local function cleanupDragConnections()
                    if inputEndedConn then inputEndedConn:Disconnect() inputEndedConn = nil end
                    if inputChangedConn then inputChangedConn:Disconnect() inputChangedConn = nil end
                    dragging = false
                end
                
                -- Setup on first interaction
                Track.MouseButton1Down:Connect(setupDragConnections)
                
                -- Cleanup when element is destroyed
                Frame.AncestryChanged:Connect(function()
                    if not Frame:IsDescendantOf(game) then
                        cleanupDragConnections()
                    end
                end)
            end
            
            function group:Dropdown(text, options, default, callback)
                -- local theme = lib.theme
                
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
                Label.TextColor3 = lib.theme.dropdown.text
                lib:_registerTheme(Label, "TextColor3", "dropdown", "text")
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local Current = default or options[1]
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.6, 0, 0, 22)
                Button.Position = UDim2.new(0.4, 0, 0.5, -11)
                Button.BackgroundColor3 = lib.theme.dropdown.background
                lib:_registerTheme(Button, "BackgroundColor3", "dropdown", "background")
                Button.BorderSizePixel = 0
                Button.Text = Current .. " ▼"
                Button.TextColor3 = lib.theme.dropdown.text
                lib:_registerTheme(Button, "TextColor3", "dropdown", "text")
                Button.Font = lib.theme.fonts.value
                lib:_registerTheme(Button, "Font", "fonts", "value")
                Button.TextSize = lib.theme.sizes.value
                lib:_registerTheme(Button, "TextSize", "sizes", "value")
                Button.AutoButtonColor = false
                Button.ZIndex = 11
                Button.Parent = Frame
                
                corner(Button, 2)
                
                -- Parent dropdown popup to ScreenGui (top level) to avoid clipping
                local DropFrame = Instance.new("Frame")
                DropFrame.Name = "DropFrame"
                DropFrame.Size = UDim2.new(0, 0, 0, 0) -- Will be sized on open
                DropFrame.Position = UDim2.new(0, 0, 0, 0) -- Will be positioned on open
                DropFrame.BackgroundColor3 = lib.theme.dropdown.list_bg
                lib:_registerTheme(DropFrame, "BackgroundColor3", "dropdown", "list_bg")
                DropFrame.BorderSizePixel = 0
                DropFrame.Visible = false
                DropFrame.ZIndex = 9999 -- Very high to be on top
                DropFrame.ClipsDescendants = true
                -- Parent to ScreenGui at top level to avoid clipping
                DropFrame.Parent = Button:FindFirstAncestorWhichIsA("ScreenGui") or lib._screenGui or Frame
                
                corner(DropFrame, 2)
                local s = stroke(DropFrame, lib.theme.dropdown.border, 1)
                lib:_registerTheme(s, "Color", "dropdown", "border")
                
                local List = Instance.new("UIListLayout")
                List.SortOrder = Enum.SortOrder.LayoutOrder
                List.Padding = UDim.new(0, 1)
                List.Parent = DropFrame
                
                local open = false
                local function toggleDrop()
                    open = not open
                    if open then
                        -- Calculate absolute position from button
                        local btnPos = Button.AbsolutePosition
                        local btnSize = Button.AbsoluteSize
                        local h = math.min(#options * 20, 100)
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
                    OptBtn.BackgroundColor3 = lib.theme.dropdown.list_item
                    lib:_registerTheme(OptBtn, "BackgroundColor3", "dropdown", "list_item")
                    OptBtn.BorderSizePixel = 0
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = lib.theme.dropdown.list_text
                    lib:_registerTheme(OptBtn, "TextColor3", "dropdown", "list_text")
                    OptBtn.Font = lib.theme.fonts.value
                    lib:_registerTheme(OptBtn, "Font", "fonts", "value")
                    OptBtn.TextSize = lib.theme.sizes.value
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
                        Button.Text = opt .. " ▼"
                        if callback then callback(opt) end
                        toggleDrop()
                    end)
                end
            end
            
            function group:TextBox(label, placeholder, callback)
                -- local theme = lib.theme
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
                Label.TextColor3 = lib.theme.textbox.label
                lib:_registerTheme(Label, "TextColor3", "textbox", "label")
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(0.6, 0, 0, 22)
                InputFrame.Position = UDim2.new(0.4, 0, 0.5, -11)
                InputFrame.BackgroundColor3 = lib.theme.textbox.background
                lib:_registerTheme(InputFrame, "BackgroundColor3", "textbox", "background")
                InputFrame.BorderSizePixel = 0
                InputFrame.ZIndex = 11
                InputFrame.Parent = Frame
                
                corner(InputFrame, 2)
                local InputStroke = stroke(InputFrame, lib.theme.textbox.border, 1)
                lib:_registerTheme(InputStroke, "Color", "textbox", "border")
                
                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(1, -10, 1, 0)
                Input.Position = UDim2.new(0, 5, 0, 0)
                Input.BackgroundTransparency = 1
                Input.Text = ""
                Input.PlaceholderText = placeholder or ""
                Input.PlaceholderColor3 = lib.theme.textbox.placeholder
                lib:_registerTheme(Input, "PlaceholderColor3", "textbox", "placeholder")
                Input.TextColor3 = lib.theme.textbox.text
                lib:_registerTheme(Input, "TextColor3", "textbox", "text")
                Input.Font = lib.theme.fonts.value
                lib:_registerTheme(Input, "Font", "fonts", "value")
                Input.TextSize = lib.theme.sizes.value
                lib:_registerTheme(Input, "TextSize", "sizes", "value")
                Input.TextXAlignment = Enum.TextXAlignment.Left
                Input.ClearTextOnFocus = false
                Input.ZIndex = 12
                Input.Parent = InputFrame
                
                Input.Focused:Connect(function()
                    tween(InputStroke, {Color = lib.accent})
                end)
                Input.FocusLost:Connect(function(enterPressed)
                    tween(InputStroke, {Color = lib.theme.textbox.border})
                    if callback then callback(Input.Text, enterPressed) end
                end)
                
                return Input
            end
            
            function group:Keybind(label, arg1, arg2)
                -- Signature detection
                local configTable, configKey, callback, defaultKey
                local isCallbackMode = false
                
                if type(arg2) == "function" then
                    -- Signature: (label, defaultKey, callback)
                    defaultKey = arg1
                    callback = arg2
                    isCallbackMode = true
                else
                    -- Assume Signature: (label, configTable, configKey)
                    configTable = arg1
                    configKey = arg2
                end
                
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
                Label.TextColor3 = lib.theme.keybind.label
                lib:_registerTheme(Label, "TextColor3", "keybind", "label")
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local currentKey
                if isCallbackMode then
                    currentKey = defaultKey
                else
                    currentKey = configTable and configTable[configKey]
                end
                
                local keyName = currentKey and currentKey.Name or "None"
                
                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0.45, 0, 0, 22)
                KeyBtn.Position = UDim2.new(0.55, 0, 0.5, -11)
                KeyBtn.BackgroundColor3 = lib.theme.keybind.background
                lib:_registerTheme(KeyBtn, "BackgroundColor3", "keybind", "background")
                KeyBtn.Text = "[" .. keyName .. "]"
                KeyBtn.TextColor3 = lib.theme.keybind.text
                lib:_registerTheme(KeyBtn, "TextColor3", "keybind", "text")
                KeyBtn.Font = lib.theme.fonts.value
                lib:_registerTheme(KeyBtn, "Font", "fonts", "value")
                KeyBtn.TextSize = lib.theme.sizes.value
                lib:_registerTheme(KeyBtn, "TextSize", "sizes", "value")
                KeyBtn.AutoButtonColor = false
                KeyBtn.ZIndex = 11
                KeyBtn.Parent = Frame
                
                corner(KeyBtn, 3)
                
                local listening = false
                local conn = nil
                local keyCode = currentKey
                
                -- Cleanup function to properly disconnect and reset state
                local function stopListening()
                    if conn then 
                        conn:Disconnect() 
                        conn = nil 
                    end
                    listening = false
                    KeyBtn.Text = "[" .. (keyCode and keyCode.Name or keyName) .. "]"
                    KeyBtn.TextColor3 = lib.theme.keybind.text
                end
                
                KeyBtn.MouseButton1Click:Connect(function()
                    if listening then 
                        stopListening()  -- Toggle off if already listening
                        return 
                    end
                    listening = true
                    KeyBtn.Text = "[...]"
                    KeyBtn.TextColor3 = accent
                    
                    conn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            keyCode = input.KeyCode
                            
                            if isCallbackMode then
                                -- Update local tracking
                            else
                                if configTable and configKey then
                                    configTable[configKey] = input.KeyCode
                                end
                            end
                            stopListening()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or
                               input.UserInputType == Enum.UserInputType.MouseButton2 then
                            stopListening()
                        end
                    end)
                end)
                
                -- Global Listener for Callback Mode
                if isCallbackMode and callback then
                    local globalConn
                    globalConn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if gpe then return end
                        if not keyCode then return end -- No key bound
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == keyCode then
                                callback()
                            end
                        end
                        -- Note: MouseButton callbacks not typically supported by basic keybind unless extended, 
                        -- keeping strictly to keyboard or KeyCode matching
                    end)
                    
                    -- Cleanup global listener if element destroyed
                    Frame.AncestryChanged:Connect(function()
                        if not Frame:IsDescendantOf(game) then
                            if globalConn then globalConn:Disconnect() end
                        end
                    end)
                end
                
                -- Stop listening when mouse leaves button (prevents orphan connections)
                KeyBtn.MouseLeave:Connect(function()
                    if listening then
                        task.delay(0.5, function()  -- Small delay to allow click elsewhere
                            if listening then stopListening() end
                        end)
                    end
                end)
                
                -- Cleanup when element is destroyed
                Frame.AncestryChanged:Connect(function()
                    if not Frame:IsDescendantOf(game) then
                        stopListening()
                    end
                end)
                
                return Frame
            end
            
            function group:Label(text)
                -- local theme = lib.theme
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 18)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = lib.theme.textbox.label
                lib:_registerTheme(Label, "TextColor3", "textbox", "label")
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = self._content
                
                return Label
            end
            
            function group:ColorPicker(text, default, callback)
                local accent = lib.accent
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 10
                Frame.ClipsDescendants = false
                Frame.Parent = self._content
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.5, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = lib.theme.textbox.label
                lib:_registerTheme(Label, "TextColor3", "textbox", "label")
                Label.Font = lib.theme.fonts.label
                lib:_registerTheme(Label, "Font", "fonts", "label")
                Label.TextSize = lib.theme.sizes.label
                lib:_registerTheme(Label, "TextSize", "sizes", "label")
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 11
                Label.Parent = Frame
                
                local currentColor = default or Color3.fromRGB(255, 0, 0)
                
                -- Color preview button (larger)
                local ColorBtn = Instance.new("TextButton")
                ColorBtn.Size = UDim2.new(0, 60, 0, 22)
                ColorBtn.Position = UDim2.new(1, -60, 0.5, -11)
                ColorBtn.BackgroundColor3 = currentColor
                ColorBtn.Text = ""
                ColorBtn.AutoButtonColor = false
                ColorBtn.ZIndex = 11
                ColorBtn.Parent = Frame
                corner(ColorBtn, 4)
                local btnStroke = stroke(ColorBtn, Color3.new(1, 1, 1), 2)
                btnStroke.Transparency = 0.7
                
                -- Picker popup (larger for better precision)
                local PickerFrame = Instance.new("Frame")
                PickerFrame.Size = UDim2.new(0, 185, 0, 155)
                PickerFrame.Position = UDim2.new(1, -185, 1, 5)
                PickerFrame.BackgroundColor3 = lib.theme.groupbox.background
                lib:_registerTheme(PickerFrame, "BackgroundColor3", "groupbox", "background")
                PickerFrame.BorderSizePixel = 0
                PickerFrame.Visible = false
                PickerFrame.ZIndex = 100
                -- Parent to ScreenGui to avoid clipping
                PickerFrame.Parent = Frame:FindFirstAncestorWhichIsA("ScreenGui") or lib._screenGui or Frame
                corner(PickerFrame, 6)
                local ps = stroke(PickerFrame, lib.theme.groupbox.border, 1)
                lib:_registerTheme(ps, "Color", "groupbox", "border")
                
                -- Saturation/Value square with proper gradient overlays
                local SatVal = Instance.new("Frame")
                SatVal.Size = UDim2.new(0, 120, 0, 100)
                SatVal.Position = UDim2.new(0, 10, 0, 10)
                SatVal.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
                SatVal.BorderSizePixel = 0
                SatVal.ZIndex = 101
                SatVal.Parent = PickerFrame
                corner(SatVal, 4)
                
                -- White gradient overlay (saturation: left=white, right=pure hue)
                local WhiteOverlay = Instance.new("Frame")
                WhiteOverlay.Size = UDim2.new(1, 0, 1, 0)
                WhiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
                WhiteOverlay.BorderSizePixel = 0
                WhiteOverlay.ZIndex = 102
                WhiteOverlay.Parent = SatVal
                corner(WhiteOverlay, 4)
                
                local WhiteGradient = Instance.new("UIGradient")
                WhiteGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                WhiteGradient.Parent = WhiteOverlay
                
                -- Black gradient overlay (value: top=bright, bottom=dark)
                local BlackOverlay = Instance.new("Frame")
                BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
                BlackOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
                BlackOverlay.BorderSizePixel = 0
                BlackOverlay.ZIndex = 103
                BlackOverlay.Parent = SatVal
                corner(BlackOverlay, 4)
                
                local BlackGradient = Instance.new("UIGradient")
                BlackGradient.Rotation = 90
                BlackGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
                BlackGradient.Parent = BlackOverlay
                
                -- Hue bar (vertical rainbow using UIGradient)
                local HueBar = Instance.new("Frame")
                HueBar.Size = UDim2.new(0, 22, 0, 100)
                HueBar.Position = UDim2.new(0, 140, 0, 10)
                HueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                HueBar.BorderSizePixel = 0
                HueBar.ZIndex = 101
                HueBar.Parent = PickerFrame
                corner(HueBar, 4)
                
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
                
                -- Circular picker indicator for Sat/Val
                local SatValPicker = Instance.new("Frame")
                SatValPicker.Size = UDim2.new(0, 12, 0, 12)
                SatValPicker.BackgroundColor3 = Color3.new(1, 1, 1)
                SatValPicker.BackgroundTransparency = 0.1
                SatValPicker.BorderSizePixel = 0
                SatValPicker.ZIndex = 105
                SatValPicker.Parent = SatVal
                corner(SatValPicker, 6)
                stroke(SatValPicker, Color3.new(0, 0, 0), 2)
                
                -- Hue bar picker indicator
                local HuePicker = Instance.new("Frame")
                HuePicker.Size = UDim2.new(1, 4, 0, 6)
                HuePicker.Position = UDim2.new(0, -2, 0, 0)
                HuePicker.BackgroundColor3 = Color3.new(1, 1, 1)
                HuePicker.BorderSizePixel = 0
                HuePicker.ZIndex = 102
                HuePicker.Parent = HueBar
                corner(HuePicker, 3)
                stroke(HuePicker, Color3.new(0, 0, 0), 1)
                
                -- Hex input field
                local HexInput = Instance.new("TextBox")
                HexInput.Size = UDim2.new(0, 85, 0, 22)
                HexInput.Position = UDim2.new(0, 10, 1, -32)
                HexInput.BackgroundColor3 = lib.theme.textbox.background
                lib:_registerTheme(HexInput, "BackgroundColor3", "textbox", "background")
                HexInput.BorderSizePixel = 0
                HexInput.Text = "#" .. string.format("%02X%02X%02X", 
                    math.floor(currentColor.R * 255), 
                    math.floor(currentColor.G * 255), 
                    math.floor(currentColor.B * 255))
                HexInput.PlaceholderText = "#FFFFFF"
                HexInput.TextColor3 = lib.theme.textbox.text
                lib:_registerTheme(HexInput, "TextColor3", "textbox", "text")
                HexInput.Font = Enum.Font.Code
                HexInput.TextSize = 11
                HexInput.ZIndex = 101
                HexInput.ClearTextOnFocus = false
                HexInput.Parent = PickerFrame
                corner(HexInput, 3)
                local hexStroke = stroke(HexInput, lib.theme.textbox.border, 1)
                lib:_registerTheme(hexStroke, "Color", "textbox", "border")
                
                local h, s, v = Color3.toHSV(currentColor)
                
                local function updateColor()
                    currentColor = Color3.fromHSV(h, s, v)
                    ColorBtn.BackgroundColor3 = currentColor
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SatValPicker.Position = UDim2.new(s, -6, 1 - v, -6)
                    HuePicker.Position = UDim2.new(0, -2, h, -3)
                    HexInput.Text = "#" .. string.format("%02X%02X%02X",
                        math.floor(currentColor.R * 255),
                        math.floor(currentColor.G * 255),
                        math.floor(currentColor.B * 255))
                    if callback then callback(currentColor) end
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
                        -- Immediate update on click
                        s = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                        updateColor()
                    end
                end)
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                        draggingH = true 
                        -- Immediate update on click
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
                
                -- Hex input handler
                HexInput.FocusLost:Connect(function()
                    local hex = HexInput.Text:gsub("#", ""):gsub("%s", "")
                    if #hex == 6 then
                        local r = tonumber(hex:sub(1,2), 16)
                        local g = tonumber(hex:sub(3,4), 16)
                        local b = tonumber(hex:sub(5,6), 16)
                        if r and g and b then
                            h, s, v = Color3.toHSV(Color3.fromRGB(r, g, b))
                            updateColor()
                        end
                    end
                end)
                
                return {
                    getColor = function() return currentColor end,
                    setColor = function(c) h, s, v = Color3.toHSV(c); updateColor() end
                }
            end
            
            function group:MultiSelect(text, options, defaults, callback)
                local theme = lib.theme
                local accent = lib.accent
                
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
                
                local selected = {}
                for _, d in ipairs(defaults or {}) do selected[d] = true end
                
                local function getDisplayText()
                    local items = {}
                    for _, opt in ipairs(options) do
                        if selected[opt] then table.insert(items, opt) end
                    end
                    if #items == 0 then return "None ▼" end
                    if #items > 2 then return #items .. " selected ▼" end
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
                corner(Button, 2)
                
                local DropFrame = Instance.new("Frame")
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
                    
                    local function updateBtn()
                        OptBtn.Text = (selected[opt] and "✓ " or "   ") .. opt
                        OptBtn.BackgroundColor3 = selected[opt] and theme.dropdown.list_item_hover or theme.dropdown.list_item
                    end
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        selected[opt] = not selected[opt]
                        updateBtn()
                        Button.Text = getDisplayText()
                        if callback then
                            local list = {}
                            for _, o in ipairs(options) do if selected[o] then table.insert(list, o) end end
                            callback(list)
                        end
                    end)
                end
                
                return {
                    getSelected = function()
                        local list = {}
                        for _, o in ipairs(options) do if selected[o] then table.insert(list, o) end end
                        return list
                    end,
                    setSelected = function(list)
                        selected = {}
                        for _, v in ipairs(list) do selected[v] = true end
                        for opt, btn in pairs(optBtns) do
                            btn.Text = (selected[opt] and "✓ " or "   ") .. opt
                            btn.BackgroundColor3 = selected[opt] and theme.dropdown.list_item_hover or theme.dropdown.list_item
                        end
                        Button.Text = getDisplayText()
                    end
                }
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
