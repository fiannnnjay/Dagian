-- Fly Classic Toggle F Key
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local flying = false
local speed = 5

local function getRoot()
    local char = game.Players.LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local bv, bg
local function startFly()
    local root = getRoot()
    if not root then return end

    bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.P = 10000
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 10000
    bg.CFrame = root.CFrame
    bg.Parent = root

    run:BindToRenderStep("DeltaFly", Enum.RenderPriority.Input.Value, function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero
        if uis:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0,1,0) end
        bv.Velocity = moveVec.Unit * speed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    run:UnbindFromRenderStep("DeltaFly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- 🔁 Toggle dengan tombol F
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            startFly()
            print("✅ Fly ON")
        else
            stopFly()
            print("❌ Fly OFF")
        end
    end
end)
