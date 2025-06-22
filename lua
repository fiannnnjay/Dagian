-- GUI Sederhana Manual
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FruitStealer"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Backpack Fruit Stealer"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.Text = "Pilih Player"
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextSize = 16

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 80)
button.Text = "STEAL RANDOM FRUIT"
button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16

-- Variabel
local SelectedPlayer = nil
local PlayerList = {}

-- Remote Function Asli
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction")

-- Ambil List Player
local function updatePlayerList()
    PlayerList = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
end

-- Saat Klik Dropdown Ganti Player
dropdown.MouseButton1Click:Connect(function()
    updatePlayerList()
    if #PlayerList == 0 then
        dropdown.Text = "Ga Ada Player"
        return
    end
    local index = table.find(PlayerList, SelectedPlayer) or 0
    index = (index % #PlayerList) + 1
    SelectedPlayer = PlayerList[index]
    dropdown.Text = "Target: " .. SelectedPlayer
end)

-- Fungsi Steal Buah Acak
button.MouseButton1Click:Connect(function()
    if not SelectedPlayer then
        button.Text = "Pilih Player!"
        return
    end

    local Target = game.Players:FindFirstChild(SelectedPlayer)
    if not Target then
        button.Text = "Player Keluar"
        return
    end

    -- Ambil semua buah dari backpack player target
    local backpackData = Remote:InvokeServer({
        Type = "Inventory",
        Data = {
            Target = Target,
            Action = "Get"
        }
    })

    if not backpackData or not backpackData.Fruit then
        button.Text = "Gagal Ambil Data"
        return
    end

    local fruits = backpackData.Fruit
    local keys = {}
    for k in pairs(fruits) do table.insert(keys, k) end

    if #keys == 0 then
        button.Text = "Backpack Kosong"
        return
    end

    -- Pilih random buah
    local chosen = keys[math.random(1, #keys)]
    local fruitData = fruits[chosen]

    -- Inject buah itu ke inventory kamu
    Remote:InvokeServer({
        Type = "Inventory",
        Data = {
            Action = "Add",
            Item = {
                Name = fruitData.Name,
                Type = "Fruit",
                Level = fruitData.Level or 1,
                Rarity = fruitData.Rarity or "Common",
                Age = fruitData.Age or 0
            }
        }
    })

    button.Text = "Berhasil: " .. fruitData.Name
    task.delay(2, function() button.Text = "STEAL RANDOM FRUIT" end)
end)
