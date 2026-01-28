-- Spectrum UI Library
-- Aimware Theme (classic style - sharp, minimal, yellow accent)

return {
    name = "aimware",
    
    fonts = {
        title = Enum.Font.SourceSans,
        label = Enum.Font.SourceSans,
        value = Enum.Font.Code,
        header = Enum.Font.SourceSansBold,
    },
    
    sizes = {
        title = 14,
        label = 13,
        value = 11,
        header = 13,
        corner = 0,
        corner_groupbox = 0,
    },
    
    window = {
        background = Color3.fromRGB(12, 12, 12),
        border = Color3.fromRGB(0, 0, 0),
        border_thickness = 1,
        titlebar = Color3.fromRGB(20, 20, 20),
        title_text = Color3.fromRGB(255, 200, 0),
        watermark = Color3.fromRGB(80, 80, 80),
        content = Color3.fromRGB(16, 16, 16),
    },
    
    tab = {
        background = Color3.fromRGB(22, 22, 22),
        inactive = Color3.fromRGB(140, 140, 140),
        hover = Color3.fromRGB(200, 200, 200),
        active = Color3.fromRGB(255, 200, 0),
    },
    
    groupbox = {
        background = Color3.fromRGB(18, 18, 18),
        header = Color3.fromRGB(24, 24, 24),
        border = Color3.fromRGB(50, 50, 50),
    },
    
    toggle = {
        background = Color3.fromRGB(30, 30, 30),
        border_off = Color3.fromRGB(70, 70, 70),
        label_on = Color3.fromRGB(255, 255, 255),
        label_off = Color3.fromRGB(160, 160, 160),
    },
    
    button = {
        background = Color3.fromRGB(28, 28, 28),
        background_hover = Color3.fromRGB(40, 40, 40),
        background_click = Color3.fromRGB(55, 55, 55),
        text = Color3.fromRGB(200, 200, 200),
        text_hover = Color3.fromRGB(255, 200, 0),
    },
    
    slider = {
        track = Color3.fromRGB(35, 35, 35),
        handle = Color3.fromRGB(255, 200, 0),
        label = Color3.fromRGB(200, 200, 200),
        value = Color3.fromRGB(255, 200, 0),
    },
    
    dropdown = {
        background = Color3.fromRGB(28, 28, 28),
        text = Color3.fromRGB(180, 180, 180),
        list_bg = Color3.fromRGB(20, 20, 20),
        list_item = Color3.fromRGB(30, 30, 30),
        list_item_hover = Color3.fromRGB(45, 45, 45),
        list_text = Color3.fromRGB(190, 190, 190),
        border = Color3.fromRGB(50, 50, 50),
    },
    
    textbox = {
        background = Color3.fromRGB(24, 24, 24),
        border = Color3.fromRGB(50, 50, 50),
        text = Color3.fromRGB(220, 220, 220),
        placeholder = Color3.fromRGB(100, 100, 100),
        label = Color3.fromRGB(200, 200, 200),
    },
    
    keybind = {
        background = Color3.fromRGB(30, 30, 30),
        text = Color3.fromRGB(180, 180, 180),
        label = Color3.fromRGB(200, 200, 200),
    },
    
    -- CS:GO-style tab icons (matches inline theme in main library)
    icons = {
        Parry = "rbxassetid://10723415903",
        Players = "rbxassetid://10723434557",
        Visuals = "rbxassetid://10723396593",
        Outfit = "rbxassetid://10723346960",
        Settings = "rbxassetid://10734950309",
    },
    
    scrollbar = Color3.fromRGB(60, 60, 60),
    close_hover = Color3.fromRGB(255, 80, 80),
}
