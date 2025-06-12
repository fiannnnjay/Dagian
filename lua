local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GardenManager"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(53, 107, 60)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 1, -60)
toggleButton.Text = "Open Garden"
toggleButton.BackgroundColor3 = Color3.fromRGB(76, 153, 85)
toggleButton.TextColor3 = Color3.white
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

-- Tab System
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Name = "TabButtons"
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local petsTabButton = Instance.new("TextButton")
petsTabButton.Name = "PetsTab"
petsTabButton.Size = UDim2.new(0.5, 0, 1, 0)
petsTabButton.Text = "Pets"
petsTabButton.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
petsTabButton.TextColor3 = Color3.white
petsTabButton.Font = Enum.Font.SourceSansBold
petsTabButton.Parent = tabButtonsFrame

local seedsTabButton = Instance.new("TextButton")
seedsTabButton.Name = "SeedsTab"
seedsTabButton.Size = UDim2.new(0.5, 0, 1, 0)
seedsTabButton.Position = UDim2.new(0.5, 0, 0, 0)
seedsTabButton.Text = "Seeds"
seedsTabButton.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
seedsTabButton.TextColor3 = Color3.white
seedsTabButton.Font = Enum.Font.SourceSansBold
seedsTabButton.Parent = tabButtonsFrame

-- Content Frames
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Pets Tab Content
local petsFrame = Instance.new("ScrollingFrame")
petsFrame.Name = "PetsFrame"
petsFrame.Size = UDim2.new(1, 0, 1, 0)
petsFrame.BackgroundTransparency = 1
petsFrame.ScrollBarThickness = 6
petsFrame.Visible = true
petsFrame.Parent = contentFrame

local petsListLayout = Instance.new("UIListLayout")
petsListLayout.Name = "PetsListLayout"
petsListLayout.Padding = UDim.new(0, 10)
petsListLayout.Parent = petsFrame

-- Seeds Tab Content
local seedsFrame = Instance.new("ScrollingFrame")
seedsFrame.Name = "SeedsFrame"
seedsFrame.Size = UDim2.new(1, 0, 1, 0)
seedsFrame.BackgroundTransparency = 1
seedsFrame.ScrollBarThickness = 6
seedsFrame.Visible = false
seedsFrame.Parent = contentFrame

local seedsListLayout = Instance.new("UIListLayout")
seedsListLayout.Name = "SeedsListLayout"
seedsListLayout.Padding = UDim.new(0, 10)
seedsListLayout.Parent = seedsFrame

-- Available Pets and Seeds Data
local gardenData = {
    Pets = {
        {Name = "Sunflower Pet", Rarity = "Common", SpawnFunction = function() spawnSunflowerPet() end},
        {Name = "Rose Pet", Rarity = "Uncommon", SpawnFunction = function() spawnRosePet() end},
        {Name = "Cactus Pet", Rarity = "Rare", SpawnFunction = function() spawnCactusPet() end}
    },
    Seeds = {
        {Name = "Sunflower Seed", Rarity = "Common", SpawnFunction = function() spawnSunflowerSeed() end},
        {Name = "Rose Seed", Rarity = "Uncommon", SpawnFunction = function() spawnRoseSeed() end},
        {Name = "Cactus Seed", Rarity = "Rare", SpawnFunction = function() spawnCactusSeed() end}
    }
}

-- Create Pet Spawn Functions
function spawnSunflowerPet()
    local pet = Instance.new("Model")
    pet.Name = "SunflowerPet"
    
    local stem = Instance.new("Part")
    stem.Name = "Stem"
    stem.Size = Vector3.new(1, 3, 1)
    stem.Color = Color3.fromRGB(0, 150, 0)
    stem.Anchored = false
    stem.CanCollide = true
    stem.Parent = pet
    
    local flower = Instance.new("Part")
    flower.Name = "Flower"
    flower.Size = Vector3.new(3, 1, 3)
    flower.Color = Color3.fromRGB(255, 215, 0)
    flower.Position = stem.Position + Vector3.new(0, 2, 0)
    flower.Parent = pet
    
    pet.PrimaryPart = stem
    pet.Parent = workspace
    
    setupPetMovement(pet)
end

function spawnRosePet()
    -- Similar implementation for rose pet
end

function spawnCactusPet()
    -- Similar implementation for cactus pet
end

-- Create Seed Spawn Functions
function spawnSunflowerSeed()
    local seed = Instance.new("Part")
    seed.Name = "SunflowerSeed"
    seed.Size = Vector3.new(0.5, 0.5, 0.5)
    seed.Color = Color3.fromRGB(139, 69, 19)
    seed.Anchored = false
    seed.CanCollide = true
    seed.Parent = workspace
    
    -- Add seed planting logic here
end

function spawnRoseSeed()
    -- Similar implementation for rose seed
end

function spawnCactusSeed()
    -- Similar implementation for cactus seed
end

-- Pet Movement Function
function setupPetMovement(pet)
    -- Similar to previous movement implementation
end

-- Populate GUI with items
local function createItemButton(itemData, parentFrame)
    local button = Instance.new("TextButton")
    button.Name = itemData.Name .. "Button"
    button.Size = UDim2.new(0.9, 0, 0, 60)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.Text = itemData.Name .. "\n(" .. itemData.Rarity .. ")"
    button.BackgroundColor3 = Color3.fromRGB(86, 137, 93)
    button.TextColor3 = Color3.white
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    
    button.MouseButton1Click:Connect(function()
        itemData.SpawnFunction()
        print("Spawned: " .. itemData.Name)
    end)
    
    button.Parent = parentFrame
    return button
end

-- Populate Pets Tab
for _, petData in ipairs(gardenData.Pets) do
    createItemButton(petData, petsFrame)
end

-- Populate Seeds Tab
for _, seedData in ipairs(gardenData.Seeds) do
    createItemButton(seedData, seedsFrame)
end

-- Tab Switching Logic
petsTabButton.MouseButton1Click:Connect(function()
    petsFrame.Visible = true
    seedsFrame.Visible = false
    petsTabButton.BackgroundColor3 = Color3.fromRGB(86, 147, 93)
    seedsTabButton.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
end)

seedsTabButton.MouseButton1Click:Connect(function()
    petsFrame.Visible = false
    seedsFrame.Visible = true
    petsTabButton.BackgroundColor3 = Color3.fromRGB(66, 117, 73)
    seedsTabButton.BackgroundColor3 = Color3.fromRGB(86, 147, 93)
end)

-- Toggle GUI Visibility
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "Close Garden" or "Open Garden"
end)

-- Adjust scrolling frame sizes when content changes
petsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    petsFrame.CanvasSize = UDim2.new(0, 0, 0, petsListLayout.AbsoluteContentSize.Y + 20)
end)

seedsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    seedsFrame.CanvasSize = UDim2.new(0, 0, 0, seedsListLayout.AbsoluteContentSize.Y + 20)
end)
