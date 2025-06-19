local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")

-- Buat GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ItemSpawnerUI"
gui.ResetOnSpawn = false

-- Frame utama
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Tombol Toggle Panel
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Text = "Tutup Panel"
toggleButton.TextColor3 = Color3.new(1, 1, 1)

-- Tombol Spawn
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "Tambah ke Tas"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 80)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.AutoButtonColor = true
spawnBtn.Active = false

-- Label status tool
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -20, 0, 30)
info.Position = UDim2.new(0, 10, 0, 20)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1, 1, 1)
info.TextScaled = true
info.Text = "Tidak Ada Item Di Tangan"

-- Toggle panel buka/tutup
local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	frame.Visible = isOpen
	toggleButton.Text = isOpen and "Tutup Panel" or "Buka Panel"
end)

-- Cek tool di tangan
local function checkTool()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool then
		spawnBtn.Active = true
		spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		info.Text = "Memegang: " .. tool.Name
	else
		spawnBtn.Active = false
		spawnBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		info.Text = "Tidak Ada Item Di Tangan"
	end
end

game:GetService("RunService").RenderStepped:Connect(checkTool)

-- Tambahkan ke tas (Backpack)
spawnBtn.MouseButton1Click:Connect(function()
	if not spawnBtn.Active then return end

	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if not tool then return end

	local clone = tool:Clone()
	clone.Parent = player.Backpack -- langsung masuk tas
end)
