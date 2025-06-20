local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")
local Character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local currentHeldPet = nil
local inventoryPets = {}

-- GUI
local Window = Rayfield:CreateWindow({
    Name = "Pet Spawner GUI",
    LoadingTitle = "Grow Garden Pet Tool",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrowPetGUI",
        FileName = "spawner_config"
    },
})

local PetTab = Window:CreateTab("Pet", 4483362458)
PetTab:CreateParagraph({
    Title = "Pet Dupe & Scan",
    Content = "Otomatis deteksi pet yang sedang dipegang & bisa clone."
})

-- Label pet yang sedang dipegang
local heldLabel = PetTab:CreateParagraph({
    Title = "Pet Dipegang",
    Content = "[Belum ada pet]"
})

-- Tombol Clone dari Pegangan
PetTab:CreateButton({
    Name = "Clone Pet (Dari Pegangan)",
    Callback = function()
        if currentHeldPet then
            local clone = currentHeldPet:Clone()
            clone.Parent = Backpack
            Rayfield:Notify({
                Title = "Clone Pet",
                Content = "Clone berhasil: " .. clone.Name,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Clone Pet",
                Content = "Tidak ada pet di tangan!",
                Duration = 3
            })
        end
    end
})

-- Scan semua pet di map (Workspace)
PetTab:CreateButton({
    Name = "Scan Semua Pet di Map",
    Callback = function()
        local found = {}
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                table.insert(found, v:GetFullName())
            end
        end
        Rayfield:Notify({
            Title = "Scan Pet Map",
            Content = "Ditemukan: " .. tostring(#found) .. " pet.",
            Duration = 5
        })
    end
})

-- Update tool yang dipegang
RunService.RenderStepped:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        currentHeldPet = tool
        heldLabel:Set({
            Title = "Pet Dipegang",
            Content = tool.Name
        })
    else
        currentHeldPet = nil
        heldLabel:Set({
            Title = "Pet Dipegang",
            Content = "[Tidak ada pet]"
        })
    end
end)
