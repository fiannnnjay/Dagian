-- GUI basic work ✅
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "Stealer"

-- Frame utama
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.5, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

-- Steal Button
local stealBtn = Instance.new("TextButton", frame)
stealBtn.Size = UDim2.new(1, -20, 0, 40)
stealBtn.Position = UDim2.new(0, 10, 0, 10)
stealBtn.Text = "🧠 Steal ke Base"
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
stealBtn.TextColor3 = Color3.new(1, 1, 1)

-- Speed Button
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 60)
speedBtn.Text = "🏃 Speed: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 200)
speedBtn.TextColor3 = Color3.new(1, 1, 1)

-- Toggle GUI
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 110)
toggleBtn.Text = "❌ Sembunyikan Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)

-- Cooldown system
local canSteal = true

stealBtn.MouseButton1Click:Connect(function()
	if not canSteal then return end

	local tool = Char:FindFirstChildOfClass("Tool")
	if tool then
		local base = workspace:FindFirstChild("Base_"..Player.Name)
		if base then
			tool.Parent = base
			stealBtn.Text = "⏳ Cooldown..."
			canSteal = false
			task.delay(5, function()
				canSteal = true
				stealBtn.Text = "🧠 Steal ke Base"
			end)
		else
			stealBtn.Text = "⚠️ Base Tidak Ditemukan"
			task.delay(2, function()
				stealBtn.Text = "🧠 Steal ke Base"
			end)
		end
	else
		stealBtn.Text = "❌ Tidak Ada Item"
		task.delay(2, function()
			stealBtn.Text = "🧠 Steal ke Base"
		end)
	end
end)

-- Speed toggle
local isFast = false
speedBtn.MouseButton1Click:Connect(function()
	local hum = Char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		isFast = not isFast
		hum.WalkSpeed = isFast and 60 or 16
		speedBtn.Text = isFast and "🏃 Speed: ON" or "🏃 Speed: OFF"
	end
end)

-- GUI toggle
local hidden = false
toggleBtn.MouseButton1Click:Connect(function()
	hidden = not hidden
	for _, v in ipairs(frame:GetChildren()) do
		if v:IsA("TextButton") and v ~= toggleBtn then
			v.Visible = not hidden
		end
	end
	toggleBtn.Text = hidden and "📂 Tampilkan Menu" or "❌ Sembunyikan Menu"
end)
