-- 🚀 GROW A GARDEN INSTANT PET SPAWNER (100% WORKING)
-- ✨ PET LANGSUNG MUNCUL DI TAS
-- 🔔 NOTIFIKASI & ANIMASI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ===== AUTO-DETECT PET FOLDER =====
local function FindPetFolder()
    local locations = {
        ReplicatedStorage,
        workspace,
        game:GetService("ServerStorage")
    }
    
    local folderNames = {
        "PetModels", "Pets", "Animals",
        "PetStorage", "PetSystem"
    }
    
    for _,location in pairs(locations) do
        for _,name in pairs(folderNames) do
            local folder = location:FindFirstChild(name)
            if folder and #folder:GetChildren() > 0 then
                return folder
            end
        end
    end
    return nil
end

-- ===== NOTIFIKASI CANTIK =====
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5,
        Icon = "rbxassetid://57254792"
    })
end

-- ===== GUI PREMIUM =====
local gui = Instance.new("ScreenGui")
gui.Name = "GardenPetSpawner"
gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Gradien Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 80))
})
gradient.Rotation = 90
gradient.Parent = mainFrame

-- Judul
local title = Instance.new("TextLabel")
title.Text = "🌱 SPAWNER PET GROW A GARDEN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Input Pet
local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Masukkan nama pet (ex: Golden Dragon)"
inputBox.Size = UDim2.new(0.9, 0, 0, 35)
inputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.Parent = mainFrame

-- Tombol Spawn
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "🚀 SPAWN PET"
spawnBtn.Size = UDim2.new(0.9, 0, 0, 45)
spawnBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Ready to spawn pets"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = mainFrame

-- ===== FUNGSI SPAWN =====
spawnBtn.MouseButton1Click:Connect(function()
    local petName = inputBox.Text
    if petName == "" then
        statusLabel.Text = "Masukkan nama pet!"
        return
    end
    
    local petFolder = FindPetFolder()
    if not petFolder then
        statusLabel.Text = "Error: Folder pet tidak ditemukan"
        Notify("ERROR", "Tidak bisa menemukan folder pet")
        return
    end
    
    -- Cari pet
    local foundPet = nil
    for _,pet in pairs(petFolder:GetChildren()) do
        if string.lower(pet.Name) == string.lower(petName) then
            foundPet = pet
            break
        end
    end
    
    if foundPet then
        -- Clone ke backpack
        local clone = foundPet:Clone()
        clone.Parent = Backpack
        
        -- Animasi sukses
        spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.delay(0.5, function()
            spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
        end)
        
        statusLabel.Text = "Sukses: "..foundPet.Name.." ditambahkan!"
        Notify("SUKSES", foundPet.Name.." ada di tas kamu!")
    else
        statusLabel.Text = "Error: Pet tidak ditemukan"
        Notify("GAGAL", petName.." tidak ditemukan")
    end
end)

-- ===== TOMBOL TOGGLE =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "🌱 BUKA SPAWNER"
toggleBtn.Size = UDim2.new(0, 150, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
