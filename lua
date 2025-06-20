-- 🔥 ULTIMATE DELTA FPS HACK 🔥
-- [F4] TOGGLE MENU | [RMB] AIMBOT | [F] 1HIT KILL

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
    FOV = 250,
    ESP = false,
    BoxColor = Color3.new(1,0,0),
    TeamCheck = true,
    OneHitKill = false,
    OneHitKey = Enum.KeyCode.F,
    NoRecoil = false,
    NoSpread = false,
    SilentAim = false
}

-- CREATE ADVANCED GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateHack"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- TABS SYSTEM
local TabButtons = {}
local TabFrames = {}

local function CreateTab(name, pos)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(0.33, -10, 0, 30)
    tabBtn.Position = pos
    tabBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = MainFrame
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 1, -80)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = MainFrame
    
    TabButtons[name] = tabBtn
    TabFrames[name] = tabFrame
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do frame.Visible = false end
        for _, btn in pairs(TabButtons) do btn.BackgroundColor3 = Color3.fromRGB(40,40,50) end
        tabFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    end)
    
    return tabFrame
end

-- CREATE TABS
local CombatTab = CreateTab("COMBAT", UDim2.new(0, 5, 0, 35))
local VisualTab = CreateTab("VISUAL", UDim2.new(0.33, 5, 0, 35))
local MiscTab = CreateTab("MISC", UDim2.new(0.66, 5, 0, 35))

-- ACTIVATE FIRST TAB
TabButtons["COMBAT"].BackgroundColor3 = Color3.fromRGB(0,150,255)
TabFrames["COMBAT"].Visible = true

-- COMBAT TAB
local function CreateCombatButton(text, ypos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = CombatTab
    return btn
end

local AimbotBtn = CreateCombatButton("AIMBOT: OFF", 10)
local TargetBtn = CreateCombatButton("TARGET: HEAD", 50)
local OneHitBtn = CreateCombatButton("1HIT KILL: OFF", 90)
local SilentAimBtn = CreateCombatButton("SILENT AIM: OFF", 130)
local NoRecoilBtn = CreateCombatButton("NO RECOIL: OFF", 170)
local NoSpreadBtn = CreateCombatButton("NO SPREAD: OFF", 210)

-- VISUAL TAB
local function CreateVisualButton(text, ypos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = VisualTab
    return btn
end

local ESPBtn = CreateVisualButton("ESP: OFF", 10)
local TeamCheckBtn = CreateVisualButton("TEAM CHECK: ON", 50)
local ChamsBtn = CreateVisualButton("CHAMS: OFF", 90)

-- MISC TAB
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "CLOSE MENU"
CloseBtn.Size = UDim2.new(0.9, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.05, 0, 0, 300)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MiscTab

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

-- 1HIT KILL FUNCTION
local function OneHitKill(target)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

-- SILENT AIM
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if settings.SilentAim and not checkcaller() then
        if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(settings.TargetPart) then
                args[1] = Ray.new(camera.CFrame.Position, (target.Character[settings.TargetPart].Position - camera.CFrame.Position).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- AIMBOT
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if settings.Aimbot and UserInputService:IsMouseButtonPressed(settings.AimbotKey) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(settings.TargetPart)
            if part then
                camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
            end
        end
    end
    
    -- 1Hit Kill
    if settings.OneHitKill and UserInputService:IsKeyDown(settings.OneHitKey) then
        local target = GetClosestPlayer()
        OneHitKill(target)
    end
end)

-- ESP/CHAMS
local function UpdateVisuals()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            -- Remove old visuals
            for _, child in pairs(p.Character:GetChildren()) do
                if child:IsA("Highlight") or child.Name == "Chams" then
                    child:Destroy()
                end
            end
            
            -- Add new visuals
            if IsEnemy(p) then
                if settings.ESP then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP"
                    highlight.Adornee = p.Character
                    highlight.FillColor = settings.BoxColor
                    highlight.OutlineColor = Color3.new(1,1,1)
                    highlight.Parent = p.Character
                end
                
                if settings.Chams then
                    local chams = Instance.new("BoxHandleAdornment")
                    chams.Name = "Chams"
                    chams.Adornee = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:WaitForChild("UpperTorso")
                    chams.Size = Vector3.new(2,3,1)
                    chams.Transparency = 0.5
                    chams.Color3 = Color3.new(1,0,0)
                    chams.ZIndex = 10
                    chams.AlwaysOnTop = true
                    chams.Parent = p.Character
                end
            end
        end
    end
end

-- TOGGLE GUI
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F4 then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- BUTTON ACTIONS
AimbotBtn.MouseButton1Click:Connect(function()
    settings.Aimbot = not settings.Aimbot
    AimbotBtn.Text = settings.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    AimbotBtn.BackgroundColor3 = settings.Aimbot and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
end)

TargetBtn.MouseButton1Click:Connect(function()
    settings.TargetPart = settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "TARGET: "..settings.TargetPart:upper()
end)

OneHitBtn.MouseButton1Click:Connect(function()
    settings.OneHitKill = not settings.OneHitKill
    OneHitBtn.Text = settings.OneHitKill and "1HIT KILL: ON (F)" or "1HIT KILL: OFF"
    OneHitBtn.BackgroundColor3 = settings.OneHitKill and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
end)

SilentAimBtn.MouseButton1Click:Connect(function()
    settings.SilentAim = not settings.SilentAim
    SilentAimBtn.Text = settings.SilentAim and "SILENT AIM: ON" or "SILENT AIM: OFF"
    SilentAimBtn.BackgroundColor3 = settings.SilentAim and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    settings.NoRecoil = not settings.NoRecoil
    NoRecoilBtn.Text = settings.NoRecoil and "NO RECOIL: ON" or "NO RECOIL: OFF"
    NoRecoilBtn.BackgroundColor3 = settings.NoRecoil and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
end)

NoSpreadBtn.MouseButton1Click:Connect(function()
    settings.NoSpread = not settings.NoSpread
    NoSpreadBtn.Text = settings.NoSpread and "NO SPREAD: ON" or "NO SPREAD: OFF"
    NoSpreadBtn.BackgroundColor3 = settings.NoSpread and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
end)

ESPBtn.MouseButton1Click:Connect(function()
    settings.ESP = not settings.ESP
    ESPBtn.Text = settings.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = settings.ESP and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
    UpdateVisuals()
end)

TeamCheckBtn.MouseButton1Click:Connect(function()
    settings.TeamCheck = not settings.TeamCheck
    TeamCheckBtn.Text = settings.TeamCheck and "TEAM CHECK: ON" or "TEAM CHECK: OFF"
    TeamCheckBtn.BackgroundColor3 = settings.TeamCheck and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
    UpdateVisuals()
end)

ChamsBtn.MouseButton1Click:Connect(function()
    settings.Chams = not settings.Chams
    ChamsBtn.Text = settings.Chams and "CHAMS: ON" or "CHAMS: OFF"
    ChamsBtn.BackgroundColor3 = settings.Chams and Color3.new(0,1,0) or Color3.fromRGB(50,50,70)
    UpdateVisuals()
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

warn("🔥 DELTA ULTIMATE FPS HACK LOADED! PRESS F4 TO TOGGLE MENU 🔥")
