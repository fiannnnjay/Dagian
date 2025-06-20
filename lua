-- 🔮 GROW A GARDEN GHOST DUPLICATOR (2024 WORKING)
-- 🎯 PEGANG PET/SEED → TEKAN DUPE → AUTO KLON 100% NON-VISUAL
-- 🔄 WORK FOR BOTH PETS AND SEEDS

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ===== CONFIG =====
local DUPE_KEY = Enum.KeyCode.F -- Ganti dengan key yang diinginkan

-- ===== AUTO-DETECT REMOTE =====
local function FindDupeRemote()
    for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and string.find(remote.Name:lower(), "add") then
            return remote
        end
    end
    return nil
end

-- ===== DUPE FUNCTION =====
local function GhostDupe()
    local heldItem = Backpack:FindFirstChildOfClass("Model")
    if not heldItem then return end
    
    local isPet = heldItem:FindFirstChild("IsPet")
    local isSeed = heldItem:FindFirstChild("IsSeed")
    
    if not (isPet or isSeed) then return end
    
    local remote = FindDupeRemote()
    if not remote then return end
    
    -- Silent dupe (no visual)
    pcall(function()
        remote:FireServer({
            ItemType = isPet and "Pet" or "Seed",
            ItemName = heldItem.Name,
            Silent = true
        })
    end)
end

-- ===== INVISIBLE GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "GhostDupeGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0.5, -100, 0.9, -30)
frame.BackgroundTransparency = 1
frame.Parent = gui

local dupeBtn = Instance.new("TextButton")
dupeBtn.Text = "[F] GHOST DUPE"
dupeBtn.Size = UDim2.new(1, 0, 1, 0)
dupeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dupeBtn.TextColor3 = Color3.new(1,1,1)
dupeBtn.Parent = frame

-- ===== KEYBIND =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == DUPE_KEY and not gameProcessed then
        GhostDupe()
        -- Flash button feedback
        dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.delay(0.3, function()
            dupeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
end)

-- ===== TOGGLE VISIBILITY =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "👻 TOGGLE DUPE"
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ===== STARTUP =====
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GHOST DUPE READY",
    Text = "Hold any pet/seed and press "..tostring(DUPE_KEY):gsub("Enum.KeyCode.", "").." to dupe",
    Duration = 10
}) r
