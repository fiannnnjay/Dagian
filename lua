-- Universal FPS Premium GUI
-- Works across most Roblox FPS games
-- Press RightShift to toggle GUI

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- Universal Installation Check
if not getgenv then
    warn("This script requires an exploit environment to function properly.")
    warn("Please use a supported executor like Synapse X, Script-Ware, or Krnl.")
    return
end

-- Global Settings
getgenv().AimbotEnabled = false
getgenv().AimbotKey = Enum.UserInputType.MouseButton2
getgenv().TargetPart = "Head"
getgenv().Smoothness = 0.5
getgenv().FOV = 100
getgenv().ESPEnabled = false
getgenv().MagicBullet = false
getgenv().NoRecoil = false
getgenv().NoSpread = false
getgenv().RapidFire = false

-- Core Functions
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = getgenv().FOV
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild(getgenv().TargetPart) then
            local targetPos = target.Character[getgenv().TargetPart].Position
            local vector, onScreen = camera:WorldToViewportPoint(targetPos)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(vector.X, vector.Y)).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = target
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

local function AimAt(target)
    if target and target.Character and target.Character:FindFirstChild(getgenv().TargetPart) then
        local targetPos = target.Character[getgenv().TargetPart].Position
        local camPos = camera.CFrame.Position
        local direction = (targetPos - camPos).Unit
        
        local currentLook = camera.CFrame.LookVector
        local newLook = currentLook:Lerp(direction, 1 - getgenv().Smoothness)
        
        camera.CFrame = CFrame.new(camPos, camPos + newLook)
    end
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalFPSGUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "UNIVERSAL FPS TOOLS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Aimbot Section
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Size = UDim2.new(0.9, 0, 0, 25)
AimbotToggle.Position = UDim2.new(0.05, 0, 0, 40)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AimbotToggle.Text = "AIMBOT: OFF"
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.TextSize = 14
AimbotToggle.Parent = MainFrame

local TargetSelection = Instance.new("TextButton")
TargetSelection.Name = "TargetSelection"
TargetSelection.Size = UDim2.new(0.9, 0, 0, 25)
TargetSelection.Position = UDim2.new(0.05, 0, 0, 70)
TargetSelection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetSelection.Text = "TARGET: HEAD"
TargetSelection.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetSelection.Font = Enum.Font.Gotham
TargetSelection.TextSize = 14
TargetSelection.Parent = MainFrame

local SmoothnessLabel = Instance.new("TextLabel")
SmoothnessLabel.Name = "SmoothnessLabel"
SmoothnessLabel.Size = UDim2.new(0.9, 0, 0, 20)
SmoothnessLabel.Position = UDim2.new(0.05, 0, 0, 100)
SmoothnessLabel.BackgroundTransparency = 1
SmoothnessLabel.Text = "SMOOTHNESS: 50%"
SmoothnessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothnessLabel.Font = Enum.Font.Gotham
SmoothnessLabel.TextSize = 12
SmoothnessLabel.TextXAlignment = Enum.TextXAlignment.Left
SmoothnessLabel.Parent = MainFrame

local SmoothnessSlider = Instance.new("Frame")
SmoothnessSlider.Name = "SmoothnessSlider"
SmoothnessSlider.Size = UDim2.new(0.9, 0, 0, 5)
SmoothnessSlider.Position = UDim2.new(0.05, 0, 0, 120)
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SmoothnessSlider.Parent = MainFrame

local SmoothnessFill = Instance.new("Frame")
SmoothnessFill.Name = "SmoothnessFill"
SmoothnessFill.Size = UDim2.new(0.5, 0, 1, 0)
SmoothnessFill.Position = UDim2.new(0, 0, 0, 0)
SmoothnessFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SmoothnessFill.BorderSizePixel = 0
SmoothnessFill.Parent = SmoothnessSlider

-- Visuals Section
local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(0.9, 0, 0, 25)
ESPToggle.Position = UDim2.new(0.05, 0, 0, 140)
ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = MainFrame

-- Combat Section
local MagicBulletToggle = Instance.new("TextButton")
MagicBulletToggle.Name = "MagicBulletToggle"
MagicBulletToggle.Size = UDim2.new(0.9, 0, 0, 25)
MagicBulletToggle.Position = UDim2.new(0.05, 0, 0, 170)
MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MagicBulletToggle.Text = "MAGIC BULLET: OFF"
MagicBulletToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MagicBulletToggle.Font = Enum.Font.Gotham
MagicBulletToggle.TextSize = 14
MagicBulletToggle.Parent = MainFrame

local NoRecoilToggle = Instance.new("TextButton")
NoRecoilToggle.Name = "NoRecoilToggle"
NoRecoilToggle.Size = UDim2.new(0.9, 0, 0, 25)
NoRecoilToggle.Position = UDim2.new(0.05, 0, 0, 200)
NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoRecoilToggle.Text = "NO RECOIL: OFF"
NoRecoilToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRecoilToggle.Font = Enum.Font.Gotham
NoRecoilToggle.TextSize = 14
NoRecoilToggle.Parent = MainFrame

local NoSpreadToggle = Instance.new("TextButton")
NoSpreadToggle.Name = "NoSpreadToggle"
NoSpreadToggle.Size = UDim2.new(0.9, 0, 0, 25)
NoSpreadToggle.Position = UDim2.new(0.05, 0, 0, 230)
NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoSpreadToggle.Text = "NO SPREAD: OFF"
NoSpreadToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSpreadToggle.Font = Enum.Font.Gotham
NoSpreadToggle.TextSize = 14
NoSpreadToggle.Parent = MainFrame

local RapidFireToggle = Instance.new("TextButton")
RapidFireToggle.Name = "RapidFireToggle"
RapidFireToggle.Size = UDim2.new(0.9, 0, 0, 25)
RapidFireToggle.Position = UDim2.new(0.05, 0, 0, 260)
RapidFireToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
RapidFireToggle.Text = "RAPID FIRE: OFF"
RapidFireToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
RapidFireToggle.Font = Enum.Font.Gotham
RapidFireToggle.TextSize = 14
RapidFireToggle.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.9, 0, 0, 25)
CloseButton.Position = UDim2.new(0.05, 0, 0, 300)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "CLOSE"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

-- Toggle GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Aimbot Toggle
AimbotToggle.MouseButton1Click:Connect(function()
    getgenv().AimbotEnabled = not getgenv().AimbotEnabled
    
    if getgenv().AimbotEnabled then
        AimbotToggle.Text = "AIMBOT: ON"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        
        RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local closest = GetClosestPlayer()
                if closest then
                    AimAt(closest)
                end
            end
        end)
    else
        AimbotToggle.Text = "AIMBOT: OFF"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- Target Selection
TargetSelection.MouseButton1Click:Connect(function()
    if getgenv().TargetPart == "Head" then
        getgenv().TargetPart = "HumanoidRootPart"
        TargetSelection.Text = "TARGET: BODY"
    else
        getgenv().TargetPart = "Head"
        TargetSelection.Text = "TARGET: HEAD"
    end
end)

-- Smoothness Slider
local smoothnessDragging = false
SmoothnessSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothnessDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothnessDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if smoothnessDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local x = input.Position.X - SmoothnessSlider.AbsolutePosition.X
        local percent = math.clamp(x / SmoothnessSlider.AbsoluteSize.X, 0.1, 0.9)
        
        getgenv().Smoothness = 1 - percent
        SmoothnessFill.Size = UDim2.new(percent, 0, 1, 0)
        SmoothnessLabel.Text = "SMOOTHNESS: " .. math.floor(percent * 100) .. "%"
    end
end)

-- ESP Toggle
ESPToggle.MouseButton1Click:Connect(function()
    getgenv().ESPEnabled = not getgenv().ESPEnabled
    
    if getgenv().ESPEnabled then
        ESPToggle.Text = "ESP: ON"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        -- ESP implementation would go here
    else
        ESPToggle.Text = "ESP: OFF"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        -- Clean up ESP elements
    end
end)

-- Magic Bullet Toggle
MagicBulletToggle.MouseButton1Click:Connect(function()
    getgenv().MagicBullet = not getgenv().MagicBullet
    
    if getgenv().MagicBullet then
        MagicBulletToggle.Text = "MAGIC BULLET: ON"
        MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        -- Magic bullet implementation
    else
        MagicBulletToggle.Text = "MAGIC BULLET: OFF"
        MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- No Recoil Toggle
NoRecoilToggle.MouseButton1Click:Connect(function()
    getgenv().NoRecoil = not getgenv().NoRecoil
    
    if getgenv().NoRecoil then
        NoRecoilToggle.Text = "NO RECOIL: ON"
        NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        -- No recoil implementation
    else
        NoRecoilToggle.Text = "NO RECOIL: OFF"
        NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- No Spread Toggle
NoSpreadToggle.MouseButton1Click:Connect(function()
    getgenv().NoSpread = not getgenv().NoSpread
    
    if getgenv().NoSpread then
        NoSpreadToggle.Text = "NO SPREAD: ON"
        NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        -- No spread implementation
    else
        NoSpreadToggle.Text = "NO SPREAD: OFF"
        NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- Rapid Fire Toggle
RapidFireToggle.MouseButton1Click:Connect(function()
    getgenv().RapidFire = not getgenv().RapidFire
    
    if getgenv().RapidFire then
        RapidFireToggle.Text = "RAPID FIRE: ON"
        RapidFireToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        -- Rapid fire implementation
    else
        RapidFireToggle.Text = "RAPID FIRE: OFF"
        RapidFireToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Initialization
warn("Universal FPS Tools loaded! Press RightShift to toggle GUI.")
