-- Spectrum UI Library
-- Skeet Theme (Gamesense-style)

return {
    name = "skeet",
    
    fonts = {
        title = Enum.Font.Code,
        label = Enum.Font.Gotham,
        value = Enum.Font.Code,
        header = Enum.Font.GothamBold,
    },
    
    sizes = {
        title = 13,
        label = 11,
        value = 10,
        header = 11,
        corner = 2,
        corner_groupbox = 4,
    },
    
    window = {
        background = Color3.fromRGB(24, 24, 28),
        border = Color3.fromRGB(8, 8, 10),
        border_thickness = 2,
        titlebar = Color3.fromRGB(20, 20, 24),
        title_text = Color3.fromRGB(200, 200, 200),
        watermark = Color3.fromRGB(60, 60, 65),
        content = Color3.fromRGB(28, 28, 32),
    },
    
    tab = {
        background = Color3.fromRGB(28, 28, 32),
        inactive = Color3.fromRGB(120, 120, 125),
        hover = Color3.fromRGB(180, 180, 185),
        active = Color3.fromRGB(255, 255, 255),
    },
    
    groupbox = {
        background = Color3.fromRGB(22, 22, 28),
        header = Color3.fromRGB(28, 28, 35),
        border = Color3.fromRGB(40, 40, 50),
    },
    
    toggle = {
        background = Color3.fromRGB(35, 35, 42),
        border_off = Color3.fromRGB(60, 60, 70),
        label_on = Color3.fromRGB(220, 220, 220),
        label_off = Color3.fromRGB(150, 150, 155),
    },
    
    button = {
        background = Color3.fromRGB(32, 32, 38),
        background_hover = Color3.fromRGB(45, 45, 52),
        background_click = Color3.fromRGB(60, 60, 70),
        text = Color3.fromRGB(180, 180, 185),
        text_hover = Color3.fromRGB(220, 220, 225),
    },
    
    slider = {
        track = Color3.fromRGB(40, 40, 48),
        handle = Color3.fromRGB(220, 220, 225),
        label = Color3.fromRGB(180, 180, 185),
        value = Color3.fromRGB(140, 140, 150),
    },
    
    dropdown = {
        background = Color3.fromRGB(32, 32, 40),
        text = Color3.fromRGB(160, 160, 170),
        list_bg = Color3.fromRGB(28, 28, 35),
        list_item = Color3.fromRGB(35, 35, 42),
        list_item_hover = Color3.fromRGB(50, 50, 60),
        list_text = Color3.fromRGB(170, 170, 180),
        border = Color3.fromRGB(50, 50, 60),
    },
    
    textbox = {
        background = Color3.fromRGB(28, 28, 34),
        border = Color3.fromRGB(50, 50, 60),
        text = Color3.fromRGB(200, 200, 205),
        placeholder = Color3.fromRGB(80, 80, 90),
        label = Color3.fromRGB(180, 180, 185),
    },
    
    keybind = {
        background = Color3.fromRGB(35, 35, 42),
        text = Color3.fromRGB(150, 150, 160),
        label = Color3.fromRGB(180, 180, 185),
    },
    
    -- CS:GO‑style icons for tab layout (Gamesense‑like)
    icons = {
        Parry = "rbxassetid://10723415903",
        Players = "rbxassetid://10723434557",
        Visuals = "rbxassetid://10723396593",
        Outfit = "rbxassetid://10723346960",
        Settings = "rbxassetid://10734950309",
    },
    
    scrollbar = Color3.fromRGB(60, 60, 70),
    close_hover = Color3.fromRGB(255, 100, 100),
}
