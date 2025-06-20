local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

local currentPet = nil

-- GUI WINDOW
local Window = Rayfield:CreateWindow({
    Name = "Pet Spawner GUI",
    LoadingTitle = "Grow Garden Pet Tool",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrowPetGUI",
        FileName = "spawner_config"
    },
})

-- PET TAB
local PetTab = Window:CreateTab("Pet", 4483362458)

PetTab:CreateParagraph({
    Title = "Pet Spawner",
    Content = "Pegang Pet dulu untuk mendeteksi dan clone otomatis."
})

PetTab:CreateButton({
    Name = "Spawn Clone Pet (Full Function)",
    Callback = function()
        if currentPet and currentPet:IsA("Tool") then
            local clone = currentPet:Clone()
            clone.Parent = player.Backpack
            Rayfield:Notify({
                Title = "Pet Spawner",
                Content = "Pet berhasil di-clone ke tas: " .. clone.Name,
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Pet Spawner",
                Content = "Tidak ada Pet yang valid sedang dipegang!",
                Duration = 4
            })
        end
    end
})

-- DETEKSI PET SAAT DIPANGGUL
RunService.RenderStepped:Connect(function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        currentPet = tool
    end
end)
