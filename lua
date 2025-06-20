local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local cam = workspace.CurrentCamera
local run = game:GetService("RunService")

-- 📦 ESP Container
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "DeltaESP"

-- 🎯 Aimbot Setting
local aiming = false
local aimPart = "Head"

-- 📡 ESP Setting
local espEnabled = false

-- 🧱 GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeltaFPSGui"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 170)
main.Position = UDim2.new(0, 20, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "⚙️ Delta FPS GUI"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local aimBtn = Instance.new("TextButton", main)
aimBtn.Size = UDim2.new(1, -20, 0, 40)
aimBtn.Position = UDim2.new(0, 10, 0, 40)
aimBtn.Text = "🎯 Aimbot: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.SourceSans
aimBtn.TextSize = 16

local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 90)
espBtn.Text = "🔍 ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSans
espBtn.TextSize = 16

local toggleGui = Instance.new("TextButton", main)
toggleGui.Size = UDim2.new(1, -20, 0, 30)
toggleGui.Position = UDim2.new(0, 10, 0, 140)
toggleGui.Text = "❌ Tutup GUI"
toggleGui.BackgroundColor3 = Color3.fromRGB(80,20,20)
toggleGui.TextColor3 = Color3.new(1,1,1)
toggleGui.Font = Enum.Font.SourceSans
toggleGui.TextSize = 14

-- 🔘 GUI Toggle Logic
toggleGui.MouseButton1Click:Connect(function()
	main.Visible = false
	local openBtn = Instance.new("TextButton", gui)
	openBtn.Text = "⚙️"
	openBtn.Size = UDim2.new(0, 40, 0, 40)
	openBtn.Position = UDim2.new(0, 10, 0, 10)
	openBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	openBtn.TextColor3 = Color3.new(1,1,1)
	openBtn.Font = Enum.Font.SourceSansBold
	openBtn.TextSize = 22
	openBtn.Name = "OpenBtn"
	openBtn.MouseButton1Click:Connect(function()
		main.Visible = true
		openBtn:Destroy()
	end)
end)

-- 🎯 Aimbot Core
aimBtn.MouseButton1Click:Connect(function()
	aiming = not aiming
	aimBtn.Text = aiming and "🎯 Aimbot: ON" or "🎯 Aimbot: OFF"
end)

local function getClosest()
	local closest, dist = nil, math.huge
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild(aimPart) then
			local pos, onScreen = cam:WorldToViewportPoint(v.Character[aimPart].Position)
			if onScreen then
				local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
				if mag < dist then
					closest = v
					dist = mag
				end
			end
		end
	end
	return closest
end

-- 🔍 ESP Core
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "🔍 ESP: ON" or "🔍 ESP: OFF"

	if not espEnabled then
		for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
	end
end)

-- 👁️ Add Box ESP
local function addEsp(player)
	if player == lp then return end
	local box = Instance.new("BoxHandleAdornment", espFolder)
	box.Name = player.Name.."_ESP"
	box.Adornee = player.Character
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Size = Vector3.new(3,5,1.5)
	box.Color3 = Color3.fromRGB(0,255,0)
	box.Transparency = 0.5
	box.Visible = true
	box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
end

-- 🔄 ESP & Aimbot Loop
run.RenderStepped:Connect(function()
	if aiming then
		local t = getClosest()
		if t and t.Character and t.Character:FindFirstChild(aimPart) then
			local targetPos = t.Character[aimPart].Position
			cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), 0.2)
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
