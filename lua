-- 🧱 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Delta Menu",
   LoadingTitle = "Delta Executor",
   LoadingSubtitle = "Uang + Fly",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

-- 💰 Tab Uang
local MoneyTab = Window:CreateTab("Uang", 4483362458)
MoneyTab:CreateSection("Set Uang Client-Side")

local MoneyTarget = 999999

MoneyTab:CreateInput({
   Name = "Jumlah Uang",
   PlaceholderText = "Contoh: 999999",
   RemoveTextAfterFocusLost = true,
   Callback = function(Value)
      MoneyTarget = tonumber(Value) or 999999
   end
})

MoneyTab:CreateButton({
   Name = "Terapkan ke Money (client)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local stats = player:FindFirstChild("leaderstats")
      if stats then
         for _, stat in pairs(stats:GetChildren()) do
            if stat:IsA("IntValue") and stat.Name:lower():find("money") then
               stat.Value = MoneyTarget
               Rayfield:Notify({
                  Title = "Berhasil!",
                  Content = "Uang diubah ke: " .. tostring(MoneyTarget),
                  Duration = 3,
               })
               return
            end
         end
      end
      Rayfield:Notify({
         Title = "Gagal!",
         Content = "Tidak menemukan leaderstats Money.",
         Duration = 3,
      })
   end
})

-- 🕊️ Tab Fly
local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateSection("Fly Mobile Friendly")

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

   game:GetService("RunService"):BindToRenderStep("FlyDelta", Enum.RenderPriority.Input.Value, function()
      local cam = workspace.CurrentCamera
      local moveVec = Vector3.zero
      local UIS = game:GetService("UserInputService")
      if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0,1,0) end
      bv.Velocity = moveVec.Unit * 60
      bg.CFrame = cam.CFrame
   end)
end

local function stopFly()
   game:GetService("RunService"):UnbindFromRenderStep("FlyDelta")
   if bv then bv:Destroy() end
   if bg then bg:Destroy() end
end

FlyTab:CreateToggle({
   Name = "Aktifkan Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      if flying then
         startFly()
         Rayfield:Notify({Title = "Fly ON", Content = "Terbang aktif", Duration = 3})
      else
         stopFly()
         Rayfield:Notify({Title = "Fly OFF", Content = "Fly dimatikan", Duration = 3})
      end
   end
})
