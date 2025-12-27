-- Spectrum UI Library
-- Key validation system

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Key = {}

local function getHWID()
    local hwid = nil
    pcall(function()
        hwid = RbxAnalyticsService:GetClientId()
    end)
    if not hwid then
        pcall(function()
            hwid = game:GetService("Players").LocalPlayer.UserId
        end)
    end
    return hwid or "unknown"
end

local function hashKey(key)
    local hash = 0
    for i = 1, #key do
        hash = (hash * 31 + string.byte(key, i)) % 2147483647
    end
    return tostring(hash)
end

function Key.validate(key, options)
    options = options or {}
    
    if not key or key == "" then
        return false, "No key provided"
    end
    
    if options.whitelist then
        local found = false
        for _, valid in ipairs(options.whitelist) do
            if key == valid then
                found = true
                break
            end
        end
        if not found then
            return false, "Invalid key"
        end
    end
    
    if options.blacklist then
        for _, blocked in ipairs(options.blacklist) do
            if key == blocked then
                return false, "Key is blacklisted"
            end
        end
    end
    
    if options.hwid then
        local hwid = getHWID()
        if options.hwidList and options.hwidList[key] then
            if options.hwidList[key] ~= hwid then
                return false, "HWID mismatch"
            end
        end
    end
    
    if options.webhook then
        pcall(function()
            local data = {
                content = nil,
                embeds = {{
                    title = "Key Validation",
                    description = "Key: `" .. key .. "`\nHWID: `" .. getHWID() .. "`\nGame: " .. game.PlaceId,
                    color = 0x00FF00,
                }}
            }
            local encoded = HttpService:JSONEncode(data)
            local req = (syn and syn.request) or (http and http.request) or request
            if req then
                req({
                    Url = options.webhook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = encoded
                })
            end
        end)
    end
    
    return true, "Valid"
end

function Key.getHWID()
    return getHWID()
end

function Key.hash(input)
    return hashKey(input)
end

return Key
