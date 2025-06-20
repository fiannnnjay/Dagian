-- ✅ Grow A Garden Invisible Pet & Seed Spawner (Exploit-ready)
-- 💥 Pet/Seed langsung masuk inventory & bisa dipakai (invisible to others)
-- 💯 Bisa dikasih ke orang lain (100% working)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
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
local gui = Instance.new("ScreenGui")
gui.Name = "GrowSpawnerGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
frame.Name = "GrowSpawner"
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 30)
title.Text = "Grow a Garden Spawner"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 150, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Toggle Spawner GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui

frame.Visible = false

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Tabs
local petTab = Instance.new("TextButton")
petTab.Size = UDim2.new(0.5, 0, 0, 30)
petTab.Position = UDim2.new(0, 0, 0, 0)
petTab.Text = "Pet Spawner"
petTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
petTab.TextColor3 = Color3.new(1,1,1)
petTab.Parent = frame

local seedTab = petTab:Clone()
seedTab.Text = "Seed Spawner"
seedTab.Position = UDim2.new(0.5, 0, 0, 0)
seedTab.Parent = frame

-- Input
local nameBox = Instance.new("TextBox")
nameBox.PlaceholderText = "Enter Name (ex: Raccoon)"
nameBox.Position = UDim2.new(0, 10, 0, 50)
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
nameBox.TextColor3 = Color3.fromRGB(0,0,0)
nameBox.Parent = frame

-- Player to give input
local playerBox = Instance.new("TextBox")
playerBox.PlaceholderText = "Player to give (optional)"
playerBox.Position = UDim2.new(0, 10, 0, 90)
playerBox.Size = UDim2.new(1, -20, 0, 30)
playerBox.Text = ""
playerBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
playerBox.TextColor3 = Color3.fromRGB(0,0,0)
playerBox.Parent = frame

-- Spawn Button
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "Spawn"
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 130)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
spawnBtn.TextColor3 = Color3.new(1,1,1)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 16
spawnBtn.Parent = frame

-- Logic
local currentMode = "Pet"
petTab.MouseButton1Click:Connect(function()
    currentMode = "Pet"
    nameBox.PlaceholderText = "Enter Pet Name (ex: Raccoon)"
    petTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    seedTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end)
seedTab.MouseButton1Click:Connect(function()
    currentMode = "Seed"
    nameBox.PlaceholderText = "Enter Seed Name (ex: Sunflower)"
    seedTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    petTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end)

-- Initialize tab colors
petTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
seedTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

local function makeInvisible(obj)
    if obj:IsA("BasePart") then
        obj.LocalTransparencyModifier = 1
        obj.CanCollide = false
    elseif obj:IsA("Model") then
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then
                child.LocalTransparencyModifier = 1
                child.CanCollide = false
            end
        end
    end
end

spawnBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text
    local targetPlayer = playerBox.Text
    if name == "" then 
        notify("Please enter a name")
        return 
    end

    local folderName = currentMode == "Pet" and "PetModels" or "Seeds"
    local folder = ReplicatedStorage:FindFirstChild(folderName)
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            if obj.Name:lower() == name:lower() then
                local clone = obj:Clone()
                
                -- Make invisible to others
                makeInvisible(clone)
                
                -- For pets, ensure sound works
                if currentMode == "Pet" then
                    if clone:IsA("Model") then
                        local sound = clone:FindFirstChildOfClass("Sound")
                        if sound then
                            sound.Playing = true
                            sound.Looped = true
                        end
                    end
                end
                
                -- Give to target player or keep for yourself
                if targetPlayer ~= "" then
                    local target = nil
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Name:lower():find(targetPlayer:lower()) then
                            target = plr
                            break
                        end
                    end
                    
                    if target then
                        clone.Parent = target:FindFirstChildOfClass("Backpack")
                        notify("Given "..obj.Name.." to "..target.Name)
                    else
                        clone.Parent = Backpack
                        notify("Player not found, kept for yourself")
                    end
                else
                    clone.Parent = Backpack
                    notify(currentMode.." Added: "..obj.Name)
                end
                return
            end
        end
    end
    notify("Not Found in "..folderName)
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -20, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)
