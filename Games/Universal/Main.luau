local Services = setmetatable({}, {
    __index = function(self, Name)
        if Wince.Environment.cloneref then
            return Wince.Environment.cloneref(game:GetService(Name))
        else
            return game:GetService(Name)
        end
    end
})

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function(Response)
    local Success, Result = pcall(function()
        toclipboard("https://t.me/w1ncexx")
    end)
    if not Success then
        Services.LocalPlayer:Kick("Failed to copy link.\nhttps://t.me/w1ncexx")
    end
end

Services.StarterGui:SetCore("SendNotification", {
    Title = "Wince Hub",
    Text = "Only DOORS is supported right now, sorry :)",
    Duration = 10,
    Button1 = "Copy Telegram Link",
    Callback = Bindable,
})
