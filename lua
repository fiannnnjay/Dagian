-- ✅ Grow A Garden Pet Duplicator GUI
-- GUI Tampilan seperti TikTok: Duplicate Craft

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetDuplicatorGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "DUPLICATE PET CRAFT EVENT"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.TextScaled = true
\local petInfo = Instance.new("TextLabel", frame)
petInfo.Size = UDim2.new(1, 0, 0, 30)
petInfo.Position = UDim2.new(0, 0, 0, 30)
petInfo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
petInfo.TextColor3 = Color3.new(1, 1, 1)
petInfo.TextScaled = true

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Text = "DUPLICATE NOW"
spawnBtn.Size = UDim2.new(1, 0, 0, 40)
spawnBtn.Position = UDim2.new(0, 0, 0, 75)
spawnBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
spawnBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
spawnBtn.TextScaled = true
spawnBtn.Active = false

-- Toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 150, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "🧬 Open Spawner"
toggleBtn.TextScaled = true

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Check tool & update info
RunService.RenderStepped:Connect(function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name then
        local name = tool.Name
        local desc = tool:FindFirstChild("Description")
        local weight = name:match("%[(.-)KG%]") or "?"
        local age = name:match("Age (%d+)") or "?"
        petInfo.Text = name
        spawnBtn.Active = true
        spawnBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    else
        petInfo.Text = "No Pet Detected"
        spawnBtn.Active = false
        spawnBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- On spawn click
spawnBtn.MouseButton1Click:Connect(function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local clone = tool:Clone()
        clone.Parent = player.Backpack
    end
end)
