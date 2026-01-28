-- Spectrum UI Library
-- Components/Keybind.lua
-- Keybind capture component (supports callback mode + config storage mode)
-- Author: @gr6wl

local UserInputService = game:GetService("UserInputService")

local Keybind = {}

function Keybind.new(lib, parent, config)
    config = config or {}

    local label = config.Name or config.Label or "Keybind"
    local callback = config.Callback

    -- Two modes:
    -- 1) Callback mode: DefaultKey + Callback
    -- 2) Config mode: ConfigTable + ConfigKey (writes KeyCode into table)
    local isCallbackMode = false
    local defaultKey = config.DefaultKey
    local configTable = config.ConfigTable
    local configKey = config.ConfigKey

    if callback ~= nil then
        isCallbackMode = true
    end

    local theme = lib.theme
    local accent = lib.accent

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 10
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = theme.keybind.label
    lib:_registerTheme(Label, "TextColor3", "keybind", "label")
    Label.Font = theme.fonts.label
    lib:_registerTheme(Label, "Font", "fonts", "label")
    Label.TextSize = theme.sizes.label
    lib:_registerTheme(Label, "TextSize", "sizes", "label")
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Frame

    local currentKey
    if isCallbackMode then
        currentKey = defaultKey
    else
        currentKey = configTable and configTable[configKey] or nil
    end

    local keyName = currentKey and currentKey.Name or "None"

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0.45, 0, 0, 22)
    KeyBtn.Position = UDim2.new(0.55, 0, 0.5, -11)
    KeyBtn.BackgroundColor3 = theme.keybind.background
    lib:_registerTheme(KeyBtn, "BackgroundColor3", "keybind", "background")
    KeyBtn.Text = "[" .. keyName .. "]"
    KeyBtn.TextColor3 = theme.keybind.text
    lib:_registerTheme(KeyBtn, "TextColor3", "keybind", "text")
    KeyBtn.Font = theme.fonts.value
    lib:_registerTheme(KeyBtn, "Font", "fonts", "value")
    KeyBtn.TextSize = theme.sizes.value
    lib:_registerTheme(KeyBtn, "TextSize", "sizes", "value")
    KeyBtn.AutoButtonColor = false
    KeyBtn.ZIndex = 11
    KeyBtn.Parent = Frame

    lib:_corner(KeyBtn, 3)

    local listening = false
    local conn
    local keyCode = currentKey

    local function stopListening()
        if conn then
            conn:Disconnect()
            conn = nil
        end
        listening = false
        KeyBtn.Text = "[" .. (keyCode and keyCode.Name or "None") .. "]"
        KeyBtn.TextColor3 = lib.theme.keybind.text
    end

    KeyBtn.MouseButton1Click:Connect(function()
        if listening then
            stopListening()
            return
        end

        listening = true
        KeyBtn.Text = "[...]"
        KeyBtn.TextColor3 = accent

        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keyCode = input.KeyCode

                if isCallbackMode then
                    -- Keep keyCode local, callback fires on global listener below.
                else
                    if configTable and configKey then
                        configTable[configKey] = input.KeyCode
                    end
                end

                stopListening()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                stopListening()
            end
        end)
    end)

    -- Global listener only for callback mode
    local globalConn
    if isCallbackMode and callback then
        globalConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then
                return
            end
            if not keyCode then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
                callback()
            end
        end)
    end

    KeyBtn.MouseLeave:Connect(function()
        if listening then
            task.delay(0.5, function()
                if listening then
                    stopListening()
                end
            end)
        end
    end)

    Frame.AncestryChanged:Connect(function()
        if not Frame:IsDescendantOf(game) then
            stopListening()
            if globalConn then
                globalConn:Disconnect()
                globalConn = nil
            end
        end
    end)

    return Frame
end

return Keybind

