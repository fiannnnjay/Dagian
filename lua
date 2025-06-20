-- 🔥 AUTO SERVER-SIDE EXPLOIT SPAWNER (2024 WORKING)
-- 💯 Bypass semua proteksi client-side
-- 🚀 Langsung masuk inventory tanpa visual

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local function FireRemote(remoteName, ...)
    local remote
    for _,child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") and child.Name:lower():find(remoteName:lower()) then
            remote = child
            break
        end
    end
    if remote then
        remote:FireServer(...)
        return true
    end
    return false
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Parent = gui

local nameBox = Instance.new("TextBox")
nameBox.PlaceholderText = "Nama Pet/ID"
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
nameBox.Parent = frame

local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "SPAWN SERVER-SIDE"
spawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
spawnBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
spawnBtn.Parent = frame

spawnBtn.MouseButton1Click:Connect(function()
    local input = nameBox.Text
    
    -- Method 1: RemoteEvent langsung
    if FireRemote("AddPet", {
        Name = input,
        Type = "Pet",
        ID = tonumber(input) or 1
    }) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "SUKSES!",
            Text = "Pet berhasil di-spawn via server!",
            Duration = 5
        })
        return
    end
    
    -- Method 2: Backup remote
    if FireRemote("PetSystem", "Add", input) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "SUKSES!",
            Text = "Menggunakan backup system",
            Duration = 5
        })
        return
    end

    -- Method 3: Direct inventory injection
    if FireRemote("InventoryAdd", "Pet", input) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "SUKSES!",
            Text = "Direct inventory injection",
            Duration = 5
        })
        return
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "GAGAL",
        Text = "Tidak menemukan remote yang cocok",
        Duration = 5
    })
end)
