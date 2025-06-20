-- ✅ FIXED - Simple FPS Aimbot GUI - Semua Fitur Aktif + GUI Buka/Tutup Aman
repeat wait() until game:IsLoaded()
wait(1)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local aiming, espEnabled, noRecoil, autoTrigger, silentAim, magicBullet = false, false, false, false, false, true
local aimPart = "Head"
local aimKey = Enum.KeyCode.Q
local maxDistance = 300
local projectileSpeed = 160
local guiVisible = true

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

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleFPSGui"

local main = Instance.new("Frame", gui)
main.Position = UDim2.new(0.02, 0, 0.2, 0)
main.Size = UDim2.new(0, 230, 0, 340)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
local function addBtn(name, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name .. ": OFF"
    btn.Name = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    y = y + 35
    return btn
end

local function toggleFlag(flag, btn)
    _G[flag] = not _G[flag]
    btn.Text = btn.Name .. (_G[flag] and ": ON" or ": OFF")
    return _G[flag]
end

addBtn("Aimbot", function(btn) aiming = toggleFlag("aiming", btn) end)
addBtn("ESP", function(btn) espEnabled = toggleFlag("espEnabled", btn) for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end end)
addBtn("NoRecoil", function(btn) noRecoil = toggleFlag("noRecoil", btn) end)
addBtn("AutoTrigger", function(btn) autoTrigger = toggleFlag("autoTrigger", btn) end)
addBtn("SilentAim", function(btn) silentAim = toggleFlag("silentAim", btn) end)
addBtn("MagicBullet", function(btn) magicBullet = toggleFlag("magicBullet", btn) end)
addBtn("SwitchTarget", function(btn) aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head" btn.Text = "Target: " .. aimPart end)

-- GUI toggle button
local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "⚙️"
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 22
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Get Closest Player
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

-- Predict
local function predictPos(target)
    local part = target.Character and target.Character:FindFirstChild(aimPart)
    if not part then return nil end
    local dist = (part.Position - cam.CFrame.Position).Magnitude
    local travel = dist / projectileSpeed
    local vel = target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Velocity or Vector3.zero
    return part.Position + vel * travel
end

-- Recoil Disable
local function disableRecoil()
    for _, tool in pairs(lp.Character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, obj in pairs(tool:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") then obj.Disabled = true end
            end
        end
    end
end

-- Trigger
local function triggerFire()
    local t = getClosest()
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        if t.Character.Humanoid.Health > 0 then mouse1click() end
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

-- ESP Draw
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
                box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
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

-- ESP Init
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

-- Main Loop
run.RenderStepped:Connect(function()
    if noRecoil then disableRecoil() end
    if aiming then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local pos = predictPos(target)
            if pos and not silentAim then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), 0.2)
            end
        end
    end
    if autoTrigger then triggerFire() end
end)

warn("✅ Aimbot GUI Sukses Dimuat!")
