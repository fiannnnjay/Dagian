-- 🌱 Grow A Garden GUI Fix Version
local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local backpack = plr:WaitForChild("Backpack")

-- 🔧 GUI Buatan
local gui = Instance.new("ScreenGui")
gui.Name = "GrowSpawnerGUI"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game.CoreGui end)

-- 🟦 Frame Utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 170)
frame.Position = UDim2.new(0.5, -140, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(33, 120, 200)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
frame.Visible = false

-- 🔲 Tombol Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 140, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "🐣 Open Spawner"
toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 🔘 Tab Pet & Seed
local petTab = Instance.new("TextButton", frame)
petTab.Size = UDim2.new(0.5, 0, 0, 30)
petTab.Text = "Pet"
petTab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
petTab.TextColor3 = Color3.new(1,1,1)

local seedTab = petTab:Clone()
seedTab.Text = "Seed"
seedTab.Position = UDim2.new(0.5, 0, 0, 0)
seedTab.Parent = frame
petTab.Parent = frame

-- 📥 Input Nama
local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Nama Pet / Seed"
input.Position = UDim2.new(0, 10, 0, 50)
input.Size = UDim2.new(1, -20, 0, 30)
input.BackgroundColor3 = Color3.fromRGB(255,255,255)
input.TextColor3 = Color3.fromRGB(0,0,0)
input.Parent = frame

-- 🟩 Tombol Spawn
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "Spawn"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 100)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
spawnBtn.TextColor3 = Color3.new(1,1,1)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 16
spawnBtn.Parent = frame

-- 🔄 Logic Tab
local mode = "Pet"
petTab.MouseButton1Click:Connect(function()
	mode = "Pet"
	input.PlaceholderText = "Nama Pet"
end)
seedTab.MouseButton1Click:Connect(function()
	mode = "Seed"
	input.PlaceholderText = "Nama Seed"
end)

-- ✅ Notifikasi
local function notif(text)
	pcall(function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Grow Spawner",
			Text = text,
			Duration = 2
		})
	end)
end

-- 🧬 Spawn
spawnBtn.MouseButton1Click:Connect(function()
	local itemName = input.Text
	if itemName == "" then return end
	local folder = rs:FindFirstChild(mode == "Pet" and "PetModels" or "Seeds")
	if folder then
		for _, v in pairs(folder:GetChildren()) do
			if v.Name:lower() == itemName:lower() then
				local clone = v:Clone()
				clone.Parent = backpack
				notif("Spawned: "..v.Name)
				return
			end
		end
	end
	notif("Item not found!")
end)
