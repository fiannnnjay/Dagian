-- ✅ Delta FPS Aimbot PRO - FIXED Tracking + Colorful ESP + Box + Distance + Anti Kick + ESP Team Color
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
local aimPart = "Head"
local maxDistance = 300
local projectileSpeed = 160
local teamColorESP = true -- NEW

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "DeltaESP"

-- Anti-Kick Hook
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return warn("[ANTI KICK] Blocked Kick attempt")
        end
        return old(self, ...)
    end)
end)

-- GUI FIXED INJECTION
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaFPSGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 350)
main.Position = UDim2.new(0.5, -120, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.ZIndex = 99
main.BackgroundTransparency = 0

local function createBtn(name, text, y)
    local btn = Instance.new("TextButton", main)
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    return btn
end

local aimBtn = createBtn("Aimbot", "Aimbot: OFF", 40)
local espBtn = createBtn("ESP", "ESP: OFF", 80)
local recoilBtn = createBtn("NoRecoil", "No Recoil: OFF", 120)
local triggerBtn = createBtn("AutoTrigger", "Auto Trigger: OFF", 160)
local partBtn = createBtn("AimPart", "Target: Head", 200)
local closeBtn = createBtn("Close", "❌ Tutup GUI", 245)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 Delta FPS Aimbot PRO"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

aimBtn.MouseButton1Click:Connect(function()
    aiming = not aiming
    aimBtn.Text = aiming and "Aimbot: ON" or "Aimbot: OFF"
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    if not espEnabled then for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end end
end)

recoilBtn.MouseButton1Click:Connect(function()
    noRecoil = not noRecoil
    recoilBtn.Text = noRecoil and "No Recoil: ON" or "No Recoil: OFF"
end)

triggerBtn.MouseButton1Click:Connect(function()
    autoTrigger = not autoTrigger
    triggerBtn.Text = autoTrigger and "Auto Trigger: ON" or "Auto Trigger: OFF"
end)

partBtn.MouseButton1Click:Connect(function()
    aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
    partBtn.Text = "Target: " .. (aimPart == "Head" and "Head" or "Body")
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    local openBtn = Instance.new("TextButton", gui)
    openBtn.Text = "⚙️"
    openBtn.Size = UDim2.new(0, 40, 0, 40)
    openBtn.Position = UDim2.new(0, 10, 0, 10)
    openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    openBtn.TextColor3 = Color3.new(1,1,1)
    openBtn.Font = Enum.Font.SourceSansBold
    openBtn.TextSize = 22
    openBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        openBtn:Destroy()
    end)
end)

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

-- Improved ESP with Colorful Box & Distance
local function drawESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Visible = true
    box.Color = teamColorESP and player.TeamColor.Color or Color3.fromHSV(math.random(), 1, 1)

    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Visible = true
    text.Color = Color3.fromRGB(255,255,255)

    local function update()
        run.RenderStepped:Connect(function()
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and espEnabled then
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
    update()
end

-- Prediction math
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

-- Auto Trigger Function
local function triggerFire()
    local target = getClosest()
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        local hum = target.Character.Humanoid
        if hum.Health > 0 then
            mouse1click()
        end
    end
end

-- Main Loop
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
