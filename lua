-- ✅ Grow A Garden Pet & Seed Spawner GUI (Exploit-ready)
-- 💥 Pet/Seed langsung masuk inventory & bisa dipakai (visible)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ✅ Fungsi notifikasi
local function notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Grow a Garden Spawner",
        Text = text,
        Duration = 3
    })
end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
frame.Name = "GrowSpawner"

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
nameBox.Parent = frame

-- Spawn Button
local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "Spawn"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 100)
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
end)"
}
