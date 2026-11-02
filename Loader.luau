if getgenv().Abysall then
    return
end

getgenv().Abysall = {
    Legit = true
}

local GameList = {
    [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/verity670011s/um-ok-alr/refs/heads/main/"

local function LoadFile(Path)
    local Success, Result = pcall(function()
        local Source = game:HttpGet(BaseUrl .. Path)
        local Chunk = loadstring(Source)

        assert(Chunk, "loadstring failed: " .. Path)

        return Chunk()
    end)

    if not Success then
        error("[Wince Hub] " .. Path .. "\n" .. tostring(Result))
    end

    return Result
end

local Abysall = getgenv().Abysall

Abysall.Environment = LoadFile("Components/Environment.luau")
Abysall.ESPLibrary = LoadFile("Components/ESP.luau")

local function CloneReference(Object)
    if Abysall and Abysall.Environment and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

Abysall.Interface = LoadFile("Components/Interface.luau")
Abysall.Analytics = LoadFile("Components/Analytics.luau")

local CurrentGame = GameList[game.GameId]

if CurrentGame then
    LoadFile("Games/" .. CurrentGame .. "/Loader.luau")
else
    LoadFile("Games/Universal/Loader.luau")
end

Abysall.Loaded = true
