-- Spectrum UI Library
-- Components/Button.lua
-- Advanced button component
-- Author: @gr6wl

local Button = {}

function Button.new(lib, parent, config)
    config = config or {}

    local text     = config.Name or config.Text or "Button"
    local callback = config.Callback

    local theme = lib.theme

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 24)
    Btn.BackgroundColor3 = theme.button.background
    lib:_registerTheme(Btn, "BackgroundColor3", "button", "background")
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = theme.button.text
    lib:_registerTheme(Btn, "TextColor3", "button", "text")
    Btn.Font = theme.fonts.label
    lib:_registerTheme(Btn, "Font", "fonts", "label")
    Btn.TextSize = theme.sizes.label
    lib:_registerTheme(Btn, "TextSize", "sizes", "label")
    Btn.AutoButtonColor = false
    Btn.ZIndex = 10
    Btn.Parent = parent

    lib:_corner(Btn, 2)

    Btn.MouseEnter:Connect(function()
        lib:_safeTween(Btn, {
            BackgroundColor3 = theme.button.background_hover,
            TextColor3 = theme.button.text_hover,
        })
    end)

    Btn.MouseLeave:Connect(function()
        lib:_safeTween(Btn, {
            BackgroundColor3 = theme.button.background,
            TextColor3 = theme.button.text,
        })
    end)

    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = theme.button.background_click
        task.delay(0.1, function()
            lib:_safeTween(Btn, {BackgroundColor3 = theme.button.background}, 0.2)
        end)
        if callback then
            callback()
        end
    end)

    return Btn
end

return Button

