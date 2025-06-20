local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeltaFlyMobile"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local up = Instance.new("TextButton", frame)
up.Size = UDim2.new(1, 0, 0, 50)
up.Position = UDim2.new(0, 0, 0, 10)
up.Text = "⬆️ Terbang Naik"
up.BackgroundColor3 = Color3.fromRGB(50,50,50)
up.TextColor3 = Color3.new(1,1,1)
up.Font = Enum.Font.SourceSansBold
up.TextSize = 16

local down = Instance.new("TextButton", frame)
down.Size = UDim2.new(1, 0, 0, 50)
down.Position = UDim2.new(0, 0, 0, 70)
down.Text = "⬇️ Turun"
down.BackgroundColor3 = Color3.fromRGB(50,50,50)
down.TextColor3 = Color3.new(1,1,1)
down.Font = Enum.Font.SourceSansBold
down.TextSize = 16

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(1, 0, 0, 30)
stopBtn.Position = UDim2.new(0, 0, 0, 130)
stopBtn.Text = "❌ Stop Fly"
stopBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 14

-- Fly Logic
local bv
local function startFly()
   local char = game.Players.LocalPlayer.Character
   local root = char and char:FindFirstChild("HumanoidRootPart")
   if root and not bv then
      bv = Instance.new("BodyVelocity", root)
      bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
      bv.Velocity = Vector3.new(0,0,0)
   end
end

local function flyUp()
   if bv then bv.Velocity = Vector3.new(0, 60, 0) end
end

local function flyDown()
   if bv then bv.Velocity = Vector3.new(0, -60, 0) end
end

local function stopFly()
   if bv then bv:Destroy() bv = nil end
end

up.MouseButton1Click:Connect(function()
   startFly()
   flyUp()
end)

down.MouseButton1Click:Connect(function()
   startFly()
   flyDown()
end)

stopBtn.MouseButton1Click:Connect(function()
   stopFly()
end)
