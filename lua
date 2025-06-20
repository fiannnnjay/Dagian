-- ✅ Grow A Garden PET SPAWNER FIX 2024
-- 🔍 Auto detect folder pet
-- 🎒 Langsung masuk inventory + notif

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ========== AUTO DETECT PET FOLDER ==========
local function findPetFolder()
    -- Cek lokasi-lokasi umum
    local possibleLocations = {
        ReplicatedStorage:FindFirstChild("PetModels"),
        ReplicatedStorage:FindFirstChild("Pets"),
        workspace:FindFirstChild("PetStorage"),
        game:GetService("ServerStorage"):FindFirstChild("Pets")
    }
    
    for _,folder in pairs(possibleLocations) do
        if folder and #folder:GetChildren() > 0 then
            return folder
        end
    end
    return nil
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "PetSpawnerPremium"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui

-- [Bagian GUI lainnya sama seperti sebelumnya...]

spawnBtn.MouseButton1Click:Connect(function()
    local petName = nameBox.Text
    if petName == "" then return end
    
    -- Auto-detect folder pet
    local petFolder = findPetFolder()
    
    if not petFolder then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ERROR",
            Text = "Tidak bisa menemukan folder pet!",
            Duration = 5,
            Icon = "rbxassetid://57254793"
        })
        return
    end
    
    -- [Bagian spawn pet sama seperti sebelumnya...]
end)
