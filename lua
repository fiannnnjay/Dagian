local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

local spawnerData = {Name = "", Age = 0, Size = Vector3.new(1, 1, 1)}

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
    Content = "Pegang Pet dulu untuk mendeteksi data otomatis."
})

PetTab:CreateButton({
    Name = "Spawn Pet (No Visual)",
    Callback = function()
        if spawnerData.Name ~= "" then
            local fakePet = Instance.new("Tool")
            fakePet.Name = spawnerData.Name
            fakePet.Parent = player.Backpack

            local part = Instance.new("Part")
            part.Name = "Handle"
            part.Size = spawnerData.Size
            part.Anchored = false
            part.CanCollide = false
            part.Transparency = 1
            part.Parent = fakePet

            Rayfield:Notify({
                Title = "Pet Spawner",
                Content = "Pet berhasil di-spawn: " .. spawnerData.Name,
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Pet Spawner",
                Content = "Tidak ada Pet terdeteksi di tangan!",
                Duration = 4
            })
        end
    end
})

-- AUTO UPDATE DATA SAAT PEGANG PET
RunService.RenderStepped:Connect(function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        spawnerData.Name = tool.Name
        spawnerData.Size = tool.Handle.Size
        spawnerData.Age = math.floor(os.clock())
    end
end)
