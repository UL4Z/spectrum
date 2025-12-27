# Spectrum

Multi-theme UI library for Roblox exploits.

## Themes
- **skeet** - Gamesense style
- **neverlose** - Neverlose 2024 style  
- **aimware** - Aimware classic style

## Usage

```lua
local Spectrum = loadstring(game:HttpGet("https://raw.githubusercontent.com/UL4Z/spectrum/main/init.lua"))()

local UI = Spectrum.new({
    title = "My Script",
    theme = "skeet",
    accent = Color3.fromRGB(200, 55, 55),
})

local Window = UI:Window()
local Tab = Window:Tab("Main")
local Group = Tab:Groupbox("Settings")

Group:Toggle("Enabled", true, function(v) 
    print("Enabled:", v) 
end)

Group:Slider("Speed", 0, 100, 50, 1, function(v)
    print("Speed:", v)
end)

Group:Dropdown("Mode", {"Option1", "Option2", "Option3"}, "Option1", function(v)
    print("Mode:", v)
end)

Group:Button("Click Me", function()
    print("Clicked")
end)

Group:TextBox("Name", "Enter name...", function(text, enter)
    print("Text:", text, "Enter:", enter)
end)

Group:Keybind("Toggle Key", Config, "ToggleKey")
```

## Key System

```lua
local valid, msg = Spectrum.Key.validate("USER-KEY-HERE", {
    whitelist = {"KEY1", "KEY2", "KEY3"},
    webhook = "https://discord.com/api/webhooks/...",
})

if not valid then
    return print("Invalid key:", msg)
end
```

## Config Persistence

```lua
Spectrum.Config.save("my_config", {enabled = true, speed = 50})
local data = Spectrum.Config.load("my_config")
```

## Components

| Component | Description |
|-----------|-------------|
| Toggle | Checkbox with label |
| Slider | Value slider with min/max/step |
| Dropdown | Select from options list |
| Button | Clickable action button |
| TextBox | Text input field |
| Keybind | Key capture button |
| Label | Static text |

## Theme Customization

```lua
local UI = Spectrum.new({
    theme = "neverlose",
    accent = Color3.fromRGB(100, 180, 255),
    toggleKey = Enum.KeyCode.RightControl,
})
```
