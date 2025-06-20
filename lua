-- MOBILE FPS HACK FOR DELTA (ANDROID)
-- TAP THE TOP-RIGHT CORNER TO TOGGLE MENU

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Player
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Settings
local settings = {
    Aimbot = false,
    TargetPart = "Head",
    ESP = false,
    NoRecoil = false,
    NoSpread = false,
    ToggleKey = Enum.KeyCode.ButtonR3 -- Right stick click
}

-- Mobile GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFPSHack"
ScreenGui.Parent = CoreGui

-- Toggle Button (Top-right corner)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(1, -60, 0, 10)
ToggleBtn.Text = "≡"
ToggleBtn.FontSize = Enum.FontSize.Size24
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.Parent = ScreenGui

-- Main Menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "MOBILE FPS HACK"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

-- Buttons
local function CreateButton(text, ypos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    return btn
end

local AimbotBtn = CreateButton("AIMBOT: OFF", 50)
local TargetBtn = CreateButton("TARGET: HEAD", 100)
local ESPBtn = CreateButton("ESP: OFF", 150)
local NoRecoilBtn = CreateButton("NO RECOIL: OFF", 200)
local CloseBtn = CreateButton("CLOSE", 250)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

-- Functions
local function GetClosestPlayer()
    local closest, closestDist = nil, math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local part = p.Character:FindFirstChild(settings.TargetPart)
            if part then
                local dist = (player:DistanceFromCharacter(part.Position))
                if dist < closestDist then
                    closest = p
                    closestDist = dist
                end
            end
        end
    end
    
    return closest
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if settings.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(settings.TargetPart)
            if part then
                camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
            end
        end
    end
end)

-- ESP
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            -- Remove old ESP
            for _, child in pairs(p.Character:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
            
            -- Add new ESP
            if settings.ESP then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = p.Character
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = p.Character
            end
        end
    end
end

-- Toggle Menu
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Button Actions
AimbotBtn.MouseButton1Click:Connect(function()
    settings.Aimbot = not settings.Aimbot
    AimbotBtn.Text = settings.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    AimbotBtn.BackgroundColor3 = settings.Aimbot and Color3.new(0, 1, 0) or Color3.fromRGB(50, 50, 70)
end)

TargetBtn.MouseButton1Click:Connect(function()
    settings.TargetPart = settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "TARGET: " .. settings.TargetPart:upper()
end)

ESPBtn.MouseButton1Click:Connect(function()
    settings.ESP = not settings.ESP
    ESPBtn.Text = settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = settings.ESP and Color3.new(0, 1, 0) or Color3.fromRGB(50, 50, 70)
    UpdateESP()
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    settings.NoRecoil = not settings.NoRecoil
    NoRecoilBtn.Text = settings.NoRecoil and "NO RECOIL: ON" or "NO RECOIL: OFF"
    NoRecoilBtn.BackgroundColor3 = settings.NoRecoil and Color3.new(0, 1, 0) or Color3.fromRGB(50, 50, 70)
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

warn("MOBILE FPS HACK LOADED! TAP THE BLUE BUTTON TO TOGGLE MENU")
