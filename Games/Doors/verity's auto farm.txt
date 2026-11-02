if _G.loaddededdijoepfiuewjpfiuewpjiofwe then return else _G.loaddededdijoepfiuewjpfiuewpjiofwe = "ofpewofew" end

local Properties = {
	ui = {
		Name = "IndexellUselessCandyFarm",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 10000,
		Parent = cloneref(game:GetService("CoreGui"))
	},
	button = {
		Name = "Button that buttons the button",
		BackgroundColor3 = Color3.fromRGB(255, 106, 0),
		Position = UDim2.new(0.127, 0,0.671, 0),
		Size = UDim2.new(0.137, 0,0.078, 0),
		AnchorPoint = Vector2.new(0.5,0.5),
		Text = "Waiting..",
		TextColor3 = Color3.fromRGB(255, 170, 0),
		TextScaled = true,
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
	},
	ratio = {
		AspectRatio = 3.674
	}
}

local InfoMSG = Instance.new("Hint",workspace)

InfoMSG.Text = "Loading Candy Farm.."

local function useProperties(d,v)
	local Info = Properties[v]
	if Info then
		for i,b in pairs(Info) do
			d[i] = b
		end
	end
end

local UI = Instance.new("ScreenGui")
local Button = Instance.new("TextButton",UI)
local ratiothing = Instance.new("UIAspectRatioConstraint",Button)

useProperties(UI,"ui")
useProperties(Button,"button")
useProperties(ratiothing,"ratio")

local Enabled = false
local CandyTotalValue = 0
local Status = "Reach door 2 first"

local Temp = Instance.new("ProximityPrompt")
local success, result = pcall(function()
	return fireproximityprompt(Temp)
end)
Temp:Destroy()

if not success then
	UI:Destroy()
	InfoMSG.Text = identifyexecutor().." does not support 'fireproximityprompt'!"
	warn("Failed to load Candy Farm (fireproximityprompt not supported):",result)
	game.Debris:AddItem(InfoMSG,3.5)
	return
end

game.ReplicatedStorage.RemotesFolder.EngageMinigame.OnClientEvent:Connect(function(v,v2,v3)
	if v == "HalloweenPerkTerminal" and v3 and v3.Token and Enabled then
		local Remote = v2.TerminalRemote
		local ElTable = Remote:InvokeServer("Fetch")
		Remote:InvokeServer("Ping")
		Remote:InvokeServer("Submit",3)
		game.ReplicatedStorage.RemotesFolder.MinigameControl:FireServer(v3.Token)
		Remote:InvokeServer("Release")
	end
end)

task.spawn(function()
	while task.wait() do
		InfoMSG.Text = "CandyFarm | Val: "..tostring(CandyTotalValue).." | S: "..Status.." | room: "..tostring(game.Players.LocalPlayer:GetAttribute("CurrentRoom"))
	end
end)

repeat task.wait() until game.Players.LocalPlayer:GetAttribute("CurrentRoom") == 2

Status = "none"
Button.Text = "Farm: off"

local function initiateFarm()
	Enabled = not Enabled
	Status = "none"
	
	Button.Text = "Farm: "..(Enabled and "on" or "off")
	
	if Enabled then
		local dontbring = false
		task.spawn(function()
			while Enabled do
				local found = 0
				for _, d in pairs(workspace.Drops:GetChildren()) do
					if d:GetAttribute("PlayerName") == game.Players.LocalPlayer.Name and d:GetAttribute("SalvageWeight") then
						if not dontbring then
							d:PivotTo(game.Players.LocalPlayer.Character:GetPivot())
						end
						found += d:GetAttribute("Value")
					end
				end
				CandyTotalValue = found
				game.ReplicatedStorage.RemotesFolder.Crouch:FireServer(false,true) --super secret remote
				task.wait()
			end
			CandyTotalValue = 0
		end)
		task.spawn(function()
			while Enabled do
				Status = "searching"
				local Room = workspace.CurrentRooms:FindFirstChild(tostring(game.Players.LocalPlayer:GetAttribute("CurrentRoom")))
				if not Room then
					task.wait()
					continue
				end
				if Room.Name == "0" then
					repeat
						task.wait()
					until workspace.CurrentRooms["1"].Assets.ManorCutsceneStuff.SFX.Playing
					repeat
						task.wait()
						game:GetService("ReplicatedStorage"):WaitForChild("FloorReplicated"):WaitForChild("ClientRemote"):WaitForChild("SkipCutscene"):WaitForChild("Remote"):FireServer(1,true)
					until not workspace.CurrentRooms["1"].Assets.ManorCutsceneStuff.SFX.Playing
				end
				if Room:FindFirstChild("SalvageItems") then
					local Items = Room:FindFirstChild("SalvageItems")
					if #Items:GetChildren() > 0 then
						Status = "getting items"
						for _, d in pairs(Items:GetChildren()) do
							repeat
								game.Players.LocalPlayer.Character:PivotTo(d.Main.CFrame)
								fireproximityprompt(d.ModulePrompt)
								task.wait()
							until not d.Parent or not d or not Enabled
							for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								if v:GetAttribute("SalvageWeight") then
									game.ReplicatedStorage.RemotesFolder.DropItem:FireServer(v)
								end
							end
							for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
								if v:GetAttribute("SalvageWeight") then
									game.ReplicatedStorage.RemotesFolder.DropItem:FireServer(v)
								end
							end
						end
						local Cauldron = Room:FindFirstChild("DepotHalloween",true)
						if not Cauldron and Room.Name == "51" then
							Cauldron = Room.Assets.GiantScrapper
						end
						dontbring = true
						while task.wait(1) do
							local found = 0
							--game.Players.LocalPlayer.Character:PivotTo(Cauldron.Base.CFrame+Vector3.new(0,6,0))
							for _, d in pairs(workspace.Drops:GetChildren()) do
								if d:GetAttribute("PlayerName") == game.Players.LocalPlayer.Name and d:GetAttribute("SalvageWeight") then
									if Cauldron.Name == "GiantScrapper" then
										d:PivotTo(Cauldron:WaitForChild("Liquid").CFrame+Vector3.new(0,4,0))
									else
										d:PivotTo(Cauldron:WaitForChild("Base").CFrame+Vector3.new(0,6,0))
									end
									found += 1
								end
							end
							Status = "selling/grinding items"
							if found == 0 or not Enabled then
								Status = "searching"
								break
							end
						end
						dontbring = false
					end
				end
				if Room:FindFirstChild("HalloweenTerminal",true) and not Room:FindFirstChild("HalloweenTerminal",true):GetAttribute("ok") then
					local Terminal = Room:FindFirstChild("HalloweenTerminal",true)
					Status = "doing terminal"
					repeat
						game.Players.LocalPlayer.Character:PivotTo(Terminal.PrimaryPart.CFrame)
						fireproximityprompt(Terminal.Attachment.ActivateEventPrompt)
						task.wait()
					until game.Players.LocalPlayer.Character:GetAttribute("InMinigame") == "HalloweenPerkTerminal"
					Room:FindFirstChild("HalloweenTerminal",true):SetAttribute("ok",true)
					Status = "searching"
				end
				game.Players.LocalPlayer.Character:PivotTo(Room.Door:WaitForChild("Door").CFrame)
				if Room >= 50 then
					UI:Destroy()
					Enabled = false
					Status = "none"
					break
				end
				task.wait()
			end
		end)
	end
end

Button.MouseButton1Up:Connect(function()
	initiateFarm()
end)
