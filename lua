-- [GROW A GARDEN SIMULATOR] ESP TELUR / EGG
local Players = game:GetService("Players")
local player = Players.LocalPlayer

function makeESP(object, color)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "EggESP"
    box.Adornee = object
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = object.Size
    box.Transparency = 0.5
    box.Color3 = color or Color3.fromRGB(255, 255, 0)
    box.Parent = object
end

function scanEgg()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Egg") and not v:FindFirstChild("Egg"):FindFirstChild("EggESP") then
            makeESP(v:FindFirstChild("Egg"))
        end
    end
end

-- Auto-scan egg setiap detik
while task.wait(1) do
    pcall(scanEgg)
end
