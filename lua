-- Grow a Garden - Full GUI Rayfield (Shop, ESP, Pet, Utility)
-- Make sure Rayfield library is loaded before running

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local petTarget = "Goat"
local autoHop = false
local autoBuyEgg = false
local autoBuySeed = false
local autoBuyGear = false
local espEnabled = false
local notifEnabled = true

-- MAIN GUI
local Window = Rayfield:CreateWindow({
    Name = "Grow ESP GUI",
    LoadingTitle = "Grow Garden GUI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrowGUI",
        FileName = "grow_ui_config"
    },
})

-- SHOP TAB
local ShopTab = Window:CreateTab("Shop", 4483362458)
ShopTab:CreateToggle({
    Name = "Auto Buy Eggs",
    CurrentValue = false,
    Callback = function(Value)
        autoBuyEgg = Value
    end,
})
ShopTab:CreateToggle({
    Name = "Auto Buy Seeds",
    CurrentValue = false,
    Callback = function(Value)
        autoBuySeed = Value
    end,
})
ShopTab:CreateToggle({
    Name = "Auto Buy Gears",
    CurrentValue = false,
    Callback = function(Value)
        autoBuyGear = Value
    end,
})

-- ESP TAB
local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({
    Name = "ESP Egg Boxes",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
    end,
})

-- PET TAB
local PetTab = Window:CreateTab("Pet", 4483362458)
PetTab:CreateInput({
    Name = "Pet Incaran",
    PlaceholderText = "Masukkan nama pet...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        petTarget = Text
    end,
})
PetTab:CreateToggle({
    Name = "Notif saat Pet ditemukan",
    CurrentValue = true,
    Callback = function(Value)
        notifEnabled = Value
    end,
})

-- UTILITY TAB
local UtilityTab = Window:CreateTab("Utility", 4483362458)
UtilityTab:CreateToggle({
    Name = "Auto Hop Server jika Pet tidak ditemukan",
    CurrentValue = false,
    Callback = function(Value)
        autoHop = Value
    end,
})

-- FUNCTION: Notif
local function notify(msg)
    if notifEnabled then
        Rayfield:Notify({Title = "Grow ESP", Content = msg, Duration = 4})
    end
end

-- FUNCTION: ESP
local function makeESP(part, text)
    if part:FindFirstChild("EggESP") then return end
    local bb = Instance.new("BillboardGui", part)
    bb.Name = "EggESP"
    bb.Size = UDim2.new(0, 100, 0, 20)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 0)
    lbl.TextScaled = true
end

-- LOOP: Auto Buy
task.spawn(function()
    while true do task.wait(2)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.MaxActivationDistance <= 12 then
                local name = v.Parent and v.Parent.Name:lower()
                if autoBuyEgg and name:find("egg") then fireproximityprompt(v) end
                if autoBuySeed and name:find("seed") then fireproximityprompt(v) end
                if autoBuyGear and name:find("gear") then fireproximityprompt(v) end
            end
        end
    end
end)

-- LOOP: ESP + Pet Scan + Auto Hop
task.spawn(function()
    while true do task.wait(6)
        local found = false
        for _, egg in pairs(workspace:GetDescendants()) do
            if egg:IsA("Model") and egg.Name:lower():find("egg") then
                local part = egg:FindFirstChildWhichIsA("BasePart")
                if part and espEnabled and not part:FindFirstChild("EggESP") then
                    local petName = "Egg"
                    for _, d in pairs(egg:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Text ~= "" then petName = d.Text break end
                        if d:IsA("Model") and d.Name:lower():find("pet") then petName = d.Name break end
                    end
                    makeESP(part, petName)
                    if petName:lower():find(petTarget:lower()) then
                        found = true
                        notify("Pet ditemukan: " .. petName)
                    end
                end
            end
        end
        if not found and autoHop then
            notify("Pet tidak ditemukan, server hop...")
            TeleportService:Teleport(game.PlaceId)
        end
    end
end)
