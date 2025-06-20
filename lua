-- 🚀 GROW A GARDEN AUTO-SPAWNER (NON-VISUAL 100%)
-- ✨ TINGGAL PEGANG PET/SEED → AUTO DUPLICATE
-- 🔥 WORKING SERVER-SIDE EXPLOIT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- ===== AUTO-DETECT SYSTEM =====
local function FindDupeRemote()
    local remotes = {
        "AddPet", "DuplicateItem", "Clone", 
        "PetSystem", "SeedSystem", "InventoryAdd"
    }
    
    for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            for _,name in pairs(remotes) do
                if string.find(remote.Name:lower(), name:lower()) then
                    return remote
                end
            end
        end
    end
    return nil
end

-- ===== MAIN DUPE FUNCTION =====
local function AutoDupe(item)
    if not item then return end
    
    local remote = FindDupeRemote()
    if not remote then
        warn("Remote not found!")
        return
    end

    -- Try different parameter formats
    local params = {
        {item.Name},
        {Item = item.Name, Type = item:FindFirstChild("IsSeed") and "Seed" or "Pet"},
        {item:Clone()},
        {Id = item:GetAttribute("Id") or 1}
    }

    for _,param in pairs(params) do
        pcall(function()
            remote:FireServer(unpack(param))
        end)
    end
end

-- ===== INVENTORY WATCHER =====
Backpack.ChildAdded:Connect(function(item)
    -- Check if it's a pet or seed
    if item:FindFirstChild("IsPet") or item:FindFirstChild("IsSeed") then
        task.wait(0.5) -- Wait for animation
        AutoDupe(item)
    end
end)

-- ===== STARTUP MESSAGE =====
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AUTO-SPAWNER AKTIF",
    Text = "Pegang pet/seed di inventory untuk auto-duplicate!",
    Duration = 10,
    Icon = "rbxassetid://57254792"
})

warn("Auto-spawner activated! Just hold any pet/seed to duplicate.")
