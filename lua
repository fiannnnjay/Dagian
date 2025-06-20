local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")
local RunService = game:GetService("RunService")

local inventoryPets = {}

-- GUI WINDOW
local Window = Rayfield:CreateWindow({
    Name = "Pet Dupe GUI",
    LoadingTitle = "Grow Garden Pet Cloner",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrowPetGUI",
        FileName = "clone_pet_config"
    },
})

-- PET TAB
local PetTab = Window:CreateTab("Pet", 4483362458)
PetTab:CreateParagraph({
    Title = "Inventory Pet Clone",
    Content = "Pilih pet dari bar inventory bawah, lalu spawn 1:1."
})

-- Dropdown untuk list pet dari Backpack
local selectedPetName = nil

local dropdown = PetTab:CreateDropdown({
    Name = "Pilih Pet dari Inventory Bar",
    Options = {},
    CurrentOption = nil,
    Callback = function(option)
        selectedPetName = option
    end
})

-- Tombol untuk spawn clone pet
PetTab:CreateButton({
    Name = "Clone Pet (Full, Tradeable, Equipable)",
    Callback = function()
        if selectedPetName then
            for _, tool in ipairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == selectedPetName then
                    local clone = tool:Clone()
                    clone.Name = tool.Name .. "_Clone"
                    clone.Parent = Backpack

                    Rayfield:Notify({
                        Title = "Clone Pet",
                        Content = "Berhasil clone: " .. tool.Name,
                        Duration = 4
                    })
                    return
                end
            end
        else
            Rayfield:Notify({
                Title = "Clone Pet",
                Content = "Pilih pet dulu dari dropdown!",
                Duration = 4
            })
        end
    end
})

-- Update list dropdown setiap 2 detik
while true do
    task.wait(2)
    inventoryPets = {}
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            table.insert(inventoryPets, tool.Name)
        end
    end
    dropdown:Refresh(inventoryPets, true)
end
