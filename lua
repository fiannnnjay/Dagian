-- ✅ Delta FPS Aimbot PRO with No Recoil, ESP Line, Prediction
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local run = game:GetService("RunService")

local aiming = false
local espEnabled = false
local noRecoil = false
local aimPart = "Head"
local maxDistance = 300
local projectileSpeed = 160 -- tweak if needed

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "DeltaESP"

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeltaFPSGui"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 270)
main.Position = UDim2.new(0, 20, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true

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
local partBtn = createBtn("AimPart", "Target: Head", 160)
local closeBtn = createBtn("Close", "❌ Tutup GUI", 210)

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

local function addLineESP(player)
    local line = Instance.new("BillboardGui", espFolder)
    line.Name = player.Name .. "_Line"
    line.AlwaysOnTop = true
    line.Size = UDim2.new(0, 0, 0, 0)
    local frame = Instance.new("Frame", line)
    frame.Size = UDim2.new(0, 2, 1, 0)
    frame.Position = UDim2.new(0, -1, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0,255,0)
    frame.BorderSizePixel = 0
    frame.Name = "Line"
    return line
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

-- Hook recoil (basic)
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

-- Main Loop
run.RenderStepped:Connect(function()
    if noRecoil then disableRecoil() end

    if aiming then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local predicted = getPredictedPosition(target)
            if predicted then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, predicted), 0.2)
            end
        end
    end

    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tag = espFolder:FindFirstChild(p.Name .. "_Line")
                if not tag then tag = addLineESP(p) end
                tag.Adornee = p.Character:FindFirstChild("HumanoidRootPart")
            end
        end
    end
end)
