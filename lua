-- FPS HACK KHUSUS ROBLOX UNTUK DELTA
-- [F4] TOGGLE MENU | [RMB] AIMBOT

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
    FOV = 200,
    ESP = false,
    BoxColor = Color3.new(1,0,0),
    TeamCheck = true
}

-- CREATE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxFPSHack"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- TITLE
local Title = Instance.new("TextLabel")
Title.Text = "ROBLOX FPS HACK DELTA"
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(15,15,25)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- BUTTONS
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Text = "AIMBOT: OFF"
AimbotBtn.Size = UDim2.new(0.9,0,0,30)
AimbotBtn.Position = UDim2.new(0.05,0,0,40)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
AimbotBtn.TextColor3 = Color3.new(1,1,1)
AimbotBtn.Font = Enum.Font.Gotham
AimbotBtn.Parent = MainFrame

local TargetBtn = Instance.new("TextButton")
TargetBtn.Text = "TARGET: HEAD"
TargetBtn.Size = UDim2.new(0.9,0,0,30)
TargetBtn.Position = UDim2.new(0.05,0,0,80)
TargetBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
TargetBtn.TextColor3 = Color3.new(1,1,1)
TargetBtn.Font = Enum.Font.Gotham
TargetBtn.Parent = MainFrame

local ESPBtn = Instance.new("TextButton")
ESPBtn.Text = "ESP: OFF"
ESPBtn.Size = UDim2.new(0.9,0,0,30)
ESPBtn.Position = UDim2.new(0.05,0,0,120)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "CLOSE"
CloseBtn.Size = UDim2.new(0.9,0,0,30)
CloseBtn.Position = UDim2.new(0.05,0,0,200)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

-- FUNCTIONS
local function IsEnemy(player)
    if not settings.TeamCheck then return true end
    return player.Team ~= Players.LocalPlayer.Team
end

local function GetClosestPlayer()
    local closest, closestDist = nil, settings.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and IsEnemy(p) then
            local part = p.Character:FindFirstChild(settings.TargetPart)
            if part then
                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X,mouse.Y) - Vector2.new(pos.X,pos.Y)).Magnitude
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
            -- Remove old ESP
            for _, child in pairs(p.Character:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
            
            -- Add new ESP
            if settings.ESP and IsEnemy(p) then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = p.Character
                highlight.FillColor = settings.BoxColor
                highlight.OutlineColor = Color3.new(1,1,1)
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
    AimbotBtn.BackgroundColor3 = settings.Aimbot and Color3.new(0,1,0) or Color3.fromRGB(40,40,50)
end)

TargetBtn.MouseButton1Click:Connect(function()
    settings.TargetPart = settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "TARGET: "..settings.TargetPart:upper()
end)

ESPBtn.MouseButton1Click:Connect(function()
    settings.ESP = not settings.ESP
    ESPBtn.Text = settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = settings.ESP and Color3.new(0,1,0) or Color3.fromRGB(40,40,50)
    UpdateESP()
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

warn("ROBLOX FPS HACK LOADED! PRESS F4 TO TOGGLE MENU")
