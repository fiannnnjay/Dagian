--// GUI by Nazril
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")

-- Config
local ITEM_NAME = "Brainrot" -- item yang kamu pegang
local COOLDOWN = 5 -- detik
local canSteal = true

-- GUI Setup
local Window = library:CreateWindow({
    Name = "Auto Curi Brainrot",
    LoadingTitle = "Steal Center",
    LoadingSubtitle = "by Nazril",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoStealConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Menu", 4483362458)
local ToggleSteal, ToggleSpeed

-- Steal Button
MainTab:CreateButton({
    Name = "Steal Item ke Base",
    Callback = function()
        if canSteal then
            canSteal = false
            local heldItem = Char:FindFirstChild(ITEM_NAME) or Char:FindFirstChildOfClass("Tool")
            if heldItem then
                local base = workspace:FindFirstChild("Base_" .. Player.Name)
                if base then
                    heldItem.Parent = base
                    print("Item berhasil dicuri ke base!")
                else
                    warn("Base kamu tidak ditemukan!")
                end
            else
                warn("Kamu tidak sedang memegang item!")
            end
            task.delay(COOLDOWN, function()
                canSteal = true
            end)
        else
            warn("Tunggu cooldown...")
        end
    end
})

-- Speed Toggle
MainTab:CreateToggle({
    Name = "Lari Cepat",
    CurrentValue = false,
    Callback = function(state)
        local humanoid = Char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and 60 or 16
        end
    end
})

-- GUI Toggle
MainTab:CreateKeybind({
    Name = "Toggle GUI",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Callback = function()
        library:ToggleUI()
    end,
})
