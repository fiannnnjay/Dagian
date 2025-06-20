local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetDupeGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0.5, -130, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🐾 DUPLICATE PET"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

local petInfo = Instance.new("TextLabel", frame)
petInfo.Size = UDim2.new(1, -20, 0, 60)
petInfo.Position = UDim2.new(0, 10, 0, 35)
petInfo.Text = "No Pet Detected"
petInfo.TextWrapped = true
petInfo.BackgroundTransparency = 1
petInfo.TextColor3 = Color3.new(1,1,1)
petInfo.TextSize = 16
petInfo.Font = Enum.Font.SourceSans

local dupBtn = Instance.new("TextButton", frame)
dupBtn.Size = UDim2.new(1, -20, 0, 40)
dupBtn.Position = UDim2.new(0, 10, 0, 105)
dupBtn.Text = "DUPLICATE NOW"
dupBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
dupBtn.TextColor3 = Color3.new(0,0,0)
dupBtn.Visible = false

-- Pet Detection
game:GetService("RunService").RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		local name = tool.Name
		local size = "?"
		local age = "?"

		for _, child in pairs(tool:GetChildren()) do
			if child:IsA("NumberValue") or child:IsA("IntValue") then
				if child.Name:lower():find("size") or child.Name:lower():find("weight") then
					size = tostring(child.Value)
				elseif child.Name:lower():find("age") then
					age = tostring(child.Value)
				end
			end
		end

		petInfo.Text = "Pet: " .. name .. "\nSize: " .. size .. " KG\nAge: " .. age
		dupBtn.Visible = true
	else
		petInfo.Text = "No Pet Detected"
		dupBtn.Visible = false
	end
end)

-- Dupe Pet
dupBtn.MouseButton1Click:Connect(function()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool then
		local clone = tool:Clone()
		clone.Parent = player.Backpack
	end
end)
