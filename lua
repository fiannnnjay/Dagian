-- ✅ Delta FPS Aimbot PRO - Rayfield GUI FIXED VERSION (Full Code)
-- GUI Fixed + Safe Delay + ESP + Line + Silent Aim + Magic Bullet + Anti Kick + Prediction

repeat wait() until game:IsLoaded()
wait(2)

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
end)

if not success then
    warn("[⚠️] Gagal memuat Rayfield GUI dari GitHub. Coba aktifkan VPN atau ganti koneksi!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rayfield Gagal", Text = "Cek koneksi atau VPN", Duration = 8
    })
    return
end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local aiming, espEnabled, noRecoil, autoTrigger, silentAim, holdToLock, magicBullet = false, false, false, false, false, false, true
local aimPart = "Head"
local maxDistance = 300
local projectileSpeed = 160
local aimKey = Enum.KeyCode.Q
local currentTool = nil

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "RayESP"

-- Anti Kick
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return warn("[ANTI KICK] Blocked") end
        return old(self, ...)
    end)
end)

-- GUI Setup
local Window = Rayfield:CreateWindow({
    Name = "🎯 Delta FPS Aimbot Pro",
    LoadingTitle = "Rayfield Loaded",
    LoadingSubtitle = "FPS Menu Ready",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({ Name = "Aimbot (Smooth)", CurrentValue = false, Callback = function(v) aiming = v end })
MainTab:CreateToggle({ Name = "ESP Colorful", CurrentValue = false, Callback = function(v) espEnabled = v for _,x in pairs(espFolder:GetChildren()) do x:Destroy() end end })
MainTab:CreateToggle({ Name = "No Recoil", CurrentValue = false, Callback = function(v) noRecoil = v end })
MainTab:CreateToggle({ Name = "Auto Trigger", CurrentValue = false, Callback = function(v) autoTrigger = v end })
MainTab:CreateToggle({ Name = "Silent Aim", CurrentValue = false, Callback = function(v) silentAim = v end })
MainTab:CreateToggle({ Name = "Hold-to-Lock (Q)", CurrentValue = false, Callback = function(v) holdToLock = v end })
MainTab:CreateToggle({ Name = "Magic Bullet", CurrentValue = true, Callback = function(v) magicBullet = v end })
MainTab:CreateButton({ Name = "Switch AimPart", Callback = function() aimPart = aimPart == "Head" and "HumanoidRootPart" or "Head" Rayfield:Notify({ Title = "Aim Target", Content = "Now aiming at: "..aimPart }) end })

-- ESP Drawing
local function drawESP(player)
    local box = Drawing.new("Square")
    local line = Drawing.new("Line")
    local text = Drawing.new("Text")

    box.Thickness = 2 box.Filled = false box.Visible = false box.Color = Color3.fromHSV(math.random(), 1, 1)
    line.Thickness = 1 line.Visible = false line.Color = box.Color
    text.Size = 14 text.Center = true text.Outline = true text.Visible = false text.Color = Color3.new(1,1,1)

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

                text.Text = player.Name .. string.format(" [%.0fm]", (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude/3.5)
                text.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
                text.Visible = true

                line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = true
            else
                box.Visible = false text.Visible = false line.Visible = false
            end
        else
            box.Visible = false text.Visible = false line.Visible = false
        end
    end)
end

-- Get Closest
local function getClosest()
    local closest, shortest = nil, maxDistance
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild(aimPart) then
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

-- Prediction
local function getPredictedPosition(target)
    local part = target.Character and target.Character:FindFirstChild(aimPart)
    if not part then return nil end
    local distance = (part.Position - cam.CFrame.Position).Magnitude
    local travelTime = distance / projectileSpeed
    local vel = target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Velocity or Vector3.zero
    return part.Position + vel * travelTime
end

-- Disable Recoil
local function disableRecoil()
    for _, tool in pairs(lp.Character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") then obj.Disabled = true end
            end
        end
    end
end

-- TriggerBot
local function triggerFire()
    local target = getClosest()
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        if target.Character.Humanoid.Health > 0 then mouse1click() end
    end
end

-- Silent Aim Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(t, k)
    if silentAim and tostring(k) == "Hit" then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            return magicBullet and target.Character[aimPart] or oldIndex(t, k)
        end
    end
    return oldIndex(t, k)
end)

-- ESP Start
run.RenderStepped:Connect(function()
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

-- Aimbot Main
run.RenderStepped:Connect(function()
    if noRecoil then disableRecoil() end

    local canAim = aiming and (not holdToLock or uis:IsKeyDown(aimKey))
    if canAim then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local predicted = getPredictedPosition(target)
            if predicted and not silentAim then
                local dir = (predicted - cam.CFrame.Position).Unit
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, cam.CFrame.Position + dir), 0.2)
            end
        end
    end

    if autoTrigger then triggerFire() end
end)

Rayfield:Notify({ Title = "✅ GUI OK", Content = "FPS Aimbot PRO GUI muncul dengan aman!" })
