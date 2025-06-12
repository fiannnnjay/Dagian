-- Config
local FOLLOW_SPEED = 5
local GROWTH_TIME = 10
local HOTKEY = Enum.KeyCode.F3

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Main GUI Function
local function createGardenGUI()
    -- ScreenGui (using CoreGui for executor compatibility)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaGarden"
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(53, 107, 60)
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 120, 0, 40)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.Text = "🌿 Buka Kebun"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(76, 153, 85)
    toggleBtn.TextColor3 = Color3.white
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.Parent = screenGui
    
    -- Tab Buttons
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame
    
    local petsTab = Instance.new("TextButton")
    petsTab.Name = "PetsTab"
    petsTab.Size = UDim2.new(0.5, 0, 1, 0)
    petsTab.Text = "🌻 Tanaman"
    petsTab.BackgroundColor3 = Color3.fromRGB(86, 147, 93)
    petsTab.TextColor3 = Color3.white
    petsTab.Font = Enum.Font.SourceSansBold
    petsTab.Parent = tabFrame
    
    local seedsTab = Instance.new("TextButton")
    seedsTab.Name = "SeedsTab"
    seedsTab.Size = UDim2.new(0.5, 0, 1, 0)
    seedsTab.Position = UDim2.new(0.5, 0, 0, 0)
    seedsTab.Text = "🌱 Benih"
    seedsTab.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
    seedsTab.TextColor3 = Color3.white
    seedsTab.Font = Enum.Font.SourceSansBold
    seedsTab.Parent = tabFrame
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Pets Scroll Frame
    local petsScroll = Instance.new("ScrollingFrame")
    petsScroll.Name = "PetsScroll"
    petsScroll.Size = UDim2.new(1, 0, 1, 0)
    petsScroll.BackgroundTransparency = 1
    petsScroll.ScrollBarThickness = 6
    petsScroll.Visible = true
    petsScroll.Parent = contentFrame
    
    local petsLayout = Instance.new("UIListLayout")
    petsLayout.Padding = UDim.new(0, 10)
    petsLayout.Parent = petsScroll
    
    -- Seeds Scroll Frame
    local seedsScroll = Instance.new("ScrollingFrame")
    seedsScroll.Name = "SeedsScroll"
    seedsScroll.Size = UDim2.new(1, 0, 1, 0)
    seedsScroll.BackgroundTransparency = 1
    seedsScroll.ScrollBarThickness = 6
    seedsScroll.Visible = false
    seedsScroll.Parent = contentFrame
    
    local seedsLayout = Instance.new("UIListLayout")
    seedsLayout.Padding = UDim.new(0, 10)
    seedsLayout.Parent = seedsScroll
    
    -- Garden Data
    local gardenData = {
        Pets = {
            {Name = "🌻 Bunga Matahari", Rarity = "Biasa", Color = Color3.fromRGB(255, 215, 0)},
            {Name = "🌹 Mawar", Rarity = "Langka", Color = Color3.fromRGB(255, 0, 0)},
            {Name = "🌵 Kaktus", Rarity = "Epik", Color = Color3.fromRGB(0, 120, 0)}
        },
        Seeds = {
            {Name = "🌱 Benih Matahari", Rarity = "Biasa", Color = Color3.fromRGB(139, 69, 19)},
            {Name = "🌱 Benih Mawar", Rarity = "Langka", Color = Color3.fromRGB(200, 50, 50)},
            {Name = "🌱 Benih Kaktus", Rarity = "Epik", Color = Color3.fromRGB(100, 150, 50)}
        }
    }
    
    -- Create Plant Function
    local function createPlant(name, color)
        local plant = Instance.new("Part")
        plant.Name = name
        plant.Size = Vector3.new(2, 3, 2)
        plant.Color = color
        plant.Anchored = false
        plant.CanCollide = true
        plant.Position = character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 0, -5)
        plant.Parent = workspace
        
        -- Growth over time
        coroutine.wrap(function()
            for i = 1, 3 do
                wait(GROWTH_TIME)
                plant.Size = plant.Size * 1.2
            end
        end)()
        
        -- Follow player
        coroutine.wrap(function()
            while plant and plant.Parent do
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = (hrp.Position - plant.Position).Unit * FOLLOW_SPEED
                    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyVelocity.Parent = plant
                    RunService.Heartbeat:Wait()
                    bodyVelocity:Destroy()
                end
                wait(0.1)
            end
        end)()
        
        print("Tanaman "..name.." telah dibuat!")
    end
    
    -- Create Seed Function
    local function createSeed(name, color)
        local seed = Instance.new("Part")
        seed.Name = name
        seed.Size = Vector3.new(0.5, 0.5, 0.5)
        seed.Color = color
        seed.Anchored = false
        seed.CanCollide = true
        seed.Position = character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 0, -3)
        seed.Parent = workspace
        
        -- Plant seed when touches ground
        seed.Touched:Connect(function(hit)
            if hit.Name == "Terrain" or hit:IsA("BasePart") then
                seed:Destroy()
                wait(3)
                createPlant("Tanaman "..name:sub(5), color)
            end
        end)
        
        print("Benih "..name.." telah dibuat!")
    end
    
    -- Create Item Buttons
    local function createButton(itemData, parent, isSeed)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 60)
        btn.Position = UDim2.new(0.05, 0, 0, 0)
        btn.Text = itemData.Name.."\n⭐ "..itemData.Rarity
        btn.BackgroundColor3 = isSeed and Color3.fromRGB(86, 137, 93) or itemData.Color
        btn.TextColor3 = Color3.white
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        
        btn.MouseButton1Click:Connect(function()
            if isSeed then
                createSeed(itemData.Name, itemData.Color)
            else
                createPlant(itemData.Name, itemData.Color)
            end
        end)
        
        btn.Parent = parent
    end
    
    -- Populate Lists
    for _, pet in ipairs(gardenData.Pets) do
        createButton(pet, petsScroll, false)
    end
    
    for _, seed in ipairs(gardenData.Seeds) do
        createButton(seed, seedsScroll, true)
    end
    
    -- Tab Switching
    petsTab.MouseButton1Click:Connect(function()
        petsScroll.Visible = true
        seedsScroll.Visible = false
        petsTab.BackgroundColor3 = Color3.fromRGB(86, 147, 93)
        seedsTab.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
    end)
    
    seedsTab.MouseButton1Click:Connect(function()
        petsScroll.Visible = false
        seedsScroll.Visible = true
        petsTab.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
        seedsTab.BackgroundColor3 = Color3.fromRGB(86, 147, 93)
    end)
    
    -- Toggle GUI
    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        toggleBtn.Text = mainFrame.Visible and "❌ Tutup Kebun" or "🌿 Buka Kebun"
    end)
    
    -- Auto-resize scroll frames
    petsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        petsScroll.CanvasSize = UDim2.new(0, 0, 0, petsLayout.AbsoluteContentSize.Y)
    end)
    
    seedsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        seedsScroll.CanvasSize = UDim2.new(0, 0, 0, seedsLayout.AbsoluteContentSize.Y)
    end)
    
    -- Hotkey
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == HOTKEY and not gameProcessed then
            mainFrame.Visible = not mainFrame.Visible
            toggleBtn.Text = mainFrame.Visible and "❌ Tutup Kebun" or "🌿 Buka Kebun"
        end
    end)
    
    return screenGui
end

-- Initialize
createGardenGUI()
print("Garden GUI berhasil di-load! Tekan F3 untuk membuka/menutup")
