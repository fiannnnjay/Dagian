-- Remote Finder
for _,remote in pairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        print("Found Remote:", remote:GetFullName())
    end
end
