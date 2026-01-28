-- Spectrum UI Library
-- Components/Groupbox.lua
-- Container component for grouping elements
-- Author: @gr6wl

local Groupbox = {}

function Groupbox.new(lib, parent, config)
    config = config or {}
    local title = config.Name or config.Title or "Group"
    
    local theme = lib.theme
    local accent = lib.accent
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 0)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundColor3 = theme.groupbox.background
    lib:_registerTheme(Container, "BackgroundColor3", "groupbox", "background")
    Container.BorderSizePixel = 0
    Container.ZIndex = 10
    Container.Parent = parent
    
    local c = lib:_corner(Container, theme.sizes.corner_groupbox)
    lib:_registerTheme(c, "CornerRadius", "sizes", "corner_groupbox")
    
    local s = lib:_stroke(Container, theme.groupbox.border, 1)
    lib:_registerTheme(s, "Color", "groupbox", "border")
    
    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Padding = UDim.new(0, 0)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Parent = Container
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 24)
    Header.BackgroundColor3 = theme.groupbox.header
    lib:_registerTheme(Header, "BackgroundColor3", "groupbox", "header")
    Header.BorderSizePixel = 0
    Header.LayoutOrder = 1
    Header.ZIndex = 10
    Header.Parent = Container
    
    local ch = lib:_corner(Header, theme.sizes.corner_groupbox)
    lib:_registerTheme(ch, "CornerRadius", "sizes", "corner_groupbox")
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, -10, 1, 0)
    HeaderLabel.Position = UDim2.new(0, 8, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = title
    HeaderLabel.TextColor3 = accent
    HeaderLabel.Font = theme.fonts.header
    lib:_registerTheme(HeaderLabel, "Font", "fonts", "header")
    HeaderLabel.TextSize = theme.sizes.header
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
    
    local group = {}
    group._content = Content
    group._lib = lib
    
    -- Helper to create components via registry
    local function createComponent(type, config)
        if lib._componentRegistry then
            local ctor = lib._componentRegistry:Get(type)
            if ctor then
                return ctor(lib, Content, config)
            end
        end
        warn("[Spectrum] Missing component module: " .. type)
        return nil
    end

    function group:Toggle(text, default, callback, configKey)
        return createComponent("Toggle", {
            Name = text,
            Default = default,
            Callback = callback,
            ConfigKey = configKey
        })
    end
    
    function group:Button(text, callback)
        return createComponent("Button", {
            Name = text,
            Callback = callback
        })
    end
    
    function group:Slider(text, min, max, default, step, callback)
        return createComponent("Slider", {
            Name = text,
            Min = min,
            Max = max,
            Default = default,
            Step = step,
            Callback = callback
        })
    end
    
    function group:Dropdown(text, options, default, callback)
        return createComponent("Dropdown", {
            Name = text,
            Options = options,
            Default = default,
            Callback = callback
        })
    end
    
    function group:MultiSelect(text, options, defaults, callback)
        return createComponent("MultiSelect", {
            Name = text,
            Options = options,
            Defaults = defaults,
            Callback = callback
        })
    end
    
    function group:ColorPicker(text, default, callback)
        return createComponent("ColorPicker", {
            Name = text,
            Default = default,
            Callback = callback
        })
    end
    
    function group:Keybind(label, arg1, arg2)
        -- Support both signatures
        local config = { Label = label }
        if type(arg2) == "function" then
            config.DefaultKey = arg1
            config.Callback = arg2
        else
            config.ConfigTable = arg1
            config.ConfigKey = arg2
        end
        return createComponent("Keybind", config)
    end
    
    function group:TextBox(label, placeholder, callback)
        return createComponent("TextBox", {
            Label = label,
            Placeholder = placeholder,
            Callback = callback
        })
    end
    
    function group:Section(text)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(1, -10, 0, 18)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.ZIndex = 10
        SectionFrame.Parent = Content
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = accent
        Label.Font = theme.fonts.header -- Use header font for sections
        lib:_registerTheme(Label, "Font", "fonts", "header")
        Label.TextSize = theme.sizes.label
        lib:_registerTheme(Label, "TextSize", "sizes", "label")
        Label.TextXAlignment = Enum.TextXAlignment.Center -- Center aligned section
        Label.ZIndex = 11
        Label.Parent = SectionFrame
        lib:_registerAccent(Label, "TextColor3")
        
        -- Optional: Add lines on side? For now just text.
        return Label
    end

    function group:Label(text)
        -- Label is simple enough to inline or use component if it exists
        -- We'll inline it for now as it's not complex, or verify if Label.lua exists? 
        -- User didn't mention Label.lua. Re-using init.lua logic for Label.
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 18)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = theme.textbox.label
        lib:_registerTheme(Label, "TextColor3", "textbox", "label")
        Label.Font = theme.fonts.label
        lib:_registerTheme(Label, "Font", "fonts", "label")
        Label.TextSize = theme.sizes.label
        lib:_registerTheme(Label, "TextSize", "sizes", "label")
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 10
        Label.Parent = Content
        
        return Label
    end

    return group
end

return Groupbox
