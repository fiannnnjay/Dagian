-- UNIVERSAL FPS SCRIPT FOR DELTA EXECUTOR
-- PRESS F4 TO TOGGLE MENU

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- PLAYER
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- SETTINGS
local settings = {
    Aimbot = false,
    AimbotKey = Enum.UserInputType.MouseButton2,
    TargetPart = "Head",
    FOV = 100,
    ESP = false,
    NoRecoil = false,
    NoSpread = false,
    BoxESP = false
}

-- CREATE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFPSHack"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- TITLE
local Title = Instance.new("TextLabel")
Title.Text = "DELTA FPS HACK"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- BUTTONS
local function CreateButton(name, ypos)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    return btn
end

local AimbotBtn = CreateButton("AIMBOT: OFF", 40)
local TargetBtn = CreateButton("TARGET: HEAD", 70)
local ESPBtn = CreateButton("ESP: OFF", 100)
local NoRecoilBtn = CreateButton("NO RECOIL: OFF", 130)
local NoSpreadBtn = CreateButton("NO SPREAD: OFF", 160)
local CloseBtn = CreateButton("CLOSE", 190)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

-- FUNCTIONS
local function GetClosestPlayer()
    local closest, closestDist = nil, settings.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local part = p.Character:FindFirstChild(settings.TargetPart)
            if part then
                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < closestDist then
                        closest = p
                        closestDist = dist
                    end
                end
            end
        end
    end
    
    return closest
end

-- AIMBOT
RunService.RenderStepped:Connect(function()
    if settings.Aimbot and UserInputService:IsMouseButtonPressed(settings.AimbotKey) then
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
            -- Remove existing ESP
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Highlight") or v.Name == "ESPBox" then
                    v:Destroy()
                end
            end
            
            -- Add new ESP
            if settings.ESP then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPBox"
                highlight.Adornee = p.Character
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = p.Character
            end
        end
    end
end

-- TOGGLE GUI
mouse.KeyDown:Connect(function(key)
    if key == "f4" then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- BUTTON ACTIONS
AimbotBtn.MouseButton1Click:Connect(function()
    settings.Aimbot = not settings.Aimbot
    AimbotBtn.Text = settings.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    AimbotBtn.BackgroundColor3 = settings.Aimbot and Color3.new(0, 0.5, 1) or Color3.fromRGB(40, 40, 50)
end)

TargetBtn.MouseButton1Click:Connect(function()
    settings.TargetPart = settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "TARGET: " .. settings.TargetPart:upper()
end)

ESPBtn.MouseButton1Click:Connect(function()
    settings.ESP = not settings.ESP
    ESPBtn.Text = settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = settings.ESP and Color3.new(0, 0.5, 1) or Color3.fromRGB(40, 40, 50)
    UpdateESP()
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    settings.NoRecoil = not settings.NoRecoil
    NoRecoilBtn.Text = settings.NoRecoil and "NO RECOIL: ON" or "NO RECOIL: OFF"
    NoRecoilBtn.BackgroundColor3 = settings.NoRecoil and Color3.new(0, 0.5, 1) or Color3.fromRGB(40, 40, 50)
end)

NoSpreadBtn.MouseButton1Click:Connect(function()
    settings.NoSpread = not settings.NoSpread
    NoSpreadBtn.Text = settings.NoSpread and "NO SPREAD: ON" or "NO SPREAD: OFF"
    NoSpreadBtn.BackgroundColor3 = settings.NoSpread and Color3.new(0, 0.5, 1) or Color3.fromRGB(40, 40, 50)
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

warn("DELTA FPS HACK LOADED! PRESS F4 TO TOGGLE MENU")
