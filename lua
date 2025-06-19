-- Grow A Garden - ESP + Auto Buy + Manual Auto-Hop Toggle
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local petTarget = "Goat" -- Ganti pet incaran
local autoHopEnabled = false
local espEnabled = true
local found = false

-- Notifikasi
local function notify(msg)
	local h = Instance.new("Hint", workspace)
	h.Text = "[GrowESP] " .. msg
	task.delay(3, function() h:Destroy() end)
end

-- GUI sederhana untuk toggle Auto-Hop
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GrowESPMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 110)
frame.Position = UDim2.new(0, 10, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 24)
title.Text = "🥚 Grow ESP Settings"
title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local petBox = Instance.new("TextBox", frame)
petBox.Size = UDim2.new(1, -20, 0, 26)
petBox.Position = UDim2.new(0, 10, 0, 30)
petBox.PlaceholderText = "Pet incaran (Goat)"
petBox.Text = petTarget
petBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
petBox.TextColor3 = Color3.new(1, 1, 1)

local hopToggle = Instance.new("TextButton", frame)
hopToggle.Size = UDim2.new(1, -20, 0, 28)
hopToggle.Position = UDim2.new(0, 10, 0, 62)
hopToggle.Text = "Auto-Hop: OFF"
hopToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
hopToggle.TextColor3 = Color3.new(1, 1, 1)

hopToggle.MouseButton1Click:Connect(function()
	autoHopEnabled = not autoHopEnabled
	hopToggle.Text = "Auto-Hop: " .. (autoHopEnabled and "ON" or "OFF")
	hopToggle.BackgroundColor3 = autoHopEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

-- Auto-buy semua item shop
task.spawn(function()
	while true do
		task.wait(2)
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") and v.MaxActivationDistance <= 12 then
				pcall(function() fireproximityprompt(v) end)
			end
		end
	end
end)

-- ESP dan deteksi Egg
local function makeESP(part, text)
	if part:FindFirstChild("EggESP") then return end
	local bb = Instance.new("BillboardGui", part)
	bb.Name = "EggESP"
	bb.Size = UDim2.new(0, 100, 0, 20)
	bb.StudsOffset = Vector3.new(0, 2, 0)
	bb.AlwaysOnTop = true

	local lbl = Instance.new("TextLabel", bb)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1, 1, 0)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.SourceSansBold
end

local function scanEgg()
	found = false
	local target = petBox.Text
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") then
			local part = egg:FindFirstChildWhichIsA("BasePart")
			if part and not part:FindFirstChild("EggESP") then
				local petName = "Egg"
				for _, d in pairs(egg:GetDescendants()) do
					if d:IsA("TextLabel") and d.Text ~= "" then
						petName = d.Text break
					elseif d:IsA("Model") and d.Name:lower():find("pet") then
						petName = d.Name break
					end
				end
				makeESP(part, petName)
				if petName:lower():find(target:lower()) then
					found = true
					notify("Pet ditemukan: " .. petName)
				end
			end
		end
	end
end

-- Loop scan & auto-hop jika aktif
task.spawn(function()
	while task.wait(6) do
		petTarget = petBox.Text
		scanEgg()
		if not found and autoHopEnabled then
			notify("Pet tidak ada, pindah server...")
			TeleportService:Teleport(game.PlaceId)
		end
	end
end)
