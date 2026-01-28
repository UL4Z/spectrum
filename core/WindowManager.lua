-- Spectrum UI Library
-- WindowManager.lua
-- Creates and manages Spectrum windows (drag, header, content)
-- Author: @gr6wl

local WindowManager = {}
WindowManager.__index = WindowManager

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function createScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Spectrum_" .. tostring(math.random(100000, 999999))
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.ResetOnSpawn = false
    pcall(function()
        gui.Parent = CoreGui
    end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return gui
end

local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
end

function WindowManager.new(theme, accent, size, toggleKey)
    local self = setmetatable({}, WindowManager)

    self.Theme = theme
    self.Accent = accent
    self.Size = size or {610, 460}
    self.ToggleKey = toggleKey or Enum.KeyCode.Insert

    self.Gui = createScreenGui()
    self.Main = nil
    self.Mini = nil
    self.TabBar = nil
    self.Content = nil

    return self
end

function WindowManager:BuildWindow(title, tween, corner, stroke)
    local theme = self.Theme
    local accent = self.Accent

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, self.Size[1], 0, self.Size[2])
    main.Position = UDim2.new(0.5, -self.Size[1] / 2, 0.5, -self.Size[2] / 2)
    main.BackgroundColor3 = theme.window and theme.window.background or Color3.fromRGB(24, 24, 28)
    main.BorderSizePixel = 0
    main.ZIndex = 1
    main.Parent = self.Gui
    makeDraggable(main)

    if corner and theme.sizes and theme.sizes.corner then
        corner(main, theme.sizes.corner)
    end
    if stroke and theme.window and theme.window.border then
        stroke(main, theme.window.border, theme.window.border_thickness or 1)
    end

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 0, 0)
    accentLine.BackgroundColor3 = accent
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 10
    accentLine.Parent = main

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.Position = UDim2.new(0, 0, 0, 2)
    titleBar.BackgroundColor3 = theme.window and theme.window.titlebar or Color3.fromRGB(20, 20, 24)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = main

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = tostring(title or "spectrum")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = theme.window and theme.window.title_text or Color3.fromRGB(200, 200, 200)
    titleLabel.Font = theme.fonts and theme.fonts.title or Enum.Font.Gotham
    titleLabel.TextSize = theme.sizes and theme.sizes.title or 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -28, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 3
    closeBtn.Parent = titleBar

    closeBtn.MouseEnter:Connect(function()
        if theme.close_hover then
            closeBtn.TextColor3 = theme.close_hover
        end
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -10, 0, 26)
    tabBar.Position = UDim2.new(0, 5, 0, 32)
    tabBar.BackgroundColor3 = theme.tab and theme.tab.background or Color3.fromRGB(28, 28, 32)
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 2
    tabBar.Parent = main
    if corner and theme.sizes and theme.sizes.corner then
        corner(tabBar, theme.sizes.corner)
    end

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 2)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -10, 1, -65)
    contentArea.Position = UDim2.new(0, 5, 0, 60)
    contentArea.BackgroundColor3 = theme.window and theme.window.content or Color3.fromRGB(28, 28, 32)
    contentArea.BackgroundTransparency = 0
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 2
    contentArea.ClipsDescendants = true
    contentArea.Parent = main
    if corner and theme.sizes and theme.sizes.corner then
        corner(contentArea, theme.sizes.corner)
    end

    local watermark = Instance.new("TextLabel")
    watermark.Text = "spectrum | @gr6wl"
    watermark.Size = UDim2.new(0, 140, 0, 14)
    watermark.Position = UDim2.new(1, -145, 0, 4)
    watermark.BackgroundTransparency = 1
    watermark.TextColor3 = theme.window and theme.window.watermark or Color3.fromRGB(60, 60, 65)
    watermark.Font = Enum.Font.Code
    watermark.TextSize = 10
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.ZIndex = 3
    watermark.Parent = titleBar

    -- Mini button (iconified window)
    local mini = Instance.new("TextButton")
    mini.Name = "Mini"
    mini.Size = UDim2.new(0, 40, 0, 40)
    mini.Position = UDim2.new(0, 15, 0.5, -20)
    mini.BackgroundColor3 = theme.window and theme.window.background or Color3.fromRGB(24, 24, 28)
    mini.Text = "S"
    mini.TextColor3 = accent
    mini.Font = Enum.Font.Code
    mini.TextSize = 18
    mini.Visible = false
    mini.Active = true
    mini.Draggable = true
    mini.ZIndex = 50
    mini.Parent = self.Gui

    if corner and theme.sizes and theme.sizes.corner then
        corner(mini, theme.sizes.corner)
    end
    if stroke then
        stroke(mini, accent, 1)
    end

    mini.MouseButton1Click:Connect(function()
        mini.Visible = false
        main.Visible = true
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then
            return
        end
        if input.KeyCode == self.ToggleKey or input.KeyCode == Enum.KeyCode.RightShift then
            main.Visible = not main.Visible
            mini.Visible = not main.Visible
        end
    end)

    self.Main = main
    self.Mini = mini
    self.TabBar = tabBar
    self.Content = contentArea

    return main, tabBar, contentArea
end

function WindowManager:Destroy()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

return WindowManager

