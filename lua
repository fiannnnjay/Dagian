local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetGiverUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0.5, -125, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Draggable = true
frame.Active = true

local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Nama Pet (Dog, Cat, dll)"
input.Size = UDim2.new(1, -20, 0, 40)
input.Position = UDim2.new(0, 10, 0, 10)
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.Text = ""

local btn = Instance.new("TextButton", frame)
btn.Text = "Tambah ke Inventory"
btn.Size = UDim2.new(1, -20, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 60)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btn.TextColor3 = Color3.new(1, 1, 1)

btn.MouseButton1Click:Connect(function()
	local petName = input.Text
	if petName == "" then return end

	local rs = game:GetService("ReplicatedStorage")
	local remote = rs:WaitForChild("Remotes"):WaitForChild("PetRemote")
	remote:FireServer("Add", petName) -- langsung dikasih ke inventory
end)
