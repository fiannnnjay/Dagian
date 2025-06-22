-- GUI manual buatan sendiri (no Rayfield)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "StealGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Steal Fruit GUI"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Dropdown = Instance.new("TextButton", Frame)
Dropdown.Size = UDim2.new(1, -20, 0, 30)
Dropdown.Position = UDim2.new(0, 10, 0, 40)
Dropdown.Text = "Pilih Player"
Dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Dropdown.TextColor3 = Color3.new(1,1,1)
Dropdown.Font = Enum.Font.SourceSans
Dropdown.TextSize = 16

local PlayerList = {}
local SelectedPlayer = nil

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -20, 0, 30)
Button.Position = UDim2.new(0, 10, 0, 80)
Button.Text = "STEAL FRUIT"
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16

-- Update Player List
local function updatePlayerList()
    PlayerList = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
end

updatePlayerList()

-- Saat klik Dropdown -> Ganti target player
Dropdown.MouseButton1Click:Connect(function()
    updatePlayerList()
    if #PlayerList == 0 then
        Dropdown.Text = "Ga Ada Player"
        return
    end

    local index = table.find(PlayerList, SelectedPlayer) or 0
    index = (index % #PlayerList) + 1
    SelectedPlayer = PlayerList[index]
    Dropdown.Text = "Target: " .. SelectedPlayer
end)

-- Saat klik STEAL
Button.MouseButton1Click:Connect(function()
    if not SelectedPlayer then
        Button.Text = "Pilih Player Dulu"
        return
    end

    local Target = game.Players:FindFirstChild(SelectedPlayer)
    if not Target then
        Button.Text = "Player Keluar"
        return
    end

    -- Ambil remote game
    local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
    if not Remote then
        Button.Text = "Remote Tidak Ada"
        return
    end

    -- Teleport paksa target
    pcall(function()
        Target.Character:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
    end)

    -- Kirim Gift Buah Palsu
    for i = 1, 8 do
        Remote:FireServer({
            ["Type"] = "Gift",
            ["Data"] = {
                ["Type"] = "Fruit",
                ["Receiver"] = game.Players.LocalPlayer,
                ["Sender"] = Target
            }
        })
        task.wait(0.1)
    end

    Button.Text = "Selesai!"
    task.delay(2, function() Button.Text = "STEAL FRUIT" end)
end)
