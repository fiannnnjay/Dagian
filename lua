local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetDuplicatorGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.5, -125, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Toggle Close/Open
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(0.5, 110, 0.5, -105)
toggleBtn.Text = "🔁"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "🐾 DUPLICATE PET"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Pet Info
local petInfo = Instance.new("TextLabel", frame)
petInfo.Size = UDim2.new(1, -20, 0, 50)
petInfo.Position = UDim2.new(0, 10, 0, 35)
petInfo.BackgroundTransparency = 1
petInfo.TextColor3 = Color3.new(1, 1, 1)
petInfo.TextWrapped = true
petInfo.Text = "No Pet Detected"
petInfo.Font = Enum.Font.SourceSans
petInfo.TextSize = 16

-- Button
local dupBtn = Instance.new("TextButton", frame)
dupBtn.Text = "DUPLICATE NOW"
dupBtn.Size = UDim2.new(1, -20, 0, 40)
dupBtn.Position = UDim2.new(0, 10, 0, 100)
dupBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
dupBtn.TextColor3 = Color3.new(0, 0, 0)
dupBtn.AutoButtonColor = true
dupBtn.Visible = false

-- Tool Check + Auto Detect Pet Info
game:GetService("RunService").RenderStepped:Connect(function()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool and tool.Name ~= "" and string.find(tool.Name, "[") then
		petInfo.Text = "Pet: " .. tool.Name
		dupBtn.Visible = true
	else
		petInfo.Text = "No Pet Detected"
		dupBtn.Visible = false
	end
end)

-- Spawn/Dupe
dupBtn.MouseButton1Click:Connect(function()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if not tool then return end

	local newPet = tool:Clone()
	newPet.Parent = player.Backpack
end)
