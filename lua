-- 📦 Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🌟 GUI Window
local Window = Rayfield:CreateWindow({
   Name = "Delta Money + Fly Menu",
   LoadingTitle = "Delta Executor",
   LoadingSubtitle = "Uang + Fly GUI",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

-- 💰 Tab Uang
local MoneyTab = Window:CreateTab("Uang", 4483362458)
MoneyTab:CreateSection("Set Uang (Client-Side)")

-- 🎯 Input & Button Uang
local MoneyTarget = 999999
MoneyTab:CreateInput({
   Name = "Jumlah Uang",
   PlaceholderText = "Masukkan jumlah (client-side)",
   RemoveTextAfterFocusLost = true,
   Callback = function(Value)
      MoneyTarget = tonumber(Value) or 999999
   end
})

MoneyTab:CreateButton({
   Name = "Set ke Jumlah Uang Tertentu",
   Callback = function()
      local player = game.Players.LocalPlayer
      local leaderstats = player:FindFirstChild("leaderstats")
      if leaderstats then
         for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") and string.lower(stat.Name):find("money") then
               stat.Value = MoneyTarget
               Rayfield:Notify({
                   Title = "Uang Diubah!",
                   Content = "Uangmu diubah jadi " .. tostring(MoneyTarget),
                   Duration = 3,
               })
               return
            end
         end
      end
      Rayfield:Notify({
         Title = "Gagal!",
         Content = "Tidak menemukan leaderstats 'Money'",
         Duration = 3,
      })
   end,
})

-- 🕊️ Tab Fly
local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateSection("Fly Mode")

-- 🕹️ Fly Function
local flying = false
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function startFly()
   local plr = game.Players.LocalPlayer
   local char = plr.Character or plr.CharacterAdded:Wait()
   local root = char:WaitForChild("HumanoidRootPart")
   local bv = Instance.new("BodyVelocity")
   bv.Name = "DeltaFlyVelocity"
   bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
   bv.Velocity = Vector3.zero
   bv.Parent = root

   local flySpeed = 70
   RunService:BindToRenderStep("DeltaFly", Enum.RenderPriority.Input.Value, function()
      local cam = workspace.CurrentCamera
      local moveVec = Vector3.zero
      if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
      if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
      if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + cam.CFrame.UpVector end
      if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - cam.CFrame.UpVector end
      bv.Velocity = moveVec.Unit * flySpeed
   end)
end

local function stopFly()
   local char = game.Players.LocalPlayer.Character
   local root = char and char:FindFirstChild("HumanoidRootPart")
   if root and root:FindFirstChild("DeltaFlyVelocity") then
      root.DeltaFlyVelocity:Destroy()
   end
   RunService:UnbindFromRenderStep("DeltaFly")
end

-- 🔘 Toggle Fly
FlyTab:CreateToggle({
   Name = "Aktifkan Fly",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      if flying then
         startFly()
         Rayfield:Notify({Title = "Fly ON", Content = "Terbang aktif!", Duration = 3})
      else
         stopFly()
         Rayfield:Notify({Title = "Fly OFF", Content = "Terbang dimatikan!", Duration = 3})
      end
   end,
})
