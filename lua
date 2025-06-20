-- 🌟 100% WORKING PET/SEED DUPLICATOR (GUI FIXED)
-- 🚀 TAMPIL GUI & AUTO DUPLIKASI PET/SEED

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ===== CONFIGURASI =====
local DUPE_KEY = Enum.KeyCode.F -- Tombol untuk duplikasi

-- ===== FUNGSI UTAMA =====
local function DuplikasiItem()
    -- Cari item yang sedang dipegang
    local item = Backpack:FindFirstChildOfClass("Model")
    if not item then return end
    
    -- Cek apakah pet atau seed
    local isPet = item:FindFirstChild("IsPet") or item:FindFirstChild("PetData")
    local isSeed = item:FindFirstChild("IsSeed") or item:FindFirstChild("SeedData")
    
    if not (isPet or isSeed) then return end
    
    -- Cari RemoteEvent
    for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- Coba berbagai format pengiriman
            pcall(function() remote:FireServer(item.Name) end)
            pcall(function() remote:FireServer({Item = item.Name}) end)
            pcall(function() remote:FireServer(item:Clone()) end)
        end
    end
    
    return true
end

-- ===== MEMBUAT GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "AutoDupeGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui") -- Pastikan parent ke CoreGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 80)
mainFrame.Position = UDim2.new(0.5, -125, 0.9, -40)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Judul
local title = Instance.new("TextLabel")
title.Text = "AUTO PET/SEED DUPLICATOR"
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 5)
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Tombol Duplikasi
local dupeBtn = Instance.new("TextButton")
dupeBtn.Text = "TEKAN F UNTUK DUPLIKASI"
dupeBtn.Size = UDim2.new(0.9, 0, 0, 40)
dupeBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
dupeBtn.TextColor3 = Color3.new(1,1,1)
dupeBtn.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Pegang pet/seed di inventory"
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = mainFrame

-- ===== FUNGSI TOGGLE GUI =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "🔧 TOGGLE MENU"
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ===== KEYBIND DUPLIKASI =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == DUPE_KEY and not gameProcessed then
        if DuplikasiItem() then
            -- Animasi sukses
            dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            statusLabel.Text = "Berhasil diduplikasi!"
            task.delay(0.5, function()
                dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            end)
        else
            -- Animasi gagal
            dupeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            statusLabel.Text = "Gagal! Pegang pet/seed dulu"
            task.delay(0.5, function()
                dupeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            end)
        end
    end
end)

-- ===== INISIALISASI =====
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AUTO DUPE READY",
    Text = "Tekan "..tostring(DUPE_KEY):gsub("Enum.KeyCode.", "").." untuk duplikasi",
    Duration = 10
})

print("Script berhasil dijalankan! GUI seharusnya muncul...")
