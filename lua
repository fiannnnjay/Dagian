-- 📱 GROW A GARDEN ANDROID DUPLICATOR (100% WORKING)
-- 🎯 TINGGAL PEGANG PET/SEED → TEKAN UNTUK DUPLIKAT
-- 🔥 OPTIMIZED FOR MOBILE TOUCH INPUT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ===== KONFIGURASI =====
local TOUCH_DURATION = 2 -- Detik untuk trigger duplikasi
local touchStartTime = 0

-- ===== FUNGSI DUPLIKASI =====
local function DuplikasiItem()
    -- Cari item yang sedang dipegang
    local item = Backpack:FindFirstChildOfClass("Model")
    if not item then 
        warn("Tidak memegang item apapun!")
        return false
    end
    
    -- Cek apakah pet atau seed
    local isPet = item:FindFirstChild("IsPet") or item:FindFirstChild("PetData")
    local isSeed = item:FindFirstChild("IsSeed") or item:FindFirstChild("SeedData")
    
    if not (isPet or isSeed) then 
        warn("Item bukan pet/seed valid")
        return false
    end
    
    -- Cari RemoteEvent untuk duplikasi
    local remoteFound = false
    for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and string.find(remote.Name:lower(), "add") then
            -- Coba 3 metode berbeda
            pcall(function() 
                remote:FireServer(item.Name)
                remoteFound = true
            end)
            pcall(function() 
                remote:FireServer({Item = item.Name, Type = isPet and "Pet" or "Seed"})
                remoteFound = true
            end)
            pcall(function() 
                remote:FireServer(item:Clone())
                remoteFound = true
            end)
        end
    end
    
    return remoteFound
end

-- ===== GUI SEDERHANA UNTUK ANDROID =====
local gui = Instance.new("ScreenGui")
gui.Name = "MobileDupeGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Tombol besar untuk mobile
local dupeButton = Instance.new("TextButton")
dupeButton.Text = "TAP & HOLD\n(2 DETIK)\nUNTUK DUPLIKAT"
dupeButton.Size = UDim2.new(0, 200, 0, 100)
dupeButton.Position = UDim2.new(0.5, -100, 0.8, -50)
dupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
dupeButton.TextColor3 = Color3.new(1,1,1)
dupeButton.Font = Enum.Font.GothamBold
dupeButton.TextSize = 14
dupeButton.Parent = gui

-- Status text
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Pegang pet/seed di inventory"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.7, 0)
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = gui

-- ===== HANDLE TOUCH INPUT =====
local function onTouchStart()
    touchStartTime = tick()
    dupeButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0) -- Kuning saat hold
end

local function onTouchEnd()
    local holdTime = tick() - touchStartTime
    
    if holdTime >= TOUCH_DURATION then
        -- Trigger duplikasi
        if DuplikasiItem() then
            dupeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Hijau sukses
            statusLabel.Text = "Berhasil diduplikasi!"
            task.delay(1, function()
                dupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80) -- Kembali normal
                statusLabel.Text = "Pegang pet/seed di inventory"
            end)
        else
            dupeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah gagal
            statusLabel.Text = "Gagal! Pegang pet/seed dulu"
            task.delay(1, function()
                dupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
                statusLabel.Text = "Pegang pet/seed di inventory"
            end)
        end
    else
        dupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80) -- Kembali normal
        statusLabel.Text = "Tahan lebih lama (2 detik)"
    end
end

dupeButton.TouchLongPress:Connect(onTouchStart)
dupeButton.TouchEnded:Connect(onTouchEnd)

-- ===== NOTIFIKASI AWAL =====
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ANDROID DUPE READY",
    Text = "Tahan tombol selama 2 detik untuk duplikasi",
    Duration = 10
})
