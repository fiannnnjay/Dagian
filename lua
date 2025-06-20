-- Tambahkan di tab Fly kamu (Rayfield UI)
local flying = false
local bv, bg

local function startFly()
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.P = 10000
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 10000
    bg.CFrame = root.CFrame
    bg.Parent = root

    game:GetService("RunService"):BindToRenderStep("MobileFly", Enum.RenderPriority.Input.Value, function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
        bv.Velocity = moveVec.Unit * 60
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    game:GetService("RunService"):UnbindFromRenderStep("MobileFly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- Tambahkan tombol Toggle Fly (di Rayfield UI)
FlyTab:CreateToggle({
   Name = "Fly Aktif",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      if flying then
         startFly()
         Rayfield:Notify({Title = "Fly ON", Content = "Terbang diaktifkan", Duration = 3})
      else
         stopFly()
         Rayfield:Notify({Title = "Fly OFF", Content = "Fly dimatikan", Duration = 3})
      end
   end,
})
