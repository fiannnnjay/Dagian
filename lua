local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Backpack = player:WaitForChild("Backpack")
local RunService = game:GetService("RunService")

local currentPet = nil

-- GUI Utama
local gui = Instance.new("ScreenGui")
gui.Name = "VisiblePetClonerUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 20, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Label Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.Text = "Pet Cloner - Visible"
title.Parent = frame

-- Tombol Clone
local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 40)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.Font = Enum.Font.GothamSemibold
spawnBtn.TextSize = 14
spawnBtn.Text = "Clone Pet (Visible)"
spawnBtn.Parent = frame

-- Tombol Tutup GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14
closeBtn.Parent = frame

-- Fungsi Clone Pet (Visible)
spawnBtn.MouseButton1Click:Connect(function()
	if currentPet then
		local clone = currentPet:Clone()
		clone.Name = currentPet.Name .. "_Clone"
		clone.Parent = Backpack
	end
end)

-- Fungsi Tutup GUI
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Toggle GUI via Keybind (misal: tombol G)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.G then
		frame.Visible = not frame.Visible
	end
end)

-- Update Pet di Pegangan
RunService.RenderStepped:Connect(function()
	local tool = character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("Handle") then
		currentPet = tool
	end
end)

print("[Pet Cloner Visible GUI] Aktif - Tekan G untuk toggle GUI")
