local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")

-- GUI Setup
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "BrainrotStealer"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Toggle Button
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.Text = "Sembunyikan GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)

-- Steal Button
local stealBtn = Instance.new("TextButton", frame)
stealBtn.Size = UDim2.new(1, -20, 0, 40)
stealBtn.Position = UDim2.new(0, 10, 0, 40)
stealBtn.Text = "🔪 Steal Brainrot"
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealBtn.TextColor3 = Color3.new(1, 1, 1)

-- Speed Toggle
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 90)
speedBtn.Text = "🏃 Lari Cepat: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
speedBtn.TextColor3 = Color3.new(1, 1, 1)

-- Cooldown + Steal Function
local cooldown = false
stealBtn.MouseButton1Click:Connect(function()
    if cooldown then return end
    local tool = Char:FindFirstChildOfClass("Tool")
    if tool then
        local base = workspace:FindFirstChild("Base_" .. Player.Name)
        if base then
            tool.Parent = base
            print("Item dicuri!")
        end
    end
    cooldown = true
    stealBtn.Text = "⏳ Cooldown..."
    task.delay(5, function()
        cooldown = false
        stealBtn.Text = "🔪 Steal Brainrot"
    end)
end)

-- Speed Toggle Function
local isFast = false
speedBtn.MouseButton1Click:Connect(function()
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if hum then
        isFast = not isFast
        hum.WalkSpeed = isFast and 50 or 16
        speedBtn.Text = isFast and "🏃 Lari Cepat: ON" or "🏃 Lari Cepat: OFF"
    end
end)

-- Toggle GUI
local hidden = false
toggleButton.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _, v in ipairs(frame:GetChildren()) do
        if v:IsA("TextButton") and v ~= toggleButton then
            v.Visible = not hidden
        end
    end
    toggleButton.Text = hidden and "Tampilkan GUI" or "Sembunyikan GUI"
end)
