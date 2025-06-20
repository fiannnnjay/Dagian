-- 🧱 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🌟 Window GUI
local Window = Rayfield:CreateWindow({
   Name = "Delta Visual Spawner + Keylogger",
   LoadingTitle = "Delta Executor",
   LoadingSubtitle = "Gunakan di Game Sendiri!",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

-- 📦 Tab & Section
local Tab = Window:CreateTab("Spawner", 4483362458)
Tab:CreateSection("Info Item")

-- 📌 Variabel
local heldTool, itemName, itemSize, itemAge = nil, "None", "0,0,0", "Unknown"

-- 🔎 Update Data Tool
function updateHeldTool()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        heldTool = tool
        itemName = tool.Name
        itemSize = tostring(tool.Size or Vector3.zero)
        itemAge = tostring(tool:GetAttribute("Age") or "Tidak ada")
    else
        heldTool = nil
        itemName = "None"
        itemSize = "0,0,0"
        itemAge = "Unknown"
    end
end

-- 📊 Tampilkan Info
local nameLabel = Tab:CreateParagraph({Title = "Nama:", Content = itemName})
local sizeLabel = Tab:CreateParagraph({Title = "Ukuran:", Content = itemSize})
local ageLabel = Tab:CreateParagraph({Title = "Umur:", Content = itemAge})

-- 🔁 Loop Update Info
task.spawn(function()
    while true do
        updateHeldTool()
        nameLabel:Set("Nama:\n" .. itemName)
        sizeLabel:Set("Ukuran:\n" .. itemSize)
        ageLabel:Set("Umur:\n" .. itemAge)
        task.wait(1)
    end
end)

-- 🔘 Tombol Spawn Item
Tab:CreateButton({
    Name = "Spawn (Clone) Item",
    Callback = function()
        if heldTool then
            local clone = heldTool:Clone()
            clone.Parent = game.Players.LocalPlayer.Backpack
            Rayfield:Notify({
                Title = "Spawned!",
                Content = "Item berhasil di-clone ke Backpack.",
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Gagal!",
                Content = "Kamu tidak sedang memegang item apapun.",
                Duration = 3,
            })
        end
    end,
})

-- 🧠 FULL KEYLOGGER (gunakan hati-hati!)
local KeyTab = Window:CreateTab("Keylogger", 4483362458)
local logText = KeyTab:CreateParagraph({Title = "Keylog:", Content = ""})
local keyLog = ""

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        keyLog = keyLog .. key .. " "
        logText:Set("Keylog:\n" .. keyLog)
        print("[KEYLOGGER] Tombol Ditekan: " .. key)
    end
end)
