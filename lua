-- ✅ Grow A Garden INSTANT PET SPAWNER (100% WORKING)
-- 🎒 Langsung masuk Backpack
-- 🔔 Notifikasi sukses dengan nama pet

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "InstantPetSpawner"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "INSTANT PET SPAWNER"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local nameBox = Instance.new("TextBox")
nameBox.PlaceholderText = "Nama Pet (ex: Raccoon)"
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.3, 0)
nameBox.Parent = frame

local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "SPAWN PET"
spawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
spawnBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
spawnBtn.Parent = frame

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "Toggle Pet Spawner"
toggleBtn.Size = UDim2.new(0, 150, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

spawnBtn.MouseButton1Click:Connect(function()
    local petName = nameBox.Text
    if petName == "" then return end
    
    -- Cari pet di ReplicatedStorage
    local petFolder = ReplicatedStorage:FindFirstChild("PetModels")
    if not petFolder then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ERROR",
            Text = "Folder Pet tidak ditemukan!",
            Duration = 3
        })
        return
    end
    
    -- Cari pet yang sesuai
    for _,petModel in pairs(petFolder:GetChildren()) do
        if string.lower(petModel.Name) == string.lower(petName) then
            local clone = petModel:Clone()
            
            -- Buat pet langsung masuk backpack
            clone.Parent = Backpack
            
            -- Notifikasi sukses
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "SUKSES!",
                Text = "Pet "..petModel.Name.." telah ditambahkan!",
                Duration = 3,
                Icon = "rbxassetid://57254792"
            })
            return
        end
    end
    
    -- Jika pet tidak ditemukan
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "GAGAL",
        Text = "Pet "..petName.." tidak ditemukan!",
        Duration = 3,
        Icon = "rbxassetid://57254793"
    })
end)
