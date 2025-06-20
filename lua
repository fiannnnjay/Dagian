repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local aiming = false
local espEnabled = false
local noRecoil = false
local autoTrigger = false
local silentAim = false
local magicBullet = false
local aimPart = "Head"
local maxDistance = 360
local projectileSpeed = 196

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
local function addBtn(name, varName)
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
        _G[varName] = not _G[varName]
        _G[name] = _G[varName]
        btn.Text = name .. (_G[varName] and ": ON" or ": OFF")
    end)
    y = y + 35
    return btn
end

addBtn("Aimbot", "aiming")
addBtn("ESP", "espEnabled")
addBtn("NoRecoil", "noRecoil")
addBtn("AutoTrigger", "autoTrigger")
addBtn("SilentAim", "silentAim")
addBtn("MagicBullet", "magicBullet")

-- Target Part Toggle
local partBtn = Instance.new("TextButton", main)
partBtn.Size = UDim2.new(1, -20, 0, 30)
partBtn.Position = UDim2.new(0, 10, 0, y)
partBtn.Text = "Target: Head"
partBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
partBtn.TextColor3 = Color3.new(1,1,1)
partBtn.Font = Enum.Font.SourceSansBold
partBtn.TextSize = 14
partBtn.MouseButton1Click:Connect(function()
    aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
    partBtn.Text = "Target: " .. aimPart
end)

-- Toggle GUI button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Text = "⚙️"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Targeting
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
local function predictPos(target)
    local part = target.Character and target.Character:FindFirstChild(aimPart)
    if not part then return nil end
    local dist = (part.Position - cam.CFrame.Position).Magnitude
    local travel = dist / projectileSpeed
    local vel = target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Velocity or Vector3.zero
    return part.Position + vel * travel
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

-- Auto Trigger
local function triggerFire()
    local t = getClosest()
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        if t.Character.Humanoid.Health > 0 then mouse1click() end
    end
end

-- Silent Aim / Magic Bullet
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__index
mt.__index = newcclosure(function(t, k)
    if tostring(k) == "Hit" and _G["silentAim"] then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            return _G["magicBullet"] and target.Character[aimPart] or old(t, k)
        end
    end
    return old(t, k)
end)

-- ESP
local function drawESP(player)
    local box = Drawing.new("Square")
    local text = Drawing.new("Text")
    local line = Drawing.new("Line")
    box.Thickness = 2 box.Filled = false box.Color = Color3.fromHSV(math.random(),1,1)
    text.Size = 14 text.Center = true text.Outline = true text.Color = Color3.new(1,1,1)
    line.Thickness = 1 line.Color = box.Color
    run.RenderStepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and _G["espEnabled"] then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                local scale = 1 / dist * 100
                local size = Vector2.new(4,6) * scale * 10
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                box.Visible = true
                text.Text = player.Name .. string.format(" [%.0fm]", dist / 3.5)
                text.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
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

run.RenderStepped:Connect(function()
    if _G["espEnabled"] then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and not espFolder:FindFirstChild(p.Name) then
                local tag = Instance.new("BoolValue", espFolder)
                tag.Name = p.Name
                drawESP(p)
            end
        end
    end
end)

run.RenderStepped:Connect(function()
    if _G["noRecoil"] then disableRecoil() end
    if _G["aiming"] then
        local t = getClosest()
        if t and t.Character and t.Character:FindFirstChild(aimPart) then
            local pos = predictPos(t)
            if pos and not _G["silentAim"] then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), 0.2)
            end
        end
    end
    if _G["autoTrigger"] then triggerFire() end
end)

warn("✅ FPS Aimbot GUI Loaded! Semua fitur OFF default, nyalakan dari tombol.")
