local Env = getgenv()

if Env.Abysall and Env.Abysall.Loaded then
    return
end

local BaseUrl =
    "https://raw.githubusercontent.com/verity670011s/um-ok-alr/main/"

Env.Abysall = Env.Abysall or {}
local Abysall = Env.Abysall

Abysall.Legit = true

local function LoadFile(Path)
    local Url = BaseUrl .. Path

    local Success, Result = pcall(function()
        local Source = game:HttpGet(Url)
        local Chunk = loadstring(Source)

        assert(Chunk, "loadstring failed: " .. Path)

        return Chunk()
    end)

    if not Success then
        error("[Wince Hub] " .. Path .. "\n" .. tostring(Result))
    end

    return Result
end

local GameList = {
    [2440500124] = "Doors"
}

Abysall.Environment =
    Abysall.Environment or LoadFile("Components/Environment.luau")

Abysall.ESPLibrary =
    Abysall.ESPLibrary or LoadFile("Components/ESP.luau")

local function CloneReference(Object)
    if Abysall.Environment and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    end

    return Object
end

local Services = setmetatable({}, {
    __index = function(_, Name)
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
