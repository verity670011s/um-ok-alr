-- Components/SettingsTab.luau
return function(Window)
	local function CloneReference(Object)
		if Abysall and Abysall.Environment.cloneref then
			return Abysall.Environment.cloneref(Object)
		else
			return Object
		end
	end

	local Services = setmetatable({}, {
		__index = function(_, Name)
			return CloneReference(game:GetService(Name))
		end
	})

	local Library      = Abysall.Interface.Library
	local SaveManager  = Abysall.Interface.SaveManager
	local ThemeManager = Abysall.Interface.ThemeManager

	local Options = Library.Options

	-- Защита Anti-Steal удалена. Теперь название может быть любым.

	-- ─── Создание вкладки Settings ─────────────────────────────────────────
	local SettingsTab = Window:AddTab("Settings", "settings")
	local MenuGroup   = SettingsTab:AddLeftGroupbox("Menu")

	MenuGroup:AddToggle("KeybindMenuOpen", {
		Default  = Library.KeybindFrame.Visible,
		Text     = "Open Keybind Menu",
		Callback = function(value)
			Library.KeybindFrame.Visible = value
		end
	})

	MenuGroup:AddToggle("ShowCustomCursor", {
		Text     = "Custom Cursor",
		Default  = false,
		Callback = function(value)
			Library.ShowCustomCursor = value
		end
	})

	MenuGroup:AddToggle("QueueOnTeleport", {
		Text     = "Queue On Teleport",
		Default  = false,
		Tooltip  = "Automatically reloads Wince Hub when you teleport to another server.",
		Callback = function(value)
			if not value then return end
			if queue_on_teleport then
				queue_on_teleport([[
					loadstring(game:HttpGet("https://raw.githubusercontent.com/verity670011s/um-ok-alr/main/Loader.luau"))()
				]])
			end
		end
	})

	MenuGroup:AddDropdown("UILibrary", {
		Text     = "UI Style",
		Values   = { "Obsidian", "Linoria" },
		Default  = (Abysall.UILibrary == "Linoria") and 2 or 1,
		Callback = function(value)
			if not (Abysall.Environment.writefile and Abysall.Environment.readfile) then
				return
			end

			local path = "Abysall/UserData.json"

			if not Abysall.Environment.isfile(path) then
				Abysall.Environment.writefile(path, Services.HttpService:JSONEncode({
					TotalExecutions = 0,
					UILibrary      = "Obsidian",
				}))
			end

			local raw  = Abysall.Environment.readfile(path)
			local data = Services.HttpService:JSONDecode(raw)

			data.UILibrary = value
			if not data.UILibrary then
				data.UILibrary = "Obsidian"
			end

			Abysall.TotalExecutions = data.TotalExecutions
			Abysall.UILibrary       = data.UILibrary

			Abysall.Environment.writefile(path, Services.HttpService:JSONEncode(data))
		end
	})

	MenuGroup:AddDropdown("DPIDropdown", {
		Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
		Default  = "100%",
		Text     = "DPI Scale",
		Callback = function(value)
			value = value:gsub("%%", "")
			Library:SetDPIScale(tonumber(value))
		end
	})

	MenuGroup:AddDivider()

	MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
		Default = "RightShift",
		NoUI    = true,
		Text    = "Menu keybind",
	})

	MenuGroup:AddButton("Copy Telegram Link", function()
		toclipboard("https://t.me/w1ncexx")
		Library:Notify("Telegram link copied.")
	end)

	MenuGroup:AddButton("Unload", function()
		Library:Unload()
	end)

	-- ─── Привязка менеджеров ───────────────────────────────────────────────
	Library.ToggleKeybind = Options.MenuKeybind

	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({ "UILibrary" })
	ThemeManager:SetFolder("Abysall")
	SaveManager:SetFolder("Abysall/" .. Abysall.SavePath)
	SaveManager:BuildConfigSection(SettingsTab)
	SaveManager:LoadAutoloadConfig()

	-- ─── Сезонная тема ─────────────────────────────────────────────────────
	local currentMonth = os.date("*t").month
	local seasonalTheme = ({
		[1]  = "Nya~!",
		[2]  = "Valentines",
		[3]  = "St. Patrick's Day",
		[4]  = "Easter",
		[10] = "Spooky Scary Skeletons",
		[11] = "Thanksgiving",
		[12] = "Christmas",
	})[currentMonth]

	if seasonalTheme then
		local ok, err = ThemeManager:ApplyTheme(seasonalTheme)
		if not ok then
			Library:Notify({
				Title       = "Seasonal Theme",
				Description = "Failed to apply " .. seasonalTheme .. ": " .. tostring(err),
				Time        = 5,
			})
		end
	end

	ThemeManager:ApplyToTab(SettingsTab)
end
