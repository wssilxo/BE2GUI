local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Blood Engine 2 GUI",
	LoadingTitle = "Blood Engine 2 GUI",
	LoadingSubtitle = "",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "BE2GUI"
	},
	Discord = {
		Enabled = false,
		Invite = "",
		RememberJoins = true
	},
	KeySystem = true,
	KeySettings = {
		Title = "Key",
		Subtitle = "Enter key:",
		Note = "Don't forget to be happy!",
		FileName = "BE2GUIKey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = "BE2GUI"
	}
})

Rayfield:Notify({
	Title = "Blood Engine 2 GUI",
	Content = "Welcome!",
	Duration = 2,
	Image = nil,
})

local Exploits = Window:CreateTab("Exploits") -- Title, Image
local Visuals = Window:CreateTab("Visuals")
local Misc = Window:CreateTab("Misc")

-- EXPLOITS
local HitboxExpander = Exploits:CreateSection("Hitbox Expander")
local EnableHE = Exploits:CreateButton({
	Name = "Enable",
	Callback = function()
		local plr = game:GetService("Players").LocalPlayer
		local run = game:GetService("RunService")

		getgenv().t = 0.77
		getgenv().size = 5

		local hit
		hit = hookmetamethod(game,'__index', function(a,b)
			if not checkcaller() and a == 'Head' and tostring(b) == 'Size' then
				return Vector3.new(2, 2, 1)
			elseif not checkcaller() and a == 'Head' and tostring(b) == 'Transparency' then
				return 1
			end
			return hit(a,b)
		end)


		run.RenderStepped:Connect(function()
			for i,v in pairs(game.Players:GetPlayers()) do 
				if v.Name ~= plr.Name  then
					v.Character['Head'].Size = Vector3.new(size,size,size)
					v.Character['Head'].Transparency = t
					v.Character['Head'].CanCollide = false
				end
			end
		end)
	end,
})

local SpeedHack = Exploits:CreateSection("Speed Hack")
local Speed = Exploits:CreateSlider({
	Name = "Speed Changer",
	Range = {16, 100},
	Increment = 1,
	Suffix = "Speed Hack Changer",
	CurrentValue = 16,
	Flag = "Slider2",
	Callback = function(Value)
		game.Workspace.Characters.Players[game.Players.LocalPlayer.Name..""].Humanoid.WalkSpeed = Value
	end,
})

-- VISUALS
local ESP = Visuals:CreateSection("ESP")

local ESPEnabled = false
local TracersEnabled = false

pcall(function()

	Camera = game:GetService("Workspace").CurrentCamera
	RunService = game:GetService("RunService")
	camera = workspace.CurrentCamera
	Bottom = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)

	function GetPoint(vector3)
		local vector, onScreen = camera:WorldToScreenPoint(vector3)
		return {Vector2.new(vector.X,vector.Y),onScreen,vector.Z}
	end

	function MakeESP(model)
		local CurrentParent = model.Parent

		local TopL = Drawing.new("Line")
		local BottomL = Drawing.new("Line")
		local LeftL = Drawing.new("Line")
		local RightL = Drawing.new("Line")
		local Tracer = Drawing.new("Line")

		coroutine.resume(coroutine.create(function()
			while model.Parent == CurrentParent and model.Humanoid.Health > 0 do

				local Distance = (Camera.CFrame.Position - model.HumanoidRootPart.Position).Magnitude
				local GetP = GetPoint(model.Head.Position)
				local headps = model.Head.CFrame

				if ESPEnabled and GetP[2] then

					-- Calculate Cords
					local topright = headps * CFrame.new(3,0.5, 0)
					local topleft = headps * CFrame.new(-3,0.5, 0)
					local bottomleft = headps * CFrame.new(-3,-7,0)
					local bottomright = headps * CFrame.new(3,-7,0)
					topright = GetPoint(topright.p)[1]
					topleft = GetPoint(topleft.p)[1]
					bottomleft = GetPoint(bottomleft.p)[1]
					bottomright = GetPoint(bottomright.p)[1]

					teamcolor = Color3.new(1, 1, 1)
					TopL.Color, BottomL.Color, RightL.Color, LeftL.Color = teamcolor, teamcolor, teamcolor, teamcolor
					TopL.From, BottomL.From, RightL.From, LeftL.From = topleft, bottomleft, topright, topleft
					TopL.To, BottomL.To, RightL.To, LeftL.To = topright, bottomright, bottomright, bottomleft
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = true, true, true, true
				else
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = false, false, false, false
				end

				if ESPEnabled and TracersEnabled and GetP[2] then
					Tracer.Color = Color3.new(1, 1, 1)
					Tracer.From = Bottom
					Tracer.To = GetPoint(headps.p)[1]
					Tracer.Thickness = 1.5
					Tracer.Visible = true
				else
					Tracer.Visible = false
				end
				RunService.RenderStepped:Wait()
			end

			TopL:Remove()
			BottomL:Remove()
			RightL:Remove()
			LeftL:Remove()
			Tracer:Remove()

		end))
	end

	for _, Player in next, game:GetService("Players"):GetChildren() do
		if Player.Name ~= game.Players.LocalPlayer.Name then
			MakeESP(Player.Character)
			Player.CharacterAdded:Connect(function()
				delay(0.5, function()
					MakeESP(Player.Character)
				end)
			end)
		end	
	end

	game:GetService("Players").PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			delay(0.5, function()
				MakeESP(player.Character)
			end)
		end)
	end)

end)

local Box = Visuals:CreateToggle({
	Name = "Enable Box",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(Value)
		ESPEnabled = Value
	end,
})

local Tracers = Visuals:CreateToggle({
	Name = "Enable Tracers",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(Value)
		TracersEnabled = Value
	end,
})

-- MISC
local Debug = Misc:CreateSection("Debug")
local DestroyUI = Misc:CreateButton({
	Name = "Destroy GUI",
	Callback = function()
		Rayfield:Destroy()
	end,
})
