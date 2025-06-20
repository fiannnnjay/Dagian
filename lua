-- 🌟 REAL PET DATA DISPLAY (DIRECT FROM SERVER)
-- 📊 Shows ACTUAL pet name, age, and size
-- 🎨 Beautiful Indonesian GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ===== AUTO-GET REAL PET DATA =====
local function GetRealPetData(petName)
    -- Method 1: Check ReplicatedStorage
    local petFolder = ReplicatedStorage:FindFirstChild("PetModels") or ReplicatedStorage:FindFirstChild("Pets")
    if petFolder then
        local petModel = petFolder:FindFirstChild(petName)
        if petModel then
            return {
                Name = petModel.Name,
                Age = petModel:FindFirstChild("Age") and petModel.Age.Value or 1,
                Size = petModel:FindFirstChild("Size") and petModel.Size.Value or 1
            }
        end
    end
    
    -- Method 2: Check player's pets
    if player:FindFirstChild("Pets") then
        for _,pet in pairs(player.Pets:GetChildren()) do
            if string.lower(pet.Name) == string.lower(petName) then
                return {
                    Name = pet.Name,
                    Age = pet:FindFirstChild("Age") and pet.Age.Value or 1,
                    Size = pet:FindFirstChild("Size") and pet.Size.Value or 1
                }
            end
        end
    end
    
    return nil
end

-- ===== BEAUTIFUL GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "PetInfoDisplay"
gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Add gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 80))
})
gradient.Rotation = 90
gradient.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Text = "🔍 INFO PET ANDA"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Input
local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Masukkan nama pet..."
inputBox.Size = UDim2.new(0.9, 0, 0, 30)
inputBox.Position = UDim2.new(0.05, 0, 0.2, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.Parent = mainFrame

-- Display Frame
local displayFrame = Instance.new("Frame")
displayFrame.Size = UDim2.new(0.9, 0, 0, 100)
displayFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
displayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
displayFrame.BackgroundTransparency = 0.3
displayFrame.Parent = mainFrame

-- Info Labels
local nameLabel = Instance.new("TextLabel")
nameLabel.Text = "Nama: -"
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Size = UDim2.new(1, 0, 0, 25)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = displayFrame

local ageLabel = nameLabel:Clone()
ageLabel.Text = "Umur: -"
ageLabel.Position = UDim2.new(0, 10, 0, 35)
ageLabel.Parent = displayFrame

local sizeLabel = nameLabel:Clone()
sizeLabel.Text = "Ukuran: -"
sizeLabel.Position = UDim2.new(0, 10, 0, 60)
sizeLabel.Parent = displayFrame

-- Search Button
local searchBtn = Instance.new("TextButton")
searchBtn.Text = "CARI PET"
searchBtn.Size = UDim2.new(0.9, 0, 0, 35)
searchBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
searchBtn.TextColor3 = Color3.new(1, 1, 1)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.Parent = mainFrame

-- Search Function
searchBtn.MouseButton1Click:Connect(function()
    local petName = inputBox.Text
    if petName == "" then return end
    
    local petData = GetRealPetData(petName)
    
    if petData then
        nameLabel.Text = "Nama: "..petData.Name
        ageLabel.Text = "Umur: "..petData.Age
        sizeLabel.Text = "Ukuran: "..petData.Size
        
        -- Animation
        game:GetService("TweenService"):Create(
            displayFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(40, 80, 40)}
        ):Play()
    else
        nameLabel.Text = "Nama: -"
        ageLabel.Text = "Umur: -"
        sizeLabel.Text = "Ukuran: -"
        
        -- Error animation
        game:GetService("TweenService"):Create(
            displayFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(80, 40, 40)}
        ):Play()
    end
end)

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "🔍 BUKA PET INFO"
toggleBtn.Size = UDim2.new(0, 150, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
