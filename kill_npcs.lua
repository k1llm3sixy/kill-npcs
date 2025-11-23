local player = game:GetService("Players").LocalPlayer
local hmd = player.Character:WaitForChild("Humanoid")
local rs = game:GetService("ReplicatedStorage")

local equipRemote = rs.remotes.shop.setItemEquipped
local stuff = {
    ["FireArm"] = rs.tools:FindFirstChild("firearm"),
    ["Other"] = rs.tools:FindFirstChild("other"),
    ["Accessories"] = rs.accessories:FindFirstChild("all")
}

function addNotify(content)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Item unlocker",
        Text = content,
        Duration = 8
    })
end

player.CharacterAdded:Connect(function(chr)
    hmd = chr:WaitForChild("Humanoid")
    local bp = player:WaitForChild("Backpack")

    bp.ChildAdded:Connect(function() updateStats() end)

    task.spawn(updateStats)
end)

function updateStats()
    for _, v in next, getgc(true) do
        if type(v) == "table" and rawget(v, "FireRate") then
            v.Auto = true
            v.FireRate = 0.0
            v.ReloadTime = 0
            v.EquippingTime = 0
            v.AmmoPerMag = math.huge
            v.Range = math.huge
            v.Recoil = 0
            v.Accuracy = 0
        end
    end
end

function giveStuff(folder, iType)
    for _, item in pairs(folder:GetChildren()) do
        equipRemote:FireServer(iType, item.Name, false)
        task.wait(0.01)
    end
end

function unlockStuff()
    if stuff.FireArm then
        giveStuff(stuff.FireArm, "tools")
        else
            addNotify("<firearm> folder not found!")
    end

    if stuff.Other then
        giveStuff(stuff.Other, "tools")
        else
            addNotify("<other> folder not found!")
    end

    if stuff.Accessories then
        giveStuff(stuff.Accessories, "accessories")
        else
            addNotify("<all> folder not found!")
    end

    hmd.Health = 0
end

task.spawn(updateStats)
task.spawn(unlockStuff)
