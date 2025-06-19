-- ESP Egg, Auto Hop Server, dan Ganti Pet dalam Egg (Grow A Garden Simulator)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Fungsi untuk menampilkan ESP (Extra Sensory Perception)
local function createESP(part)
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Parent = part
    espBox.Adornee = part
    espBox.Size = part.Size
    espBox.Color3 = Color3.fromRGB(255, 255, 0) -- Warna kuning untuk Egg
    espBox.Transparency = 0.5
    espBox.ZIndex = 10
    espBox.Visible = true
    espBox.AlwaysOnTop = true
end

-- Fungsi untuk ESP Egg di sekitar
local function espEggs()
    for _, part in pairs(workspace:GetChildren()) do
        if part:IsA("Part") and part.Name == "Egg" then
            createESP(part) -- Menambahkan ESP ke semua Egg yang ditemukan
        end
    end
end

-- Auto Server Hop Function
local function hopServer()
    local currentServerId = game.JobId
    local joinedServer = false

    -- Pencarian server baru dengan Egg yang bagus
    while not joinedServer do
        local serverList = game:GetService("Players"):GetPlayers()
        
        for _, server in ipairs(serverList) do
            if server.UserId ~= player.UserId then
                local success, errorMsg = pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.JobId, player)
                end)

                if success then
                    print("Server Hop sukses!")
                    joinedServer = true
                    break
                else
                    print("Gagal join server: " .. errorMsg)
                end
            end
        end
        wait(5) -- Cek setiap 5 detik
    end
end

-- Fungsi untuk auto-ganti isi pet dalam Egg
local function changeEggPet()
    -- Contoh placeholder fungsi. Biasanya server yang tentukan isi Egg.
    -- Gak bisa langsung ubah pet di Egg, tapi kita bisa pindah server untuk mendapatkan pet yang baru
    hopServer() -- Pindah server secara otomatis untuk mendapatkan pet berbeda di Egg
end

-- Menampilkan tombol untuk merubah pet dan meng-hopping server
local function createUI()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "EggSpawnerUI"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5

    local hopButton = Instance.new("TextButton", frame)
    hopButton.Size = UDim2.new(1, 0, 0.5, 0)
    hopButton.Position = UDim2.new(0, 0, 0, 0)
    hopButton.Text = "Auto Hop Server"
    hopButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopButton.MouseButton1Click:Connect(function()
        hopServer()
    end)

    local changePetButton = Instance.new("TextButton", frame)
    changePetButton.Size = UDim2.new(1, 0, 0.5, 0)
    changePetButton.Position = UDim2.new(0, 0, 0.5, 0)
    changePetButton.Text = "Ganti Pet di Egg"
    changePetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 150)
    changePetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    changePetButton.MouseButton1Click:Connect(function()
        changeEggPet()
    end)
end

-- Memulai fungsi ESP Egg
espEggs()

-- Membuat GUI untuk interaksi
createUI()
