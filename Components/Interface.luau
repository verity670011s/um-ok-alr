
local Library = (Abysall.UILibrary == "Linoria" and "LinoriaLib" or "Obsidian")

-- Obsidian Library
local BaseUrl = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"

-- YOUR REPOSITORY
local AbysallUrl = "https://raw.githubusercontent.com/verity670011s/um-ok-alr/refs/heads/main/"

local Interface = {
    Library = loadstring(game:HttpGet(BaseUrl .. "Library.lua"))(),
    SaveManager = loadstring(game:HttpGet(BaseUrl .. "addons/SaveManager.lua"))(),
    ThemeManager = loadstring(game:HttpGet(BaseUrl .. "addons/ThemeManager.lua"))(),

    ApplyInfoTab = loadstring(game:HttpGet(AbysallUrl .. "Components/InfoTab.luau"))(),
    ApplySettingsTab = loadstring(game:HttpGet(AbysallUrl .. "Components/SettingsTab.luau"))()
}

-- UI Appearance Settings
Interface.Appearance = {
    CornerRadius = 14,

    MainTransparency = 0.22,
    PanelTransparency = 0.28,
    ControlTransparency = 0.15,

    MainColor = Color3.fromRGB(43, 46, 53),
    PanelColor = Color3.fromRGB(65, 69, 78),
    ControlColor = Color3.fromRGB(83, 88, 98),

    OutlineColor = Color3.fromRGB(125, 130, 140)
}

-- Apply Grey Glass Appearance
function Interface.ApplyAppearance()
    local Library = Interface.Library
    local Window = Library.Window
    local Settings = Interface.Appearance

    if not Window or not Window.MainFrame then
        warn("[Wince Hub] Window not found")
        return
    end

    local MainFrame = Window.MainFrame

    -- Rounded corners
    Window:SetCornerRadius(Settings.CornerRadius)

    -- Main window
    MainFrame.BackgroundColor3 = Settings.MainColor
    MainFrame.BackgroundTransparency = Settings.MainTransparency

    -- Main window gradient
    local Gradient = MainFrame:FindFirstChild("WinceGlassGradient")

    if not Gradient then
        Gradient = Instance.new("UIGradient")
        Gradient.Name = "WinceGlassGradient"
        Gradient.Rotation = 90
        Gradient.Parent = MainFrame
    end

    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(83, 88, 98)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(39, 42, 49))
    })

    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 0.35)
    })

    -- Sidebar
    local Tabs = MainFrame:FindFirstChild("Tabs")

    if Tabs and Tabs:IsA("ScrollingFrame") then
        Tabs.BackgroundColor3 = Settings.PanelColor
        Tabs.BackgroundTransparency = Settings.PanelTransparency
    end

    -- Main content
    local Container = Library.WindowContainer

    if Container then
        Container.BackgroundColor3 = Settings.PanelColor
        Container.BackgroundTransparency = Settings.PanelTransparency
    end

    -- All internal panels and controls
    for _, Object in ipairs(MainFrame:GetDescendants()) do

        if Object:IsA("Frame") or Object:IsA("ScrollingFrame") then

            if Object.BackgroundTransparency < 1 then
                Object.BackgroundColor3 = Settings.PanelColor
                Object.BackgroundTransparency = Settings.PanelTransparency
            end

        elseif Object:IsA("TextBox") then

            Object.BackgroundColor3 = Settings.ControlColor
            Object.BackgroundTransparency = Settings.ControlTransparency

        elseif Object:IsA("TextButton") then

            if Object.BackgroundTransparency < 1 then
                Object.BackgroundColor3 = Settings.ControlColor
                Object.BackgroundTransparency = Settings.ControlTransparency
            end
        end

        -- Soft borders
        if Object:IsA("UIStroke") then
            Object.Color = Settings.OutlineColor
            Object.Transparency = 0.45
        end

        -- Rounded internal elements
        if Object:IsA("UICorner") then
            Object.CornerRadius = UDim.new(
                0,
                math.min(Settings.CornerRadius / 2, 8)
            )
        end
    end

    print("[Wince Hub] Grey Glass appearance applied")
end

-- Built-in themes
Interface.ThemeManager.BuiltInThemes = {
    ["Default"]        = { 1,  { FontColor = "ffffff", MainColor = "1c1c1c", AccentColor = "0055ff", BackgroundColor = "141414", OutlineColor = "323232" } },
    ["BBot"]           = { 2,  { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" } },
    ["Fatality"]       = { 3,  { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" } },
    ["Jester"]         = { 4,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
    ["Mint"]           = { 5,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
    ["Tokyo Night"]    = { 6,  { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" } },
    ["Ubuntu"]         = { 7,  { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" } },
    ["Quartz"]         = { 8,  { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" } },
    ["Nord"]           = { 9,  { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a" } },
    ["Dracula"]        = { 10, { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4" } },
    ["Monokai"]        = { 11, { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e" } },
    ["Gruvbox"]        = { 12, { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945" } },
    ["Solarized"]      = { 13, { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75" } },
    ["Catppuccin"]     = { 14, { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268" } },
    ["One Dark"]       = { 15, { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370" } },
    ["Cyberpunk"]      = { 16, { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e" } },
    ["Oceanic Next"]   = { 17, { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46" } },
    ["Material"]       = { 18, { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242" } },
}

return Interface
