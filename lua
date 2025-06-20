-- ✅ Delta FPS Aimbot PRO - Rayfield GUI Version
-- Uses Rayfield UI Library for better performance and UI handling
-- Make sure Rayfield is loaded before running (auto-loads from GitHub if missing)

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local aiming, espEnabled, noRecoil, autoTrigger, autoSkill, pickupBullet = false, false, false, false, false, false
local aimPart = "Head"
local maxDistance = 300
local projectileSpeed = 160
local teamColorESP = true

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "RayESP"

-- Anti Kick
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return warn("[ANTI KICK] Blocked Kick")
        end
        return old(self, ...)
    end)
end)

-- GUI via Rayfield
local Window = Rayfield:CreateWindow({
    Name = "🎯 Delta FPS Aimbot Pro",
    LoadingTitle = "Delta FPS Injecting...",
    LoadingSubtitle = "by ChatGPT",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        aiming = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP (Colorful + Distance)",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
    end
})

MainTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Callback = function(Value)
        noRecoil = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Trigger",
    CurrentValue = false,
    Callback = function(Value)
        autoTrigger = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Skill",
    CurrentValue = false,
    Callback = function(Value)
        autoSkill = Value
    end
})

MainTab:CreateToggle({
    Name = "Pickup Bullet",
    CurrentValue = false,
    Callback = function(Value)
        pickupBullet = Value
    end
})

MainTab:CreateButton({
    Name = "Switch Target Head/Body",
    Callback = function()
        aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
        Rayfield:Notify({ Title = "Aimbot Target", Content = "Now aiming at: " .. aimPart })
    end
})

local function getClosest()
    local closest, shortest = nil, maxDistance
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild(aimPart) then
            local part = v.Character[aimPart]
            local pos, onScreen = cam:WorldToViewportPoint(part.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if mag < shortest then
                    shortest = mag
                    closest = v
                end
            end
        end
    end
    return closest
end

local function drawESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    box.Color = teamColorESP and player.TeamColor.Color or Color3.fromHSV(math.random(), 1, 1)

    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Visible = false
    text.Color = Color3.fromRGB(255,255,255)

    run.RenderStepped:Connect(function()
        if espEnabled and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local scale = 1 / (hrp.Position - cam.CFrame.Position).Magnitude * 100
                local size = Vector2.new(4, 6) * scale * 10
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                box.Visible = true
                text.Text = string.format("%s [%.0fm]", player.Name, (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude/3.5)
                text.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
                text.Visible = true
            else
                box.Visible = false
                text.Visible = false
            end
        else
            box.Visible = false
            text.Visible = false
        end
    end)
end

local function getPredictedPosition(target)
    local part = target.Character:FindFirstChild(aimPart)
    if not part then return nil end
    local distance = (part.Position - cam.CFrame.Position).Magnitude
    local travelTime = distance / projectileSpeed
    local vel = target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Velocity or Vector3.zero
    return part.Position + vel * travelTime
end

local function disableRecoil()
    for _, tool in pairs(lp.Character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") then
                    obj.Disabled = true
                end
            end
        end
    end
end

local function triggerFire()
    local target = getClosest()
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        local hum = target.Character.Humanoid
        if hum.Health > 0 then
            mouse1click()
        end
    end
end

local function useSkill()
    if lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("skill") then
                v:FireServer()
            end
        end
    end
end

local function grabBullets()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") and obj.Parent.Name:lower():find("bullet") then
            firetouchinterest(lp.Character.HumanoidRootPart, obj.Parent, 0)
            task.wait()
            firetouchinterest(lp.Character.HumanoidRootPart, obj.Parent, 1)
        end
    end
end

run.RenderStepped:Connect(function()
    if noRecoil then disableRecoil() end
    if aiming then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local predicted = getPredictedPosition(target)
            if predicted then
                local direction = (predicted - cam.CFrame.Position).Unit
                cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + direction)
            end
        end
    end
    if autoTrigger then triggerFire() end
    if autoSkill then useSkill() end
    if pickupBullet then grabBullets() end
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and not espFolder:FindFirstChild(p.Name) then
                local tag = Instance.new("BoolValue", espFolder)
                tag.Name = p.Name
                drawESP(p)
            end
        end
    end
end)

Rayfield:Notify({Title = "✅ Loaded!", Content = "GUI Siap & Aktif"})
