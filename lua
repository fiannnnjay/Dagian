-- Grow A Garden ESP Egg + Pet Detector GUI (v1)
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "EggGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 40)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.Text = "TUTUP ESP"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)

-- ESP Folder
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "EggESPFolder"

local enabled = true

toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "TUTUP ESP" or "BUKA ESP"
	espFolder.Visible = enabled
end)

-- Fungsi Buat ESP
function makeESP(part, text)
	if part:FindFirstChild("ESPLabel") then return end

	local bill = Instance.new("BillboardGui", part)
	bill.Name = "ESPLabel"
	bill.Size = UDim2.new(0, 100, 0, 40)
	bill.StudsOffset = Vector3.new(0, 2, 0)
	bill.AlwaysOnTop = true

	local label = Instance.new("TextLabel", bill)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 0)
	label.TextScaled = true
	label.Text = text or "EGG"
end

-- Deteksi semua Egg
function scanEgg()
	for _, egg in pairs(workspace:GetDescendants()) do
		if egg:IsA("Model") and egg.Name:lower():find("egg") and not egg:FindFirstChild("ESPLabel") then
			local base = egg:FindFirstChildWhichIsA("BasePart")
			if base then
				local petName = "Egg"
				-- Coba cari preview pet
				for _, c in pairs(egg:GetDescendants()) do
					if c:IsA("TextLabel") and c.Text ~= "" then
						petName = c.Text
						break
					elseif c:IsA("Model") and c.Name:lower():find("pet") then
						petName = c.Name
						break
					end
				end
				makeESP(base, petName)
			end
		end
	end
end

-- Loop ESP
rs.RenderStepped:Connect(function()
	pcall(scanEgg)
end)
