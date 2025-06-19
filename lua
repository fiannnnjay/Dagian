-- Grow A Garden - Ultra Ringan ESP + Pet Detector + Auto Buy
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local petTarget = "Goat" -- Ganti sesuai pet incaran kamu
local enabled = true
local found = false

-- Notifikasi
local function notify(txt)
	local gui = Instance.new("Hint", workspace)
	gui.Text = "[ESP] " .. txt
	task.delay(3, function()
		gui:Destroy()
	end)
end

-- Auto Buy Semua Item di Shop (Egg/Seed/Gear)
task.spawn(function()
	while true do
		task.wait(2)
		if not enabled then continue end
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") and v.MaxActivationDistance <= 12 then
				pcall(function()
					fireproximityprompt(v)
				end)
			end
		end
	end
end)

-- Buat ESP sederhana
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
end

-- Cek isi Egg & kasih ESP
local function scanEgg()
	found = false
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") then
			local base = egg:FindFirstChildWhichIsA("BasePart")
			if base and not base:FindFirstChild("EggESP") then
				local petName = "Egg"
				for _, desc in pairs(egg:GetDescendants()) do
					if desc:IsA("TextLabel") and desc.Text ~= "" then
						petName = desc.Text
						break
					elseif desc:IsA("Model") and desc.Name:lower():find("pet") then
						petName = desc.Name
						break
					end
				end
				makeESP(base, petName)
				if petName:lower():find(petTarget:lower()) then
					found = true
					notify("Pet ditemukan: " .. petName)
				end
			end
		end
	end
end

-- Loop ESP dan Auto-Hop
task.spawn(function()
	while task.wait(6) do
		if not enabled then continue end
		scanEgg()
		if not found then
			notify("Pet tidak ditemukan... server hop")
			TeleportService:Teleport(PlaceId)
		end
	end
end)
