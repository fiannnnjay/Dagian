local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SpawnerGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
frame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Spawner"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Close Button
local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame
close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Tab Buttons
local tabPet = Instance.new("TextButton", frame)
tabPet.Size = UDim2.new(0.5, 0, 0, 30)
tabPet.Position = UDim2.new(0, 0, 0, 30)
tabPet.Text = "Pet Spawner"
tabPet.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
tabPet.TextColor3 = Color3.new(1,1,1)
tabPet.Font = Enum.Font.GothamSemibold
tabPet.TextSize = 14

local tabSeed = tabPet:Clone()
tabSeed.Text = "Seed Spawner"
tabSeed.Position = UDim2.new(0.5, 0, 0, 30)

tabPet.Parent = frame
tabSeed.Parent = frame

-- Pet Name Input
local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Pet Name"
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 70)
input.BackgroundColor3 = Color3.fromRGB(255,255,255)
input.TextColor3 = Color3.new(0,0,0)
input.Text = ""

-- Spawn Button
local spawn = Instance.new("TextButton", frame)
spawn.Text = "Spawn"
spawn.Size = UDim2.new(1, -20, 0, 40)
spawn.Position = UDim2.new(0, 10, 0, 110)
spawn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
spawn.TextColor3 = Color3.new(1,1,1)
spawn.Font = Enum.Font.GothamBold
spawn.TextSize = 16

spawn.Parent = frame

-- Fungsi spawn
spawn.MouseButton1Click:Connect(function()
	local name = input.Text
	if name == "" then return end
	
	-- Coba cari prefab pet/seed dari ReplicatedStorage
	local target = ReplicatedStorage:FindFirstChild("PetModels") or ReplicatedStorage:FindFirstChild("Seeds")
	if target then
		for _, obj in pairs(target:GetChildren()) do
			if obj.Name:lower() == name:lower() then
				local clone = obj:Clone()
				clone.Parent = Backpack
				break
			end
		end
	end
end)

-- Toggle tab text
tabPet.MouseButton1Click:Connect(function()
	input.PlaceholderText = "Pet Name"
end)
tabSeed.MouseButton1Click:Connect(function()
	input.PlaceholderText = "Seed Name"
end)
