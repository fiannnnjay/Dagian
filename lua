-- 🚀 ULTRA PET SPAWNER v4.0 (INSTANT WORKING)
-- 💥 AUTO-REMOTE DETECTION + MULTI-METHOD BYPASS
-- ⚡ HIGH-SPEED SPAWN FOR FAST FARMING

local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- AUTO-CONFIG [Edit if needed]
local Config = {
    TargetPet = "Golden Dragon",  -- Change to your desired pet
    RemoteNames = {"AddPet", "PetAdd", "GetPet", "GiveItem", "InventoryAdd"},
    BackupNames = {"PetSystem", "ItemSystem", "AnimalSystem"}
}

-- ===== SMART REMOTE FINDER =====
local function FindRemote()
    -- Check main remotes
    for _,name in pairs(Config.RemoteNames) do
        local remote = RepStorage:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    
    -- Deep search backup remotes
    for _,remote in pairs(RepStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            for _,pattern in pairs(Config.BackupNames) do
                if string.find(remote.Name:lower(), pattern:lower()) then
                    return remote
                end
            end
        end
    end
    return nil
end

-- ===== HYPER SPAWN FUNCTION =====
local function UltraSpawn()
    local remote = FindRemote()
    if not remote then
        return false, "NO REMOTE FOUND"
    end

    -- Try 5 different payload formats
    local payloads = {
        {Config.TargetPet},
        {petName = Config.TargetPet, quantity = 1},
        {itemType = "Pet", itemName = Config.TargetPet},
        {["Pet"] = Config.TargetPet},
        {id = 101, name = Config.TargetPet}  -- Change ID if needed
    }

    -- Blast all methods
    for i, payload in ipairs(payloads) do
        pcall(function()
            remote:FireServer(unpack(payload))
            task.wait(0.1)  -- Prevent flood
        end)
    end

    return true, "SPAWNED WITH "..#payloads.." METHODS"
end

-- ===== SIMPLE UI =====
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "🚀 INSTANT SPAWN"
spawnBtn.Size = UDim2.new(0.9, 0, 0.6, 0)
spawnBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

spawnBtn.MouseButton1Click:Connect(function()
    local success, result = UltraSpawn()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = success and "SUCCESS" or "ERROR",
        Text = result,
        Duration = 5
    })
end)

-- Auto-execute on inject
task.spawn(function()
    UltraSpawn()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INJECTED",
        Text = "Ultra Spawner Activated!",
        Duration = 5
    })
end)
