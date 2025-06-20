-- Universal FPS Script for Delta Executor
-- Press F4 to toggle GUI

-- Fix for Delta compatibility
if not getgenv then
    getgenv = function() return _G end
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Player
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Settings
getgenv().settings = {
    Aimbot = false,
    AimbotKey = Enum.UserInputType.MouseButton2,
    TargetPart = "Head",
    Smoothness = 0.5,
    FOV = 100,
    ESP = false,
    NoRecoil = false,
    NoSpread = false,
    BoxESP = false
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFPSGui"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "DELTA FPS TOOLS"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Aimbot Toggle
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Text = "AIMBOT: OFF"
AimbotBtn.Size = UDim2.new(0.9, 0, 0, 25)
AimbotBtn.Position = UDim2.new(0.05, 0, 0, 40)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.Font = Enum.Font.Gotham
AimbotBtn.Parent = MainFrame

-- Target Selection
local TargetBtn = Instance.new("TextButton")
TargetBtn.Text = "TARGET: HEAD"
TargetBtn.Size = UDim2.new(0.9, 0, 0, 25)
TargetBtn.Position = UDim2.new(0.05, 0, 0, 70)
TargetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.Gotham
TargetBtn.Parent = MainFrame

-- ESP Toggle
local ESPBtn = Instance.new("TextButton")
ESPBtn.Text = "ESP: OFF"
ESPBtn.Size = UDim2.new(0.9, 0, 0, 25)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 100)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.Parent = MainFrame

-- No Recoil
local NoRecoilBtn = Instance.new("TextButton")
NoRecoilBtn.Text = "NO RECOIL: OFF"
NoRecoilBtn.Size = UDim2.new(0.9, 0, 0, 25)
NoRecoilBtn.Position = UDim2.new(0.05, 0, 0, 130)
NoRecoilBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoRecoilBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRecoilBtn.Font = Enum.Font.Gotham
NoRecoilBtn.Parent = MainFrame

-- No Spread
local NoSpreadBtn = Instance.new("TextButton")
NoSpreadBtn.Text = "NO SPREAD: OFF"
NoSpreadBtn.Size = UDim2.new(0.9, 0, 0, 25)
NoSpreadBtn.Position = UDim2.new(0.05, 0, 0, 160)
NoSpreadBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoSpreadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSpreadBtn.Font = Enum.Font.Gotham
NoSpreadBtn.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "CLOSE"
CloseBtn.Size = UDim2.new(0.9, 0, 0, 25)
CloseBtn.Position = UDim2.new(0.05, 0, 0, 190)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

-- Functions
local function GetClosestPlayer()
    local closest = nil
    local minDist = getgenv().settings.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(getgenv().settings.TargetPart)
            if part then
                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < minDist then
                        closest = player
                        minDist = dist
                    end
                end
            end
        end
    end
    
    return closest
end

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if getgenv().settings.Aimbot and UserInputService:IsMouseButtonPressed(getgenv().settings.AimbotKey) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(getgenv().settings.TargetPart)
            if part then
                local camPos = camera.CFrame.Position
                local targetPos = part.Position
                local direction = (targetPos - camPos).Unit
                
                local currentLook = camera.CFrame.LookVector
                local newLook = currentLook:Lerp(direction, 1 - getgenv().settings.Smoothness)
                
                camera.CFrame = CFrame.new(camPos, camPos + newLook)
            end
        end
    end
end)

-- Toggle GUI
mouse.KeyDown:Connect(function(key)
    if key == "f4" then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Button Functions
AimbotBtn.MouseButton1Click:Connect(function()
    getgenv().settings.Aimbot = not getgenv().settings.Aimbot
    AimbotBtn.Text = getgenv().settings.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    AimbotBtn.BackgroundColor3 = getgenv().settings.Aimbot and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
end)

TargetBtn.MouseButton1Click:Connect(function()
    getgenv().settings.TargetPart = getgenv().settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "TARGET: " .. getgenv().settings.TargetPart:upper()
end)

ESPBtn.MouseButton1Click:Connect(function()
    getgenv().settings.ESP = not getgenv().settings.ESP
    ESPBtn.Text = getgenv().settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = getgenv().settings.ESP and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    getgenv().settings.NoRecoil = not getgenv().settings.NoRecoil
    NoRecoilBtn.Text = getgenv().settings.NoRecoil and "NO RECOIL: ON" or "NO RECOIL: OFF"
    NoRecoilBtn.BackgroundColor3 = getgenv().settings.NoRecoil and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
end)

NoSpreadBtn.MouseButton1Click:Connect(function()
    getgenv().settings.NoSpread = not getgenv().settings.NoSpread
    NoSpreadBtn.Text = getgenv().settings.NoSpread and "NO SPREAD: ON" or "NO SPREAD: OFF"
    NoSpreadBtn.BackgroundColor3 = getgenv().settings.NoSpread and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

warn("Delta FPS Tools Loaded! Press F4 to toggle GUI.")
