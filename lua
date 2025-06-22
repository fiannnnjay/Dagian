-- Load Rayfield UI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if not success then
    warn("Rayfield UI gagal di-load.")
    return
end

-- Buat Window
local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden - Fruit Steal",
    LoadingTitle = "Delta Executor",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Variabel global
local SelectedPlayer = nil

-- Buat Tab
local MainTab = Window:CreateTab("Steal Menu", 4483362458)

-- Dropdown: Player List
local dropdown = MainTab:CreateDropdown({
    Name = "Pilih Player Target",
    Options = {}, -- otomatis diisi
    CurrentOption = "",
    Callback = function(Value)
        SelectedPlayer = Value
    end
})

-- Tombol Steal
MainTab:CreateButton({
    Name = "Steal Buah dari Player",
    Callback = function()
        local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        if not Remote then
            Rayfield:Notify({
                Title = "RemoteEvent Tidak Ditemukan",
                Content = "Script tidak bisa jalan. RemoteEvent hilang.",
                Duration = 4
            })
            return
        end

        if not SelectedPlayer then
            Rayfield:Notify({
                Title = "Player Kosong",
                Content = "Pilih player dulu.",
                Duration = 3
            })
            return
        end

        local target = game.Players:FindFirstChild(SelectedPlayer)
        if not target then
            Rayfield:Notify({
                Title = "Player Ga Ketemu",
                Content = "Player keluar dari server.",
                Duration = 3
            })
            return
        end

        -- Teleport paksa
        pcall(function()
            target.Character:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
        end)

        -- Kirim gift palsu
        for i = 1, 8 do
            Remote:FireServer({
                ["Type"] = "Gift",
                ["Data"] = {
                    ["Type"] = "Fruit",
                    ["Receiver"] = game.Players.LocalPlayer,
                    ["Sender"] = target
                }
            })
            task.wait(0.1)
        end

        Rayfield:Notify({
            Title = "Selesai!",
            Content = "Steal buah sudah dikirim!",
            Duration = 3
        })
    end
})

-- Isi Player List terus menerus
task.spawn(function()
    while task.wait(2) do
        local names = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(names, plr.Name)
            end
        end
        dropdown:SetOptions(names)
    end
end)
