-- [Delta FPS Aimbot Pro]
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local cam = workspace.CurrentCamera
local run = game:GetService("RunService")

-- 📦 ESP Folder
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "DeltaESP"

-- Aimbot Settings
local aiming = false
local aimPart = "Head"
local maxDistance = 150

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeltaFPSGui"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 210)
main.Position = UDim2.new(0, 20, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 Delta Aimbot PRO"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local aimBtn = Instance.new("TextButton", main)
aimBtn.Size = UDim2.new(1, -20, 0, 40)
aimBtn.Position = UDim2.new(0, 10, 0, 35)
aimBtn.Text = "Aimbot: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.SourceSans
aimBtn.TextSize = 16

local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 80)
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSans
espBtn.TextSize = 16

local partBtn = Instance.new("TextButton", main)
partBtn.Size = UDim2.new(1, -20, 0, 30)
partBtn.Position = UDim2.new(0, 10, 0, 125)
partBtn.Text = "🎯 Target: Head"
partBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
partBtn.TextColor3 = Color3.new(1,1,1)
partBtn.Font = Enum.Font.SourceSans
partBtn.TextSize = 14

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(1, -20, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 165)
closeBtn.Text = "❌ Tutup GUI"
closeBtn.BackgroundColor3 = Color3.fromRGB(80,20,20)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 14

-- Toggle Part
partBtn.MouseButton1Click:Connect(function()
   aimPart = (aimPart == "Head") and "HumanoidRootPart" or "Head"
   partBtn.Text = "🎯 Target: " .. (aimPart == "Head" and "Head" or "Torso")
end)

-- Aimbot Toggle
aimBtn.MouseButton1Click:Connect(function()
   aiming = not aiming
   aimBtn.Text = aiming and "Aimbot: ON" or "Aimbot: OFF"
end)

-- ESP Toggle
local espEnabled = false
espBtn.MouseButton1Click:Connect(function()
   espEnabled = not espEnabled
   espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
   if not espEnabled then
      for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
   end
end)

-- GUI Hide
closeBtn.MouseButton1Click:Connect(function()
   main.Visible = false
   local openBtn = Instance.new("TextButton", gui)
   openBtn.Text = "⚙️"
   openBtn.Size = UDim2.new(0, 40, 0, 40)
   openBtn.Position = UDim2.new(0, 10, 0, 10)
   openBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
   openBtn.TextColor3 = Color3.new(1,1,1)
   openBtn.Font = Enum.Font.SourceSansBold
   openBtn.TextSize = 22
   openBtn.MouseButton1Click:Connect(function()
      main.Visible = true
      openBtn:Destroy()
   end)
end)

-- Aimbot Lock Function
local function getClosest()
   local closest = nil
   local shortest = maxDistance
   for _,v in pairs(Players:GetPlayers()) do
      if v ~= lp and v.Character and v.Character:FindFirstChild(aimPart) then
         local part = v.Character[aimPart]
         local screen, onScreen = cam:WorldToViewportPoint(part.Position)
         if onScreen then
            local distance = (Vector2.new(screen.X, screen.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if distance < shortest then
               shortest = distance
               closest = v
            end
         end
      end
   end
   return closest
end

-- ESP Add Box
local function addEsp(p)
   if not p.Character then return end
   local box = Instance.new("BoxHandleAdornment", espFolder)
   box.Name = p.Name.."_ESP"
   box.Adornee = p.Character:FindFirstChild("HumanoidRootPart")
   box.AlwaysOnTop = true
   box.ZIndex = 5
   box.Size = Vector3.new(3,5,1.5)
   box.Color3 = Color3.fromRGB(0,255,0)
   box.Transparency = 0.5
end

-- Main Loop
run.RenderStepped:Connect(function()
   if aiming then
      local t = getClosest()
      if t and t.Character and t.Character:FindFirstChild(aimPart) then
         local target = t.Character[aimPart].Position
         cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target), 0.2)
      end
   end

   if espEnabled then
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not espFolder:FindFirstChild(p.Name.."_ESP") then
               addEsp(p)
            end
         end
      end
   end
end)
