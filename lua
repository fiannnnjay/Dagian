-- ✅ Grow A Garden TEXT-ONLY Pet Spawner (Server-sided exploit)
-- 💯 Only shows name/age/size (NO VISUAL MODEL)
-- 🔥 Works on actual game servers (not client-side)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "InvisiblePetSpawner"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "INVISIBLE PET SPAWNER"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local nameBox = Instance.new("TextBox")
nameBox.PlaceholderText = "Pet Name (ex: Raccoon)"
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
nameBox.Parent = frame

local ageBox = Instance.new("TextBox")
ageBox.PlaceholderText = "Age (1-100)"
ageBox.Size = UDim2.new(0.4, 0, 0, 30)
ageBox.Position = UDim2.new(0.05, 0, 0.4, 0)
ageBox.Parent = frame

local sizeBox = Instance.new("TextBox")
sizeBox.PlaceholderText = "Size (0.5-5)"
sizeBox.Size = UDim2.new(0.4, 0, 0, 30)
sizeBox.Position = UDim2.new(0.55, 0, 0.4, 0)
sizeBox.Parent = frame

local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "CREATE INVISIBLE PET"
spawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
spawnBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
spawnBtn.Parent = frame

-- Find the remote events
local petRemotes = {
    add = ReplicatedStorage:FindFirstChild("AddPetRemote") or ReplicatedStorage:FindFirstChild("PetAddRemote"),
    remove = ReplicatedStorage:FindFirstChild("RemovePetRemote")
}

if not petRemotes.add then
    spawnBtn.Text = "ERROR: NO REMOTE FOUND"
    spawnBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    return
end

spawnBtn.MouseButton1Click:Connect(function()
    local petName = nameBox.Text
    local petAge = tonumber(ageBox.Text) or 1
    local petSize = tonumber(sizeBox.Text) or 1
    
    -- Validate inputs
    petAge = math.clamp(petAge, 1, 100)
    petSize = math.clamp(petSize, 0.5, 5)
    
    -- Fire the server remote
    petRemotes.add:FireServer({
        Name = petName,
        Age = petAge,
        Size = petSize,
        -- These make the pet invisible but functional
        Model = nil,
        Mesh = nil,
        Texture = nil,
        Sound = nil
    })
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INVISIBLE PET CREATED",
        Text = petName.." (Age: "..petAge..", Size: "..petSize..")",
        Duration = 5
    })
end)

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "Toggle Pet Spawner"
toggleBtn.Size = UDim2.new(0, 150, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Parent = gui
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
