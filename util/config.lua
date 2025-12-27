-- Spectrum UI Library
-- Config persistence system

local HttpService = game:GetService("HttpService")

local Config = {}

local function encode(data)
    local success, result = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    return success and result or nil
end

local function decode(str)
    local success, result = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    return success and result or nil
end

function Config.save(name, data, folder)
    if not writefile then return false, "writefile not available" end
    
    folder = folder or "spectrum_configs"
    local path = folder .. "/" .. name .. ".json"
    
    local json = encode(data)
    if not json then return false, "Failed to encode" end
    
    local success, err = pcall(function()
        if not isfolder(folder) then
            makefolder(folder)
        end
        writefile(path, json)
    end)
    
    return success, err
end

function Config.load(name, folder)
    if not readfile or not isfile then return nil, "readfile not available" end
    
    folder = folder or "spectrum_configs"
    local path = folder .. "/" .. name .. ".json"
    
    if not isfile(path) then
        return nil, "Config not found"
    end
    
    local success, result = pcall(function()
        local content = readfile(path)
        return decode(content)
    end)
    
    if success then
        return result, nil
    else
        return nil, result
    end
end

function Config.delete(name, folder)
    if not delfile then return false end
    
    folder = folder or "spectrum_configs"
    local path = folder .. "/" .. name .. ".json"
    
    pcall(function()
        delfile(path)
    end)
    return true
end

function Config.list(folder)
    if not listfiles then return {} end
    
    folder = folder or "spectrum_configs"
    local files = {}
    
    pcall(function()
        if isfolder(folder) then
            for _, path in ipairs(listfiles(folder)) do
                local name = path:match("([^/\\]+)%.json$")
                if name then
                    table.insert(files, name)
                end
            end
        end
    end)
    
    return files
end

return Config
