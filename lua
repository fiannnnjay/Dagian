-- Grow A Garden ESP + Pet Filter + AutoHop + ON/OFF vFinal
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local PLACE_ID = game.PlaceId
local PET_INCARAN = "Goat" -- Ganti sesuai target pet
local ENABLED = true

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GrowEggESP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0, 10, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "🥚 Grow ESP"
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local box = Instance.new("TextBox", frame)
box.PlaceholderText = "Pet incaran (contoh: Goat)"
box.Text = PET_INCARAN
box.Size = UDim2.new(1, -20, 0, 30)
box.Position = UDim2.new(0, 10, 0, 35)
box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
box.TextColor3 = Color3.new(1, 1, 1)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 75)
toggle.Text = "Matikan"
toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)

local notif = Instance.new("TextLabel", frame)
notif.Text = ""
notif.Size = UDim2.new(1, -20, 0, 25)
notif.Position = UDim2.new(0, 10, 0, 110)
notif.BackgroundTransparency = 1
notif.TextColor3 = Color3.new(1, 1, 0)
notif.TextScaled = true

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "Matikan" or "Nyalakan"
	toggle.BackgroundColor3 = ENABLED and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

-- ESP
local function makeESP(part, text)
	if part:FindFirstChild("EggESP") then return end
	local bill = Instance.new("BillboardGui", part)
	bill.Name = "EggESP"
	bill.Size = UDim2.new(0, 100, 0, 30)
	bill.StudsOffset = Vector3.new(0, 3, 0)
	bill.AlwaysOnTop = true
	local label = Instance.new("TextLabel", bill)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 0)
	label.TextScaled = true
	label.Text = text
	label.Font = Enum.Font.SourceSansBold
	bill.Parent = part
end

local function detectEggs()
	local found = false
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") then
			local part = egg:FindFirstChildWhichIsA("BasePart")
			if part and not part:FindFirstChild("EggESP") then
				local petName = "?"
				for _, d in pairs(egg:GetDescendants()) do
					if d:IsA("TextLabel") and d.Text ~= "" then
						petName = d.Text
						break
					elseif d:IsA("Model") and d.Name:lower():find("pet") then
						petName = d.Name
						break
					end
				end
				makeESP(part, petName)
				if petName:lower():find(box.Text:lower()) then
					found = true
				end
			end
		end
	end
	if found then
		notif.Text = "✅ Pet ditemukan: " .. box.Text
		-- optional sound
		local s = Instance.new("Sound", LocalPlayer:WaitForChild("PlayerGui"))
		s.SoundId = "rbxassetid://6026984224"
		s.Volume = 2
		s:Play()
		game.Debris:AddItem(s, 3)
	else
		notif.Text = ""
	end
	return found
end

-- LOOP
task.spawn(function()
	while true do
		task.wait(5)
		if ENABLED then
			local ketemu = detectEggs()
			if not ketemu then
				TeleportService:Teleport(PLACE_ID)
			end
		end
	end
end)
