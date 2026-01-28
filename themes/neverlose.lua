-- Spectrum UI Library
-- Neverlose Theme (2024 style - glassmorphism, rounded, modern)

return {
    name = "neverlose",
    
    fonts = {
        title = Enum.Font.GothamBold,
        label = Enum.Font.Gotham,
        value = Enum.Font.Gotham,
        header = Enum.Font.GothamBold,
    },
    
    sizes = {
        title = 14,
        label = 12,
        value = 11,
        header = 12,
        corner = 8,
        corner_groupbox = 10,
    },
    
    window = {
        background = Color3.fromRGB(18, 18, 24),
        border = Color3.fromRGB(45, 45, 60),
        border_thickness = 1,
        titlebar = Color3.fromRGB(22, 22, 30),
        title_text = Color3.fromRGB(235, 235, 240),
        watermark = Color3.fromRGB(100, 100, 115),
        content = Color3.fromRGB(20, 20, 28),
    },
    
    tab = {
        background = Color3.fromRGB(25, 25, 32),
        inactive = Color3.fromRGB(130, 130, 145),
        hover = Color3.fromRGB(200, 200, 210),
        active = Color3.fromRGB(255, 255, 255),
    },
    
    groupbox = {
        background = Color3.fromRGB(24, 24, 32),
        header = Color3.fromRGB(28, 28, 38),
        border = Color3.fromRGB(50, 50, 65),
    },
    
    toggle = {
        background = Color3.fromRGB(32, 32, 42),
        border_off = Color3.fromRGB(70, 70, 85),
        label_on = Color3.fromRGB(240, 240, 245),
        label_off = Color3.fromRGB(140, 140, 155),
    },
    
    button = {
        background = Color3.fromRGB(35, 35, 48),
        background_hover = Color3.fromRGB(50, 50, 65),
        background_click = Color3.fromRGB(65, 65, 85),
        text = Color3.fromRGB(200, 200, 210),
        text_hover = Color3.fromRGB(240, 240, 245),
    },
    
    slider = {
        track = Color3.fromRGB(40, 40, 55),
        handle = Color3.fromRGB(255, 255, 255),
        label = Color3.fromRGB(200, 200, 210),
        value = Color3.fromRGB(160, 160, 175),
    },
    
    dropdown = {
        background = Color3.fromRGB(32, 32, 45),
        text = Color3.fromRGB(180, 180, 195),
        list_bg = Color3.fromRGB(26, 26, 38),
        list_item = Color3.fromRGB(35, 35, 48),
        list_item_hover = Color3.fromRGB(55, 55, 72),
        list_text = Color3.fromRGB(190, 190, 205),
        border = Color3.fromRGB(55, 55, 72),
    },
    
    textbox = {
        background = Color3.fromRGB(28, 28, 40),
        border = Color3.fromRGB(55, 55, 72),
        text = Color3.fromRGB(220, 220, 230),
        placeholder = Color3.fromRGB(90, 90, 105),
        label = Color3.fromRGB(200, 200, 210),
    },
    
    keybind = {
        background = Color3.fromRGB(35, 35, 48),
        text = Color3.fromRGB(170, 170, 185),
        label = Color3.fromRGB(200, 200, 210),
    },
    
    -- CS:GO-style icons & sounds (Neverlose‑inspired)
    icons = {
        Parry = "rbxassetid://6022668955",   -- Lua/Code icon (Rage/Script)
        Players = "rbxassetid://6035181869", -- Chat icon (Players/Social)
        Visuals = "rbxassetid://6031154871", -- Search/Inspect (Visuals)
        Outfit = "rbxassetid://6035067857",  -- Save icon (Configs/Outfits)
        Settings = "rbxassetid://6031280882" -- Gear icon (Settings)
    },
    
    sounds = {
        Hover = "rbxassetid://10066931761",
        Click = "rbxassetid://6895079853",
        Popup = "rbxassetid://225320558",
    },
    
    scrollbar = Color3.fromRGB(70, 70, 90),
    close_hover = Color3.fromRGB(255, 90, 90),
}
