-- 🖼️ GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaGUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0

-- 🎯 Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Delta Fly + Uang"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- 🔘 Button: Fly
local FlyButton = Instance.new("TextButton", Frame)
FlyButton.Size = UDim2.new(1, -20, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 40)
FlyButton.Text = "Aktifkan Fly"
FlyButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
FlyButton.TextColor3 = Color3.new(1,1,1)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 16
FlyButton.AutoButtonColor = true

-- 🪙 Button: Set Uang
local MoneyButton = Instance.new("TextButton", Frame)
MoneyButton.Size = UDim2.new(1, -20, 0, 40)
MoneyButton.Position = UDim2.new(0, 10, 0, 90)
MoneyButton.Text = "Set Uang ke 999999"
MoneyButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
MoneyButton.TextColor3 = Color3.new(1,1,1)
MoneyButton.Font = Enum.Font.SourceSans
MoneyButton.TextSize = 16
MoneyButton.AutoButtonColor = true

-- 🔄 Fly Logic
local flying = false
local bv, bg

local function startFly()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    bv = Instance.new("BodyVelocity", root)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

    bg = Instance.new("BodyGyro", root)
    bg.CFrame = workspace.CurrentCamera.CFrame
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)

    game:GetService("RunService"):BindToRenderStep("SimpleFly", Enum.RenderPriority.Input.Value, function()
        local move = Vector3.zero
        local cam = workspace.CurrentCamera
        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        bv.Velocity = move.Unit * 60
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    game:GetService("RunService"):UnbindFromRenderStep("SimpleFly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "Matikan Fly" or "Aktifkan Fly"
    if flying then startFly() else stopFly() end
end)

-- 💰 Uang Logic
MoneyButton.MouseButton1Click:Connect(function()
    local stats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        for _,v in pairs(stats:GetChildren()) do
            if v:IsA("IntValue") and v.Name:lower():find("money") then
                v.Value = 999999
                MoneyButton.Text = "✅ Uang Diubah!"
                task.wait(2)
                MoneyButton.Text = "Set Uang ke 999999"
                return
            end
        end
    end
    MoneyButton.Text = "❌ Gagal (No leaderstats)"
    task.wait(2)
    MoneyButton.Text = "Set Uang ke 999999"
end)
