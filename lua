-- Premium FPS Shooter GUI
-- By [Your Name]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFPSGUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Text = "PREMIUM FPS TOOLS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tabs
local TabButtons = {}
local TabFrames = {}

local function CreateTab(name, position)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.Size = UDim2.new(0.33, -10, 0, 30)
    tabButton.Position = position
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.Parent = MainFrame
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name .. "TabFrame"
    tabFrame.Size = UDim2.new(1, -20, 1, -80)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = MainFrame
    
    TabButtons[name] = tabButton
    TabFrames[name] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        tabFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
end

CreateTab("Aimbot", UDim2.new(0, 5, 0, 40))
CreateTab("Visuals", UDim2.new(0.33, 5, 0, 40))
CreateTab("Misc", UDim2.new(0.66, 5, 0, 40))

-- Activate first tab
TabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(60, 60, 80)
TabFrames["Aimbot"].Visible = true

-- Aimbot Tab
local AimbotTab = TabFrames["Aimbot"]

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Size = UDim2.new(1, 0, 0, 30)
AimbotToggle.Position = UDim2.new(0, 0, 0, 0)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AimbotToggle.Text = "Aimbot [OFF]"
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.TextSize = 14
AimbotToggle.Parent = AimbotTab

local AimbotKeybind = Instance.new("TextButton")
AimbotKeybind.Name = "AimbotKeybind"
AimbotKeybind.Size = UDim2.new(1, 0, 0, 30)
AimbotKeybind.Position = UDim2.new(0, 0, 0, 40)
AimbotKeybind.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AimbotKeybind.Text = "Keybind: Right Mouse Button"
AimbotKeybind.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotKeybind.Font = Enum.Font.Gotham
AimbotKeybind.TextSize = 14
AimbotKeybind.Parent = AimbotTab

local TargetPart = Instance.new("TextLabel")
TargetPart.Name = "TargetPartLabel"
TargetPart.Size = UDim2.new(1, 0, 0, 20)
TargetPart.Position = UDim2.new(0, 0, 0, 80)
TargetPart.BackgroundTransparency = 1
TargetPart.Text = "Target Part: Head"
TargetPart.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetPart.Font = Enum.Font.Gotham
TargetPart.TextSize = 14
TargetPart.TextXAlignment = Enum.TextXAlignment.Left
TargetPart.Parent = AimbotTab

local HeadButton = Instance.new("TextButton")
HeadButton.Name = "HeadButton"
HeadButton.Size = UDim2.new(0.48, 0, 0, 25)
HeadButton.Position = UDim2.new(0, 0, 0, 105)
HeadButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
HeadButton.Text = "Head"
HeadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadButton.Font = Enum.Font.Gotham
HeadButton.TextSize = 14
HeadButton.Parent = AimbotTab

local BodyButton = Instance.new("TextButton")
BodyButton.Name = "BodyButton"
BodyButton.Size = UDim2.new(0.48, 0, 0, 25)
BodyButton.Position = UDim2.new(0.52, 0, 0, 105)
BodyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
BodyButton.Text = "Body"
BodyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BodyButton.Font = Enum.Font.Gotham
BodyButton.TextSize = 14
BodyButton.Parent = AimbotTab

local SmoothnessLabel = Instance.new("TextLabel")
SmoothnessLabel.Name = "SmoothnessLabel"
SmoothnessLabel.Size = UDim2.new(1, 0, 0, 20)
SmoothnessLabel.Position = UDim2.new(0, 0, 0, 140)
SmoothnessLabel.BackgroundTransparency = 1
SmoothnessLabel.Text = "Smoothness: 50%"
SmoothnessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothnessLabel.Font = Enum.Font.Gotham
SmoothnessLabel.TextSize = 14
SmoothnessLabel.TextXAlignment = Enum.TextXAlignment.Left
SmoothnessLabel.Parent = AimbotTab

local SmoothnessSlider = Instance.new("TextButton")
SmoothnessSlider.Name = "SmoothnessSlider"
SmoothnessSlider.Size = UDim2.new(1, 0, 0, 20)
SmoothnessSlider.Position = UDim2.new(0, 0, 0, 165)
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SmoothnessSlider.Text = ""
SmoothnessSlider.Parent = AimbotTab

local SmoothnessFill = Instance.new("Frame")
SmoothnessFill.Name = "SmoothnessFill"
SmoothnessFill.Size = UDim2.new(0.5, 0, 1, 0)
SmoothnessFill.Position = UDim2.new(0, 0, 0, 0)
SmoothnessFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SmoothnessFill.BorderSizePixel = 0
SmoothnessFill.Parent = SmoothnessSlider

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Parent = ScreenGui

local FOVCircleOutline = Instance.new("ImageLabel")
FOVCircleOutline.Name = "FOVCircleOutline"
FOVCircleOutline.Size = UDim2.new(1, 0, 1, 0)
FOVCircleOutline.Position = UDim2.new(0, 0, 0, 0)
FOVCircleOutline.BackgroundTransparency = 1
FOVCircleOutline.Image = "rbxassetid://3570695787"
FOVCircleOutline.ImageColor3 = Color3.fromRGB(0, 150, 255)
FOVCircleOutline.ScaleType = Enum.ScaleType.Slice
FOVCircleOutline.SliceCenter = Rect.new(100, 100, 100, 100)
FOVCircleOutline.Parent = FOVCircle

local FOVToggle = Instance.new("TextButton")
FOVToggle.Name = "FOVToggle"
FOVToggle.Size = UDim2.new(1, 0, 0, 30)
FOVToggle.Position = UDim2.new(0, 0, 0, 195)
FOVToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FOVToggle.Text = "Show FOV [ON]"
FOVToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVToggle.Font = Enum.Font.Gotham
FOVToggle.TextSize = 14
FOVToggle.Parent = AimbotTab

local FOVSizeLabel = Instance.new("TextLabel")
FOVSizeLabel.Name = "FOVSizeLabel"
FOVSizeLabel.Size = UDim2.new(1, 0, 0, 20)
FOVSizeLabel.Position = UDim2.new(0, 0, 0, 235)
FOVSizeLabel.BackgroundTransparency = 1
FOVSizeLabel.Text = "FOV Size: 100"
FOVSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVSizeLabel.Font = Enum.Font.Gotham
FOVSizeLabel.TextSize = 14
FOVSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVSizeLabel.Parent = AimbotTab

local FOVSizeSlider = Instance.new("TextButton")
FOVSizeSlider.Name = "FOVSizeSlider"
FOVSizeSlider.Size = UDim2.new(1, 0, 0, 20)
FOVSizeSlider.Position = UDim2.new(0, 0, 0, 260)
FOVSizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FOVSizeSlider.Text = ""
FOVSizeSlider.Parent = AimbotTab

local FOVSizeFill = Instance.new("Frame")
FOVSizeFill.Name = "FOVSizeFill"
FOVSizeFill.Size = UDim2.new(0.5, 0, 1, 0)
FOVSizeFill.Position = UDim2.new(0, 0, 0, 0)
FOVSizeFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FOVSizeFill.BorderSizePixel = 0
FOVSizeFill.Parent = FOVSizeSlider

-- Visuals Tab
local VisualsTab = TabFrames["Visuals"]

local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Position = UDim2.new(0, 0, 0, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPToggle.Text = "ESP [OFF]"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = VisualsTab

local ESPColorLabel = Instance.new("TextLabel")
ESPColorLabel.Name = "ESPColorLabel"
ESPColorLabel.Size = UDim2.new(1, 0, 0, 20)
ESPColorLabel.Position = UDim2.new(0, 0, 0, 40)
ESPColorLabel.BackgroundTransparency = 1
ESPColorLabel.Text = "ESP Color:"
ESPColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorLabel.Font = Enum.Font.Gotham
ESPColorLabel.TextSize = 14
ESPColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPColorLabel.Parent = VisualsTab

local ESPColorPreview = Instance.new("Frame")
ESPColorPreview.Name = "ESPColorPreview"
ESPColorPreview.Size = UDim2.new(0, 50, 0, 20)
ESPColorPreview.Position = UDim2.new(0, 0, 0, 65)
ESPColorPreview.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ESPColorPreview.Parent = VisualsTab

local ESPColorRed = Instance.new("TextButton")
ESPColorRed.Name = "ESPColorRed"
ESPColorRed.Size = UDim2.new(0.3, 0, 0, 20)
ESPColorRed.Position = UDim2.new(0, 60, 0, 65)
ESPColorRed.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ESPColorRed.Text = "Red"
ESPColorRed.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorRed.Font = Enum.Font.Gotham
ESPColorRed.TextSize = 14
ESPColorRed.Parent = VisualsTab

local ESPColorGreen = Instance.new("TextButton")
ESPColorGreen.Name = "ESPColorGreen"
ESPColorGreen.Size = UDim2.new(0.3, 0, 0, 20)
ESPColorGreen.Position = UDim2.new(0.35, 60, 0, 65)
ESPColorGreen.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
ESPColorGreen.Text = "Green"
ESPColorGreen.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorGreen.Font = Enum.Font.Gotham
ESPColorGreen.TextSize = 14
ESPColorGreen.Parent = VisualsTab

local ESPColorBlue = Instance.new("TextButton")
ESPColorBlue.Name = "ESPColorBlue"
ESPColorBlue.Size = UDim2.new(0.3, 0, 0, 20)
ESPColorBlue.Position = UDim2.new(0.7, 60, 0, 65)
ESPColorBlue.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
ESPColorBlue.Text = "Blue"
ESPColorBlue.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorBlue.Font = Enum.Font.Gotham
ESPColorBlue.TextSize = 14
ESPColorBlue.Parent = VisualsTab

local ESPLinesToggle = Instance.new("TextButton")
ESPLinesToggle.Name = "ESPLinesToggle"
ESPLinesToggle.Size = UDim2.new(1, 0, 0, 30)
ESPLinesToggle.Position = UDim2.new(0, 0, 0, 95)
ESPLinesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPLinesToggle.Text = "ESP Lines [OFF]"
ESPLinesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLinesToggle.Font = Enum.Font.Gotham
ESPLinesToggle.TextSize = 14
ESPLinesToggle.Parent = VisualsTab

local ESPBoxesToggle = Instance.new("TextButton")
ESPBoxesToggle.Name = "ESPBoxesToggle"
ESPBoxesToggle.Size = UDim2.new(1, 0, 0, 30)
ESPBoxesToggle.Position = UDim2.new(0, 0, 0, 135)
ESPBoxesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPBoxesToggle.Text = "ESP Boxes [OFF]"
ESPBoxesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBoxesToggle.Font = Enum.Font.Gotham
ESPBoxesToggle.TextSize = 14
ESPBoxesToggle.Parent = VisualsTab

local ESPNamesToggle = Instance.new("TextButton")
ESPNamesToggle.Name = "ESPNamesToggle"
ESPNamesToggle.Size = UDim2.new(1, 0, 0, 30)
ESPNamesToggle.Position = UDim2.new(0, 0, 0, 175)
ESPNamesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPNamesToggle.Text = "ESP Names [OFF]"
ESPNamesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPNamesToggle.Font = Enum.Font.Gotham
ESPNamesToggle.TextSize = 14
ESPNamesToggle.Parent = VisualsTab

-- Misc Tab
local MiscTab = TabFrames["Misc"]

local MagicBulletToggle = Instance.new("TextButton")
MagicBulletToggle.Name = "MagicBulletToggle"
MagicBulletToggle.Size = UDim2.new(1, 0, 0, 30)
MagicBulletToggle.Position = UDim2.new(0, 0, 0, 0)
MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MagicBulletToggle.Text = "Magic Bullet [OFF]"
MagicBulletToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MagicBulletToggle.Font = Enum.Font.Gotham
MagicBulletToggle.TextSize = 14
MagicBulletToggle.Parent = MiscTab

local NoRecoilToggle = Instance.new("TextButton")
NoRecoilToggle.Name = "NoRecoilToggle"
NoRecoilToggle.Size = UDim2.new(1, 0, 0, 30)
NoRecoilToggle.Position = UDim2.new(0, 0, 0, 40)
NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
NoRecoilToggle.Text = "No Recoil [OFF]"
NoRecoilToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRecoilToggle.Font = Enum.Font.Gotham
NoRecoilToggle.TextSize = 14
NoRecoilToggle.Parent = MiscTab

local NoSpreadToggle = Instance.new("TextButton")
NoSpreadToggle.Name = "NoSpreadToggle"
NoSpreadToggle.Size = UDim2.new(1, 0, 0, 30)
NoSpreadToggle.Position = UDim2.new(0, 0, 0, 80)
NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
NoSpreadToggle.Text = "No Spread [OFF]"
NoSpreadToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSpreadToggle.Font = Enum.Font.Gotham
NoSpreadToggle.TextSize = 14
NoSpreadToggle.Parent = MiscTab

local RapidFireToggle = Instance.new("TextButton")
RapidFireToggle.Name = "RapidFireToggle"
RapidFireToggle.Size = UDim2.new(1, 0, 0, 30)
RapidFireToggle.Position = UDim2.new(0, 0, 0, 120)
RapidFireToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
RapidFireToggle.Text = "Rapid Fire [OFF]"
RapidFireToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
RapidFireToggle.Font = Enum.Font.Gotham
RapidFireToggle.TextSize = 14
RapidFireToggle.Parent = MiscTab

-- Variables
local aimbotEnabled = false
local aimbotKey = Enum.UserInputType.MouseButton2
local targetPart = "Head"
local smoothness = 0.5
local fovEnabled = true
local fovSize = 100
local espEnabled = false
local espColor = Color3.fromRGB(255, 50, 50)
local espLinesEnabled = false
local espBoxesEnabled = false
local espNamesEnabled = false
local magicBulletEnabled = false
local noRecoilEnabled = false
local noSpreadEnabled = false
local rapidFireEnabled = false

-- Functions
local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = fovSize
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild(targetPart) then
            local character = player.Character
            local targetPosition = character[targetPart].Position
            local vector, onScreen = camera:WorldToViewportPoint(targetPosition)
            
            if onScreen then
                local mousePosition = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(mousePosition.X, mousePosition.Y) - Vector2.new(vector.X, vector.Y)).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

local function AimAt(target)
    if target and target.Character and target.Character:FindFirstChild(targetPart) then
        local targetPosition = target.Character[targetPart].Position
        local cameraPosition = camera.CFrame.Position
        local direction = (targetPosition - cameraPosition).Unit
        
        local currentLook = camera.CFrame.LookVector
        local newLook = currentLook:Lerp(direction, 1 - smoothness)
        
        camera.CFrame = CFrame.new(cameraPosition, cameraPosition + newLook)
    end
end

local function CreateESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoidRootPart or not head then return end
    
    -- ESP Box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.7
    box.Color3 = espColor
    box.Parent = humanoidRootPart
    
    -- ESP Line
    local line = Instance.new("LineHandleAdornment")
    line.Name = "ESPLine"
    line.Adornee = humanoidRootPart
    line.AlwaysOnTop = true
    line.ZIndex = 10
    line.Length = 1000
    line.Thickness = 1
    line.Transparency = 0.7
    line.Color3 = espColor
    line.Parent = humanoidRootPart
    
    -- ESP Name
    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Name = "ESPName"
    nameLabel.Adornee = head
    nameLabel.AlwaysOnTop = true
    nameLabel.Size = UDim2.new(0, 100, 0, 40)
    nameLabel.StudsOffset = Vector3.new(0, 3, 0)
    nameLabel.Parent = head
    
    local nameText = Instance.new("TextLabel")
    nameText.Name = "NameText"
    nameText.Size = UDim2.new(1, 0, 0.5, 0)
    nameText.Position = UDim2.new(0, 0, 0, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = player.Name
    nameText.TextColor3 = espColor
    nameText.TextStrokeTransparency = 0
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 14
    nameText.Parent = nameLabel
    
    local distanceText = Instance.new("TextLabel")
    distanceText.Name = "DistanceText"
    distanceText.Size = UDim2.new(1, 0, 0.5, 0)
    distanceText.Position = UDim2.new(0, 0, 0.5, 0)
    distanceText.BackgroundTransparency = 1
    distanceText.Text = "0m"
    distanceText.TextColor3 = espColor
    distanceText.TextStrokeTransparency = 0
    distanceText.Font = Enum.Font.Gotham
    distanceText.TextSize = 12
    distanceText.Parent = nameLabel
    
    return {
        Box = box,
        Line = line,
        Name = nameLabel
    }
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            -- Remove existing ESP
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoidRootPart then
                for _, child in pairs(humanoidRootPart:GetChildren()) do
                    if child.Name == "ESPBox" or child.Name == "ESPLine" then
                        child:Destroy()
                    end
                end
            end
            
            if head then
                local nameLabel = head:FindFirstChild("ESPName")
                if nameLabel then
                    nameLabel:Destroy()
                end
            end
            
            -- Create new ESP if enabled
            if espEnabled and player.Character then
                CreateESP(player)
            end
        end
    end
end

-- Connections
local aimbotConnection
local espConnection

-- Toggle Aimbot
AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        AimbotToggle.Text = "Aimbot [ON]"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local closestPlayer = GetClosestPlayerToCursor()
                if closestPlayer then
                    AimAt(closestPlayer)
                end
            end
        end)
    else
        AimbotToggle.Text = "Aimbot [OFF]"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
    end
end)

-- Change Aimbot Keybind
AimbotKeybind.MouseButton1Click:Connect(function()
    AimbotKeybind.Text = "Press a key..."
    
    local input = UserInputService.InputBegan:Wait()
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        aimbotKey = input.KeyCode
        AimbotKeybind.Text = "Keybind: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        aimbotKey = Enum.UserInputType.MouseButton1
        AimbotKeybind.Text = "Keybind: Left Mouse Button"
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotKey = Enum.UserInputType.MouseButton2
        AimbotKeybind.Text = "Keybind: Right Mouse Button"
    else
        AimbotKeybind.Text = "Keybind: Right Mouse Button"
    end
end)

-- Target Part Selection
HeadButton.MouseButton1Click:Connect(function()
    targetPart = "Head"
    TargetPart.Text = "Target Part: Head"
    HeadButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    BodyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)

BodyButton.MouseButton1Click:Connect(function()
    targetPart = "HumanoidRootPart"
    TargetPart.Text = "Target Part: Body"
    HeadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    BodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
end)

-- Smoothness Slider
local smoothnessDragging = false
SmoothnessSlider.MouseButton1Down:Connect(function()
    smoothnessDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothnessDragging = false
    end
end)

SmoothnessSlider.MouseMoved:Connect(function()
    if smoothnessDragging then
        local x = UserInputService:GetMouseLocation().X - SmoothnessSlider.AbsolutePosition.X
        local percent = math.clamp(x / SmoothnessSlider.AbsoluteSize.X, 0, 1)
        
        smoothness = 1 - percent
        SmoothnessFill.Size = UDim2.new(percent, 0, 1, 0)
        SmoothnessLabel.Text = "Smoothness: " .. math.floor(percent * 100) .. "%"
    end
end)

-- FOV Toggle
FOVToggle.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    FOVCircle.Visible = fovEnabled
    
    if fovEnabled then
        FOVToggle.Text = "Show FOV [ON]"
        FOVToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        FOVToggle.Text = "Show FOV [OFF]"
        FOVToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- FOV Size Slider
local fovSizeDragging = false
FOVSizeSlider.MouseButton1Down:Connect(function()
    fovSizeDragging = true
end)

FOVSizeSlider.MouseMoved:Connect(function()
    if fovSizeDragging then
        local x = UserInputService:GetMouseLocation().X - FOVSizeSlider.AbsolutePosition.X
        local percent = math.clamp(x / FOVSizeSlider.AbsoluteSize.X, 0.1, 1)
        
        fovSize = math.floor(50 + percent * 200)
        FOVSizeFill.Size = UDim2.new(percent, 0, 1, 0)
        FOVSizeLabel.Text = "FOV Size: " .. fovSize
        FOVCircle.Size = UDim2.new(0, fovSize * 2, 0, fovSize * 2)
        FOVCircle.Position = UDim2.new(0.5, -fovSize, 0.5, -fovSize)
    end
end)

-- ESP Toggle
ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPToggle.Text = "ESP [ON]"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        UpdateESP()
        
        espConnection = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if espEnabled then
                    CreateESP(player)
                end
            end)
        end)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                if player.Character then
                    CreateESP(player)
                end
                
                player.CharacterAdded:Connect(function()
                    if espEnabled then
                        CreateESP(player)
                    end
                end)
            end
        end
    else
        ESPToggle.Text = "ESP [OFF]"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        UpdateESP()
        
        if espConnection then
            espConnection:Disconnect()
        end
    end
end)

-- ESP Color Selection
ESPColorRed.MouseButton1Click:Connect(function()
    espColor = Color3.fromRGB(255, 50, 50)
    ESPColorPreview.BackgroundColor3 = espColor
    UpdateESP()
end)

ESPColorGreen.MouseButton1Click:Connect(function()
    espColor = Color3.fromRGB(50, 255, 50)
    ESPColorPreview.BackgroundColor3 = espColor
    UpdateESP()
end)

ESPColorBlue.MouseButton1Click:Connect(function()
    espColor = Color3.fromRGB(50, 50, 255)
    ESPColorPreview.BackgroundColor3 = espColor
    UpdateESP()
end)

-- ESP Lines Toggle
ESPLinesToggle.MouseButton1Click:Connect(function()
    espLinesEnabled = not espLinesEnabled
    
    if espLinesEnabled then
        ESPLinesToggle.Text = "ESP Lines [ON]"
        ESPLinesToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        ESPLinesToggle.Text = "ESP Lines [OFF]"
        ESPLinesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    
    UpdateESP()
end)

-- ESP Boxes Toggle
ESPBoxesToggle.MouseButton1Click:Connect(function()
    espBoxesEnabled = not espBoxesEnabled
    
    if espBoxesEnabled then
        ESPBoxesToggle.Text = "ESP Boxes [ON]"
        ESPBoxesToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        ESPBoxesToggle.Text = "ESP Boxes [OFF]"
        ESPBoxesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    
    UpdateESP()
end)

-- ESP Names Toggle
ESPNamesToggle.MouseButton1Click:Connect(function()
    espNamesEnabled = not espNamesEnabled
    
    if espNamesEnabled then
        ESPNamesToggle.Text = "ESP Names [ON]"
        ESPNamesToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        ESPNamesToggle.Text = "ESP Names [OFF]"
        ESPNamesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    
    UpdateESP()
end)

-- Magic Bullet Toggle
MagicBulletToggle.MouseButton1Click:Connect(function()
    magicBulletEnabled = not magicBulletEnabled
    
    if magicBulletEnabled then
        MagicBulletToggle.Text = "Magic Bullet [ON]"
        MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        MagicBulletToggle.Text = "Magic Bullet [OFF]"
        MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- No Recoil Toggle
NoRecoilToggle.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    
    if noRecoilEnabled then
        NoRecoilToggle.Text = "No Recoil [ON]"
        NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        NoRecoilToggle.Text = "No Recoil [OFF]"
        NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- No Spread Toggle
NoSpreadToggle.MouseButton1Click:Connect(function()
    noSpreadEnabled = not noSpreadEnabled
    
    if noSpreadEnabled then
        NoSpreadToggle.Text = "No Spread [ON]"
        NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        NoSpreadToggle.Text = "No Spread [OFF]"
        NoSpreadToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Rapid Fire Toggle
RapidFireToggle.MouseButton1Click:Connect(function()
    rapidFireEnabled = not rapidFireEnabled
    
    if rapidFireEnabled then
        RapidFireToggle.Text = "Rapid Fire [ON]"
        RapidFireToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        RapidFireToggle.Text = "Rapid Fire [OFF]"
        RapidFireToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Initialize
FOVCircle.Visible = fovEnabled
