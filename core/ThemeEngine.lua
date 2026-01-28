-- Spectrum UI Library
-- ThemeEngine.lua
-- Centralized theming system for Spectrum UI
-- Author: @gr6wl

local ThemeEngine = {}
ThemeEngine.__index = ThemeEngine

local DEFAULT_THEME = {
    Colors = {
        Background      = Color3.fromRGB(45, 45, 45),
        DarkBackground  = Color3.fromRGB(35, 35, 35),
        Header          = Color3.fromRGB(55, 55, 55),

        AccentPrimary   = Color3.fromRGB(120, 255, 120),
        AccentDanger    = Color3.fromRGB(255, 120, 120),
        AccentWarning   = Color3.fromRGB(255, 255, 120),

        TextPrimary     = Color3.fromRGB(255, 255, 255),
        TextSecondary   = Color3.fromRGB(200, 200, 200),
        TextDisabled    = Color3.fromRGB(120, 120, 120),

        ButtonDefault   = Color3.fromRGB(60, 60, 60),
        ButtonHover     = Color3.fromRGB(70, 70, 70),
        CheckboxOn      = Color3.fromRGB(120, 255, 120),
        CheckboxOff     = Color3.fromRGB(50, 50, 50),
    },

    Fonts = {
        Primary = Enum.Font.Gotham,
        Mono    = Enum.Font.Code,
        Sizes = {
            Header = 16,
            Body   = 14,
            Small  = 12,
            Tiny   = 10,
        }
    },

    Layout = {
        WindowPadding  = 8,
        SectionPadding = 6,
        ItemSpacing    = 4,
        IndentWidth    = 20,

        ComponentHeight = {
            Toggle  = 24,
            Slider  = 28,
            Button  = 30,
            Header  = 32,
        },

        BorderRadius    = 4,
        BorderThickness = 1,
    }
}

function ThemeEngine.new()
    local self = setmetatable({}, ThemeEngine)
    self.Current = DEFAULT_THEME
    return self
end

function ThemeEngine:Get()
    return self.Current
end

function ThemeEngine:Set(themeTable)
    if type(themeTable) ~= "table" then return end
    self.Current = themeTable
end

return ThemeEngine

