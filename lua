-- ✅ Grow A Garden Pet & Seed Spawner GUI (Exploit-ready)
-- 💥 Pet/Seed langsung masuk inventory & bisa dipakai (visible)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ✅ Fungsi notifikasi
local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Grow a Garden Spawner",
            Text = text,
            Duration = 3
        })
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GrowSpawnerGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = CoreGui end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 140, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0, 60)
toggleBtn.Text = "Toggle Spawner GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
frame.Name = "GrowSpawner"
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Tabs
local petTab = Instance.new("TextButton", frame)
petTab.Size = UDim2.new(0.5, 0, 0, 30)
petTab.Position = UDim2.new(0, 0, 0, 0)
petTab.Text = "Pet Spawner"

local seedTab = petTab:Clone()
seedTab.Text = "Seed Spawner"
seedTab.Position = UDim2.new(0.5, 0, 0, 0)
seedTab.Parent = frame
petTab.Parent = frame

-- Input
local nameBox = Instance.new("TextBox", frame)
nameBox.PlaceholderText = "Enter Name (ex: Raccoon)"
nameBox.Position = UDim2.new(0, 10, 0, 50)
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
nameBox.TextColor3 = Color3.fromRGB(0,0,0)
nameBox.Parent = frame

-- Spawn Button
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "Spawn"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 100)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
spawnBtn.TextColor3 = Color3.new(1,1,1)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 16
spawnBtn.Parent = frame

-- Logic
local currentMode = "Pet"
petTab.MouseButton1Click:Connect(function()
    currentMode = "Pet"
    nameBox.PlaceholderText = "Enter Pet Name"
end)
seedTab.MouseButton1Click:Connect(function()
    currentMode = "Seed"
    nameBox.PlaceholderText = "Enter Seed Name"
end)

spawnBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text
    if name == "" then return end

    local folderName = currentMode == "Pet" and "PetModels" or "Seeds"
    local folder = ReplicatedStorage:FindFirstChild(folderName)
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            if obj.Name:lower() == name:lower() then
                local clone = obj:Clone()
                clone.Parent = Backpack
                notify(currentMode .. " Added: " .. obj.Name)
                return
            end
        end
    end
    notify("Not Found in " .. folderName)
end)
