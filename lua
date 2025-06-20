-- Aimbot GUI by Delta
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FPSAimbot"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Delta Aimbot"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "🟢 Aimbot: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 16

local part = "Head"
local aiming = false

toggle.MouseButton1Click:Connect(function()
	aiming = not aiming
	toggle.Text = aiming and "🟢 Aimbot: ON" or "🔴 Aimbot: OFF"
end)

-- Core aimbot function
local function getClosest()
	local cam = workspace.CurrentCamera
	local closest, dist = nil, math.huge
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild(part) then
			local pos, onScreen = cam:WorldToViewportPoint(v.Character[part].Position)
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

run.RenderStepped:Connect(function()
	if aiming then
		local target = getClosest()
		if target and target.Character and target.Character:FindFirstChild(part) then
			local cam = workspace.CurrentCamera
			local targetPos = target.Character[part].Position
			cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), 0.15)
		end
	end
end)
