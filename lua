-- ✅ FPS Aimbot PRO - Simple GUI (No Rayfield)
repeat wait() until game:IsLoaded()
wait(1)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local aiming, espEnabled, noRecoil, autoTrigger, silentAim, holdToLock, magicBullet = false, false, false, false, false, false, true
local aimPart = "Head"
local aimKey = Enum.KeyCode.Q
local maxDistance = 300
local projectileSpeed = 160
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "SimpleESP"

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
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleFPSGui"

local main = Instance.new("Frame", gui)
main.Position = UDim2.new(0.02, 0, 0.2, 0)
main.Size = UDim2.new(0, 220, 0, 320)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 FPS Aimbot GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local y = 35
local function addBtn(label, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = label
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    y = y + 35
    return btn
end

local function toggle(varName, label, btn)
    _G[varName] = not _G[varName]
    btn.Text = label .. (_G[varName] and ": ON" or ": OFF")
end

local aimBtn = addBtn("Aimbot: OFF", function() toggle("aiming", "Aimbot", aimBtn) aiming = not aiming end)
local espBtn = addBtn("ESP: OFF", function() toggle("espEnabled", "ESP", espBtn) espEnabled = not espEnabled for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end end)
local recoilBtn = addBtn("No Recoil: OFF", function() toggle("noRecoil", "No Recoil", recoilBtn) noRecoil = not noRecoil end)
local triggerBtn = addBtn("Auto Trigger: OFF", function() toggle("autoTrigger", "Auto Trigger", triggerBtn) autoTrigger = not autoTrigger end)
local silentBtn = addBtn("Silent Aim: OFF", function() toggle("silentAim", "Silent Aim", silentBtn) silentAim = not silentAim end)
local magicBtn = addBtn("Magic Bullet: ON", function() magicBullet = not magicBullet magicBtn.Text = "Magic Bullet: "..(magicBullet and "ON" or "OFF") end)
local switchBtn = addBtn("Target: Head", function() aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head" switchBtn.Text = "Target: "..(aimPart == "Head" and "Head" or "Body") end)

addBtn("❌ Sembunyikan GUI", function() main.Visible = not main.Visible end)

-- ESP
local function drawESP(player)
    local box = Drawing.new("Square")
    local text = Drawing.new("Text")
    local line = Drawing.new("Line")

    box.Thickness = 2 box.Filled = false box.Color = Color3.fromHSV(math.random(), 1, 1)
    text.Size = 14 text.Center = true text.Outline = true text.Color = Color3.new(1,1,1)
    line.Thickness = 1 line.Color = box.Color

    run.RenderStepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and espEnabled then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                local scale = 1 / dist * 100
                local size = Vector2.new(4, 6) * scale * 10
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                box.Visible = true
                text.Text = player.Name .. string.format(" [%.0fm]", dist / 3.5)
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

local function getClosest()
    local closest, shortest = nil, maxDistance
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild(aimPart) then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character[aimPart].Position)
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

local function getPredictedPosition(target)
    local part = target.Character and target.Character:FindFirstChild(aimPart)
    if not part then return nil end
    local distance = (part.Position - cam.CFrame.Position).Magnitude
    local travelTime = distance / projectileSpeed
    local vel = target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Velocity or Vector3.zero
    return part.Position + vel * travelTime
end

local function disableRecoil()
    for _, tool in pairs(lp.Character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") then obj.Disabled = true end
            end
        end
    end
end

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

-- ESP Loop
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

-- Aimbot Loop
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
