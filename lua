-- GUI Buatan Script
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Membuat ScreenGui
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ItemSpawnerUI"
gui.ResetOnSpawn = false

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

-- Nama input
local nameBox = Instance.new("TextBox", frame)
nameBox.PlaceholderText = "Nama Item"
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 10)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
nameBox.TextColor3 = Color3.new(1, 1, 1)

-- Ukuran input
local sizeBox = Instance.new("TextBox", frame)
sizeBox.PlaceholderText = "Ukuran (misal: 2)"
sizeBox.Size = UDim2.new(1, -20, 0, 30)
sizeBox.Position = UDim2.new(0, 10, 0, 50)
sizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sizeBox.TextColor3 = Color3.new(1, 1, 1)

-- Umur input
local ageBox = Instance.new("TextBox", frame)
ageBox.PlaceholderText = "Umur (detik)"
ageBox.Size = UDim2.new(1, -20, 0, 30)
ageBox.Position = UDim2.new(0, 10, 0, 90)
ageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ageBox.TextColor3 = Color3.new(1, 1, 1)

-- Tombol Spawn
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "Spawn Item"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 130)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.AutoButtonColor = true
spawnBtn.Active = false

-- Fungsi pengecekan tool
local function checkTool()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	spawnBtn.Active = (tool ~= nil)
	spawnBtn.BackgroundColor3 = tool and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 100)
end

-- Update tiap detik
game:GetService("RunService").RenderStepped:Connect(checkTool)

-- Aksi saat spawn ditekan
spawnBtn.MouseButton1Click:Connect(function()
	if not spawnBtn.Active then return end

	local itemName = nameBox.Text
	local size = tonumber(sizeBox.Text) or 1
	local age = tonumber(ageBox.Text) or 10

	-- Spawn item
	local part = Instance.new("Part", workspace)
	part.Name = itemName
	part.Size = Vector3.new(size, size, size)
	part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
	part.Anchored = false
	part.BrickColor = BrickColor.Random()

	-- Hilangkan setelah umur detik
	game:GetService("Debris"):AddItem(part, age)
end)
