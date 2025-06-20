-- Delta FPS Aimbot Ultra v3
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local cam = workspace.CurrentCamera
local run = game:GetService("RunService")

local aimPart = "Head"
local aiming = false
local espEnabled = false
local maxDistance = 200

-- ESP Folder
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "DeltaESP"

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeltaAimbotUI"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 250)
main.Position = UDim2.new(0, 20, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 Delta FPS Aimbot UI"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Aimbot Toggle
local aimBtn = Instance.new("TextButton", main)
aimBtn.Size = UDim2.new(1, -20, 0, 40)
aimBtn.Position = UDim2.new(0, 10, 0, 35)
aimBtn.Text = "Aimbot: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.SourceSansBold
aimBtn.TextSize = 16

-- ESP Toggle
local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 85)
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 16

-- Aim Target Selector
local aimList = Instance.new("TextButton", main)
aimList.Size = UDim2.new(1, -20, 0, 30)
aimList.Position = UDim2.new(0, 10, 0, 135)
aimList.Text = "🎯 Lock Part: Head"
aimList.BackgroundColor3 = Color3.fromRGB(30,30,30)
aimList.TextColor3 = Color3.new(1,1,1)
aimList.Font = Enum.Font.SourceSans
aimList.TextSize = 14

-- Close Button
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(1, -20, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 180)
closeBtn.Text = "❌ Tutup GUI"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 14

-- Reopen GUI Button
closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	local openBtn = Instance.new("TextButton", gui)
	openBtn.Size = UDim2.new(0, 40, 0, 40)
	openBtn.Position = UDim2.new(0, 10, 0, 10)
	openBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	openBtn.TextColor3 = Color3.new(1,1,1)
	openBtn.Font = Enum.Font.SourceSansBold
	openBtn.TextSize = 22
	openBtn.Text = "⚙️"
	openBtn.MouseButton1Click:Connect(function()
		main.Visible = true
		openBtn:Destroy()
	end)
end)

-- Toggle Aimbot
aimBtn.MouseButton1Click:Connect(function()
	aiming = not aiming
	aimBtn.Text = aiming and "Aimbot: ON" or "Aimbot: OFF"
end)

-- Toggle ESP
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	if not espEnabled then
		for _, v in pairs(espFolder:GetChildren()) do v:Destroy() end
	end
end)

-- Ganti Lock Part (Head / Body)
aimList.MouseButton1Click:Connect(function()
	aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
	aimList.Text = "🎯 Lock Part: " .. (aimPart == "Head" and "Head" or "Body")
end)

-- Aimbot Function
local function getClosest()
	local closest, shortest = nil, maxDistance
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild(aimPart) then
			local part = v.Character[aimPart]
			local screen, onScreen = cam:WorldToViewportPoint(part.Position)
			if onScreen then
				local mag = (Vector2.new(screen.X, screen.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
				if mag < shortest then
					shortest = mag
					closest = v
				end
			end
		end
	end
	return closest
end

-- ESP Box
local function addEsp(player)
	local box = Instance.new("BoxHandleAdornment", espFolder)
	box.Name = player.Name.."_ESP"
	box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Size = Vector3.new(3, 5, 1.5)
	box.Color3 = Color3.fromRGB(0,255,0)
	box.Transparency = 0.4
end

-- MAIN LOOP
run.RenderStepped:Connect(function()
	if aiming then
		local target = getClosest()
		if target and target.Character and target.Character:FindFirstChild(aimPart) then
			local pos = target.Character[aimPart].Position
			cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), 0.25)
		end
	end
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not espFolder:FindFirstChild(p.Name.."_ESP") then
					addEsp(p)
				end
			end
		end
	end
end)
