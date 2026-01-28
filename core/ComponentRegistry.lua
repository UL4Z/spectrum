-- Spectrum UI Library
-- ComponentRegistry.lua
-- Central registry / factory for Spectrum components
-- Author: @gr6wl

local Registry = {}
Registry.__index = Registry

function Registry.new()
    local self = setmetatable({}, Registry)
    self.Components = {}
    return self
end

function Registry:Register(name, constructor)
    self.Components[name] = constructor
end

function Registry:Get(name)
    return self.Components[name]
end

return Registry

